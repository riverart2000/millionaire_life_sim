import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/di/injection.dart';
import '../core/utils/logger.dart';
import '../core/constants/jar_constants.dart';
import '../models/jar_model.dart';
import '../models/marketplace_item_model.dart';
import '../models/user_profile_model.dart';
import '../repositories/interfaces/jar_repository.dart';
import '../repositories/interfaces/marketplace_repository.dart';
import '../repositories/interfaces/transaction_repository.dart';
import '../repositories/interfaces/user_repository.dart';
import '../repositories/local/hive_jar_repository.dart';
import '../repositories/local/hive_marketplace_repository.dart';
import '../repositories/local/hive_transaction_repository.dart';
import '../repositories/local/hive_user_repository.dart';
import '../services/bootstrap_service.dart';
import '../services/bills_service.dart';
import '../services/data_export_service.dart';
import '../services/data_seed_service.dart';
import '../services/income_service.dart';
import '../services/interest_service.dart';
import '../services/investment_return_service.dart';
import '../services/investment_service.dart';
import '../services/jar_service.dart';
import '../services/market_price_service.dart';
import '../services/marketplace_service.dart';
import '../services/transaction_service.dart';
import 'session_providers.dart';

final bootstrapServiceProvider = Provider<BootstrapService>((ref) {
  return getIt<BootstrapService>();
});

final appInitializationProvider = FutureProvider<void>((ref) async {
  final bootstrapService = ref.watch(bootstrapServiceProvider);
  await bootstrapService.initialize();
});

// Offline-only local repositories
final jarRepositoryProvider = Provider<JarRepository>((ref) => HiveJarRepository());
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) => HiveTransactionRepository());
final marketplaceRepositoryProvider = Provider<MarketplaceRepository>((ref) => HiveMarketplaceRepository());
final userRepositoryProvider = Provider<UserRepository>((ref) => HiveUserRepository());

final transactionServiceProvider = Provider((ref) {
  return TransactionService(
    localRepository: ref.watch(transactionRepositoryProvider),
    remoteRepository: null,  // Fully offline
    userRepository: ref.watch(userRepositoryProvider),
  );
});

final jarServiceProvider = Provider((ref) {
  return JarService(
    localRepository: ref.watch(jarRepositoryProvider),
    remoteRepository: null,  // Fully offline
    userRepository: ref.watch(userRepositoryProvider),
    transactionService: ref.watch(transactionServiceProvider),
  );
});

final interestServiceProvider = Provider<InterestService>((ref) => InterestService());

final investmentReturnServiceProvider = Provider<InvestmentReturnService>((ref) => InvestmentReturnService());

final billsServiceProvider = Provider<BillsService>((ref) => BillsService());

final investmentServiceProvider = Provider<InvestmentService>((ref) => InvestmentService());

final marketPriceServiceProvider = Provider<MarketPriceService>((ref) => MarketPriceService());

final incomeServiceProvider = Provider((ref) => IncomeService(
  userRepository: ref.watch(userRepositoryProvider),
  jarService: ref.watch(jarServiceProvider),
  interestService: ref.watch(interestServiceProvider),
  investmentService: ref.watch(investmentServiceProvider),
  marketPriceService: ref.watch(marketPriceServiceProvider),
  billsService: ref.watch(billsServiceProvider),
  investmentReturnService: ref.watch(investmentReturnServiceProvider),
  marketplaceService: ref.watch(marketplaceServiceProvider),
));

final marketplaceServiceProvider = Provider((ref) {
  return MarketplaceService(
    localRepository: ref.watch(marketplaceRepositoryProvider),
    remoteRepository: null,  // Fully offline
    jarRepository: ref.watch(jarRepositoryProvider),
    jarService: ref.watch(jarServiceProvider),
    transactionService: ref.watch(transactionServiceProvider),
  );
});

final dataSeedServiceProvider = Provider((ref) {
  return DataSeedService(
    marketplaceRepository: ref.watch(marketplaceRepositoryProvider),
    marketplaceRemoteRepository: null,  // Fully offline
  );
});

final dataExportServiceProvider = Provider((ref) => DataExportService(
  jarRepository: ref.watch(jarRepositoryProvider),
  transactionRepository: ref.watch(transactionRepositoryProvider),
  userRepository: ref.watch(userRepositoryProvider),
  marketplaceRepository: ref.watch(marketplaceRepositoryProvider),
));

final userBootstrapProvider = FutureProvider<void>((ref) async {
  try {
    logInfo('Starting user bootstrap...');
    
    final userId = ref.read(userIdProvider);
    final userRepository = ref.read(userRepositoryProvider);
    final jarRepository = ref.read(jarRepositoryProvider);
    final dataSeedService = ref.read(dataSeedServiceProvider);
    final marketplaceRepository = ref.read(marketplaceRepositoryProvider);
    
    logInfo('User ID: $userId');

    // Parallelize independent operations
    final profileFuture = userRepository.fetchProfile();
    final jarsFuture = jarRepository.fetchAll();
    final catalogFuture = marketplaceRepository.fetchLocalCatalog();

    // Wait for all parallel operations
    final results = await Future.wait([profileFuture, jarsFuture, catalogFuture]);
    final profile = results[0] as UserProfile?;
    final existingJars = results[1] as List<Jar>;
    final catalog = results[2] as List<MarketplaceItem>;

    // Ensure user profile exists locally
    var finalProfile = profile;
    if (finalProfile == null) {
      logInfo('Creating new user profile...');
      finalProfile = UserProfile(
        id: userId,
        name: ref.read(userDisplayNameProvider), // Use authenticated name
        email: '',
        dailyIncome: 200,
        jarPercentages: JarConstants.defaultPercentages,
        autoSimulateDaily: false,
        lastSyncedAt: DateTime.now(),
        syncEnabled: false, // Default to offline mode
      );
      await userRepository.saveProfile(finalProfile);
      logInfo('✅ Created new user profile');
    } else {
      logInfo('✅ User profile loaded: ${finalProfile.name}');
    }

    // Initialize default jars if needed
    logInfo('Found ${existingJars.length} existing jars');
    
    if (existingJars.isEmpty) {
      logInfo('Initializing default jars...');
      // Create jars directly without remote sync
      final defaultJars = JarConstants.defaultPercentages.entries.map((entry) {
        return Jar(
          id: entry.key,
          name: entry.key,
          percentage: entry.value,
          balance: 0,
          transactionIds: [],
          lastUpdated: DateTime.now(),
          isDefault: true,
        );
      }).toList();
      
      await jarRepository.saveAll(defaultJars);
      logInfo('✅ Initialized ${defaultJars.length} default jars');
    } else {
      logInfo('✅ Jars already initialized');
    }

    // Seed marketplace catalog from assets if empty or version mismatch
    logInfo('Found ${catalog.length} marketplace items');
    
    // Check marketplace version
    final prefs = await SharedPreferences.getInstance();
    final currentVersion = prefs.getInt('marketplace_version') ?? 0;
    const expectedVersion = 2; // Update this when marketplace changes
    
    if (catalog.isEmpty || currentVersion < expectedVersion) {
      if (currentVersion < expectedVersion) {
        logInfo('Marketplace version outdated ($currentVersion < $expectedVersion), re-seeding...');
      } else {
        logInfo('Seeding marketplace...');
      }
      final seedResult = await dataSeedService.seedMarketplaceFromAsset('assets/data/marketplace_items.json');
      if (seedResult.isSuccess) {
        await prefs.setInt('marketplace_version', expectedVersion);
        logInfo('✅ Seeded marketplace catalog locally (version $expectedVersion)');
      } else {
        logError('Failed to seed marketplace', seedResult.error);
      }
    } else {
      logInfo('✅ Marketplace already seeded locally (version $currentVersion)');
    }
    
    logInfo('✅ Bootstrap complete!');
  } catch (e, st) {
    logError('Bootstrap failed', e, st);
    rethrow;
  }
});

