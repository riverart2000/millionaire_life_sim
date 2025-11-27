import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final simulationDateProvider = NotifierProvider<SimulationDateNotifier, DateTime>(() {
  return SimulationDateNotifier();
});

class SimulationDateNotifier extends Notifier<DateTime> {
  static const String _storageKey = 'simulation_current_date';
  bool _isInitialized = false;

  @override
  DateTime build() {
    // Initialize with today's date first
    final today = DateTime.now();
    
    // Load saved date asynchronously if not already initialized
    if (!_isInitialized) {
      _isInitialized = true;
      _loadDate();
    }
    
    return today;
  }

  Future<void> _loadDate() async {
    final prefs = await SharedPreferences.getInstance();
    final dateString = prefs.getString(_storageKey);
    
    if (dateString != null) {
      try {
        final savedDate = DateTime.parse(dateString);
        // Only use saved date if it's valid (not too far in the past/future)
        final today = DateTime.now();
        final daysDifference = savedDate.difference(today).inDays;
        
        // If saved date is more than 1 year old or more than 1 year in future, reset to today
        if (daysDifference.abs() < 365) {
          state = savedDate;
          if (kDebugMode) {
            debugPrint('📅 Loaded saved date: ${DateFormat('EEEE, MMMM d, yyyy').format(savedDate)}');
          }
          return;
        }
      } catch (e) {
        // Invalid date, will default to today
      }
    }
    
    // Default to today and save it
    final today = DateTime.now();
    state = today;
    await _saveDate(today);
    if (kDebugMode) {
      debugPrint('📅 Initialized with today\'s date: ${DateFormat('EEEE, MMMM d, yyyy').format(today)}');
    }
  }

  Future<void> _saveDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, date.toIso8601String());
  }

  Future<void> incrementDay() async {
    // Get current state - ensure we're working with the actual current state
    final currentDate = state;
    final newDate = currentDate.add(const Duration(days: 1));
    
    if (kDebugMode) {
      debugPrint('📅 Incrementing date from ${DateFormat('EEEE, MMMM d, yyyy').format(currentDate)} to ${DateFormat('EEEE, MMMM d, yyyy').format(newDate)}');
    }
    
    // Update state synchronously - this will trigger a rebuild automatically in Riverpod 3.x
    // Setting state here causes all widgets watching this provider to rebuild
    state = newDate;
    
    // Save to persistence (don't await before updating state to keep UI responsive)
    _saveDate(newDate).catchError((error) {
      if (kDebugMode) {
        debugPrint('⚠️ Failed to save date: $error');
      }
    });
    
    // Verify state was updated
    if (kDebugMode) {
      final verifyState = state;
      debugPrint('✅ Date updated and saved. Current state: ${DateFormat('EEEE, MMMM d, yyyy').format(verifyState)}');
    }
  }

  String getFormattedDate() {
    return DateFormat('EEEE, MMMM d, yyyy').format(state);
  }
}

