import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/result.dart';
import '../../models/marketplace_item_model.dart';
import '../../providers/data_providers.dart';
import '../../providers/bootstrap_provider.dart';
import '../../providers/session_providers.dart';
import '../../widgets/purchase_celebration.dart';

class MarketplaceView extends ConsumerWidget {
  const MarketplaceView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localCatalog = ref.watch(marketplaceCatalogProvider);
    final globalListings = ref.watch(marketplaceListingsProvider);
    final userId = ref.watch(userIdProvider);

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
          Text(
            'Marketplace',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'List items from your catalog or acquire assets from other investors.',
            style: Theme.of(context).textTheme.bodySmall,
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
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: item.imageUrl.isNotEmpty
            ? Image.network(
                item.imageUrl,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 56,
                    height: 56,
                    color: Colors.blueGrey.shade100,
                    child: const Icon(Icons.image_not_supported, size: 28),
                  );
                },
              )
            : Container(
                width: 56,
                height: 56,
                color: Colors.blueGrey.shade100,
                child: Center(
                  child: Text(
                    item.name.substring(0, 1),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
      ),
      title: Text(item.name),
      subtitle: Text('${item.category} • £${item.price.toStringAsFixed(0)} • Jar: ${item.requiredJar}'),
      trailing: item.isListed
          ? const Chip(label: Text('Listed'))
          : OutlinedButton(
              onPressed: () async {
                final result = await marketplaceService.listItemForSale(userId: userId, item: item);
                if (result is Success<void>) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${item.name} listed for sale.')),
                  );
                } else if (result is Failure<void>) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Listing failed: ${result.exception}')),
                  );
                }
              },
              child: const Text('List for sale'),
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
            if (item.imageUrl.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.blueGrey.shade100,
                      child: const Center(
                        child: Icon(Icons.image_not_supported, size: 60),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Purchase failed: ${result.exception}')),
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

