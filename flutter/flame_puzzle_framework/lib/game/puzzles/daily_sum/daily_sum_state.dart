class DailySumState {
  final int target;
  final List<int> cards;
  final Set<int> selectedIndexes;

  DailySumState({
    required this.target,
    required this.cards,
    Set<int>? selectedIndexes,
  }) : selectedIndexes = selectedIndexes ?? {};

  int get currentSum =>
      selectedIndexes.fold(0, (sum, idx) => sum + cards[idx]);

  bool get isSolved => currentSum == target;

  DailySumState toggle(int index) {
    final next = Set<int>.from(selectedIndexes);
    if (!next.add(index)) next.remove(index);
    return DailySumState(target: target, cards: cards, selectedIndexes: next);
  }

  DailySumState reset() => DailySumState(target: target, cards: cards);
}
