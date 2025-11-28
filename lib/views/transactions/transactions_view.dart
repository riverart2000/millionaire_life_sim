import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/jar_model.dart';
import '../../models/transaction_model.dart';
import '../../providers/data_providers.dart';

class TransactionsView extends ConsumerStatefulWidget {
  const TransactionsView({super.key});

  @override
  ConsumerState<TransactionsView> createState() => _TransactionsViewState();
}

class _TransactionsViewState extends ConsumerState<TransactionsView> {
  String _selectedJar = 'ALL';
  TransactionKind? _selectedKind;

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionsProvider);
    final jarsAsync = ref.watch(jarsProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transactions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildJarFilter(jarsAsync)),
              const SizedBox(width: 12),
              Expanded(child: _buildTypeFilter()),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: transactionsAsync.when(
              data: (transactions) {
                final filtered = _applyFilters(transactions);
                if (filtered.isEmpty) {
                  return const Center(child: Text('No transactions match the current filters.'));
                }
                return ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final tx = filtered[index];
                    return ListTile(
                      leading: _iconFor(tx.kind),
                      title: Text(tx.description),
                      subtitle: Text('${tx.jarId} • ${_formatDate(tx.date)}'),
                      trailing: Text(
                        '4${tx.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: tx.amount >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Failed to load transactions: $error')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJarFilter(AsyncValue<List<Jar>> jarsAsync) {
    return jarsAsync.when(
      data: (jars) {
        final options = ['ALL', ...jars.map((jar) => jar.id)];
        return DropdownButtonFormField<String>(
          value: _selectedJar,
          decoration: const InputDecoration(labelText: 'Jar', border: OutlineInputBorder()),
          items: options
              .map(
                (value) => DropdownMenuItem(
                  value: value,
                  child: Text(value == 'ALL' ? 'All Jars' : value),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value == null) return;
            setState(() => _selectedJar = value);
          },
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildTypeFilter() {
    return DropdownButtonFormField<TransactionKind?>(
      value: _selectedKind,
      decoration: const InputDecoration(labelText: 'Type', border: OutlineInputBorder()),
      items: [
        const DropdownMenuItem<TransactionKind?>(value: null, child: Text('All Types')),
        ...TransactionKind.values.map(
          (kind) => DropdownMenuItem(
            value: kind,
            child: Text(kind.name.toUpperCase()),
          ),
        ),
      ],
      onChanged: (value) {
        setState(() => _selectedKind = value);
      },
    );
  }

  List<MoneyTransaction> _applyFilters(List<MoneyTransaction> transactions) {
    return transactions.where((tx) {
      final jarMatches = _selectedJar == 'ALL' || tx.jarId == _selectedJar;
      final typeMatches = _selectedKind == null || tx.kind == _selectedKind;
      return jarMatches && typeMatches;
    }).toList();
  }

  Widget _iconFor(TransactionKind kind) {
    IconData icon;
    Color color;
    switch (kind) {
      case TransactionKind.income:
        icon = Icons.trending_up;
        color = Colors.green;
        break;
      case TransactionKind.allocation:
        icon = Icons.savings_outlined;
        color = Colors.blueGrey;
        break;
      case TransactionKind.purchase:
        icon = Icons.shopping_cart_outlined;
        color = Colors.orange;
        break;
      case TransactionKind.sale:
        icon = Icons.point_of_sale_outlined;
        color = Colors.purple;
        break;
      case TransactionKind.transfer:
        icon = Icons.sync_alt;
        color = Colors.indigo;
        break;
      case TransactionKind.answer:
        icon = Icons.question_answer;
        color = Colors.teal;
        break;
    }
    return CircleAvatar(backgroundColor: color.withOpacity(0.15), child: Icon(icon, color: color));
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

