import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

import '../core/constants/hive_box_constants.dart';
import '../core/utils/logger.dart';
import '../firebase_options.dart';
import '../models/investment_price_model.dart';
import '../models/jar_model.dart';
import '../models/marketplace_item_model.dart';
import '../models/transaction_model.dart';
import '../models/user_profile_model.dart';

@lazySingleton
class BootstrapService {
  Future<void> initialize() async {
    // Initialize Hive first (fast, local) then Firebase in parallel
    await _initHive();
    // Initialize Firebase in background - don't block on it
    _initFirebase().catchError((e) {
      logInfo('Firebase initialization deferred/failed: $e');
    });
  }

  Future<void> _initFirebase() async {
    try {
      // Check if Firebase is configured (not placeholder values)
      final options = DefaultFirebaseOptions.currentPlatform;
      if (options.apiKey == 'YOUR_WEB_API_KEY' || 
          options.apiKey == 'YOUR_ANDROID_API_KEY' ||
          options.apiKey == 'YOUR_IOS_API_KEY' ||
          options.apiKey == 'YOUR_MACOS_API_KEY' ||
          options.apiKey == 'YOUR_DESKTOP_API_KEY') {
        logInfo('⚠️ Firebase not configured, skipping initialization');
        return;
      }
      
      // Try to initialize Firebase, but don't block if it fails
      await Firebase.initializeApp(options: options).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          logInfo('⚠️ Firebase initialization timeout, continuing without Firebase');
          throw TimeoutException('Firebase init timeout');
        },
      );
      await _ensureAnonymousAuth();
      logInfo('✅ Firebase initialized');
    } on TimeoutException {
      // Already logged, continue without Firebase
    } on Exception catch (error, stackTrace) {
      logError('Firebase initialization failed', error, stackTrace);
      // Continue without Firebase - app works offline
    }
  }

  Future<void> _ensureAnonymousAuth() async {
    try {
      final auth = FirebaseAuth.instance;
      if (auth.currentUser == null) {
        await auth.signInAnonymously();
      }
    } on Exception catch (error, stackTrace) {
      logError('Anonymous auth failed', error, stackTrace);
    }
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

