import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import '../models/riddle_model.dart';

@lazySingleton
class RiddleService {
  static const String _riddleStreakKey = 'riddle_streak';
  static const String _totalCorrectKey = 'riddle_total_correct';
  static const String _totalAttemptsKey = 'riddle_total_attempts';

  List<Riddle> _allRiddles = [];
  final Random _random = Random();

  // Streak milestones and rewards
  static const Map<int, double> streakRewards = {
    3: 50.0,
    5: 200.0,
    10: 1000.0,
    20: 5000.0,
  };

  Future<void> initialize() async {
    await _loadRiddles();
  }

  Future<void> _loadRiddles() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/all_riddles.json');
      final jsonList = jsonDecode(jsonString) as List;
      
      for (final categoryJson in jsonList) {
        final category = RiddleCategory.fromJson(categoryJson as Map<String, dynamic>);
        _allRiddles.addAll(category.items);
      }
      print('✅ Loaded ${_allRiddles.length} riddles successfully');
    } catch (e, stackTrace) {
      print('❌ Error loading riddles: $e');
      print('Stack trace: $stackTrace');
      rethrow; // Re-throw so initialization fails visibly
    }
  }

  Riddle getRandomRiddle({String? difficulty}) {
    if (_allRiddles.isEmpty) {
      throw StateError('Riddles not loaded. Call initialize() first.');
    }

    List<Riddle> filteredRiddles = _allRiddles;
    
    if (difficulty != null) {
      filteredRiddles = _allRiddles.where((r) => r.difficulty == difficulty).toList();
      if (filteredRiddles.isEmpty) {
        filteredRiddles = _allRiddles;
      }
    }

    return filteredRiddles[_random.nextInt(filteredRiddles.length)];
  }

  Riddle getRiddleBasedOnStreak() {
    final streak = getCurrentStreak();
    
    if (streak >= 10) {
      return getRandomRiddle(difficulty: 'advanced');
    } else if (streak >= 5) {
      return getRandomRiddle(difficulty: 'intermediate');
    } else {
      return getRandomRiddle(difficulty: 'beginner');
    }
  }

  int getCurrentStreak() {
    final box = Hive.box('app_data');
    return box.get(_riddleStreakKey, defaultValue: 0) as int;
  }

  int getTotalCorrect() {
    final box = Hive.box('app_data');
    return box.get(_totalCorrectKey, defaultValue: 0) as int;
  }

  int getTotalAttempts() {
    final box = Hive.box('app_data');
    return box.get(_totalAttemptsKey, defaultValue: 0) as int;
  }

  Future<void> recordCorrectAnswer() async {
    final box = Hive.box('app_data');
    final currentStreak = getCurrentStreak();
    final totalCorrect = getTotalCorrect();
    final totalAttempts = getTotalAttempts();

    await box.put(_riddleStreakKey, currentStreak + 1);
    await box.put(_totalCorrectKey, totalCorrect + 1);
    await box.put(_totalAttemptsKey, totalAttempts + 1);
  }

  Future<void> recordIncorrectAnswer() async {
    final box = Hive.box('app_data');
    final totalAttempts = getTotalAttempts();

    await box.put(_riddleStreakKey, 0); // Reset streak
    await box.put(_totalAttemptsKey, totalAttempts + 1);
  }

  Future<void> resetStreak() async {
    final box = Hive.box('app_data');
    await box.put(_riddleStreakKey, 0);
  }

  double? getStreakReward(int streak) {
    return streakRewards[streak];
  }

  bool isStreakMilestone(int streak) {
    return streakRewards.containsKey(streak);
  }

  String getStreakMessage(int streak) {
    if (streak >= 20) {
      return '🔥 LEGENDARY! 20+ Streak! Master Riddler Status!';
    } else if (streak >= 10) {
      return '⚡ INCREDIBLE! 10+ Streak! You\'re on fire!';
    } else if (streak >= 5) {
      return '🎯 EXCELLENT! 5+ Streak! Keep it up!';
    } else if (streak >= 3) {
      return '💪 GREAT! 3+ Streak! Building momentum!';
    } else {
      return 'Keep going! Build your streak!';
    }
  }

  double getAccuracyPercentage() {
    final totalAttempts = getTotalAttempts();
    if (totalAttempts == 0) return 0.0;
    
    final totalCorrect = getTotalCorrect();
    return (totalCorrect / totalAttempts) * 100;
  }
}
