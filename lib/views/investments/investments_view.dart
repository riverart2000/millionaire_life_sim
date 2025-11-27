import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as legacy;

import '../../core/utils/currency_formatter.dart';
import '../../core/utils/result.dart';
import '../../models/investment_model.dart';
import '../../models/jar_model.dart';
import '../../providers/data_providers.dart';
import '../../providers/investment_provider.dart';
import '../../providers/sound_provider.dart';
import '../../widgets/purchase_celebration.dart';

class InvestmentsView extends ConsumerWidget {
  const InvestmentsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final investmentsAsync = ref.watch(investmentsProvider);
    final jarsAsync = ref.watch(jarsProvider);

    final ffaBalance = jarsAsync.when<double>(
      data: (jars) => _ffaBalance(jars),
      error: (_, __) => 0,
      loading: () => 0,
    );

    final totalInvestments = investmentsAsync.when<double>(
      data: (investments) => investments.fold<double>(
        0.0,
        (sum, investment) => sum + investment.marketValue,
      ),
      error: (_, __) => 0,
      loading: () => 0,
    );

    return PurchaseCelebration(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
            children: [
              Icon(Icons.trending_up, color: Theme.of(context).colorScheme.primary, size: 18),
              const SizedBox(width: 6),
              Text(
                'Investments',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _formatCurrency(totalInvestments),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
              const Spacer(),
              Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('FFA', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10)),
                      const SizedBox(height: 2),
                      Text(
                        _formatCurrency(ffaBalance),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: investmentsAsync.when(
              data: (investments) {
                // Always show all 3 investment types (Gold, Silver, BTC)
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final maxWidth = constraints.maxWidth;
                    int crossAxisCount;
                    if (maxWidth >= 1100) {
                      crossAxisCount = 3;
                    } else if (maxWidth >= 720) {
                      crossAxisCount = 2;
                    } else {
                      crossAxisCount = 1;
                    }

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 6,
                        childAspectRatio: crossAxisCount == 1 ? 3.5 : 2.5,
                      ),
                      itemCount: investments.length,
                      itemBuilder: (context, index) {
                        final investment = investments[index];
                        return _InvestmentCard(
                          investment: investment,
                          ffaBalance: ffaBalance,
                          onBuy: (amount) => _handlePurchase(context, ref, investment, amount),
                          onSell: (units) => _handleSale(context, ref, investment, units),
                        );
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Failed to load investments: $error')),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Future<void> _handlePurchase(
    BuildContext context,
    WidgetRef ref,
    Investment investment,
    double amount,
  ) async {
    // Play investment-specific jingle
    try {
      final soundProvider = legacy.Provider.of<SoundProvider>(context, listen: false);
      await soundProvider.playInvestmentJingle(investment.symbol);
    } catch (e) {
      // Sound failed, but continue with purchase
    }

    final result = await buyInvestment(
      ref: ref,
      symbol: investment.symbol,
      amountDollars: amount,
      currentPrice: investment.pricePerUnit,
      currentUnits: investment.unitsOwned,
    );

    if (context.mounted) {
      if (result is Success<Investment>) {
        // Trigger celebration fireworks!
        PurchaseCelebration.celebrate(context);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Purchased ${result.value.name} worth ${_formatCurrency(amount)}'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (result is Failure<Investment>) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Purchase failed: ${result.exception}')),
        );
      }
    }
  }

  Future<void> _handleSale(
    BuildContext context,
    WidgetRef ref,
    Investment investment,
    double units,
  ) async {
    // Play investment-specific jingle
    try {
      final soundProvider = legacy.Provider.of<SoundProvider>(context, listen: false);
      await soundProvider.playInvestmentJingle(investment.symbol);
    } catch (e) {
      // Sound failed, but continue with sale
    }

    final result = await sellInvestment(
      ref: ref,
      symbol: investment.symbol,
      units: units,
      currentPrice: investment.pricePerUnit,
      currentUnits: investment.unitsOwned,
    );

    if (context.mounted) {
      if (result is Success<Investment>) {
        final saleAmount = units * investment.pricePerUnit;
        
        // Trigger celebration fireworks!
        PurchaseCelebration.celebrate(context);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('💰 Sold ${units.toStringAsFixed(4)} units of ${result.value.name} for ${_formatCurrency(saleAmount)}'),
            backgroundColor: Colors.blue,
          ),
        );
      } else if (result is Failure<Investment>) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sale failed: ${result.exception}')),
        );
      }
    }
  }
}

class _InvestmentCard extends StatefulWidget {
  const _InvestmentCard({
    required this.investment,
    required this.ffaBalance,
    required this.onBuy,
    required this.onSell,
  });

  final Investment investment;
  final double ffaBalance;
  final Future<void> Function(double amount) onBuy;
  final Future<void> Function(double units) onSell;

  @override
  State<_InvestmentCard> createState() => _InvestmentCardState();
}

class _InvestmentCardState extends State<_InvestmentCard> {
  bool _isBuying = false;
  bool _isSelling = false;

  @override
  Widget build(BuildContext context) {
    final investment = widget.investment;
    final theme = Theme.of(context);

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                  child: Text(
                    investment.symbol,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        investment.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${investment.unitsOwned.toStringAsFixed(4)} units',
                        style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            _DetailRow(label: 'Price', value: _formatCurrency(investment.pricePerUnit)),
            const SizedBox(height: 1),
            _DetailRow(label: 'Value', value: _formatCurrency(investment.marketValue)),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _isBuying || _isSelling ? null : () => _showBuyDialog(context),
                    icon: _isBuying
                        ? const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.shopping_cart, size: 14),
                    label: const Text('Buy', style: TextStyle(fontSize: 12)),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: const Size(0, 24),
                      backgroundColor: theme.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: (_isBuying || _isSelling || investment.unitsOwned <= 0) ? null : () => _showSellDialog(context),
                    icon: _isSelling
                        ? const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.sell, size: 14),
                    label: const Text('Sell', style: TextStyle(fontSize: 12)),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: const Size(0, 24),
                      backgroundColor: theme.colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showBuyDialog(BuildContext context) async {
    final controller = TextEditingController();
    final theme = Theme.of(context);

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Buy ${widget.investment.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Enter the amount to invest (min \$10).'),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Amount in FFA',
                  prefixText: '\$',
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Available: ${_formatCurrency(widget.ffaBalance)}',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final amount = double.tryParse(controller.text.trim()) ?? 0;
                if (amount < 10) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Investment must be at least \$10.')),
                  );
                  return;
                }
                if (amount > widget.ffaBalance) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Insufficient funds in FFA jar.')),
                  );
                  return;
                }

                setState(() => _isBuying = true);
                Navigator.of(context).pop();
                await widget.onBuy(amount);
                setState(() => _isBuying = false);
              },
              child: const Text('Buy'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSellDialog(BuildContext context) async {
    final controller = TextEditingController();
    final theme = Theme.of(context);

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Sell ${widget.investment.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Enter the number of units to sell.'),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Units to sell',
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'You own: ${widget.investment.unitsOwned.toStringAsFixed(4)} units',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 4),
              Text(
                'Current value: ${_formatCurrency(widget.investment.marketValue)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final units = double.tryParse(controller.text.trim()) ?? 0;
                if (units <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Units must be greater than zero.')),
                  );
                  return;
                }
                if (units > widget.investment.unitsOwned) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cannot sell more units than you own.')),
                  );
                  return;
                }

                setState(() => _isSelling = true);
                Navigator.of(context).pop();
                await widget.onSell(units);
                setState(() => _isSelling = false);
              },
              child: const Text('Sell'),
            ),
          ],
        );
      },
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 11,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

String _formatCurrency(double value) {
  return CurrencyFormatter.format(value);
}

double _ffaBalance(List<Jar> jars) {
  for (final jar in jars) {
    if (jar.id.toUpperCase() == 'FFA') {
      return jar.balance;
    }
  }
  return 0;
}

