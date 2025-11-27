class Investment {
  const Investment({
    required this.symbol,
    required this.name,
    required this.pricePerUnit,
    required this.unitsOwned,
  });

  final String symbol;
  final String name;
  final double pricePerUnit;
  final double unitsOwned;

  double get marketValue => pricePerUnit * unitsOwned;
}

