class PortfolioItem {
  final String symbol;
  final double weight; // 0..100

  const PortfolioItem({required this.symbol, required this.weight});

  PortfolioItem copyWith({String? symbol, double? weight}) {
    return PortfolioItem(
      symbol: symbol ?? this.symbol,
      weight: weight ?? this.weight,
    );
  }
}
