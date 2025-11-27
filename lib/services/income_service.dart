import 'dart:math';

import '../core/constants/jar_constants.dart';
import '../core/utils/logger.dart';
import '../core/utils/result.dart';
import '../models/jar_model.dart';
import '../models/transaction_model.dart';
import '../models/user_profile_model.dart';
import '../repositories/interfaces/user_repository.dart';
import 'bills_service.dart';
import 'interest_service.dart';
import 'investment_return_service.dart';
import 'investment_service.dart';
import 'jar_service.dart';
import 'market_price_service.dart';

class IncomeService {
  IncomeService({
    required UserRepository userRepository,
    required JarService jarService,
    required InterestService interestService,
    required InvestmentService investmentService,
    required MarketPriceService marketPriceService,
    required BillsService billsService,
    required InvestmentReturnService investmentReturnService,
  })  : _userRepository = userRepository,
        _jarService = jarService,
        _interestService = interestService,
        _investmentService = investmentService,
        _marketPriceService = marketPriceService,
        _billsService = billsService,
        _investmentReturnService = investmentReturnService,
        _random = Random();

  final UserRepository _userRepository;
  final JarService _jarService;
  final InterestService _interestService;
  final InvestmentService _investmentService;
  final MarketPriceService _marketPriceService;
  final BillsService _billsService;
  final InvestmentReturnService _investmentReturnService;
  final Random _random;

  Future<Result<double>> simulateNextDay({required String userId}) async {
    try {
      final profile = await _userRepository.fetchProfile();
      if (profile == null) {
        throw StateError('User profile not found');
      }

      final income = _determineIncome(profile);
      
      // IMPORTANT: Deduct bills BEFORE distributing income
      // This ensures NEC jar can go negative if bills exceed the income allocation
      try {
        final bills = await _billsService.loadBills();
        final totalBills = bills.values.fold<double>(0.0, (sum, amount) => sum + amount);
        
        if (totalBills > 0) {
          logInfo('💰 Deducting daily bills from NEC jar: £${totalBills.toStringAsFixed(2)}');
          
          // Withdraw bills from NEC jar (can go negative)
          final result = await _jarService.withdraw(
            userId: userId,
            jarId: JarConstants.nec,
            amount: totalBills,
            description: 'Daily bills: Rent £${bills[BillsService.rentKey]!.toStringAsFixed(2)}, Food £${bills[BillsService.foodKey]!.toStringAsFixed(2)}, Travel £${bills[BillsService.travelKey]!.toStringAsFixed(2)}, Accessories £${bills[BillsService.accessoriesKey]!.toStringAsFixed(2)}',
            kind: TransactionKind.purchase,
            allowNegative: true, // NEC jar can go negative
          );
          
          if (result is Success<Jar>) {
            logInfo('✅ Bills deducted from NEC jar. New balance: £${result.value.balance.toStringAsFixed(2)}');
          } else if (result is Failure<Jar>) {
            logError('❌ Failed to deduct bills from NEC jar', result.exception, result.stackTrace);
          }
        }
      } catch (error, stackTrace) {
        logError('❌ Failed to process bills', error, stackTrace);
        // Don't fail the entire operation if bills processing fails
      }
      
      // Add income to unallocated balance instead of auto-distributing
      // User will manually allocate this money using the drag-drop interface
      final updatedProfile = profile.copyWith(
        unallocatedBalance: profile.unallocatedBalance + income,
      );
      await _userRepository.saveProfile(updatedProfile);
      logInfo('💰 Added £${income.toStringAsFixed(2)} to unallocated balance. New balance: £${updatedProfile.unallocatedBalance.toStringAsFixed(2)}');

      // Apply interest to jars
      final interestRates = await _interestService.loadRates();
      await _jarService.applyInterest(
        userId: userId,
        interestRates: interestRates,
      );
      logInfo('✅ Applied interest to jars');

      // Apply investment returns (increase units owned)
      try {
        final investmentReturnRates = await _investmentReturnService.loadRates();
        await _investmentService.applyDailyReturns(investmentReturnRates);
        logInfo('✅ Applied investment returns');
      } catch (error, stackTrace) {
        logError('❌ Failed to apply investment returns', error, stackTrace);
        // Don't fail the entire operation
      }

      // Increase bills by £0.10 per day (inflation)
      try {
        await _billsService.increaseBillsDaily();
        logInfo('✅ Increased daily bills by £0.10 (inflation)');
      } catch (error, stackTrace) {
        logError('❌ Failed to increase bills', error, stackTrace);
        // Don't fail the entire operation
      }

      // Update investment prices from market (only if stale or missing)
      try {
        logInfo('🔄 Checking investment prices...');
        
        // Check which prices need updating
        final symbolsToFetch = <String>[];
        for (final symbol in ['GOLD', 'SILVER', 'BTC']) {
          final cachedPrice = await _investmentService.getCachedPrice(symbol);
          if (cachedPrice == null) {
            symbolsToFetch.add(symbol);
            logInfo('📥 $symbol needs fetching (no cache)');
          } else {
            logInfo('✅ $symbol is cached and fresh');
          }
        }
        
        // Only fetch if we need to
        if (symbolsToFetch.isNotEmpty) {
          logInfo('🔄 Fetching prices for: ${symbolsToFetch.join(", ")}');
          final allPrices = await _marketPriceService.fetchAllPrices();
          
          // Filter to only update symbols we need
          final pricesToUpdate = <String, double>{};
          for (final symbol in symbolsToFetch) {
            if (allPrices.containsKey(symbol)) {
              pricesToUpdate[symbol] = allPrices[symbol]!;
            }
          }
          
          if (pricesToUpdate.isNotEmpty) {
            logInfo('✅ Updating prices: $pricesToUpdate');
            await _investmentService.updatePrices(pricesToUpdate);
            logInfo('✅ Successfully updated investment prices');
          } else {
            logError('⚠️ No prices received from market service for needed symbols', null, null);
          }
        } else {
          logInfo('✅ All prices are cached and fresh, skipping fetch');
        }
      } catch (error, stackTrace) {
        logError('❌ Failed to update investment prices', error, stackTrace);
        // Don't fail the entire operation if price update fails
      }

      return Success(income);
    } catch (error, stackTrace) {
      logError('Failed to simulate daily income', error, stackTrace);
      return Failure(error, stackTrace);
    }
  }

  double _determineIncome(UserProfile profile) {
    final base = profile.dailyIncome;
    if (base <= 0) {
      return 0;
    }
    final variance = base * 0.1; // ±10%
    final offset = (_random.nextDouble() * variance * 2) - variance;
    return (base + offset).clamp(0, double.infinity);
  }
}

