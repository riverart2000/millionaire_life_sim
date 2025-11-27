import 'dart:async';

import 'package:flutter/foundation.dart';

import '../services/sound_service.dart';

class SoundProvider extends ChangeNotifier {
  SoundProvider({SoundService? service}) : _service = service ?? SoundService.instance;

  final SoundService _service;
  bool _isEnabled = true;
  bool _isReady = false;

  bool get isEnabled => _isEnabled;
  bool get isReady => _isReady;

  Future<void> initialize() async {
    _isEnabled = await _service.init();
    _isReady = true;
    notifyListeners();
  }

  Future<void> toggleSound() async {
    _isEnabled = await _service.toggle();
    notifyListeners();
  }

  Future<void> playCelebration() async {
    await _service.playCelebration();
  }

  Future<void> playNotification() async {
    await _service.playNotification();
  }

  Future<void> playJarJingle(String jarId) async {
    switch (jarId.toUpperCase()) {
      case 'NEC':
        await _service.playNecJingle();
        break;
      case 'FFA':
        await _service.playFfaJingle();
        break;
      case 'LTSS':
        await _service.playLtssJingle();
        break;
      case 'EDU':
        await _service.playEduJingle();
        break;
      case 'PLAY':
        await _service.playPlayJingle();
        break;
      case 'GIVE':
        await _service.playGiveJingle();
        break;
      default:
        await _service.playCelebration();
    }
  }

  Future<void> playNextDayJingle() async {
    await _service.playNextDayJingle();
  }

  Future<void> playInvestmentJingle(String symbol) async {
    switch (symbol.toUpperCase()) {
      case 'GOLD':
        await _service.playGoldInvestmentJingle();
        break;
      case 'SILVER':
        await _service.playSilverInvestmentJingle();
        break;
      case 'BTC':
        await _service.playBtcInvestmentJingle();
        break;
      case 'REALESTATE':
        await _service.playRealEstateInvestmentJingle();
        break;
      default:
        await _service.playCelebration();
    }
  }

  @override
  void dispose() {
    unawaited(_service.dispose());
    super.dispose();
  }
}

