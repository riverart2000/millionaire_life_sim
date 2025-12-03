import 'dart:math';
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

class _ShuffledQuestion {
  final CourseQuestion question;
  final List<String> shuffledOptions;
  final int newCorrectAnswer;

  _ShuffledQuestion({
    required this.question,
    required this.shuffledOptions,
    required this.newCorrectAnswer,
  });
}

class _CourseQuizDialogState extends State<CourseQuizDialog> {
  int _currentQuestionIndex = 0;
  int? _selectedAnswer;
  bool _showExplanation = false;
  bool _isCorrect = false;
  int _correctAnswers = 0;
  late ConfettiController _confettiController;
  late List<_ShuffledQuestion> _shuffledQuestions;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _shuffleQuestions();
  }

  void _shuffleQuestions() {
    final random = Random();
    
    // Shuffle questions
    final questions = List<CourseQuestion>.from(widget.quiz.questions);
    questions.shuffle(random);
    
    // Shuffle options for each question
    _shuffledQuestions = questions.map((question) {
      final indices = List.generate(question.options.length, (i) => i);
      indices.shuffle(random);
      
      final shuffledOptions = indices.map((i) => question.options[i]).toList();
      final newCorrectAnswer = indices.indexOf(question.correctAnswer);
      
      return _ShuffledQuestion(
        question: question,
        shuffledOptions: shuffledOptions,
        newCorrectAnswer: newCorrectAnswer,
      );
    }).toList();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  _ShuffledQuestion get _currentQuestion => _shuffledQuestions[_currentQuestionIndex];
  int get _totalQuestions => _shuffledQuestions.length;
  bool get _isLastQuestion => _currentQuestionIndex == _totalQuestions - 1;

  void _checkAnswer() {
    if (_selectedAnswer == null) return;

    setState(() {
      _isCorrect = _selectedAnswer == _currentQuestion.newCorrectAnswer;
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
      
      // Close dialog and call onComplete immediately
      Navigator.of(context).pop();
      widget.onComplete();
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
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            width: double.maxFinite,
            padding: const EdgeInsets.all(12),
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
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Q${_currentQuestionIndex + 1}/$_totalQuestions',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${_correctAnswers}/$_totalQuestions',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Progress bar
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  color: Colors.green,
                ),
                const SizedBox(height: 16),

                // Question
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          _currentQuestion.question.text,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Options
                        ...List.generate(_currentQuestion.shuffledOptions.length, (index) {
                          final isSelected = _selectedAnswer == index;
                          final isCorrect = index == _currentQuestion.newCorrectAnswer;
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
                            padding: const EdgeInsets.only(bottom: 8),
                            child: InkWell(
                              onTap: _showExplanation ? null : () {
                                setState(() {
                                  _selectedAnswer = index;
                                });
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  border: Border.all(
                                    color: borderColor ?? theme.colorScheme.outline,
                                    width: borderColor != null ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 28,
                                      height: 28,
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
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        _currentQuestion.shuffledOptions[index],
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                    ),
                                    if (showResult && isCorrect)
                                      const Icon(Icons.check_circle, color: Colors.green, size: 20),
                                    if (showResult && isSelected && !isCorrect)
                                      const Icon(Icons.cancel, color: Colors.red, size: 20),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),

                        // Explanation
                        if (_showExplanation) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _isCorrect
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
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
                                      size: 18,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _isCorrect ? 'Correct!' : 'Try Again',
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: _isCorrect ? Colors.green : Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _currentQuestion.question.explanation,
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!_showExplanation) ...[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: _selectedAnswer != null ? _checkAnswer : null,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: const Text('Submit'),
                      ),
                    ] else ...[
                      FilledButton(
                        onPressed: _nextQuestion,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: Text(_isCorrect
                            ? (_isLastQuestion ? 'Complete' : 'Next')
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
