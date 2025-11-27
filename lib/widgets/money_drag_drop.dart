import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart' as legacy;

import '../core/utils/currency_formatter.dart';
import '../models/jar_model.dart';
import '../providers/sound_provider.dart';

class DraggableMoney extends StatelessWidget {
  const DraggableMoney({
    super.key,
    required this.amount,
    required this.onDragCompleted,
  });

  final double amount;
  final VoidCallback onDragCompleted;

  @override
  Widget build(BuildContext context) {
    return Draggable<double>(
      data: amount,
      onDragCompleted: onDragCompleted,
      feedback: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(16),
        child: _MoneyBill(amount: amount, isDragging: true),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _MoneyBill(amount: amount),
      ),
      child: _MoneyBill(amount: amount),
    );
  }
}

class _MoneyBill extends StatelessWidget {
  const _MoneyBill({
    required this.amount,
    this.isDragging = false,
  });

  final double amount;
  final bool isDragging;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 80,
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: isDragging
            ? [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Stack(
        children: [
          // Decorative pattern
          Positioned(
            right: -10,
            top: -10,
            child: Icon(
              Icons.attach_money,
              size: 40,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          // Amount
          Center(
            child: Text(
              CurrencyFormatter.formatWhole(amount),
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class JarDragTarget extends StatefulWidget {
  const JarDragTarget({
    super.key,
    required this.jar,
    required this.onMoneyDropped,
    required this.isAtMax,
  });

  final Jar jar;
  final Function(double amount) onMoneyDropped;
  final bool isAtMax;

  @override
  State<JarDragTarget> createState() => _JarDragTargetState();
}

class _JarDragTargetState extends State<JarDragTarget>
    with SingleTickerProviderStateMixin {
  bool _isHovering = false;
  bool _justDropped = false;
  late AnimationController _dropAnimationController;

  @override
  void initState() {
    super.initState();
    _dropAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _dropAnimationController.dispose();
    super.dispose();
  }

  void _handleDrop(double amount) async {
    // Prevent multiple drops in quick succession
    if (_justDropped) return;
    
    setState(() => _justDropped = true);
    _dropAnimationController.forward(from: 0);
    
    // Play jar-specific sound effect
    final soundProvider = legacy.Provider.of<SoundProvider>(context, listen: false);
    await soundProvider.playJarJingle(widget.jar.id);
    
    // Call the callback to update the jar
    widget.onMoneyDropped(amount);
    
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() => _justDropped = false);
    }
  }

  Color _getJarColor() {
    final colorMap = {
      'NEC': const Color(0xFF4A5EE5),
      'FFA': const Color(0xFF5BE9B9),
      'LTSS': const Color(0xFFFB6F92),
      'EDU': const Color(0xFFFFCE67),
      'PLAY': const Color(0xFF8758FF),
      'GIVE': const Color(0xFF34C759),
    };
    return colorMap[widget.jar.id.toUpperCase()] ?? Colors.blueGrey;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final jarColor = _getJarColor();

    return DragTarget<double>(
      onWillAcceptWithDetails: (details) {
        setState(() => _isHovering = true);
        return true;
      },
      onLeave: (data) {
        setState(() => _isHovering = false);
      },
      onAcceptWithDetails: (details) {
        setState(() => _isHovering = false);
        _handleDrop(details.data);
      },
      builder: (context, candidateData, rejectedData) {
        final isActive = _isHovering || _justDropped;
        final isNegative = widget.jar.balance < 0;
        
        Widget container = AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isActive
                ? jarColor.withOpacity(0.2)
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive ? jarColor : jarColor.withOpacity(0.3),
              width: isActive ? 3 : 2,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: jarColor.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  // Jar icon
                  Icon(
                    _getJarIcon(),
                    size: 36,
                    color: isNegative ? Colors.red : jarColor,
                  ),
                  // Negative warning badge
                  if (isNegative)
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: const Icon(
                          Icons.warning_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                      ).animate(onPlay: (controller) => controller.repeat())
                          .scale(
                            begin: const Offset(1.0, 1.0),
                            end: const Offset(1.2, 1.2),
                            duration: 400.ms,
                          )
                          .then()
                          .scale(
                            begin: const Offset(1.2, 1.2),
                            end: const Offset(1.0, 1.0),
                            duration: 400.ms,
                          ),
                    ),
                  // Drop animation
                  if (_justDropped)
                    AnimatedBuilder(
                      animation: _dropAnimationController,
                      builder: (context, child) {
                        return Positioned(
                          top: -20 + (_dropAnimationController.value * 40),
                          child: Opacity(
                            opacity: 1 - _dropAnimationController.value,
                            child: Icon(
                              Icons.attach_money,
                              size: 24,
                              color: jarColor,
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.jar.name,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: jarColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                CurrencyFormatter.format(widget.jar.balance),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: widget.jar.balance < 0
                      ? Colors.red
                      : null,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${widget.jar.percentage.toStringAsFixed(0)}%',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 11,
                ),
              ),
              if (isActive && !_justDropped)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Icon(
                    Icons.arrow_downward,
                    color: jarColor,
                    size: 24,
                  ).animate(onPlay: (controller) => controller.repeat())
                      .moveY(begin: 0, end: 8, duration: 600.ms)
                      .then()
                      .moveY(begin: 8, end: 0, duration: 600.ms),
                ),
            ],
          ),
        );
        
        // Add shimmer effect if jar is at max (but not negative)
        if (widget.isAtMax && !isNegative) {
          container = container
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(
                duration: 1500.ms,
                color: jarColor.withOpacity(0.3),
                angle: 0.5,
              )
              .then()
              .shimmer(
                duration: 1500.ms,
                color: jarColor.withOpacity(0.1),
                angle: 0.5,
              );
        }
        
        // Add RED FLASHING BORDER WARNING if jar is negative
        if (isNegative) {
          container = Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: container,
          ).animate(onPlay: (controller) => controller.repeat())
              .boxShadow(
                begin: const BoxShadow(
                  color: Colors.transparent,
                  blurRadius: 0,
                  spreadRadius: 0,
                ),
                end: BoxShadow(
                  color: Colors.red.withOpacity(0.8),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
                duration: 500.ms,
              )
              .then()
              .boxShadow(
                begin: BoxShadow(
                  color: Colors.red.withOpacity(0.8),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
                end: const BoxShadow(
                  color: Colors.transparent,
                  blurRadius: 0,
                  spreadRadius: 0,
                ),
                duration: 500.ms,
              );
          
          // Also add shimmer overlay for extra emphasis
          container = container
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(
                duration: 800.ms,
                color: Colors.red.withOpacity(0.6),
                angle: 0.5,
              )
              .then()
              .shimmer(
                duration: 800.ms,
                color: Colors.red.withOpacity(0.2),
                angle: 0.5,
              );
        }
        
        return container;
      },
    );
  }

  IconData _getJarIcon() {
    switch (widget.jar.id.toUpperCase()) {
      case 'NEC':
        return Icons.home;
      case 'FFA':
        return Icons.savings;
      case 'LTSS':
        return Icons.account_balance;
      case 'EDU':
        return Icons.school;
      case 'PLAY':
        return Icons.sports_esports;
      case 'GIVE':
        return Icons.volunteer_activism;
      default:
        return Icons.monetization_on;
    }
  }
}

class MoneyDragDropWidget extends StatefulWidget {
  const MoneyDragDropWidget({
    super.key,
    required this.jars,
    required this.onAllocate,
    required this.dailyIncome,
  });

  final List<Jar> jars;
  final Function(String jarId, double amount, double remainder) onAllocate;
  final double dailyIncome;

  @override
  State<MoneyDragDropWidget> createState() => _MoneyDragDropWidgetState();
}

class _MoneyDragDropWidgetState extends State<MoneyDragDropWidget> {
  final List<int> _denominations = [100, 50, 20, 10];
  final List<int> _ascendingDenominations = [10, 20, 50, 100];
  List<double> _availableAmounts = [];
  final Set<int> _usedAmountIndices = {};
  
  // Track how much each jar has received from the current available money batch
  final Map<String, double> _jarAllocations = {};
  
  @override
  void initState() {
    super.initState();
    _generateAvailableMoney();
  }
  
  @override
  void didUpdateWidget(MoneyDragDropWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Regenerate money notes if dailyIncome (unallocatedBalance) changed significantly
    // Use a tolerance to avoid regenerating due to tiny floating point differences
    final difference = (oldWidget.dailyIncome - widget.dailyIncome).abs();
    if (difference > 0.01) {
      _generateAvailableMoney();
    }
  }
  
  void _generateAvailableMoney() {
    // Generate money bills based on daily income, up to 10 notes, using set denominations
    final clampedIncome = widget.dailyIncome.clamp(0, 1000);
    final incomeInt = ((clampedIncome / 10).floor()) * 10;

    if (incomeInt <= 0) {
      setState(() {
        _availableAmounts = [];
        _usedAmountIndices.clear();
        _jarAllocations.clear(); // Reset allocations when no money
      });
      return;
    }

    final noteCount = math.min(10, math.max(1, incomeInt ~/ 10));
    final notes = <int>[];
    var remaining = incomeInt;

    while (notes.length < noteCount && remaining >= 10) {
      var addedInCycle = false;
      for (var idx = 0; idx < _denominations.length; idx++) {
        final value = _denominations[idx];
        if (notes.length >= noteCount || remaining < 10) {
          break;
        }
        if (value <= remaining) {
          notes.add(value);
          remaining -= value;
          addedInCycle = true;
        }
      }
      if (!addedInCycle) {
        break;
      }
    }

    while (notes.length < noteCount && remaining >= 10) {
      notes.add(10);
      remaining -= 10;
    }

    var upgraded = true;
    while (remaining >= 10 && upgraded) {
      upgraded = false;
      for (var i = 0; i < notes.length && remaining >= 10; i++) {
        final next = _nextDenomination(notes[i]);
        if (next != null) {
          final diff = next - notes[i];
          if (diff <= remaining) {
            notes[i] = next;
            remaining -= diff;
            upgraded = true;
          }
        }
      }
    }

    setState(() {
      // Generate new money notes
      _availableAmounts = notes.map((value) => value.toDouble()).toList();
      // Clear all used indices - all notes are fresh
      _usedAmountIndices.clear();
      // Reset all jar allocations to zero - new batch of money
      _jarAllocations.clear();
    });
  }

  int? _nextDenomination(int current) {
    final index = _ascendingDenominations.indexOf(current);
    if (index == -1 || index == _ascendingDenominations.length - 1) {
      return null;
    }
    return _ascendingDenominations[index + 1];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.touch_app,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Drag Money into Jars',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Drag and drop money amounts to allocate funds to your jars',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Available money bills
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Available Money',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        'Daily Income: ${CurrencyFormatter.formatWhole(widget.dailyIncome)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(_availableAmounts.length, (index) {
                      if (_usedAmountIndices.contains(index)) {
                        return const SizedBox(width: 80, height: 50);
                      }
                      return DraggableMoney(
                        amount: _availableAmounts[index],
                        onDragCompleted: () {
                          // Note will be marked as used when dropped
                          // Remainder handling happens in onMoneyDropped
                        },
                      ).animate().fadeIn(duration: 400.ms).scale(delay: (index * 50).ms);
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Jars as drop targets
            Text(
              'Your Jars',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: widget.jars
                  .map(
                    (jar) {
                      // Calculate if this jar is at max
                      final originalTotalAvailable = _availableAmounts.fold<double>(
                        0.0, 
                        (sum, amt) => sum + amt,
                      );
                      final maxAllowedForJar = originalTotalAvailable * (jar.percentage / 100);
                      final alreadyReceived = _jarAllocations[jar.id] ?? 0.0;
                      
                      // Special case: If NEC jar is negative, disable percentage enforcement
                      // This allows user to allocate extra money to bring it back to positive
                      final isNecNegative = jar.id.toUpperCase() == 'NEC' && jar.balance < 0;
                      final isAtMax = isNecNegative 
                          ? false  // NEC jar can accept unlimited money when negative
                          : alreadyReceived >= maxAllowedForJar - 0.01; // Normal percentage enforcement
                      
                      return JarDragTarget(
                        jar: jar,
                        isAtMax: isAtMax && originalTotalAvailable > 0, // Only show if there's available money
                        onMoneyDropped: (amount) {
                          setState(() {
                            // Find the note that was just dropped
                            int? droppedIndex;
                            for (int i = 0; i < _availableAmounts.length; i++) {
                              if (!_usedAmountIndices.contains(i) && 
                                  (_availableAmounts[i] - amount).abs() < 0.01) {
                                droppedIndex = i;
                                break;
                              }
                            }
                            
                            // Calculate the ORIGINAL total available money (all notes including used ones)
                            // This is the baseline for percentage calculations
                            final originalTotalAvailable = _availableAmounts.fold<double>(
                              0.0, 
                              (sum, amt) => sum + amt,
                            );
                            
                            // Special case: If NEC jar is negative, disable percentage enforcement
                            // This allows user to allocate unlimited money to bring it back to positive
                            final isNecNegative = jar.id.toUpperCase() == 'NEC' && jar.balance < 0;
                            
                            if (isNecNegative) {
                              // NEC jar is negative - accept the full amount, no percentage limit
                              final amountToAccept = amount;
                              final remainder = 0.0; // No remainder when percentage is disabled
                              
                              // Update tracking (but don't enforce percentage limits)
                              if (amountToAccept > 0) {
                                _jarAllocations[jar.id] = (_jarAllocations[jar.id] ?? 0.0) + amountToAccept;
                              }
                              
                              // Mark the dropped note as used
                              if (droppedIndex != null) {
                                _usedAmountIndices.add(droppedIndex);
                              }
                              
                              widget.onAllocate(jar.id, amountToAccept, remainder);
                              return;
                            }
                            
                            // Normal percentage enforcement for all other jars (and NEC when positive)
                            final maxAllowedForJar = originalTotalAvailable * (jar.percentage / 100);
                            final alreadyReceived = _jarAllocations[jar.id] ?? 0.0;
                            final maxCanAccept = (maxAllowedForJar - alreadyReceived).clamp(0.0, double.infinity);
                            
                            // Safety check: Ensure we never exceed the percentage limit
                            final newTotalForJar = alreadyReceived + amount;
                            final enforcedMax = newTotalForJar > maxAllowedForJar + 0.01
                                ? maxCanAccept  // Clamp to remaining allowed amount
                                : amount;  // Can accept full amount
                            
                            // Accept only what's allowed, return the remainder
                            final amountToAccept = amount > enforcedMax ? enforcedMax : amount;
                            final remainder = amount - amountToAccept;
                            
                            // Additional validation: Ensure the jar never receives more than its percentage allows
                            final finalAllocated = alreadyReceived + amountToAccept;
                            if (finalAllocated > maxAllowedForJar + 0.01) {
                              // This should never happen, but if it does, clamp it
                              final clampedAmount = (maxAllowedForJar - alreadyReceived).clamp(0.0, double.infinity);
                              final totalRemainder = remainder + (amountToAccept - clampedAmount);
                              // Update tracking
                              _jarAllocations[jar.id] = alreadyReceived + clampedAmount;
                              
                              // Handle the note based on remainder
                              if (droppedIndex != null) {
                                if (totalRemainder > 0.01) {
                                  // Update note to show remainder
                                  _availableAmounts[droppedIndex] = totalRemainder;
                                } else {
                                  // Mark as used
                                  _usedAmountIndices.add(droppedIndex);
                                }
                              }
                              
                              widget.onAllocate(jar.id, clampedAmount, totalRemainder);
                              return;
                            }
                            
                            // Update tracking for how much this jar has received
                            if (amountToAccept > 0) {
                              _jarAllocations[jar.id] = alreadyReceived + amountToAccept;
                            }
                            
                            // Handle the note based on whether there's a remainder
                            if (droppedIndex != null) {
                              if (remainder > 0.01) {
                                // There's a remainder - update the note to show remainder amount
                                // Don't mark as used, just change its value
                                _availableAmounts[droppedIndex] = remainder;
                              } else {
                                // No remainder - mark the note as fully used
                                _usedAmountIndices.add(droppedIndex);
                              }
                            }
                            
                            widget.onAllocate(jar.id, amountToAccept, remainder);
                          });
                        },
                      );
                    },
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

