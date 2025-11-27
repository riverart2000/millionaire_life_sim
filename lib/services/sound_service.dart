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
    await _playUrl(
      'https://assets.mixkit.co/active_storage/sfx/2014/2014-preview.mp3',
      volume: 0.4,
    );
  }

  Future<void> playNotification() async {
    if (!_enabled) return;
    await _playUrl(
      'https://assets.mixkit.co/active_storage/sfx/2869/2869-preview.mp3',
      volume: 0.3,
    );
  }

  // Jar-specific jingles
  Future<void> playNecJingle() async {
    if (!_enabled) return;
    // Home/Necessities - Warm, comforting bell sound
    await _playUrl(
      'https://assets.mixkit.co/active_storage/sfx/2000/2000-preview.mp3',
      volume: 0.35,
    );
  }

  Future<void> playFfaJingle() async {
    if (!_enabled) return;
    // Financial Freedom - Success/achievement chime
    await _playUrl(
      'https://assets.mixkit.co/active_storage/sfx/2018/2018-preview.mp3',
      volume: 0.35,
    );
  }

  Future<void> playLtssJingle() async {
    if (!_enabled) return;
    // Long Term Savings - Growing/ascending chime
    await _playUrl(
      'https://assets.mixkit.co/active_storage/sfx/2019/2019-preview.mp3',
      volume: 0.35,
    );
  }

  Future<void> playEduJingle() async {
    if (!_enabled) return;
    // Education - Bright, enlightening ding
    await _playUrl(
      'https://assets.mixkit.co/active_storage/sfx/2021/2021-preview.mp3',
      volume: 0.35,
    );
  }

  Future<void> playPlayJingle() async {
    if (!_enabled) return;
    // Play - Fun, playful chime
    await _playUrl(
      'https://assets.mixkit.co/active_storage/sfx/2015/2015-preview.mp3',
      volume: 0.35,
    );
  }

  Future<void> playGiveJingle() async {
    if (!_enabled) return;
    // Give - Generous, warm bell
    await _playUrl(
      'https://assets.mixkit.co/active_storage/sfx/2016/2016-preview.mp3',
      volume: 0.35,
    );
  }

  // Simulate Next Day jingle
  Future<void> playNextDayJingle() async {
    if (kIsWeb) {
      print('🎵 Next Day jingle requested (enabled: $_enabled)');
    }
    if (!_enabled) {
      if (kIsWeb) print('⏸️ Sound is disabled, skipping');
      return;
    }
    // New day - Uplifting, fresh start chime
    await _playUrl(
      'https://assets.mixkit.co/active_storage/sfx/2001/2001-preview.mp3',
      volume: 0.4,
    );
  }

  // Investment-specific jingles (powerful and motivating!)
  Future<void> playGoldInvestmentJingle() async {
    if (!_enabled) return;
    // Gold - Rich, luxurious success sound
    await _playUrl(
      'https://assets.mixkit.co/active_storage/sfx/2004/2004-preview.mp3',
      volume: 0.45,
    );
  }

  Future<void> playSilverInvestmentJingle() async {
    if (!_enabled) return;
    // Silver - Bright, victory chime
    await _playUrl(
      'https://assets.mixkit.co/active_storage/sfx/2003/2003-preview.mp3',
      volume: 0.45,
    );
  }

  Future<void> playBtcInvestmentJingle() async {
    if (!_enabled) return;
    // Bitcoin - Futuristic, high-tech success sound
    await _playUrl(
      'https://assets.mixkit.co/active_storage/sfx/2020/2020-preview.mp3',
      volume: 0.45,
    );
  }

  Future<void> playRealEstateInvestmentJingle() async {
    if (!_enabled) return;
    // Real Estate - Grand, achievement fanfare
    await _playUrl(
      'https://assets.mixkit.co/active_storage/sfx/2002/2002-preview.mp3',
      volume: 0.5,
    );
  }

  Future<void> _playUrl(String url, {double volume = 0.3}) async {
    if (!_enabled || _player == null) return;
    
    try {
      if (kIsWeb) {
        print('🎵 Playing sound on web: $url at volume $volume');
        // For web: create a new player for each sound to avoid conflicts
        final webPlayer = AudioPlayer();
        await webPlayer.setVolume(volume);
        await webPlayer.setReleaseMode(ReleaseMode.release);
        await webPlayer.play(UrlSource(url));
        // Auto-dispose after playing
        webPlayer.onPlayerComplete.listen((_) {
          webPlayer.dispose();
        });
        print('✅ Web sound started');
      } else {
        // For mobile: reuse the same player
        await _player!.stop();
        await _player!.setVolume(volume);
        await _player!.play(UrlSource(url));
      }
    } catch (error) {
      if (kIsWeb) {
        print('❌ Web audio error: $error');
        print('ℹ️ Tip: Interact with the page first (click a button) to enable audio');
      }
      
      // Fallback to system sound (mobile only)
      if (!kIsWeb) {
        try {
          await SystemSound.play(SystemSoundType.click);
        } catch (_) {
          // Silently fail
        }
      }
    }
  }

  Future<void> dispose() async {
    await _player?.dispose();
  }
}

