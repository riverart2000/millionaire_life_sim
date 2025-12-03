import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/declaration_model.dart';
import '../providers/declaration_provider.dart';
import '../services/declaration_service.dart';
import '../services/sound_service.dart';

/// Dialog to display and interact with declarations
class DeclarationDialog extends ConsumerStatefulWidget {
  const DeclarationDialog({
    super.key,
    required this.declaration,
  });

  final Declaration declaration;

  @override
  ConsumerState<DeclarationDialog> createState() => _DeclarationDialogState();
}

class _DeclarationDialogState extends ConsumerState<DeclarationDialog> {
  final TextEditingController _textController = TextEditingController();
  bool _isCompleting = false;
  int _remainingSeconds = 0;
  Timer? _countdownTimer;
  bool _canAccept = false; // Flag to track if accept button is enabled
  int _acceptCountdown = 5; // Countdown for accept button

  @override
  void initState() {
    super.initState();
    if (widget.declaration.type == 'do' &&
        widget.declaration.countdownSeconds != null) {
      _remainingSeconds = widget.declaration.countdownSeconds!;
      _startCountdown();
    }
    
    // Start 5-second countdown for accept button on declaration type
    if (widget.declaration.type == 'declaration') {
      _startAcceptCountdown();
    } else {
      // For other types, enable immediately
      _canAccept = true;
    }
  }
  
  void _startAcceptCountdown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_acceptCountdown > 0) {
        setState(() {
          _acceptCountdown--;
        });
      } else {
        setState(() {
          _canAccept = true;
        });
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _textController.dispose();
    super.dispose();
  }
  
  String _getButtonText() {
    if (!_canAccept && widget.declaration.type == 'declaration') {
      return 'Accept ($_acceptCountdown)';
    }
    if (widget.declaration.type == 'do' && _remainingSeconds > 0) {
      return 'Done ($_remainingSeconds)';
    }
    if (widget.declaration.type == 'declaration') {
      return 'Accept';
    }
    return 'Submit';
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _completeDeclaration({String? userInput}) async {
    setState(() {
      _isCompleting = true;
    });

    try {
      final service = ref.read(declarationServiceProvider);
      await service.saveResponse(
        declarationId: widget.declaration.id,
        type: widget.declaration.type,
        text: widget.declaration.text,
        userInput: userInput,
      );

      // Invalidate provider to refresh footer
      ref.invalidate(latestDeclarationsByTypeProvider);

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      debugPrint('❌ Error completing declaration: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isCompleting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        width: double.maxFinite,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon
            Row(
              children: [
                Icon(
                  _getIconForType(),
                  color: Theme.of(context).colorScheme.primary,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _getTitleForType(),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Declaration text
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Text(
                widget.declaration.text,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 24),

            // Type-specific content
            if (widget.declaration.type == 'answer') ...[
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: widget.declaration.placeholder ?? 'Your answer...',
                  helperText: 'Minimum 10 characters',
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
                maxLines: 3,
                autofocus: true,
              ),
              const SizedBox(height: 16),
            ],

            if (widget.declaration.type == 'do') ...[
              Center(
                child: Column(
                  children: [
                    Text(
                      'Take a moment to visualize...',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _remainingSeconds > 0
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).colorScheme.primary,
                      ),
                      child: Center(
                        child: Text(
                          _remainingSeconds > 0
                              ? '$_remainingSeconds'
                              : '✓',
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(
                                color: _remainingSeconds > 0
                                    ? Theme.of(context).colorScheme.onPrimaryContainer
                                    : Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Action buttons
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                  onPressed: _isCompleting ||
                          !_canAccept ||
                          (widget.declaration.type == 'do' &&
                              _remainingSeconds > 0)
                      ? null
                      : () {
                          // Play pleasant button sound
                          SoundService.instance.playButtonClick();
                          
                          if (widget.declaration.type == 'answer') {
                            final input = _textController.text.trim();
                            if (input.isEmpty || input.length < 10) {
                              // Just return without showing SnackBar
                              return;
                            }
                            _completeDeclaration(userInput: input);
                          } else {
                            _completeDeclaration();
                          }
                        },
                  child: _isCompleting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(_getButtonText()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForType() {
    switch (widget.declaration.type) {
      case 'declaration':
        return Icons.check_circle_outline;
      case 'answer':
        return Icons.edit_outlined;
      case 'do':
        return Icons.timer_outlined;
      default:
        return Icons.star_outline;
    }
  }

  String _getTitleForType() {
    switch (widget.declaration.type) {
      case 'declaration':
        return 'Declaration';
      case 'answer':
        return 'Answer This';
      case 'do':
        return 'Visualization';
      default:
        return 'Declaration';
    }
  }

  String _getButtonTextForType() {
    switch (widget.declaration.type) {
      case 'declaration':
        return 'I Accept';
      case 'answer':
        return 'Submit Answer';
      case 'do':
        return 'Complete';
      default:
        return 'Continue';
    }
  }
}
