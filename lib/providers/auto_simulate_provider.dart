import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/utils/logger.dart';
import '../core/utils/result.dart';
import 'bootstrap_provider.dart';
import 'data_providers.dart';
import 'investment_provider.dart';
import 'session_providers.dart';
import 'simulation_date_provider.dart';

/// Provider that handles automatic daily income simulation
/// Checks if simulation should run when the dashboard loads
final autoSimulateProvider = FutureProvider<void>((ref) async {
  try {
    // Get user profile to check if auto-simulate is enabled
    final profileAsync = await ref.watch(userProfileProvider.future);
    final profile = profileAsync;
    
    if (profile == null || !profile.autoSimulateDaily) {
      logInfo('⏸️ Auto-simulate is disabled');
      return;
    }
    
    // Get current simulation date
    final simulationDate = ref.watch(simulationDateProvider);
    final now = DateTime.now();
    
    // Normalize dates to compare just the date part (ignore time)
    final simDateNormalized = DateTime(simulationDate.year, simulationDate.month, simulationDate.day);
    final nowNormalized = DateTime(now.year, now.month, now.day);
    
    // Calculate days behind
    final daysBehind = nowNormalized.difference(simDateNormalized).inDays;
    
    if (daysBehind <= 0) {
      logInfo('✅ Simulation date is current (${simulationDate.toIso8601String()})');
      return;
    }
    
    logInfo('🔄 Auto-simulating $daysBehind day(s) of income...');
    
    final userId = ref.read(userIdProvider);
    final incomeService = ref.read(incomeServiceProvider);
    final dateNotifier = ref.read(simulationDateProvider.notifier);
    
    // Simulate each day that was missed
    for (int i = 0; i < daysBehind; i++) {
      final result = await incomeService.simulateNextDay(userId: userId);
      
      if (result is Success<double>) {
        await dateNotifier.incrementDay();
        logInfo('✅ Day ${i + 1}/$daysBehind simulated: income ${result.value.toStringAsFixed(2)}');
      } else if (result is Failure<double>) {
        logError('❌ Failed to simulate day ${i + 1}', result.exception, result.stackTrace);
        // Stop on first failure
        break;
      }
    }
    
    // Invalidate providers to refresh UI
    ref.invalidate(jarsProvider);
    ref.invalidate(investmentsProvider);
    
    logInfo('✅ Auto-simulation complete');
  } catch (e, st) {
    logError('Auto-simulate failed', e, st);
    // Don't rethrow - we don't want to break the app if auto-simulate fails
  }
});

