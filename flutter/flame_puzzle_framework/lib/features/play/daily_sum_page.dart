import 'package:flutter/material.dart';
import '../../game/puzzles/daily_sum/daily_sum_state.dart';

class DailySumPage extends StatefulWidget {
  final DailySumState initialState;
  const DailySumPage({super.key, required this.initialState});

  @override
  State<DailySumPage> createState() => _DailySumPageState();
}

class _DailySumPageState extends State<DailySumPage> {
  late DailySumState state;

  @override
  void initState() {
    super.initState();
    state = widget.initialState;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Sum')),
      body: Center(
        child: Text('Target: ${state.target} / Sum: ${state.currentSum}'),
      ),
    );
  }
}
