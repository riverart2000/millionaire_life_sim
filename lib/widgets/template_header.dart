import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quote_provider.dart';
import 'top_menu.dart';

class TemplateHeader extends StatelessWidget {
  const TemplateHeader({
    super.key,
    required this.userName,
    required this.activeMenu,
    required this.menuItems,
    required this.onMenuSelected,
    required this.onLogout,
    required this.isSoundEnabled,
    required this.onToggleSound,
  });

  final String userName;
  final String activeMenu;
  final List<TemplateMenuItem> menuItems;
  final ValueChanged<String> onMenuSelected;
  final Future<void> Function() onLogout;
  final bool isSoundEnabled;
  final Future<void> Function() onToggleSound;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.school,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Millionaire Life Style',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        'Reusable UI shell with menu, header, and quotes',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Hello, $userName',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Tooltip(
                          message: isSoundEnabled ? 'Mute celebration sounds' : 'Unmute celebration sounds',
                          child: IconButton(
                            icon: Icon(isSoundEnabled ? Icons.volume_up : Icons.volume_off),
                            onPressed: () async {
                              await onToggleSound();
                            },
                          ),
                        ),
                        const SizedBox(width: 4),
                        TextButton.icon(
                          onPressed: () async {
                            await onLogout();
                          },
                          icon: const Icon(Icons.logout, size: 16),
                          label: const Text('Logout'),
                          style: TextButton.styleFrom(
                            foregroundColor: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            TemplateTopMenu(
              items: menuItems,
              activeItemId: activeMenu,
              onItemSelected: onMenuSelected,
            ),
            const SizedBox(height: 16),
            _buildMotivationalQuote(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMotivationalQuote(BuildContext context) {
    return Consumer<QuoteProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return _QuoteBannerContainer(
            child: const Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        if (provider.error != null) {
          return _QuoteBannerContainer(
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.redAccent, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    provider.error!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                TextButton(
                  onPressed: provider.loadQuotes,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final quote = provider.currentQuote;
        if (quote == null) {
          return const SizedBox.shrink();
        }

        return _QuoteBannerContainer(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.format_quote,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quote.text,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '— ${quote.author}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Show another quote',
                onPressed: provider.nextQuote,
                icon: const Icon(Icons.refresh, size: 20),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _QuoteBannerContainer extends StatelessWidget {
  const _QuoteBannerContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.35),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}

