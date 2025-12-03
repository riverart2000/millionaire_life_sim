import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:confetti/confetti.dart';

import '../../core/utils/currency_formatter.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/result.dart';
import '../../models/jar_model.dart';
import '../../models/transaction_model.dart';
import '../../providers/bootstrap_provider.dart';
import '../../providers/data_providers.dart';
import '../../providers/investment_provider.dart';
import '../../providers/session_providers.dart';
import '../../providers/simulation_date_provider.dart';
import '../../providers/sound_provider.dart';
import '../../providers/declaration_provider.dart';
import '../../repositories/interfaces/user_repository.dart';
import '../../services/sound_service.dart';
import '../../widgets/daily_affirmation_quest_dialog.dart';
import '../../widgets/declaration_dialog.dart';
import '../../widgets/money_drag_drop.dart';
import 'package:provider/provider.dart' as legacy;

class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jarsAsync = ref.watch(jarsProvider);
    final profileAsync = ref.watch(userProfileProvider);
    final totalWealth = ref.watch(totalWealthProvider);
    final simulationDate = ref.watch(simulationDateProvider);

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
            data: (jars) => _DragDropAllocationWidget(
              key: ValueKey(simulationDate.toString()),
              jars: jars,
              ref: ref,
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Text('Error loading jars: $error'),
          ),
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
                  data: (profile) {
                    final name = profile?.name ?? 'Investor';
                    // If name already contains "Millionaire", use it as-is
                    // Otherwise, add "Millionaire" prefix
                    final displayName = name.contains('Millionaire')
                        ? name
                        : 'Millionaire $name';
                    return Text(
                      'Welcome back, $displayName',
                      style: textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
                    );
                  },
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              CurrencyFormatter.format(totalWealth),
                              style: textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                            ),
                            const SizedBox(width: 12),
                            profileAsync.when(
                              data: (profile) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.purple[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.psychology, size: 16, color: Colors.purple[700]),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${(profile?.mindsetLevel ?? 1.0).toStringAsFixed(1)}x',
                                      style: textTheme.labelLarge?.copyWith(
                                        color: Colors.purple[700],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              loading: () => const SizedBox.shrink(),
                              error: (_, __) => const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const _NextDayButton(),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DragDropAllocationWidget extends ConsumerWidget {
  const _DragDropAllocationWidget({
    super.key,
    required this.jars,
    required this.ref,
  });

  final List<Jar> jars;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final dailyIncome = profileAsync.maybeWhen(
      data: (profile) => (profile?.dailyIncome ?? 0.0) > 0 ? profile!.dailyIncome : 200.0,
      orElse: () => 200.0,
    );
    
    // Watch simulation date to force money regeneration when day changes
    final simulationDate = ref.watch(simulationDateProvider);
    
    // We need to pass a ref to MoneyDragDropWidget to access its state
    // Instead, let's make the widget handle the remainder internally
    return MoneyDragDropWidget(
      key: ValueKey('money_${simulationDate.toString()}'),
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
      
      // Increment the day counter in user profile
      final userRepo = ref.read(userRepositoryProvider);
      final currentProfile = await userRepo.fetchProfile();
      if (currentProfile != null) {
        await userRepo.saveProfile(
          currentProfile.copyWith(dayCounter: currentProfile.dayCounter + 1),
        );
      }
      
      // Refresh investments to show updated prices
      ref.invalidate(investmentsProvider);
      // Refresh jars to show updated balances (including interest)
      ref.invalidate(jarsProvider);
      // Refresh user profile to show updated unallocated balance
      ref.invalidate(userProfileProvider);
      // Refresh marketplace catalog to show updated item prices
      ref.invalidate(marketplaceCatalogProvider);
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
        // Step 1: Show affirmation quest dialog
        bool affirmationCompleted = false;
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => DailyAffirmationQuestDialog(
            actionName: 'Simulate Next Day',
            onComplete: () {
              // Mark as completed (dialog closes itself)
              affirmationCompleted = true;
            },
          ),
        );
        
        // If affirmation not completed, stop
        if (!affirmationCompleted || !context.mounted) return;
        
        // Step 2: Load and show all declarations in random order
        final service = ref.read(declarationServiceProvider);
        await service.loadDeclarations();
        final allDeclarations = service.getAllDeclarations();
        
        if (allDeclarations.isNotEmpty) {
          // Shuffle declarations for random order each time
          final shuffledDeclarations = List.from(allDeclarations)..shuffle();
          
          // Show each declaration one by one
          for (final declaration in shuffledDeclarations) {
            if (!context.mounted) break;
            
            final completed = await showDialog<bool>(
              context: context,
              barrierDismissible: false,
              builder: (context) => DeclarationDialog(
                declaration: declaration,
              ),
            );
            
            // If user didn't complete, stop the flow
            if (completed != true) {
              return;
            }
          }
          
          // All declarations completed! Show celebration
          if (context.mounted && allDeclarations.isNotEmpty) {
            // Play celebration sound
            SoundService.instance.playCelebration();
            
            // Show confetti celebration
            final confettiController = ConfettiController(duration: const Duration(seconds: 3));
            confettiController.play();
            
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => Stack(
                children: [
                  // Confetti layers
                  Align(
                    alignment: Alignment.topCenter,
                    child: ConfettiWidget(
                      confettiController: confettiController,
                      blastDirection: 3.14 / 2, // Down
                      emissionFrequency: 0.05,
                      numberOfParticles: 20,
                      gravity: 0.3,
                      colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple, Colors.yellow],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: ConfettiWidget(
                      confettiController: confettiController,
                      blastDirection: -3.14 / 4, // Up-right
                      emissionFrequency: 0.05,
                      numberOfParticles: 15,
                      gravity: 0.2,
                      colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple, Colors.yellow],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ConfettiWidget(
                      confettiController: confettiController,
                      blastDirection: -3 * 3.14 / 4, // Up-left
                      emissionFrequency: 0.05,
                      numberOfParticles: 15,
                      gravity: 0.2,
                      colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple, Colors.yellow],
                    ),
                  ),
                  // Success dialog
                  Center(
                    child: Card(
                      margin: const EdgeInsets.all(32),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.emoji_events, size: 64, color: Colors.amber),
                            const SizedBox(height: 16),
                            Text(
                              'Declarations Complete!',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Great job completing all ${allDeclarations.length} declarations!',
                              style: Theme.of(context).textTheme.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            FilledButton(
                              onPressed: () {
                                confettiController.stop();
                                Navigator.of(context).pop();
                              },
                              child: const Text('Continue'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        }
        
        // Step 3: All declarations completed, proceed with simulation
        if (context.mounted) {
          await _executeSimulation(context, ref);
        }
      },
      icon: const Icon(Icons.calendar_today),
      label: Consumer(
        builder: (context, ref, _) {
          final profileAsync = ref.watch(userProfileProvider);
          return profileAsync.when(
            data: (profile) => Text('Goto DAY ${profile?.dayCounter ?? 1}'),
            loading: () => const Text('Goto DAY 1'),
            error: (_, __) => const Text('Goto DAY 1'),
          );
        },
      ),
    );
  }
}
