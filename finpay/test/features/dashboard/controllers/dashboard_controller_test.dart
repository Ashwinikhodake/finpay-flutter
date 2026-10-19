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

    test('addExpense rejects an amount greater than balance', () {
      final initialBalance = controller.walletBalance.value;
      final initialTransactionCount = controller.transactions.length;

      final success = controller.addExpense(20000);

      expect(success, isFalse);
      expect(controller.walletBalance.value, initialBalance);
      expect(controller.transactions.length, initialTransactionCount);
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
}
