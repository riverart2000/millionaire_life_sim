import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
import '../repositories/remote/firestore_jar_repository.dart';
import '../repositories/remote/firestore_marketplace_repository.dart';
import '../repositories/remote/firestore_transaction_repository.dart';
import '../repositories/remote/firestore_user_repository.dart';
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
import '../services/sync_service.dart';
import '../services/transaction_service.dart';
import 'session_providers.dart';

final bootstrapServiceProvider = Provider<BootstrapService>((ref) {
  return getIt<BootstrapService>();
});

final appInitializationProvider = FutureProvider<void>((ref) async {
  final bootstrapService = ref.watch(bootstrapServiceProvider);
  await bootstrapService.initialize();
});

/// Get FirebaseFirestore instance safely, or null if not initialized
FirebaseFirestore? _getFirestore() {
  try {
    Firebase.app(); // Check if Firebase is initialized
    return FirebaseFirestore.instance;
  } catch (e) {
    // Firebase not initialized
    return null;
  }
}

// Manual DI - create instances directly
final jarRepositoryProvider = Provider<JarRepository>((ref) => HiveJarRepository());
final jarRemoteRepositoryProvider = Provider<JarRemoteRepository>((ref) {
  final firestore = _getFirestore();
  if (firestore == null) {
    throw StateError('Firebase not initialized - remote repository unavailable');
  }
  return FirestoreJarRepository(firestore: firestore);
});

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) => HiveTransactionRepository());
final transactionRemoteRepositoryProvider = Provider<TransactionRemoteRepository>((ref) {
  final firestore = _getFirestore();
  if (firestore == null) {
    throw StateError('Firebase not initialized - remote repository unavailable');
  }
  return FirestoreTransactionRepository(firestore: firestore);
});

final marketplaceRepositoryProvider = Provider<MarketplaceRepository>((ref) => HiveMarketplaceRepository());
final marketplaceRemoteRepositoryProvider = Provider<MarketplaceRemoteRepository>((ref) {
  final firestore = _getFirestore();
  if (firestore == null) {
    throw StateError('Firebase not initialized - remote repository unavailable');
  }
  return FirestoreMarketplaceRepository(firestore: firestore);
});

final userRepositoryProvider = Provider<UserRepository>((ref) => HiveUserRepository());
final userRemoteRepositoryProvider = Provider<UserRemoteRepository>((ref) {
  final firestore = _getFirestore();
  if (firestore == null) {
    throw StateError('Firebase not initialized - remote repository unavailable');
  }
  return FirestoreUserRepository(firestore: firestore);
});

final transactionServiceProvider = Provider((ref) {
  // Try to get remote repository, null if Firebase not initialized
  TransactionRemoteRepository? remoteRepo;
  try {
    remoteRepo = ref.watch(transactionRemoteRepositoryProvider);
  } catch (e) {
    // Firebase not initialized - remote repository unavailable
    remoteRepo = null;
  }
  
  return TransactionService(
    localRepository: ref.watch(transactionRepositoryProvider),
    remoteRepository: remoteRepo,
    userRepository: ref.watch(userRepositoryProvider),
  );
});

final jarServiceProvider = Provider((ref) {
  // Try to get remote repository, null if Firebase not initialized
  JarRemoteRepository? remoteRepo;
  try {
    remoteRepo = ref.watch(jarRemoteRepositoryProvider);
  } catch (e) {
    // Firebase not initialized - remote repository unavailable
    remoteRepo = null;
  }
  
  return JarService(
    localRepository: ref.watch(jarRepositoryProvider),
    remoteRepository: remoteRepo,
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
));

final syncServiceProvider = Provider((ref) {
  // Only create sync service if Firebase is initialized
  final firestore = _getFirestore();
  if (firestore == null) {
    throw StateError('Sync service requires Firebase - please configure Firebase to enable sync');
  }
  
  return SyncService(
    jarRepository: ref.watch(jarRepositoryProvider),
    jarRemoteRepository: ref.watch(jarRemoteRepositoryProvider),
    transactionRepository: ref.watch(transactionRepositoryProvider),
    transactionRemoteRepository: ref.watch(transactionRemoteRepositoryProvider),
    userRepository: ref.watch(userRepositoryProvider),
    userRemoteRepository: ref.watch(userRemoteRepositoryProvider),
    marketplaceRepository: ref.watch(marketplaceRepositoryProvider),
    marketplaceRemoteRepository: ref.watch(marketplaceRemoteRepositoryProvider),
  );
});

final marketplaceServiceProvider = Provider((ref) {
  // Try to get remote repository, null if Firebase not initialized
  MarketplaceRemoteRepository? remoteRepo;
  try {
    remoteRepo = ref.watch(marketplaceRemoteRepositoryProvider);
  } catch (e) {
    // Firebase not initialized - remote repository unavailable
    remoteRepo = null;
  }
  
  return MarketplaceService(
    localRepository: ref.watch(marketplaceRepositoryProvider),
    remoteRepository: remoteRepo,
    jarRepository: ref.watch(jarRepositoryProvider),
    jarService: ref.watch(jarServiceProvider),
    transactionService: ref.watch(transactionServiceProvider),
  );
});

final dataSeedServiceProvider = Provider((ref) {
  // Try to get remote repository, null if Firebase not initialized
  MarketplaceRemoteRepository? remoteRepo;
  try {
    remoteRepo = ref.watch(marketplaceRemoteRepositoryProvider);
  } catch (e) {
    remoteRepo = null;
  }
  
  return DataSeedService(
    marketplaceRepository: ref.watch(marketplaceRepositoryProvider),
    marketplaceRemoteRepository: remoteRepo,
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

    // Seed marketplace catalog from assets if empty
    logInfo('Found ${catalog.length} marketplace items');
    
    if (catalog.isEmpty) {
      logInfo('Seeding marketplace...');
      final seedResult = await dataSeedService.seedMarketplaceFromAsset('assets/data/marketplace_items.json');
      if (seedResult.isSuccess) {
        logInfo('✅ Seeded marketplace catalog locally');
        
        // Also sync to Firebase if available (one-time setup)
        final firebaseSyncResult = await dataSeedService.syncMarketplaceToFirebase('assets/data/marketplace_items.json');
        if (firebaseSyncResult.isSuccess) {
          logInfo('✅ Synced marketplace to Firebase');
        } else {
          logInfo('ℹ️ Could not sync to Firebase (may be offline or not configured)');
        }
      } else {
        logError('Failed to seed marketplace', seedResult.error);
      }
    } else {
      logInfo('✅ Marketplace already seeded locally');
    }
    
    logInfo('✅ Bootstrap complete!');
  } catch (e, st) {
    logError('Bootstrap failed', e, st);
    rethrow;
  }
});

