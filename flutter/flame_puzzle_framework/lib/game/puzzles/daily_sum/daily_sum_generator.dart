import 'dart:math';

class DailySumData {
  final int target;
  final List<int> cards;

  const DailySumData({required this.target, required this.cards});
}

class DailySumGenerator {
  static DailySumData generate({
    required DateTime date,
    int cardCount = 8,
    int minValue = 1,
    int maxValue = 12,
    int minSolutionSize = 2,
    int maxSolutionSize = 4,
  }) {
    final seed = _dateSeed(date);
    final rng = Random(seed);

    final solutionSize =
        minSolutionSize + rng.nextInt(maxSolutionSize - minSolutionSize + 1);

    // 1) 정답(솔루션) 숫자 먼저 만든다
    final solution = <int>[];
    for (int i = 0; i < solutionSize; i++) {
      solution.add(_randInt(rng, minValue, maxValue));
    }
    final target = solution.reduce((a, b) => a + b);

    // 2) 카드 목록에 솔루션을 넣고, 나머지는 방해꾼으로 채운다
    final cards = <int>[...solution];
    while (cards.length < cardCount) {
      final candidate = _randInt(rng, minValue, maxValue);

      // 너무 쉬워지는 걸 막기 위한 가드(초보용 최소치)
      // - target과 동일한 단일 숫자 방지
      // - 2개로 바로 target 되는 케이스 과다 방지(완벽하진 않아도 초반엔 충분)
      if (candidate == target) continue;

      cards.add(candidate);
    }

    // 3) 섞기
    cards.shuffle(rng);

    return DailySumData(target: target, cards: cards);
  }

  static int _randInt(Random rng, int min, int max) =>
      min + rng.nextInt(max - min + 1);

  static int _dateSeed(DateTime dt) {
    final y = dt.year;
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return int.parse('$y$m$d'); // e.g. 20251229
  }
}