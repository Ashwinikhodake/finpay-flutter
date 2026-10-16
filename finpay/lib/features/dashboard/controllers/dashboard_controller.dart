import 'package:get/state_manager.dart';

class DashboardController extends GetxController {
  final walletBalance = 12450.00.obs;

  final transactions = <Map<String, dynamic>>[
    {'title': 'Grocery Store', 'category': 'Shopping', 'amount': -850.00},
    {'title': 'Salary Credit', 'category': 'Income', 'amount': 25000.00},
    {'title': 'Electricity Bill', 'category': 'Utilities', 'amount': -1200.00},
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
    return true;
  }
}
