import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../models/course_question_model.dart';
import '../services/sound_service.dart';

class CourseQuizDialog extends StatefulWidget {
  const CourseQuizDialog({
    super.key,
    required this.quiz,
    required this.courseTitle,
    required this.onComplete,
  });

  final CourseQuiz quiz;
  final String courseTitle;
  final VoidCallback onComplete;

  @override
  State<CourseQuizDialog> createState() => _CourseQuizDialogState();
}

class _CourseQuizDialogState extends State<CourseQuizDialog> {
  int _currentQuestionIndex = 0;
  int? _selectedAnswer;
  bool _showExplanation = false;
  bool _isCorrect = false;
  int _correctAnswers = 0;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  CourseQuestion get _currentQuestion => widget.quiz.questions[_currentQuestionIndex];
  int get _totalQuestions => widget.quiz.questions.length;
  bool get _isLastQuestion => _currentQuestionIndex == _totalQuestions - 1;

  void _checkAnswer() {
    if (_selectedAnswer == null) return;

    setState(() {
      _isCorrect = _selectedAnswer == _currentQuestion.correctAnswer;
      _showExplanation = true;
      
      if (_isCorrect) {
        _correctAnswers++;
        SoundService.instance.playButtonClick();
      }
    });
  }

  void _nextQuestion() {
    if (!_isCorrect) {
      // Must answer correctly to proceed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must answer correctly to continue! Try again.'),
          backgroundColor: Colors.orange,
        ),
      );
      setState(() {
        _selectedAnswer = null;
        _showExplanation = false;
      });
      return;
    }

    if (_isLastQuestion) {
      // All questions answered correctly!
      _confettiController.play();
      SoundService.instance.playCelebration();
      
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.of(context).pop();
          widget.onComplete();
        }
      });
    } else {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _showExplanation = false;
        _isCorrect = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = (_currentQuestionIndex + 1) / _totalQuestions;

    return Stack(
      children: [
        // Confetti
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: 3.14 / 2,
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            gravity: 0.3,
            colors: const [Colors.green, Colors.blue, Colors.purple, Colors.orange],
          ),
        ),
        
        // Dialog
        Dialog(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.courseTitle,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Question ${_currentQuestionIndex + 1} of $_totalQuestions',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${_correctAnswers}/$_totalQuestions',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Progress bar
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  color: Colors.green,
                ),
                const SizedBox(height: 24),

                // Question
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          _currentQuestion.text,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Options
                        ...List.generate(_currentQuestion.options.length, (index) {
                          final isSelected = _selectedAnswer == index;
                          final isCorrect = index == _currentQuestion.correctAnswer;
                          final showResult = _showExplanation;

                          Color? backgroundColor;
                          Color? borderColor;
                          
                          if (showResult) {
                            if (isCorrect) {
                              backgroundColor = Colors.green.withOpacity(0.1);
                              borderColor = Colors.green;
                            } else if (isSelected && !isCorrect) {
                              backgroundColor = Colors.red.withOpacity(0.1);
                              borderColor = Colors.red;
                            }
                          } else if (isSelected) {
                            backgroundColor = theme.colorScheme.primaryContainer;
                            borderColor = theme.colorScheme.primary;
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: InkWell(
                              onTap: _showExplanation ? null : () {
                                setState(() {
                                  _selectedAnswer = index;
                                });
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  border: Border.all(
                                    color: borderColor ?? theme.colorScheme.outline,
                                    width: borderColor != null ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isSelected
                                            ? theme.colorScheme.primary
                                            : theme.colorScheme.surfaceContainerHighest,
                                      ),
                                      child: Center(
                                        child: Text(
                                          String.fromCharCode(65 + index), // A, B, C, D
                                          style: TextStyle(
                                            color: isSelected
                                                ? theme.colorScheme.onPrimary
                                                : theme.colorScheme.onSurface,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        _currentQuestion.options[index],
                                        style: theme.textTheme.bodyLarge,
                                      ),
                                    ),
                                    if (showResult && isCorrect)
                                      const Icon(Icons.check_circle, color: Colors.green),
                                    if (showResult && isSelected && !isCorrect)
                                      const Icon(Icons.cancel, color: Colors.red),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),

                        // Explanation
                        if (_showExplanation) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: _isCorrect
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _isCorrect ? Colors.green : Colors.orange,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      _isCorrect ? Icons.check_circle : Icons.info_outline,
                                      color: _isCorrect ? Colors.green : Colors.orange,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _isCorrect ? 'Correct!' : 'Try Again',
                                      style: theme.textTheme.titleSmall?.copyWith(
                                        color: _isCorrect ? Colors.green : Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _currentQuestion.explanation,
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

                const SizedBox(height: 24),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!_showExplanation) ...[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: _selectedAnswer != null ? _checkAnswer : null,
                        child: const Text('Submit Answer'),
                      ),
                    ] else ...[
                      FilledButton(
                        onPressed: _nextQuestion,
                        child: Text(_isCorrect
                            ? (_isLastQuestion ? 'Complete Course' : 'Next Question')
                            : 'Try Again'),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
