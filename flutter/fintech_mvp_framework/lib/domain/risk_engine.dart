import '../models/portfolio_item.dart';

enum RiskLevel { safe, caution, danger }

class RiskResult {
  final int score; // 0..100
  final RiskLevel level;
  final String reason;

  const RiskResult({required this.score, required this.level, required this.reason});
}

/// MVP-grade risk scoring.
///
/// This is intentionally *rule-based* (no price APIs, no ML).
/// It exists to validate the product value: "warn me when I'm concentrated".
class RiskEngine {
  static RiskResult evaluate(List<PortfolioItem> items) {
    if (items.isEmpty) {
      return const RiskResult(
        score: 0,
        level: RiskLevel.safe,
        reason: 'No positions yet.',
      );
    }

    final normalized = _normalize(items);
    final weights = normalized.map((e) => e.weight).toList()..sort((a, b) => b.compareTo(a));

    final top1 = weights.first;
    final top3 = weights.take(3).fold<double>(0, (a, b) => a + b);
    final n = weights.length;

    int score = 10; // baseline
    String reason = 'Diversification looks okay.';

    if (top1 >= 60) {
      score += 55;
      reason = 'Top holding is above 60% (high concentration).';
    } else if (top1 >= 50) {
      score += 40;
      reason = 'Top holding is above 50% (concentrated).';
    } else if (top1 >= 35) {
      score += 25;
      reason = 'Top holding is above 35% (watch concentration).';
    }

    if (top3 >= 90) {
      score += 25;
      reason = 'Top 3 holdings exceed 90% (very concentrated).';
    } else if (top3 >= 80) {
      score += 15;
      reason = 'Top 3 holdings exceed 80% (concentrated).';
    }

    if (n <= 2) {
      score += 20;
      reason = 'Only 1–2 positions (single-theme risk).';
    } else if (n <= 4) {
      score += 10;
      // keep existing reason if already strong
      reason = reason == 'Diversification looks okay.' ? 'Only 3–4 positions (limited diversification).' : reason;
    }

    score = score.clamp(0, 100);

    final level = score >= 70
        ? RiskLevel.danger
        : (score >= 40 ? RiskLevel.caution : RiskLevel.safe);

    return RiskResult(score: score, level: level, reason: reason);
  }

  static List<PortfolioItem> _normalize(List<PortfolioItem> items) {
    final sum = items.fold<double>(0, (a, b) => a + b.weight);
    if (sum <= 0) return items;
    return items
        .map((e) => e.copyWith(weight: (e.weight / sum) * 100))
        .toList(growable: false);
  }
}
