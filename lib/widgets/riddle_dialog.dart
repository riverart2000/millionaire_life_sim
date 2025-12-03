import 'dart:async';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../core/utils/responsive.dart';
import '../models/riddle_model.dart';
import '../services/riddle_service.dart';
import '../services/sound_service.dart';

class RiddleDialog extends StatefulWidget {
  final Riddle riddle;
  final RiddleService riddleService;
  final Function(bool correct, double? reward) onComplete;

  const RiddleDialog({
    Key? key,
    required this.riddle,
    required this.riddleService,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<RiddleDialog> createState() => _RiddleDialogState();
}

class _RiddleDialogState extends State<RiddleDialog> {
  int? selectedOption;
  bool hasAnswered = false;
  bool isCorrect = false;
  int timeRemaining = 30;
  Timer? _timer;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _confettiController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (timeRemaining > 0) {
            timeRemaining--;
          } else {
            _handleTimeout();
          }
        });
      }
    });
  }

  void _handleTimeout() {
    _timer?.cancel();
    if (!hasAnswered) {
      _handleAnswer(-1); // No answer selected
    }
  }

  Future<void> _handleAnswer(int optionIndex) async {
    if (hasAnswered) return;

    setState(() {
      selectedOption = optionIndex;
      hasAnswered = true;
      isCorrect = optionIndex == widget.riddle.correctOptionIndex;
    });

    _timer?.cancel();

    if (isCorrect) {
      await widget.riddleService.recordCorrectAnswer();
      final newStreak = widget.riddleService.getCurrentStreak();
      final reward = widget.riddleService.getStreakReward(newStreak);

      // Play success sound
      await SoundService.instance.playNotification();

      // Show confetti for milestones
      if (widget.riddleService.isStreakMilestone(newStreak)) {
        _confettiController.play();
        await SoundService.instance.playCelebration();
      }

      // Wait a bit to show the result
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        widget.onComplete(true, reward);
        Navigator.of(context).pop(true);
      }
    } else {
      await widget.riddleService.recordIncorrectAnswer();
      // No sound for incorrect

      // Wait to show explanation
      await Future.delayed(const Duration(seconds: 3));

      if (mounted) {
        widget.onComplete(false, null);
        Navigator.of(context).pop(false);
      }
    }
  }

  Color _getOptionColor(int index) {
    if (!hasAnswered) {
      return selectedOption == index
          ? Theme.of(context).primaryColor.withOpacity(0.2)
          : Colors.transparent;
    }

    if (index == widget.riddle.correctOptionIndex) {
      return Colors.green.withOpacity(0.3);
    }

    if (index == selectedOption && !isCorrect) {
      return Colors.red.withOpacity(0.3);
    }

    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentStreak = widget.riddleService.getCurrentStreak();

    return Stack(
      children: [
        Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            width: double.maxFinite,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header with timer and streak
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Streak display
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: currentStreak > 0 
                            ? Colors.orange.withOpacity(0.2)
                            : Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '🔥',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$currentStreak Streak',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Timer
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: timeRemaining <= 5 
                            ? Colors.red.withOpacity(0.2)
                            : theme.primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 18,
                            color: timeRemaining <= 5 ? Colors.red : theme.primaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${timeRemaining}s',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: timeRemaining <= 5 ? Colors.red : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Title
                Text(
                  '🧩 Quick Riddle',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Difficulty badge
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor().withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.riddle.difficulty.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: _getDifficultyColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Riddle text
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.riddle.riddle,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),

                // Options
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.riddle.options.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Material(
                          color: _getOptionColor(index),
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            onTap: hasAnswered ? null : () => _handleAnswer(index),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: selectedOption == index
                                      ? theme.primaryColor
                                      : Colors.grey.shade300,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: theme.primaryColor.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        String.fromCharCode(65 + index), // A, B, C, D
                                        style: theme.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: theme.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      widget.riddle.options[index],
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ),
                                  if (hasAnswered && index == widget.riddle.correctOptionIndex)
                                    const Icon(Icons.check_circle, color: Colors.green),
                                  if (hasAnswered && index == selectedOption && !isCorrect)
                                    const Icon(Icons.cancel, color: Colors.red),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Explanation (shown after answer)
                if (hasAnswered) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isCorrect 
                          ? Colors.green.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isCorrect ? Colors.green : Colors.orange,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              isCorrect ? Icons.check_circle : Icons.info_outline,
                              color: isCorrect ? Colors.green : Colors.orange,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isCorrect ? 'Correct!' : 'Incorrect',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isCorrect ? Colors.green : Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.riddle.explanation,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        // Confetti overlay
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: 3.14 / 2, // Down
            maxBlastForce: 5,
            minBlastForce: 2,
            emissionFrequency: 0.05,
            numberOfParticles: 30,
            gravity: 0.3,
          ),
        ),
      ],
    );
  }

  Color _getDifficultyColor() {
    switch (widget.riddle.difficulty) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
