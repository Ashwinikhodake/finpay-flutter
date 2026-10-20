import 'package:finpay/features/dashboard/controllers/dashboard_controller.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';

void main() {
  late GetStorage testStorage;
  late DashboardController controller;
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel(
    'plugins.flutter.io/path_provider',
  );

  channel.setMockMethodCallHandler((MethodCall methodCall) async {
    return '.';
  });

  setUpAll(() async {
    await GetStorage.init('FinPayTest');
  });

  setUp(() {
    testStorage = GetStorage('FinPayTest');
    testStorage.erase();
    controller = DashboardController(storage: testStorage);
  });

  tearDown(() {
    controller.onClose();
    testStorage.erase();
  });

  group('DashboardController', () {
    test('calculates total income correctly', () {
      expect(controller.totalIncome, 25000.00);
    });
    test('calculates total expense correctly', () {
      expect(controller.totalExpenses, 2050.00);
    });
    test('addMoney saves the updated balance to storage', () async {
      controller.addMoney(500);

      await Future<void>.delayed(const Duration(microseconds: 100));

      expect(testStorage.read<double>('walletBalance'), 12950.00);
    });

    test(
      'restores the saved wallet balance when controller is recreated',
      () async {
        controller.addMoney(500);

        await Future<void>.delayed(const Duration(microseconds: 100));
        final newController = DashboardController(storage: testStorage);
        newController.onInit();
        expect(newController.walletBalance.value, 12950.00);
        newController.onClose();
      },
    );

    test(
      'restores saved tranaction history when controller is recreated',
      () async {
        controller.addExpense(250, title: 'Lunch', category: 'Food');

        await Future<void>.delayed(const Duration(microseconds: 100));
        final newController = DashboardController(storage: testStorage);
        newController.onInit();

        expect(newController.transactions.first.title, 'Lunch');
        expect(newController.transactions.first.category, 'Food');
        expect(newController.transactions.first.amount, -250.00);

        newController.onClose();
      },
    );

    test('initial wallet balance is 12450', () {
      expect(controller.walletBalance.value, 12450.00);
    });

    test('addMoney increases balance and records a transaction', () {
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

      final success = controller.addExpense(
        1000,
        title: 'Groceries',
        category: 'Food',
      );

      expect(success, isTrue);
      expect(controller.walletBalance.value, 11450.00);
      expect(controller.transactions.length, initialTransactionCount + 1);
      expect(controller.transactions.first.title, 'Groceries');
      expect(controller.transactions.first.category, 'Food');
      expect(controller.transactions.first.amount, -1000.00);
    });
    test('deleteTransaction refunds an expense and removes it', () {
      final success = controller.addExpense(
        500,
        title: 'Lunch',
        category: 'Food',
      );

      expect(success, isTrue);
      expect(controller.walletBalance.value, 11950.00);
      final expense = controller.transactions.first;
      final deleted = controller.deleteTransaction(expense);
      expect(deleted, isTrue);
      expect(controller.walletBalance.value, 12450.00);

      expect(
        controller.transactions.any(
          (transaction) => transaction.title == 'Lunch',
        ),
        isFalse,
      );
    });

    test('deleteTransaction deducts income and removes it', () {
      controller.addMoney(2000);
      expect(controller.walletBalance.value, 14450.00);

      final income = controller.transactions.first;
      final deleted = controller.deleteTransaction(income);
      expect(deleted, isTrue);

      expect(controller.walletBalance.value, 12450.00);

      expect(
        controller.transactions.any(
          (transaction) => transaction.title == 'Money Added',
        ),
        isFalse,
      );
    });

    test('delete Transaction stays deleted after ', () async {
      controller.addExpense(500, title: 'Lunch', category: 'Food');
      final expense = controller.transactions.first;
      controller.deleteTransaction(expense);

      await Future<void>.delayed(const Duration(milliseconds: 10));
      final newController = DashboardController(storage: testStorage);
      newController.onInit();

      expect(
        controller.transactions.any(
          (transaction) => transaction.title == 'Lunch',
        ),
        isFalse,
      );

      expect(controller.walletBalance.value, 12450.00);
      newController.onClose();
    });

    test('addExpense rejects an amount greater than balance', () {
      final initialBalance = controller.walletBalance.value;
      final initialTransactionCount = controller.transactions.length;

      final success = controller.addExpense(20000);

      expect(success, isFalse);
      expect(controller.walletBalance.value, initialBalance);
      expect(controller.transactions.length, initialTransactionCount);
    });

    test('deleteTransaction returns false if transaction is absent', () {
      final initialBalance = controller.walletBalance.value;
      final initialCount = controller.transactions.length;

      controller.addMoney(1000);

      final transaction = controller.transactions.first;
      controller.transactions.remove(transaction);

      final balanceBeforeDelete = controller.walletBalance.value;
      final countBeforeDelete = controller.transactions.length;

      final deleted = controller.deleteTransaction(transaction);

      expect(deleted, isFalse);
      expect(controller.walletBalance.value, balanceBeforeDelete);
      expect(controller.transactions.length, countBeforeDelete);

      // The initial balance was captured to make the setup explicit.
      expect(initialBalance, 12450.00);
      expect(initialCount, 3);
    });

    test('addExpense rejects zero and negative amounts', () {
      final initialBalance = controller.walletBalance.value;
      final initialTransactionCount = controller.transactions.length;

      expect(controller.addExpense(0), isFalse);
      expect(controller.addExpense(-500), isFalse);

      expect(controller.walletBalance.value, initialBalance);
      expect(controller.transactions.length, initialTransactionCount);
    });
  });
  test('editTransaction updates expense and adjusts wallet balance', () {
    controller.addExpense(500, title: 'Lunch', category: 'Food');
    final expense = controller.transactions.first;

    final success = controller.editTransaction(
      expense,
      title: 'Dinner',
      category: 'Food',
      amount: 800,
    );

    expect(success, isTrue);
    expect(controller.walletBalance.value, 11650.00);
    expect(controller.transactions.first.title, 'Dinner');
    expect(controller.transactions.first.category, 'Food');
    expect(controller.transactions.first.amount, -800.00);
  });

  test('editTransaction updates income and adjusts wallet balance', () {
    controller.addMoney(2000);
    final income = controller.transactions.first;

    final success = controller.editTransaction(
      income,
      title: 'Freelance Payment',
      category: 'Icome',
      amount: 1500,
    );

    expect(success, isTrue);
    expect(controller.walletBalance.value, 13950.00);
    expect(controller.transactions.first.title, 'Freelance Payment');
    expect(controller.transactions.first.category, 'Icome');
    expect(controller.transactions.first.amount, 1500.00);
    expect(controller.transactions.first.isIncome, isTrue);
  });

  test('editTransaction rejects invalid input without changing data', () {
    controller.addExpense(500, title: 'Lunch', category: 'Food');
    final expense = controller.transactions.first;
    final balanceBeforeEdit = controller.walletBalance.value;
    final titleBeforeEdit = expense.title;
    final amountBeforeEdit = expense.amount;

    expect(
      controller.editTransaction(
        expense,
        title: '',
        category: 'Food',
        amount: 800,
      ),
      isFalse,
    );
    expect(
      controller.editTransaction(
        expense,
        title: 'Lunch',
        category: 'Food',
        amount: -100,
      ),
      isFalse,
    );

    expect(controller.walletBalance.value, balanceBeforeEdit);
    expect(controller.transactions.first.title, titleBeforeEdit);
    expect(controller.transactions.first.amount, amountBeforeEdit);
  });

  test(
    'editTransaction rejects an expense that would make balance negative',
    () {
      controller.addExpense(500, title: 'Lunch', category: 'Food');
      final expense = controller.transactions.first;
      final balanceBeforeEdit = controller.walletBalance.value;

      final success = controller.editTransaction(
        expense,
        title: 'Expensive Purchase',
        category: 'Shopping',
        amount: 20000,
      );
      expect(success, isFalse);
      expect(controller.walletBalance.value, balanceBeforeEdit);
      expect(controller.transactions.first.title, 'Lunch');
      expect(controller.transactions.first.amount, -500.00);
    },
  );
  test('editTransaction rejects a transaction that no longer exists', () {
    controller.addExpense(500, title: 'Lunch', category: 'Food');
    final transaction = controller.transactions.first;
    final initialBalance = controller.walletBalance.value;

    controller.transactions.remove(transaction);

    final success = controller.editTransaction(
      transaction,
      title: 'Updated Transaction',
      category: 'Other',
      amount: 100,
    );
    expect(success, isFalse);
    expect(controller.walletBalance.value, initialBalance);
  });
}
