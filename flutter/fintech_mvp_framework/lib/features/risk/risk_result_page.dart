import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/i18n.dart';
import '../../domain/risk_engine.dart';
import '../../providers/portfolio_provider.dart';

class RiskResultPage extends ConsumerWidget {
  const RiskResultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(portfolioProvider);
    final result = RiskEngine.evaluate(state.items);

    final (icon, title) = switch (result.level) {
      RiskLevel.safe => (Icons.check_circle_outline, 'SAFE'),
      RiskLevel.caution => (Icons.error_outline, 'CAUTION'),
      RiskLevel.danger => (Icons.warning_amber_outlined, 'DANGER'),
    };

    return Scaffold(
      appBar: AppBar(title: Text(context.t.dailyTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(icon, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '$title  •  ${result.score}/100',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(result.reason),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(value: result.score / 100.0),
                  const SizedBox(height: 16),
                  Text(
                    'MVP note: this score is rule-based (no price data).',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Your positions (normalized):',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ...state.items.map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Expanded(child: Text(e.symbol.isEmpty ? '(blank)' : e.symbol)),
                          Text('${e.weight.toStringAsFixed(1)}%'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
