import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundService {
  SoundService._internal();

  static final SoundService _instance = SoundService._internal();
  static SoundService get instance => _instance;

  AudioPlayer? _player;
  bool _enabled = true;

  static const _prefsKey = 'template_sound_enabled';

  Future<bool> init() async {
    final prefs = await SharedPreferences.getInstance();
    _enabled = prefs.getBool(_prefsKey) ?? true;
    
    // Initialize player
    _player = AudioPlayer();
    
    // On web, set up player for better compatibility
    if (kIsWeb) {
      try {
        await _player?.setReleaseMode(ReleaseMode.release);
        print('🔊 Web audio player initialized');
      } catch (e) {
        print('❌ Web audio initialization error: $e');
      }
    }
    
    return _enabled;
  }

  bool get isEnabled => _enabled;

  Future<bool> toggle() async {
    _enabled = !_enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, _enabled);
    return _enabled;
  }

  Future<void> setEnabled(bool value) async {
    _enabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, _enabled);
  }

  Future<void> playCelebration() async {
    if (!_enabled) return;
    await _playAsset('sounds/celebration.mp3', volume: 0.4);
  }

  Future<void> playNotification() async {
    if (!_enabled) return;
    await _playAsset('sounds/notification.mp3', volume: 0.3);
  }

  Future<void> playButtonClick() async {
    if (!_enabled) return;
    // Pleasant, soft button click sound
    await _playAsset('sounds/button_click.mp3', volume: 0.25);
  }

  // Jar-specific jingles
  Future<void> playNecJingle() async {
    if (!_enabled) return;
    // Home/Necessities - Warm, comforting bell sound
    await _playAsset('sounds/nec_jar.mp3', volume: 0.35);
  }

  Future<void> playFfaJingle() async {
    if (!_enabled) return;
    // Financial Freedom - Success/achievement chime
    await _playAsset('sounds/ffa_jar.mp3', volume: 0.35);
  }

  Future<void> playLtssJingle() async {
    if (!_enabled) return;
    // Long Term Savings - Growing/ascending chime
    await _playAsset('sounds/ltss_jar.mp3', volume: 0.35);
  }

  Future<void> playEduJingle() async {
    if (!_enabled) return;
    // Education - Bright, enlightening ding
    await _playAsset('sounds/edu_jar.mp3', volume: 0.35);
  }

  Future<void> playPlayJingle() async {
    if (!_enabled) return;
    // Play - Fun, playful chime
    await _playAsset('sounds/play_jar.mp3', volume: 0.35);
  }

  Future<void> playGiveJingle() async {
    if (!_enabled) return;
    // Give - Generous, warm bell
    await _playAsset('sounds/give_jar.mp3', volume: 0.35);
  }

  // Simulate Next Day jingle
  Future<void> playNextDayJingle() async {
    if (!_enabled) return;
    // New day - Uplifting, fresh start chime
    await _playAsset('sounds/next_day.mp3', volume: 0.4);
  }

  // Investment-specific jingles (powerful and motivating!)
  Future<void> playGoldInvestmentJingle() async {
    if (!_enabled) return;
    // Gold - Rich, luxurious success sound
    await _playAsset('sounds/gold_invest.mp3', volume: 0.45);
  }

  Future<void> playSilverInvestmentJingle() async {
    if (!_enabled) return;
    // Silver - Bright, victory chime
    await _playAsset('sounds/silver_invest.mp3', volume: 0.45);
  }

  Future<void> playBtcInvestmentJingle() async {
    if (!_enabled) return;
    // Bitcoin - Futuristic, high-tech success sound
    await _playAsset('sounds/btc_invest.mp3', volume: 0.45);
  }

  Future<void> playRealEstateInvestmentJingle() async {
    if (!_enabled) return;
    // Real Estate - Grand, achievement fanfare
    await _playAsset('sounds/real_estate_invest.mp3', volume: 0.5);
  }

  Future<void> _playAsset(String assetPath, {double volume = 0.3}) async {
    if (!_enabled || _player == null) return;
    
    try {
      if (kIsWeb) {
        // For web: create a new player for each sound to avoid conflicts
        final webPlayer = AudioPlayer();
        await webPlayer.setVolume(volume);
        await webPlayer.setReleaseMode(ReleaseMode.release);
        await webPlayer.play(AssetSource(assetPath));
        // Auto-dispose after playing
        webPlayer.onPlayerComplete.listen((_) {
          webPlayer.dispose();
        });
      } else {
        // For mobile/desktop: reuse the same player
        await _player!.stop();
        await _player!.setVolume(volume);
        await _player!.play(AssetSource(assetPath));
      }
    } catch (error) {
      // Silently fail on all platforms - audio is nice-to-have
      // Just continue without sound rather than showing errors
    }
  }

  Future<void> dispose() async {
    await _player?.dispose();
  }
}

