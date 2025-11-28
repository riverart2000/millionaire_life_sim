import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/jar_model.dart';
import '../models/marketplace_item_model.dart';
import '../models/transaction_model.dart';
import '../models/user_profile_model.dart';
import 'bootstrap_provider.dart';
import 'investment_provider.dart';

final syncEnabledProvider = Provider<bool>((ref) {
  return ref.watch(userProfileProvider).maybeWhen(
        data: (profile) => profile?.syncEnabled ?? true,
        orElse: () => true,
      );
});

final jarsProvider = StreamProvider<List<Jar>>((ref) {
  final repo = ref.watch(jarRepositoryProvider);
  return repo.watchAll();
});

final transactionsProvider = StreamProvider<List<MoneyTransaction>>((ref) {
  final repo = ref.watch(transactionRepositoryProvider);
  return repo.watchAll();
});

final userProfileProvider = StreamProvider<UserProfile?>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return repo.watchProfile();
});

final marketplaceCatalogProvider = StreamProvider<List<MarketplaceItem>>((ref) {
  final repo = ref.watch(marketplaceRepositoryProvider);
  return repo.watchLocalCatalog();
});

final marketplaceListingsProvider = StreamProvider<List<MarketplaceItem>>((ref) {
  final syncEnabled = ref.watch(syncEnabledProvider);
  // Fully offline - always use local catalog
  return ref.watch(marketplaceRepositoryProvider).watchLocalCatalog();
});

final totalWealthProvider = Provider<double>((ref) {
  // 1. Sum of jar balances (excluding GIVE jar)
  final jars = ref.watch(jarsProvider).value ?? const [];
  final jarTotal = jars.where((jar) => jar.id.toUpperCase() != 'GIVE').fold<double>(0, (sum, jar) => sum + jar.balance);
  
  // 2. Sum of investment values (units × price)
  final investments = ref.watch(investmentsProvider).value ?? const [];
  final investmentTotal = investments.fold<double>(0, (sum, investment) => sum + (investment.unitsOwned * investment.pricePerUnit));
  
  // 3. Sum of owned marketplace item values (only items the user owns)
  final marketplaceItems = ref.watch(marketplaceCatalogProvider).value ?? const [];
  final ownedItems = marketplaceItems.where((item) => item.isOwned);
  final marketplaceTotal = ownedItems.fold<double>(0, (sum, item) => sum + item.price);
  
  if (kDebugMode) {
    print('💰 Total Wealth Calculation:');
    print('   Jar balances: £${jarTotal.toStringAsFixed(2)}');
    print('   Investments: £${investmentTotal.toStringAsFixed(2)}');
    print('   Owned items (${ownedItems.length}): £${marketplaceTotal.toStringAsFixed(2)}');
    print('   TOTAL: £${(jarTotal + investmentTotal + marketplaceTotal).toStringAsFixed(2)}');
  }
  
  return jarTotal + investmentTotal + marketplaceTotal;
});

