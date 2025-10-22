import 'package:flutter/material.dart';

class AwardsPage extends StatelessWidget {
  const AwardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('어워드')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemBuilder: (ctx, i) => _monthCard(context, 2025, 10 - i),
        itemCount: 6,
      ),
    );
  }

  Widget _monthCard(BuildContext context, int year, int month) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$year년 $month월', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: 0.0),
            const SizedBox(height: 4),
            const Text('0/31'),
          ],
        ),
      ),
    );
  }
}
