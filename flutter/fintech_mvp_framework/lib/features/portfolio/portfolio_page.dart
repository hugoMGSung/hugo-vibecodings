import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/i18n.dart';
import '../../providers/portfolio_provider.dart';

class PortfolioPage extends ConsumerWidget {
  const PortfolioPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(portfolioProvider);
    final ctrl = ref.read(portfolioProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.t.homeDaily),
        actions: [
          IconButton(
            tooltip: 'Demo',
            onPressed: ctrl.resetToDemo,
            icon: const Icon(Icons.auto_fix_high_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: ctrl.add,
        icon: const Icon(Icons.add),
        label: const Text('+'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    context.t.consentBody,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _Chip(label: 'Tip: weights don\'t need to sum to 100.'),
                      _Chip(label: 'Use CASH for cash weight.'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (state.items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(child: Text(context.t.loading)),
            )
          else
            ...List.generate(state.items.length, (i) {
              final item = state.items[i];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Symbol',
                                hintText: 'e.g., SKHYNIX',
                              ),
                              controller: TextEditingController(text: item.symbol)
                                ..selection = TextSelection.fromPosition(
                                  TextPosition(offset: item.symbol.length),
                                ),
                              onChanged: (v) => ctrl.updateSymbol(i, v.trim()),
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 120,
                            child: TextField(
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: const InputDecoration(
                                labelText: 'Weight %',
                                hintText: '0..100',
                              ),
                              controller: TextEditingController(text: item.weight == 0 ? '' : item.weight.toStringAsFixed(1))
                                ..selection = TextSelection.fromPosition(
                                  TextPosition(offset: (item.weight == 0 ? '' : item.weight.toStringAsFixed(1)).length),
                                ),
                              onChanged: (v) {
                                final parsed = double.tryParse(v);
                                if (parsed != null) ctrl.updateWeight(i, parsed);
                              },
                            ),
                          ),
                          IconButton(
                            tooltip: 'Remove',
                            onPressed: () => ctrl.removeAt(i),
                            icon: const Icon(Icons.delete_outline),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Total weight: ${state.sumWeight.toStringAsFixed(1)}%'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: state.items.isEmpty ? null : () => context.push('/risk'),
                    child: Text(context.t.play),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  const _Chip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(label));
  }
}
