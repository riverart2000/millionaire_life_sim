import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/sound_provider.dart';

/// A celebration overlay that shows fireworks and plays a jingle
/// Can be triggered programmatically for purchases
class PurchaseCelebration extends StatefulWidget {
  const PurchaseCelebration({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<PurchaseCelebration> createState() => PurchaseCelebrationState();

  /// Show celebration from any descendant widget
  static void celebrate(BuildContext context) {
    final state = context.findAncestorStateOfType<PurchaseCelebrationState>();
    state?.celebrate();
  }
}

class PurchaseCelebrationState extends State<PurchaseCelebration> {
  late ConfettiController _leftController;
  late ConfettiController _rightController;
  late ConfettiController _centerController;

  @override
  void initState() {
    super.initState();
    _leftController = ConfettiController(duration: const Duration(milliseconds: 800));
    _rightController = ConfettiController(duration: const Duration(milliseconds: 800));
    _centerController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _leftController.dispose();
    _rightController.dispose();
    _centerController.dispose();
    super.dispose();
  }

  void celebrate() {
    // Play celebration sound
    try {
      final soundProvider = context.read<SoundProvider>();
      unawaited(soundProvider.playCelebration());
    } catch (e) {
      // Sound failed, but continue with visual celebration
    }
    
    // Trigger confetti
    _leftController.play();
    _rightController.play();
    _centerController.play();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        // Fireworks from top-left
        Positioned.fill(
          child: IgnorePointer(
            child: Align(
              alignment: Alignment.topLeft,
              child: ConfettiWidget(
                confettiController: _leftController,
                blastDirection: 0, // radians - 0 is right
                blastDirectionality: BlastDirectionality.explosive,
                emissionFrequency: 0.03,
                numberOfParticles: 25,
                maxBlastForce: 40,
                minBlastForce: 15,
                gravity: 0.2,
                colors: const [
                  Color(0xFF4A5EE5),
                  Color(0xFF5BE9B9),
                  Color(0xFFFFCE67),
                  Color(0xFFFB6F92),
                  Color(0xFF8758FF),
                  Color(0xFF34C759),
                ],
              ),
            ),
          ),
        ),
        // Fireworks from top-right
        Positioned.fill(
          child: IgnorePointer(
            child: Align(
              alignment: Alignment.topRight,
              child: ConfettiWidget(
                confettiController: _rightController,
                blastDirection: 3.14, // radians - π is left
                blastDirectionality: BlastDirectionality.explosive,
                emissionFrequency: 0.03,
                numberOfParticles: 25,
                maxBlastForce: 40,
                minBlastForce: 15,
                gravity: 0.2,
                colors: const [
                  Color(0xFF4A5EE5),
                  Color(0xFF5BE9B9),
                  Color(0xFFFFCE67),
                  Color(0xFFFB6F92),
                  Color(0xFF8758FF),
                  Color(0xFF34C759),
                ],
              ),
            ),
          ),
        ),
        // Center explosion
        Positioned.fill(
          child: IgnorePointer(
            child: Align(
              alignment: Alignment.center,
              child: ConfettiWidget(
                confettiController: _centerController,
                blastDirectionality: BlastDirectionality.explosive,
                emissionFrequency: 0.02,
                numberOfParticles: 50,
                gravity: 0.15,
                maxBlastForce: 30,
                minBlastForce: 10,
                colors: const [
                  Color(0xFF4A5EE5),
                  Color(0xFF8758FF),
                  Color(0xFFFFB4A2),
                  Color(0xFFB5E48C),
                  Color(0xFFFFCE67),
                  Color(0xFF5BE9B9),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

