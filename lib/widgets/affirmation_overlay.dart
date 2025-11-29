import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/affirmation_provider.dart';

class AffirmationOverlay extends ConsumerStatefulWidget {
  const AffirmationOverlay({super.key});

  @override
  ConsumerState<AffirmationOverlay> createState() => _AffirmationOverlayState();
}

class _AffirmationOverlayState extends ConsumerState<AffirmationOverlay> {
  Timer? _intervalTimer;
  Timer? _fadeTimer;
  String _currentAffirmation = '';
  bool _isVisible = false;
  final Random _random = Random();
  double _positionX = 0.5;
  double _positionY = 0.5;

  @override
  void initState() {
    super.initState();
    _initializeAffirmations();
  }

  Future<void> _initializeAffirmations() async {
    final service = ref.read(affirmationServiceProvider);
    await service.loadAffirmations();
    _startTimer();
  }

  void _startTimer() {
    final settings = ref.read(affirmationSettingsProvider);
    
    _intervalTimer?.cancel();
    
    if (!settings.enabled) return;

    _intervalTimer = Timer.periodic(
      Duration(seconds: settings.intervalSeconds),
      (_) => _showAffirmation(),
    );
  }

  void _showAffirmation() {
    final settings = ref.read(affirmationSettingsProvider);
    final service = ref.read(affirmationServiceProvider);

    if (!settings.enabled) return;

    setState(() {
      _currentAffirmation = service.getNextAffirmation();
      _isVisible = true;
      
      if (settings.randomPosition) {
        _positionX = 0.1 + _random.nextDouble() * 0.8;
        _positionY = 0.1 + _random.nextDouble() * 0.8;
      } else {
        _positionX = 0.5;
        _positionY = 0.5;
      }
    });

    _fadeTimer?.cancel();
    _fadeTimer = Timer(
      Duration(milliseconds: settings.flashDurationMs),
      () {
        if (mounted) {
          setState(() => _isVisible = false);
        }
      },
    );
  }

  @override
  void dispose() {
    _intervalTimer?.cancel();
    _fadeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AffirmationSettings>(affirmationSettingsProvider, (previous, next) {
      if (previous?.enabled != next.enabled || 
          previous?.intervalSeconds != next.intervalSeconds) {
        _startTimer();
      }
    });

    final settings = ref.watch(affirmationSettingsProvider);

    if (!settings.enabled || _currentAffirmation.isEmpty) {
      return const SizedBox.shrink();
    }

    return Positioned.fill(
      child: IgnorePointer(
        child: AnimatedOpacity(
          opacity: _isVisible ? settings.opacity : 0.0,
          duration: const Duration(milliseconds: 100),
          child: FractionallySizedBox(
            alignment: Alignment(
              (_positionX - 0.5) * 2,
              (_positionY - 0.5) * 2,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  _currentAffirmation,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: settings.fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    decoration: TextDecoration.none,
                    shadows: const [
                      Shadow(
                        color: Colors.black,
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
