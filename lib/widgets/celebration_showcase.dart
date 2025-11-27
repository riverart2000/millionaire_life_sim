import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/sound_provider.dart';

class CelebrationShowcase extends StatefulWidget {
  const CelebrationShowcase({super.key});

  @override
  State<CelebrationShowcase> createState() => _CelebrationShowcaseState();
}

class _CelebrationShowcaseState extends State<CelebrationShowcase> {
  late ConfettiController _centerController;
  late ConfettiController _fireworksController;

  @override
  void initState() {
    super.initState();
    _centerController = ConfettiController(duration: const Duration(seconds: 2));
    _fireworksController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _centerController.dispose();
    _fireworksController.dispose();
    super.dispose();
  }

  void _playCelebration() {
    final soundProvider = context.read<SoundProvider>();
    unawaited(soundProvider.playCelebration());
    _centerController.play();
    _fireworksController.play();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.celebration, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 12),
                    Text(
                      'Celebrate progress',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Trigger the confetti fireworks and soundscape exactly like the main app whenever learners hit big milestones.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    FilledButton.icon(
                      onPressed: _playCelebration,
                      icon: const Icon(Icons.catching_pokemon_outlined),
                      label: const Text('Launch fireworks'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        final soundProvider = context.read<SoundProvider>();
                        unawaited(soundProvider.playNotification());
                      },
                      icon: const Icon(Icons.spatial_audio),
                      label: const Text('Play chime'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _fireworksController,
                blastDirectionality: BlastDirectionality.explosive,
                emissionFrequency: 0.05,
                numberOfParticles: 20,
                maxBlastForce: 35,
                minBlastForce: 10,
                colors: const [
                  Color(0xFF4A5EE5),
                  Color(0xFF5BE9B9),
                  Color(0xFFFFCE67),
                  Color(0xFFFB6F92),
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: Align(
              alignment: Alignment.center,
              child: ConfettiWidget(
                confettiController: _centerController,
                blastDirectionality: BlastDirectionality.explosive,
                emissionFrequency: 0.02,
                numberOfParticles: 40,
                gravity: 0.1,
                maxBlastForce: 25,
                minBlastForce: 8,
                colors: const [
                  Color(0xFF4A5EE5),
                  Color(0xFF8758FF),
                  Color(0xFFFFB4A2),
                  Color(0xFFB5E48C),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

