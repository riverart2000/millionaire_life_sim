import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

import '../core/constants/hive_box_constants.dart';
import '../core/utils/logger.dart';
import '../models/investment_price_model.dart';
import '../models/jar_model.dart';
import '../models/marketplace_item_model.dart';
import '../models/transaction_model.dart';
import '../models/user_profile_model.dart';

@lazySingleton
class BootstrapService {
  Future<void> initialize() async {
    // Initialize Hive (fully offline local storage)
    await _initHive();
    logInfo('✅ App initialized in offline mode');
  }

  Future<void> _initHive() async {
    await Hive.initFlutter();
    _registerAdapters();
    await Future.wait([
      Hive.openBox<UserProfile>(HiveBoxConstants.userProfile),
      Hive.openBox<Jar>(HiveBoxConstants.jars),
      Hive.openBox<MoneyTransaction>(HiveBoxConstants.transactions),
      Hive.openBox<MarketplaceItem>(HiveBoxConstants.marketplaceItems),
      Hive.openBox<MarketplaceItem>(HiveBoxConstants.ownedItems),
      Hive.openBox<InvestmentPrice>(HiveBoxConstants.investmentPrices),
      Hive.openBox('app_data'), // For riddle service and other app-wide data
    ]);
    logInfo('✅ Hive initialized');
  }

  void _registerAdapters() {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(JarAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(MoneyTransactionAdapter());
    }
    if (!Hive.isAdapterRegistered(10)) {
      Hive.registerAdapter(TransactionKindAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(MarketplaceItemAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(UserProfileAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(InvestmentPriceAdapter());
    }
  }
}

