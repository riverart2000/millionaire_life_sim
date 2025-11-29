import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import '../../core/utils/result.dart';
import '../../models/marketplace_item_model.dart';
import '../../providers/data_providers.dart';
import '../../providers/bootstrap_provider.dart';
import '../../providers/session_providers.dart';
import '../../widgets/purchase_celebration.dart';
import '../../widgets/riddle_dialog.dart';
import '../../widgets/streak_reward_dialog.dart';
import '../../services/riddle_service.dart';
import '../../services/jar_service.dart';
import '../../models/transaction_model.dart';

class MarketplaceView extends ConsumerWidget {
  const MarketplaceView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localCatalog = ref.watch(marketplaceCatalogProvider);
    final globalListings = ref.watch(marketplaceListingsProvider);
    final userId = ref.watch(userIdProvider);
    final jars = ref.watch(jarsProvider);

    return PurchaseCelebration(
      child: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(marketplaceCatalogProvider);
          ref.invalidate(marketplaceListingsProvider);
        },
        child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Marketplace',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              jars.when(
                data: (jarList) {
                  final ffaJar = jarList.firstWhere(
                    (jar) => jar.id == 'FFA',
                    orElse: () => jarList.first,
                  );
                  final playJar = jarList.firstWhere(
                    (jar) => jar.id == 'PLAY',
                    orElse: () => jarList.first,
                  );
                  final ltssJar = jarList.firstWhere(
                    (jar) => jar.id == 'LTSS',
                    orElse: () => jarList.first,
                  );
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _JarChip(label: 'FFA', balance: ffaJar.balance, color: Colors.green),
                      const SizedBox(width: 8),
                      _JarChip(label: 'PLAY', balance: playJar.balance, color: Colors.purple),
                      const SizedBox(width: 8),
                      _JarChip(label: 'LTSS', balance: ltssJar.balance, color: Colors.blue),
                    ],
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'List items from your catalog or acquire assets from other investors.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),

          // Marketplace Progress Bar
          localCatalog.when(
            data: (catalogItems) {
              final purchasedCount = catalogItems.where((item) => item.isOwned).length;
              final totalCount = catalogItems.length;
              final progress = totalCount > 0 ? (purchasedCount / totalCount).clamp(0.0, 1.0) : 0.0;
              
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        children: [
                          Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.easeOutCubic,
                            height: 6,
                            width: constraints.maxWidth * progress,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).colorScheme.primary,
                                  Theme.of(context).colorScheme.secondary,
                                  Theme.of(context).colorScheme.tertiary,
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 16),
          localCatalog.when(
            data: (items) => _LocalCatalogSection(items: items, userId: userId),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Text('Failed to load catalog: $error'),
          ),
          const SizedBox(height: 16),
          globalListings.when(
            data: (items) => _GlobalListingsSection(items: items, currentUserId: userId),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Text('Failed to load live listings: $error'),
          ),
        ],
      ),
      ),
    );
  }
}

class _LocalCatalogSection extends ConsumerWidget {
  const _LocalCatalogSection({required this.items, required this.userId});

  final List<MarketplaceItem> items;
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Filter to only show items owned by the current user
    final ownedItems = items.where((item) => item.ownerId == userId).toList();
    
    if (ownedItems.isEmpty) {
      return Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Catalog',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'You don\'t own any items yet. Purchase items from the marketplace below to add them to your catalog.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Catalog',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: Text('${ownedItems.length} items'),
                  backgroundColor: Colors.green.shade100,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...ownedItems.map((item) => _CatalogItemTile(item: item, userId: userId)),
          ],
        ),
      ),
    );
  }
}

class _CatalogItemTile extends ConsumerWidget {
  const _CatalogItemTile({required this.item, required this.userId});

  final MarketplaceItem item;
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketplaceService = ref.watch(marketplaceServiceProvider);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: _MarketplaceImage(
          imageUrl: item.imageUrl,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(item.name),
      subtitle: Text('${item.category} • £${item.price.toStringAsFixed(0)} • Jar: ${item.requiredJar}'),
      trailing: SizedBox(
        width: 120,
        child: item.isListed
            ? const Chip(
                label: Text('Listed', style: TextStyle(fontSize: 12)),
                visualDensity: VisualDensity.compact,
              )
            : item.category == 'Experiences'
                ? const Chip(
                    label: Text('Experience', style: TextStyle(fontSize: 11)),
                    backgroundColor: Colors.purple,
                    visualDensity: VisualDensity.compact,
                  )
                : OutlinedButton(
              onPressed: () async {
                // Show confirmation dialog
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Sell Back Item?'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sell ${item.name} back to the marketplace?'),
                        const SizedBox(height: 16),
                        Text('You will receive: £${item.price.toStringAsFixed(0)}'),
                        Text('Refunded to: ${item.requiredJar} jar'),
                        const SizedBox(height: 8),
                        Text(
                          'The item will be removed from your catalog and become available for others to purchase.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Sell Back'),
                      ),
                    ],
                  ),
                );

                if (confirmed != true || !context.mounted) return;

                final result = await marketplaceService.sellBackItem(userId: userId, item: item);
                if (result is Success<void>) {
                  ref.invalidate(marketplaceCatalogProvider);
                  ref.invalidate(jarsProvider);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('✅ Sold ${item.name} for £${item.price.toStringAsFixed(0)}'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } else if (result is Failure<void>) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Sale failed: ${result.exception}')),
                    );
                  }
                }
              },
              child: const Text('List for sale', style: TextStyle(fontSize: 12)),
            ),
      ),
    );
  }
}

class _GlobalListingsSection extends ConsumerWidget {
  const _GlobalListingsSection({required this.items, required this.currentUserId});

  final List<MarketplaceItem> items;
  final String currentUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Filter to show items NOT owned by the current user (available for purchase)
    final availableItems = items.where((item) => item.ownerId != currentUserId).toList();
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Available to Purchase',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                if (availableItems.isNotEmpty)
                  Chip(
                    label: Text('${availableItems.length} items'),
                    backgroundColor: Colors.blue.shade100,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Purchase items to add them to your catalog',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            if (availableItems.isEmpty)
              Text(
                'You own all available items! 🎉',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              )
            else
              ...availableItems.map((item) => _ListingTile(item: item, currentUserId: currentUserId)),
          ],
        ),
      ),
    );
  }
}

class _ListingTile extends ConsumerWidget {
  const _ListingTile({required this.item, required this.currentUserId});

  final MarketplaceItem item;
  final String currentUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketplaceService = ref.watch(marketplaceServiceProvider);
    final isOwner = item.ownerId == currentUserId || item.sellerId == currentUserId;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _MarketplaceImage(
                imageUrl: item.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Text('£${item.price.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text(item.description),
            const SizedBox(height: 8),
            Text('Jar required: ${item.requiredJar} • Category: ${item.category}'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isOwner)
                  OutlinedButton(
                    onPressed: () async {
                      final result = await marketplaceService.cancelListing(item.id);
                      if (result is Success<void>) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Listing removed for ${item.name}.')),
                        );
                      } else if (result is Failure<void>) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to remove listing: ${result.exception}')),
                        );
                      }
                    },
                    child: const Text('Cancel listing'),
                  )
                else
                  FilledButton.icon(
                    onPressed: () async {
                      // First check if user has enough money by getting jar balance
                      final jars = await ref.read(jarsProvider.future);
                      final requiredJar = jars.firstWhere(
                        (jar) => jar.id == item.requiredJar,
                        orElse: () => jars.first,
                      );
                      
                      if (requiredJar.balance < item.price) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Not enough yet! Work harder, smarter, longer. Build your ${requiredJar.name} jar to £${item.price.toStringAsFixed(0)} to unlock this.'),
                            backgroundColor: Colors.orange,
                            duration: const Duration(seconds: 4),
                          ),
                        );
                        return;
                      }
                      
                      // Show riddle challenge after money check passes
                      final riddleService = GetIt.instance<RiddleService>();
                      final riddle = riddleService.getRiddleBasedOnStreak();
                      
                      final riddleResult = await showDialog<bool>(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => RiddleDialog(
                          riddle: riddle,
                          riddleService: riddleService,
                          onComplete: (correct, reward) {},
                        ),
                      );
                      
                      // Only proceed with purchase if riddle was answered correctly
                      if (riddleResult != true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('❌ Purchase cancelled. Try again when you\'re ready!'),
                            backgroundColor: Colors.orange,
                            duration: Duration(seconds: 3),
                          ),
                        );
                        return;
                      }
                      
                      // Check for streak milestone reward
                      final newStreak = riddleService.getCurrentStreak();
                      final reward = riddleService.getStreakReward(newStreak);
                      
                      if (reward != null) {
                        // Add reward to PLAY jar
                        final jarService = ref.read(jarServiceProvider);
                        final profile = ref.read(userProfileProvider).value;
                        final userId = profile?.id ?? 'demo';
                        
                        await jarService.deposit(
                          userId: userId,
                          jarId: 'PLAY',
                          amount: reward,
                          description: 'Riddle Streak Bonus (${newStreak}x)',
                          kind: TransactionKind.income,
                        );
                        
                        // Show streak reward dialog with fireworks
                        await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => StreakRewardDialog(
                            streak: newStreak,
                            reward: reward,
                            jarName: 'PLAY',
                          ),
                        );
                      }
                      
                      // Now proceed with purchase
                      final result = await marketplaceService.purchaseItem(
                        userId: currentUserId,
                        sellerId: item.sellerId ?? item.ownerId ?? '',
                        item: item,
                      );
                      if (result is Success<void>) {
                        // Trigger celebration fireworks!
                        PurchaseCelebration.celebrate(context);
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('✅ Purchased ${item.name}!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else if (result is Failure<void>) {
                        final message = result.exception.toString();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(message.replaceFirst('Bad state: ', '').replaceFirst('StateError: ', '')),
                            backgroundColor: Colors.orange,
                            duration: const Duration(seconds: 4),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text('Buy now'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper widget to safely load marketplace images with fallback
class _MarketplaceImage extends StatelessWidget {
  const _MarketplaceImage({
    required this.imageUrl,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
  });

  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return _buildPlaceholder(context);
    }

    // Use Image.network for URLs, Image.asset for local assets
    final isNetworkImage = imageUrl.startsWith('http://') || imageUrl.startsWith('https://');
    
    if (isNetworkImage) {
      return Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Failed to load image: $imageUrl - Error: $error');
          return _buildPlaceholder(context);
        },
      );
    }

    return Image.asset(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        debugPrint('Failed to load image: $imageUrl - Error: $error');
        return _buildPlaceholder(context);
      },
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    final iconSize = width.isFinite ? width / 2 : 48.0;
    return Container(
      width: width.isFinite ? width : null,
      height: height,
      color: Colors.blueGrey.shade100,
      child: Center(
        child: Icon(Icons.image, color: Colors.grey, size: iconSize),
      ),
    );
  }
}

/// Helper widget to display jar balance chips
class _JarChip extends StatelessWidget {
  const _JarChip({
    required this.label,
    required this.balance,
    required this.color,
  });

  final String label;
  final double balance;
  final MaterialColor color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color.shade900,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '£${balance.toStringAsFixed(0)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color.shade900,
            ),
          ),
        ],
      ),
    );
  }
}

