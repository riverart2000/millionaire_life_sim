import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../services/sound_service.dart';
import '../services/riddle_service.dart';

class StreakRewardDialog extends StatefulWidget {
  final int streak;
  final double reward;
  final String jarName;

  const StreakRewardDialog({
    Key? key,
    required this.streak,
    required this.reward,
    required this.jarName,
  }) : super(key: key);

  @override
  State<StreakRewardDialog> createState() => _StreakRewardDialogState();
}

class _StreakRewardDialogState extends State<StreakRewardDialog>
    with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController1;
  late ConfettiController _confettiController2;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _confettiController1 = ConfettiController(duration: const Duration(seconds: 5));
    _confettiController2 = ConfettiController(duration: const Duration(seconds: 5));

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 2.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Start animations
    _animationController.forward();
    _confettiController1.play();
    _confettiController2.play();

    // Play celebration sound
    SoundService.instance.playCelebration();
  }

  @override
  void dispose() {
    _confettiController1.dispose();
    _confettiController2.dispose();
    _animationController.dispose();
    super.dispose();
  }

  String _getStreakEmoji() {
    if (widget.streak >= 20) return '👑';
    if (widget.streak >= 10) return '⚡';
    if (widget.streak >= 5) return '🎯';
    return '💪';
  }

  String _getStreakTitle() {
    if (widget.streak >= 20) return 'LEGENDARY STREAK!';
    if (widget.streak >= 10) return 'INCREDIBLE STREAK!';
    if (widget.streak >= 5) return 'EXCELLENT STREAK!';
    return 'GREAT STREAK!';
  }

  String _getStreakMessage() {
    if (widget.streak >= 20) {
      return 'You\'ve achieved Master Riddler status! 🏆\nYou\'re unstoppable!';
    } else if (widget.streak >= 10) {
      return 'Double digits! Your mind is razor sharp! 🔥';
    } else if (widget.streak >= 5) {
      return 'Keep this momentum going! 💫';
    } else {
      return 'Building strong habits! 🌟';
    }
  }

  Color _getStreakColor() {
    if (widget.streak >= 20) return Colors.purple;
    if (widget.streak >= 10) return Colors.orange;
    if (widget.streak >= 5) return Colors.blue;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final streakColor = _getStreakColor();

    return Stack(
      children: [
        Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: Colors.transparent,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    streakColor.withOpacity(0.1),
                    streakColor.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: streakColor, width: 3),
              ),
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Animated emoji
                      RotationTransition(
                        turns: _rotationAnimation,
                        child: Text(
                          _getStreakEmoji(),
                          style: const TextStyle(fontSize: 80),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Streak count with fire effect
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: streakColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: streakColor, width: 2),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🔥', style: TextStyle(fontSize: 24)),
                            const SizedBox(width: 8),
                            Text(
                              '${widget.streak} STREAK',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: streakColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('🔥', style: TextStyle(fontSize: 24)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Title
                      Text(
                        _getStreakTitle(),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: streakColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),

                      // Message
                      Text(
                        _getStreakMessage(),
                        style: theme.textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // Reward amount
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.green, width: 2),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              '💰 BONUS REWARD',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '£${widget.reward.toStringAsFixed(0)}',
                              style: theme.textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Added to ${widget.jarName} jar',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.green.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Continue button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: streakColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        // Left confetti
        Align(
          alignment: Alignment.centerLeft,
          child: ConfettiWidget(
            confettiController: _confettiController1,
            blastDirection: 0, // Right
            maxBlastForce: 20,
            minBlastForce: 10,
            emissionFrequency: 0.03,
            numberOfParticles: 20,
            gravity: 0.1,
            colors: const [
              Colors.red,
              Colors.blue,
              Colors.green,
              Colors.yellow,
              Colors.purple,
              Colors.orange,
            ],
          ),
        ),
        // Right confetti
        Align(
          alignment: Alignment.centerRight,
          child: ConfettiWidget(
            confettiController: _confettiController2,
            blastDirection: 3.14, // Left
            maxBlastForce: 20,
            minBlastForce: 10,
            emissionFrequency: 0.03,
            numberOfParticles: 20,
            gravity: 0.1,
            colors: const [
              Colors.red,
              Colors.blue,
              Colors.green,
              Colors.yellow,
              Colors.purple,
              Colors.orange,
            ],
          ),
        ),
      ],
    );
  }
}
