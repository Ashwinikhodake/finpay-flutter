import 'package:finpay/features/transactions/models/transaction_model.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';

class DashboardController extends GetxController {
  final GetStorage _storage;
  DashboardController({GetStorage? storage})
    : _storage = storage ?? GetStorage();
  @override
  void onInit() {
    super.onInit();
    _loadSaveData();
  }

  final walletBalance = 12450.00.obs;

  final transactions = <TransactionModel>[
    TransactionModel(
      title: 'Grocery Store',
      category: 'Shopping',
      amount: -850.00,
      date: DateTime.now(),
    ),
    TransactionModel(
      title: 'Salary Credit',
      category: 'Income',
      amount: 25000.00,
      date: DateTime.now(),
    ),
    TransactionModel(
      title: 'Electricity Bill',
      category: 'Utilities',
      amount: -1200.00,
      date: DateTime.now(),
    ),
  ].obs;

  double get totalIncome => transactions
      .where((transaction) => transaction.amount > 0)
      .fold(0.0, (total, transaction) => total + transaction.amount);

  double get totalExpenses => transactions
      .where((transaction) => transaction.amount < 0)
      .fold(0.0, (total, transation) => total + transation.amount.abs());

  bool addExpense(
    double amount, {
    String title = 'Expense',
    String category = 'Other',
  }) {
    if (amount <= 0 || amount > walletBalance.value) {
      return false;
    }
    walletBalance.value -= amount;
    transactions.insert(
      0,
      TransactionModel(
        title: title,
        category: category,
        amount: -amount,
        date: DateTime.now(),
      ),
    );
    _saveData();
    return true;
  }

  void addMoney(double amount) {
    if (amount <= 0) return;
    walletBalance.value += amount;
    transactions.insert(
      0,
      TransactionModel(
        title: 'Money Added',
        category: 'Income',
        amount: amount,
        date: DateTime.now(),
      ),
    );
    _saveData();
  }

  void _loadSaveData() {
    final savedBalance = _storage.read<double>('walletBalance');
    final savedTransactions = _storage.read<List>('transactions');
    if (savedBalance != null) {
      walletBalance.value = savedBalance;
    }
    if (savedTransactions != null) {
      transactions.assignAll(
        savedTransactions.map(
          (item) => TransactionModel(
            title: item['title'] as String,
            category: item['category'] as String,
            amount: (item['amount'] as num).toDouble(),
            date: DateTime.parse(item['date'] as String),
          ),
        ),
      );
    }
  }

  void _saveData() {
    _storage.write('walletBalance', walletBalance.value);

    final savedTransactions = transactions.map((transaction) {
      return {
        'title': transaction.title,
        'category': transaction.category,
        'amount': transaction.amount,
        'date': transaction.date.toIso8601String(),
      };
    }).toList();

    _storage.write('transactions', savedTransactions);
  }

  Map<String, double> get expensesByCategory {
    final Map<String, double> totals = {};
    for (final transaction in transactions) {
      if (transaction.amount < 0) {
        totals.update(
          transaction.category,
          (current) => current + transaction.amount.abs(),
          ifAbsent: () => transaction.amount.abs(),
        );
      }
    }
    return totals;
  }

  bool deleteTransaction(TransactionModel transaction) {
    final exists = transactions.contains(transaction);

    if (!exists) return false;
    if (transaction.amount > 0) {
      walletBalance.value -= transaction.amount;
    } else {
      walletBalance.value += transaction.amount.abs();
    }
    transactions.remove(transaction);
    _saveData();
    return true;
  }

  bool editTransaction(
    TransactionModel transaction, {
    required String title,
    required String category,
    required double amount,
  }) {
    if (title.trim().isEmpty || category.trim().isEmpty || amount <= 0) {
      return false;
    }
    final index = transactions.indexOf(transaction);
    if (index == -1) return false;

    final oldAmount = transaction.amount;
    final newAmount = oldAmount > 0 ? amount : -amount;

    final adjustedBalance = walletBalance.value - oldAmount + newAmount;

    if (adjustedBalance < 0) return false;

    walletBalance.value = adjustedBalance;

    transactions[index] = TransactionModel(
      title: title.trim(),
      category: category.trim(),
      amount: newAmount,
      date: transaction.date,
    );

    _saveData();
    return true;
  }
}
