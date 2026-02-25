import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/i18n.dart';

/// Fintech MVP dashboard.
///
/// - Entry point after consent.
/// - Keeps your existing light/dark theme & localization plumbing.
/// - Routes to Portfolio input and Settings.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t.appTitle),
        actions: [
          IconButton(
            tooltip: context.t.settingsTitle,
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    context.t.homeDaily,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.t.loading,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => context.push('/portfolio'),
                    icon: const Icon(Icons.account_balance_wallet_outlined),
                    label: Text(context.t.play),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.shield_outlined),
              title: Text(context.t.dailyTitle),
              subtitle: Text(
                context.t.awardsHint,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/portfolio'),
            ),
          ),
        ],
      ),
    );
  }
}
