import 'package:finpay/features/transactions/models/transaction_model.dart';
import 'package:get/state_manager.dart';

class DashboardController extends GetxController {
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

  void addMoney(double amount) {
    if (amount < 0) return;
    walletBalance.value += amount;
  }

  bool addExpense(double amount) {
    if (amount <= 0 || amount > walletBalance.value) {
      return false;
    }
    walletBalance.value -= amount;
    transactions.insert(
      0,
      TransactionModel(
        title: 'Expense',
        category: 'Other',
        amount: -amount,
        date: DateTime.now(),
      ),
    );
    return true;
  }
}
