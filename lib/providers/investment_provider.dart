import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/jar_constants.dart';
import '../core/utils/result.dart';
import '../models/investment_model.dart';
import '../models/jar_model.dart';
import '../models/transaction_model.dart';
import 'bootstrap_provider.dart';
import 'session_providers.dart';

final investmentsProvider = FutureProvider<List<Investment>>((ref) async {
  final investmentService = ref.watch(investmentServiceProvider);
  return await investmentService.fetchInvestments();
});

// Helper function to buy investments
Future<Result<Investment>> buyInvestment({
  required WidgetRef ref,
  required String symbol,
  required double amountDollars,
  required double currentPrice,
  required double currentUnits,
}) async {
  final investmentService = ref.read(investmentServiceProvider);
  final jarService = ref.read(jarServiceProvider);
  final userId = ref.read(userIdProvider);

  if (amountDollars <= 0) {
    return Failure(ArgumentError('Amount must be greater than zero'));
  }

  try {
    final price = currentPrice;
    final unitsToAdd = amountDollars / price;

    final withdrawResult = await jarService.withdraw(
      userId: userId,
      jarId: JarConstants.ffa,
      amount: amountDollars,
      description: 'Investment purchase $symbol',
      kind: TransactionKind.purchase,
    );

    if (withdrawResult is Failure<Jar>) {
      return Failure(withdrawResult.exception, withdrawResult.stackTrace);
    }

    await investmentService.recordPurchase(symbol: symbol, units: unitsToAdd);
    
    // Refresh investments list by invalidating the provider
    ref.invalidate(investmentsProvider);

    // Return immediately with manually constructed updated investment
    final updatedInvestment = Investment(
      symbol: symbol,
      name: symbol == 'GOLD' ? 'Gold' : symbol == 'SILVER' ? 'Silver' : 'Bitcoin',
      pricePerUnit: currentPrice, // Use the current price from the system
      unitsOwned: currentUnits + unitsToAdd,
    );
    
    return Success(updatedInvestment);
  } catch (error, stackTrace) {
    return Failure(error, stackTrace);
  }
}

// Helper function to sell investments
Future<Result<Investment>> sellInvestment({
  required WidgetRef ref,
  required String symbol,
  required double units,
  required double currentPrice,
  required double currentUnits,
}) async {
  final investmentService = ref.read(investmentServiceProvider);
  final jarService = ref.read(jarServiceProvider);
  final userId = ref.read(userIdProvider);

  if (units <= 0) {
    return Failure(ArgumentError('Units must be greater than zero'));
  }

  if (units > currentUnits) {
    return Failure(ArgumentError('Cannot sell more units than you own'));
  }

  try {
    final saleAmount = units * currentPrice;

    // Deposit proceeds into FFA jar
    final depositResult = await jarService.deposit(
      userId: userId,
      jarId: JarConstants.ffa,
      amount: saleAmount,
      description: 'Investment sale $symbol',
      kind: TransactionKind.income,
    );

    if (depositResult is Failure<Jar>) {
      return Failure(depositResult.exception, depositResult.stackTrace);
    }

    await investmentService.recordSale(symbol: symbol, units: units);
    
    // Refresh investments list by invalidating the provider
    ref.invalidate(investmentsProvider);

    // Return updated investment
    final updatedInvestment = Investment(
      symbol: symbol,
      name: symbol == 'GOLD' ? 'Gold' : symbol == 'SILVER' ? 'Silver' : symbol == 'BTC' ? 'Bitcoin' : 'Real Estate',
      pricePerUnit: currentPrice,
      unitsOwned: currentUnits - units,
    );
    
    return Success(updatedInvestment);
  } catch (error, stackTrace) {
    return Failure(error, stackTrace);
  }
}

