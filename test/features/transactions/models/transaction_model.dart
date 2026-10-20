class TransactionModel {
  final String title;
  final String category;
  final double amount;
  final DateTime date;

  const TransactionModel({
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
  });

  bool get isIncome => amount > 0;
  String get formattedAmount {
    final sign = isIncome ? '+' : '-';
    return '$sign₹${amount.abs().toStringAsFixed(2)}';
  }
}
