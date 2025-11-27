import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/affirmations_provider.dart';

class AffirmationsView extends ConsumerStatefulWidget {
  const AffirmationsView({super.key});

  @override
  ConsumerState<AffirmationsView> createState() => _AffirmationsViewState();
}

class _AffirmationsViewState extends ConsumerState<AffirmationsView> {
  final TextEditingController _answerController = TextEditingController();
  final FocusNode _answerFocus = FocusNode();
  String? _feedback;

  @override
  void dispose() {
    _answerController.dispose();
    _answerFocus.dispose();
    super.dispose();
  }

  void _startNewAffirmation() {
    final service = ref.read(affirmationsServiceProvider);
    final affirmation = service.getRandomAffirmation();
    ref.read(affirmationProvider.notifier).setCurrentAffirmation(affirmation);
    setState(() {
      _feedback = null;
    });
    _answerController.clear();
    _answerFocus.requestFocus();
  }

  void _checkAnswer() {
    final state = ref.read(affirmationProvider);
    final affirmation = state.currentAffirmation;
    if (affirmation == null) return;

    final service = ref.read(affirmationsServiceProvider);
    final userAnswer = _answerController.text;
    final blankIndex = state.currentBlankIndex;

    if (blankIndex >= affirmation.blankIndices.length) {
      // All blanks filled - affirmation complete
      ref.read(affirmationProvider.notifier).markCompleted(affirmation.id);
      setState(() {
        _feedback = '🎉 Excellent! Affirmation complete!';
      });
      return;
    }

    final isCorrect = service.checkAnswer(affirmation, blankIndex, userAnswer);

    if (isCorrect) {
      ref.read(affirmationProvider.notifier).addAnswer(userAnswer);
      _answerController.clear();
      setState(() {
        _feedback = '✅ Correct!';
      });

      // Check if this was the last blank
      if (state.currentBlankIndex + 1 >= affirmation.blankIndices.length) {
        ref.read(affirmationProvider.notifier).markCompleted(affirmation.id);
        setState(() {
          _feedback = '🎉 Excellent! Affirmation complete!';
        });
      } else {
        _answerFocus.requestFocus();
      }
    } else {
      setState(() {
        _feedback = '❌ Try again!';
      });
    }
  }

  void _showHintDialog() {
    final state = ref.read(affirmationProvider);
    final affirmation = state.currentAffirmation;
    if (affirmation == null) return;

    final blankIndex = state.currentBlankIndex;
    if (blankIndex >= affirmation.blankIndices.length) return;

    final correctIndex = affirmation.blankIndices[blankIndex];
    final correctWord = affirmation.words[correctIndex].replaceAll(RegExp(r'[,.]'), '');
    final hint = '${correctWord[0]}${'_' * (correctWord.length - 1)}';

    setState(() {
      _feedback = '💡 Hint: $hint';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final asyncAffirmations = ref.watch(affirmationsLoadProvider);
    final state = ref.watch(affirmationProvider);
    final affirmation = state.currentAffirmation;

    return Scaffold(
      appBar: AppBar(
        title: const Text('💭 Daily Affirmations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
          ),
        ],
      ),
      body: asyncAffirmations.when(
        data: (_) => _buildContent(theme, state, affirmation),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Error loading affirmations: $err'),
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme, AffirmationState state, affirmation) {
    if (affirmation == null) {
      return _buildWelcomeScreen(theme, state);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildProgressCard(theme, state),
          const SizedBox(height: 24),
          _buildAffirmationCard(theme, state, affirmation),
          const SizedBox(height: 24),
          if (state.currentBlankIndex < affirmation.blankIndices.length) ...[
            _buildAnswerInput(theme),
            const SizedBox(height: 16),
            _buildActionButtons(theme),
          ] else ...[
            _buildCompletionButtons(theme),
          ],
          if (_feedback != null) ...[
            const SizedBox(height: 16),
            _buildFeedback(theme),
          ],
        ],
      ),
    );
  }

  Widget _buildWelcomeScreen(ThemeData theme, AffirmationState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.psychology,
              size: 120,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 32),
            Text(
              'Welcome to MMI Affirmations',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Practice positive affirmations with an interactive word game. Fill in the missing words to reinforce powerful beliefs about money and success.',
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildProgressStats(theme, state),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _startNewAffirmation,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Practice'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(ThemeData theme, AffirmationState state) {
    final progress = state.progress;
    final percentage = progress.totalAffirmations > 0
        ? (progress.completedAffirmations / progress.totalAffirmations * 100)
        : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Progress',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${progress.completedAffirmations} of ${progress.totalAffirmations} completed',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            CircleAvatar(
              backgroundColor: theme.colorScheme.primaryContainer,
              radius: 30,
              child: Text(
                '${percentage.toStringAsFixed(0)}%',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressStats(ThemeData theme, AffirmationState state) {
    final progress = state.progress;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStatChip(
          theme,
          Icons.check_circle,
          '${progress.completedAffirmations}',
          'Completed',
        ),
        const SizedBox(width: 16),
        if (progress.lastPracticeDate != null)
          _buildStatChip(
            theme,
            Icons.calendar_today,
            _formatDate(progress.lastPracticeDate!),
            'Last Practice',
          ),
      ],
    );
  }

  Widget _buildStatChip(ThemeData theme, IconData icon, String value, String label) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildAffirmationCard(ThemeData theme, AffirmationState state, affirmation) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              'Fill in the missing words:',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 16),
            _buildAffirmationText(theme, state, affirmation),
          ],
        ),
      ),
    );
  }

  Widget _buildAffirmationText(ThemeData theme, AffirmationState state, affirmation) {
    final words = affirmation.words;
    final blankIndices = affirmation.blankIndices;
    final userAnswers = state.userAnswers;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: List.generate(words.length, (index) {
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
          // Current blank to fill
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.secondary,
                width: 2,
              ),
            ),
            child: Text(
              '_' * 8,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSecondaryContainer,
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
              '_' * 8,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          );
        }
      }),
    );
  }

  Widget _buildAnswerInput(ThemeData theme) {
    return TextField(
      controller: _answerController,
      focusNode: _answerFocus,
      decoration: InputDecoration(
        labelText: 'Your answer',
        hintText: 'Type the missing word',
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: const Icon(Icons.send),
          onPressed: _checkAnswer,
        ),
      ),
      textCapitalization: TextCapitalization.words,
      onSubmitted: (_) => _checkAnswer(),
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _showHintDialog,
            icon: const Icon(Icons.lightbulb_outline),
            label: const Text('Hint'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: FilledButton.icon(
            onPressed: _checkAnswer,
            icon: const Icon(Icons.check),
            label: const Text('Submit'),
          ),
        ),
      ],
    );
  }

  Widget _buildCompletionButtons(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              ref.read(affirmationProvider.notifier).reset();
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.home),
            label: const Text('Back to Dashboard'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: FilledButton.icon(
            onPressed: _startNewAffirmation,
            icon: const Icon(Icons.refresh),
            label: const Text('Next Affirmation'),
          ),
        ),
      ],
    );
  }

  Widget _buildFeedback(ThemeData theme) {
    final isSuccess = _feedback!.contains('✅') || _feedback!.contains('🎉');
    return Card(
      color: isSuccess
          ? theme.colorScheme.primaryContainer
          : theme.colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          _feedback!,
          style: theme.textTheme.titleMedium?.copyWith(
            color: isSuccess
                ? theme.colorScheme.onPrimaryContainer
                : theme.colorScheme.onErrorContainer,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How to Play'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('1. Read the affirmation with missing words'),
              SizedBox(height: 8),
              Text('2. Type the missing word in the text field'),
              SizedBox(height: 8),
              Text('3. Press Submit or Enter to check your answer'),
              SizedBox(height: 8),
              Text('4. Need help? Use the Hint button'),
              SizedBox(height: 8),
              Text('5. Complete all blanks to finish the affirmation'),
              SizedBox(height: 16),
              Text(
                '💡 Tip: Practicing these affirmations daily helps build a positive money mindset!',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) return 'Today';
    if (difference.inDays == 1) return 'Yesterday';
    if (difference.inDays < 7) return '${difference.inDays} days ago';
    return '${date.day}/${date.month}/${date.year}';
  }
}
