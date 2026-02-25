import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/portfolio_item.dart';

class PortfolioState {
  final List<PortfolioItem> items;
  const PortfolioState({required this.items});

  double get sumWeight => items.fold<double>(0, (a, b) => a + b.weight);
}

class PortfolioController extends StateNotifier<PortfolioState> {
  PortfolioController() : super(const PortfolioState(items: []));

  void add() {
    state = PortfolioState(
      items: [...state.items, const PortfolioItem(symbol: '', weight: 0)],
    );
  }

  void removeAt(int index) {
    final next = [...state.items]..removeAt(index);
    state = PortfolioState(items: next);
  }

  void updateSymbol(int index, String symbol) {
    final next = [...state.items];
    next[index] = next[index].copyWith(symbol: symbol);
    state = PortfolioState(items: next);
  }

  void updateWeight(int index, double weight) {
    final next = [...state.items];
    next[index] = next[index].copyWith(weight: weight);
    state = PortfolioState(items: next);
  }

  void resetToDemo() {
    state = const PortfolioState(items: [
      PortfolioItem(symbol: 'SKHYNIX', weight: 55),
      PortfolioItem(symbol: 'SAMSUNG', weight: 25),
      PortfolioItem(symbol: 'CASH', weight: 20),
    ]);
  }
}

final portfolioProvider = StateNotifierProvider<PortfolioController, PortfolioState>(
  (ref) => PortfolioController(),
);
