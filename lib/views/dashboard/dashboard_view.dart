import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/utils/currency_formatter.dart';
import '../../core/utils/result.dart';
import '../../models/jar_model.dart';
import '../../models/transaction_model.dart';
import '../../providers/bootstrap_provider.dart';
import '../../providers/data_providers.dart';
import '../../providers/investment_provider.dart';
import '../../providers/session_providers.dart';
import '../affirmations/affirmations_view.dart';
import '../../providers/simulation_date_provider.dart';
import '../../providers/sound_provider.dart';
import '../../widgets/daily_affirmation_quest_dialog.dart';
import '../../widgets/money_drag_drop.dart';
import 'package:provider/provider.dart' as legacy;

class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jarsAsync = ref.watch(jarsProvider);
    final profileAsync = ref.watch(userProfileProvider);
    final totalWealth = ref.watch(totalWealthProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(userBootstrapProvider);
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(context, profileAsync, totalWealth),
          const SizedBox(height: 16),
          jarsAsync.when(
            data: (jars) => _DragDropAllocationWidget(jars: jars, ref: ref),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Text('Error loading jars: $error'),
          ),
          const SizedBox(height: 16),
          _buildAffirmationCard(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AsyncValue profileAsync, double totalWealth) {
    final textTheme = Theme.of(context).textTheme;
    return Consumer(
      builder: (context, ref, _) {
        // Watch the provider to get updates when state changes
        final currentDate = ref.watch(simulationDateProvider);
        // Format date directly from the watched state to ensure it updates
        final formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(currentDate);
        
        // Debug: Print when date changes in UI
        if (kDebugMode) {
          debugPrint('📅 Dashboard showing date: $formattedDate');
        }
        
        return Card(
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                profileAsync.when(
                  data: (profile) => Text(
                    'Welcome back, ${profile?.name ?? 'Investor'}',
                    style: textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 8),
                Text(
                  formattedDate,
                  style: textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Net Worth',
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          CurrencyFormatter.format(totalWealth),
                          style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Affirmations button
                        FilledButton.tonalIcon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const AffirmationsView(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.psychology),
                          label: const Text('Affirmations'),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.deepPurple[100],
                            foregroundColor: Colors.deepPurple[900],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const _NextDayButton(),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAffirmationCard(BuildContext context) {
    final affirmations = <String>[
      'Money is a tool that I control.',
      'I allocate every dollar with purpose and vision.',
      'Passive income streams flow to me consistently.',
      'I invest in my education and expand my mindset daily.',
      'Generosity compounds my abundance.',
    ];
    final randomAffirmation = affirmations[Random().nextInt(affirmations.length)];

    return Card(
      color: Colors.deepPurple.shade50,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AffirmationsView(),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.psychology, color: Colors.deepPurple),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      randomAffirmation,
                      style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                    ).animate().fadeIn(duration: 600.ms),
                    const SizedBox(height: 8),
                    Text(
                      'Tap to practice MMI affirmations →',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.deepPurple[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DragDropAllocationWidget extends ConsumerWidget {
  const _DragDropAllocationWidget({
    required this.jars,
    required this.ref,
  });

  final List<Jar> jars;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final dailyIncome = profileAsync.maybeWhen(
      data: (profile) => profile?.unallocatedBalance ?? 0.0,
      orElse: () => 0.0,
    );
    
    // We need to pass a ref to MoneyDragDropWidget to access its state
    // Instead, let's make the widget handle the remainder internally
    return MoneyDragDropWidget(
      jars: jars,
      dailyIncome: dailyIncome,
      onAllocate: (jarId, amount, remainder) async {
        final jarService = ref.read(jarServiceProvider);
        final userId = ref.read(userIdProvider);

        // Add amount to the jar using deposit method (which handles transaction creation)
        final result = await jarService.deposit(
          userId: userId,
          jarId: jarId,
          amount: amount,
          description: 'Manual drag & drop allocation',
          kind: TransactionKind.allocation,
        );

        if (result is Success<Jar>) {
          // Refresh the jars to get updated balances
          ref.invalidate(jarsProvider);
          
          if (context.mounted) {
            final message = remainder > 0
                ? 'Added ${CurrencyFormatter.format(amount)} to ${result.value.name} jar! (${CurrencyFormatter.format(remainder)} returned - jar at max %)'
                : 'Added ${CurrencyFormatter.format(amount)} to ${result.value.name} jar!';
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          }
          
          // Return remainder - need to pass it back somehow
          // We'll handle this by invalidating and letting the widget refresh
        } else if (result is Failure<Jar>) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to allocate: ${result.exception}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
    );
  }
}

class _NextDayButton extends ConsumerWidget {
  const _NextDayButton();

  Future<void> _executeSimulation(BuildContext context, WidgetRef ref) async {
    final incomeService = ref.read(incomeServiceProvider);
    final userId = ref.read(userIdProvider);
    final dateNotifier = ref.read(simulationDateProvider.notifier);
    
    // Play the next day jingle
    try {
      final soundProvider = legacy.Provider.of<SoundProvider>(context, listen: false);
      await soundProvider.playNextDayJingle();
    } catch (e) {
      // Sound failed, but continue with simulation
      print('Sound error: $e');
    }
    
    final result = await incomeService.simulateNextDay(userId: userId);
    if (result is Success<double>) {
      final income = result.value;
      // Increment the simulation date
      await dateNotifier.incrementDay();
      // Refresh investments to show updated prices
      ref.invalidate(investmentsProvider);
      // Refresh jars to show updated balances (including interest)
      ref.invalidate(jarsProvider);
      // Refresh user profile to show updated unallocated balance
      ref.invalidate(userProfileProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Simulated next day • Income earned: ${CurrencyFormatter.format(income)} (drag notes to jars to allocate)')),
        );
      }
    } else if (result is Failure<double>) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to simulate income: ${result.exception}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilledButton.icon(
      onPressed: () async {
        // Show quest dialog every time
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => DailyAffirmationQuestDialog(
            actionName: 'Simulate Next Day',
            onComplete: () async {
              await _executeSimulation(context, ref);
            },
          ),
        );
      },
      icon: const Icon(Icons.calendar_today),
      label: const Text('Simulate Next Day'),
    );
  }
}
