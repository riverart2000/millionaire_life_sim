import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import '../providers/affirmations_provider.dart';

class DailyAffirmationQuestDialog extends ConsumerStatefulWidget {
  final VoidCallback onComplete;
  final String actionName; // e.g., "Simulate Next Day" or "Regenerate Money"

  const DailyAffirmationQuestDialog({
    super.key,
    required this.onComplete,
    required this.actionName,
  });

  @override
  ConsumerState<DailyAffirmationQuestDialog> createState() =>
      _DailyAffirmationQuestDialogState();
}

class _DailyAffirmationQuestDialogState
    extends ConsumerState<DailyAffirmationQuestDialog> {
  final TextEditingController _answerController = TextEditingController();
  final FocusNode _answerFocus = FocusNode();
  late ConfettiController _confettiController;
  String? _feedback;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    
    // Load a random affirmation for today's quest
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(affirmationsLoadProvider.future);
      final service = ref.read(affirmationsServiceProvider);
      final affirmation = service.getRandomAffirmation();
      ref.read(affirmationProvider.notifier).setCurrentAffirmation(affirmation);
      _answerFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _answerController.dispose();
    _answerFocus.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _checkAnswer() {
    final state = ref.read(affirmationProvider);
    final affirmation = state.currentAffirmation;
    if (affirmation == null) return;

    final service = ref.read(affirmationsServiceProvider);
    final userAnswer = _answerController.text;
    final blankIndex = state.currentBlankIndex;

    if (blankIndex >= affirmation.blankIndices.length) return;

    final isCorrect = service.checkAnswer(affirmation, blankIndex, userAnswer);

    if (isCorrect) {
      ref.read(affirmationProvider.notifier).addAnswer(userAnswer);
      _answerController.clear();
      setState(() {
        _feedback = '✅ Correct!';
      });

      // Check if this was the last blank
      if (state.currentBlankIndex + 1 >= affirmation.blankIndices.length) {
        setState(() {
          _feedback = '🎉 Quest Complete!';
          _isCompleted = true;
        });
        _confettiController.play();
        
        // Auto-close after celebration
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.of(context).pop();
            widget.onComplete();
          }
        });
      } else {
        // Auto-focus next blank
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            _answerFocus.requestFocus();
          }
        });
      }
    } else {
      setState(() {
        _feedback = '❌ Try again!';
      });
    }
  }

  void _skip() {
    Navigator.of(context).pop();
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(affirmationProvider);
    final affirmation = state.currentAffirmation;

    return Stack(
      children: [
        Dialog(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(24.0),
            child: affirmation == null
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header
                      Row(
                        children: [
                          Icon(
                            Icons.emoji_events,
                            color: Colors.amber[700],
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '🔥 Daily Affirmation Quest',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Complete to ${widget.actionName}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Affirmation text with blanks
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.primary.withOpacity(0.3),
                          ),
                        ),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: _buildAffirmationWords(theme, state, affirmation),
                        ),
                      ),
                      
                      if (_feedback != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _feedback!.contains('✅') || _feedback!.contains('🎉')
                                ? Colors.green[50]
                                : Colors.red[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _feedback!,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: _feedback!.contains('✅') || _feedback!.contains('🎉')
                                  ? Colors.green[700]
                                  : Colors.red[700],
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                      
                      const SizedBox(height: 24),
                      
                      // Action buttons
                      if (!_isCompleted)
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _skip,
                                child: const Text('Skip for Now'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: FilledButton.icon(
                                onPressed: _checkAnswer,
                                icon: const Icon(Icons.check),
                                label: const Text('Check Answer'),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
          ),
        ),
        // Confetti overlay
        Align(
          alignment: Alignment.center,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            particleDrag: 0.05,
            emissionFrequency: 0.05,
            numberOfParticles: 30,
            gravity: 0.3,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple,
              Colors.yellow,
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildAffirmationWords(
    ThemeData theme,
    AffirmationState state,
    affirmation,
  ) {
    final words = affirmation.words;
    final blankIndices = affirmation.blankIndices;
    final userAnswers = state.userAnswers;

    return List.generate(words.length, (index) {
      final blankPosition = blankIndices.indexOf(index);

      if (blankPosition == -1) {
        // Regular word
        return Text(
          words[index],
          style: theme.textTheme.titleLarge,
        );
      } else if (blankPosition < userAnswers.length) {
        // Filled blank
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.primary,
              width: 2,
            ),
          ),
          child: Text(
            userAnswers[blankPosition],
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      } else if (blankPosition == state.currentBlankIndex) {
        // Current blank to fill - INLINE INPUT
        return IntrinsicWidth(
          child: Container(
            constraints: const BoxConstraints(minWidth: 100),
            child: TextField(
              controller: _answerController,
              focusNode: _answerFocus,
              autofocus: true,
              textAlign: TextAlign.center,
              textCapitalization: TextCapitalization.words,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                hintText: '___',
                hintStyle: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onSecondaryContainer.withOpacity(0.3),
                ),
                filled: true,
                fillColor: theme.colorScheme.secondaryContainer,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: theme.colorScheme.secondary,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: theme.colorScheme.secondary,
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: theme.colorScheme.secondary,
                    width: 3,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                isDense: true,
              ),
              onSubmitted: (_) => _checkAnswer(),
            ),
          ),
        );
      } else {
        // Future blank
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.outline,
            ),
          ),
          child: Text(
            '_' * 6,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        );
      }
    });
  }
}
