import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../services/affirmation_service.dart';
import '../core/config/app_config.dart';

class AffirmationSettings {
  final bool enabled;
  final int flashDurationMs;
  final double opacity;
  final int intervalSeconds;
  final bool randomPosition;
  final double fontSize;

  const AffirmationSettings({
    required this.enabled,
    required this.flashDurationMs,
    required this.opacity,
    required this.intervalSeconds,
    required this.randomPosition,
    required this.fontSize,
  });

  AffirmationSettings copyWith({
    bool? enabled,
    int? flashDurationMs,
    double? opacity,
    int? intervalSeconds,
    bool? randomPosition,
    double? fontSize,
  }) {
    return AffirmationSettings(
      enabled: enabled ?? this.enabled,
      flashDurationMs: flashDurationMs ?? this.flashDurationMs,
      opacity: opacity ?? this.opacity,
      intervalSeconds: intervalSeconds ?? this.intervalSeconds,
      randomPosition: randomPosition ?? this.randomPosition,
      fontSize: fontSize ?? this.fontSize,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'flashDurationMs': flashDurationMs,
      'opacity': opacity,
      'intervalSeconds': intervalSeconds,
      'randomPosition': randomPosition,
      'fontSize': fontSize,
    };
  }

  factory AffirmationSettings.fromJson(Map<String, dynamic> json) {
    return AffirmationSettings(
      enabled: json['enabled'] ?? true,
      flashDurationMs: json['flashDurationMs'] ?? 150,
      opacity: json['opacity'] ?? 0.15,
      intervalSeconds: json['intervalSeconds'] ?? 60,
      randomPosition: json['randomPosition'] ?? true,
      fontSize: json['fontSize'] ?? 32.0,
    );
  }
}

class AffirmationSettingsNotifier extends Notifier<AffirmationSettings> {
  static const String _storageKey = 'subliminal_affirmation_settings';

  @override
  AffirmationSettings build() {
    _loadSettings();
    // Return temporary defaults while loading
    return const AffirmationSettings(
      enabled: true,
      flashDurationMs: 150,
      opacity: 0.15,
      intervalSeconds: 60,
      randomPosition: true,
      fontSize: 32.0,
    );
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      
      if (jsonString != null) {
        // User has saved settings
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        state = AffirmationSettings.fromJson(json);
      } else {
        // First time - load from config file
        final config = await AppConfig.load();
        final affConfig = config.affirmations;
        state = AffirmationSettings(
          enabled: affConfig.enabled,
          flashDurationMs: affConfig.flashDurationMs,
          opacity: affConfig.opacity,
          intervalSeconds: affConfig.intervalSeconds,
          randomPosition: affConfig.randomPosition,
          fontSize: affConfig.fontSize,
        );
      }
    } catch (e) {
      // Use defaults if config loading fails
      print('Error loading affirmation settings: $e');
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(state.toJson());
      await prefs.setString(_storageKey, jsonString);
    } catch (e) {
      // Ignore errors
    }
  }

  void setEnabled(bool enabled) {
    state = state.copyWith(enabled: enabled);
    _saveSettings();
  }

  void setFlashDuration(int durationMs) {
    state = state.copyWith(flashDurationMs: durationMs);
    _saveSettings();
  }

  void setOpacity(double opacity) {
    state = state.copyWith(opacity: opacity);
    _saveSettings();
  }

  void setInterval(int intervalSeconds) {
    state = state.copyWith(intervalSeconds: intervalSeconds);
    _saveSettings();
  }

  void setRandomPosition(bool randomPosition) {
    state = state.copyWith(randomPosition: randomPosition);
    _saveSettings();
  }

  void setFontSize(double fontSize) {
    state = state.copyWith(fontSize: fontSize);
    _saveSettings();
  }
}

final affirmationSettingsProvider = NotifierProvider<AffirmationSettingsNotifier, AffirmationSettings>(() {
  return AffirmationSettingsNotifier();
});

final affirmationServiceProvider = Provider<AffirmationService>((ref) {
  return AffirmationService();
});
