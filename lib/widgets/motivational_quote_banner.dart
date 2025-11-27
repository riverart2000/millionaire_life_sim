import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quote_provider.dart';

class MotivationalQuoteBanner extends StatelessWidget {
  const MotivationalQuoteBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<QuoteProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const _BannerContainer(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (provider.error != null) {
          return _BannerContainer(
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.redAccent),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    provider.error!,
                    style: Theme.of(context).textTheme.bodyMedium,
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

        return _BannerContainer(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.format_quote,
                color: Theme.of(context).colorScheme.primary,
                size: 28,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quote.text,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '— ${quote.author}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                tooltip: 'Show another quote',
                onPressed: provider.nextQuote,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BannerContainer extends StatelessWidget {
  const _BannerContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.35),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

