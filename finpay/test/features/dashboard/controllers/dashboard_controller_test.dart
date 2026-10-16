import 'package:finpay/features/dashboard/controllers/dashboard_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DashboardController', () {
    late DashboardController controller;

    setUp(() {
      controller = DashboardController();
    });
    test('initial wallet balance is 12450', () {
      expect(controller.walletBalance.value, 12450.00);
    });
    test('AddMoney increases the wallet balance', () {
      final initialTransactionCount = controller.transactions.length;
      controller.addMoney(500);
      expect(controller.walletBalance.value, 12950.00);
      expect(controller.transactions.length, initialTransactionCount + 1);
      expect(controller.transactions.first.title, 'Money Added');
      expect(controller.transactions.first.category, 'Income');
      expect(controller.transactions.first.amount, 500.00);
      expect(controller.transactions.first.isIncome, isTrue);
    });

    test('addExpense deducts balance and records a transaction', () {
      final initialTransactionCount = controller.transactions.length;

      final success = controller.addExpense(1000);

      expect(success, isTrue);
      expect(controller.walletBalance.value, 11450.00);
      expect(controller.transactions.length, initialTransactionCount + 1);
      expect(controller.transactions.first.title, 'Expense');
      expect(controller.transactions.first.amount, -1000.00);
    });

    test('addExpense rejects an amount greater than balance', () {
      final initialBalance = controller.walletBalance.value;
      final initialTransactionCount = controller.transactions.length;

      final success = controller.addExpense(20000);
      expect(success, isFalse);
      expect(controller.walletBalance.value, initialBalance);
      expect(controller.transactions.length, initialTransactionCount);
    });

    test('addExpense rejects zero and nagative amounts', () {
      final initialBalance = controller.walletBalance.value;
      final initialTransactionCount = controller.transactions.length;

      expect(controller.addExpense(0), isFalse);
      expect(controller.addExpense(-500), isFalse);

      expect(controller.walletBalance.value, initialBalance);
      expect(controller.transactions.length, initialTransactionCount);
    });
  });
}
