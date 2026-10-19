import 'package:finpay/features/dashboard/controllers/dashboard_controller.dart';
import 'package:finpay/features/transactions/views/transaction_history_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'FinPay',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF5F7FA),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Welcome back!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Here is your wallet overview.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF123C69),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Demo Wallet Balance',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 12),
                Obx(
                  () => Text(
                    '₹${controller.walletBalance.value.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Icon(Icons.shield_outlined, color: Colors.white70),
                    SizedBox(width: 8),
                    Text(
                      'Demo balance . No real Money',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => _summaryCard(
                    title: 'Total Income',
                    amount: controller.totalIncome,
                    icon: Icons.trending_up,
                    color: Colors.green,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(
                  () => _summaryCard(
                    title: 'Total Expenses',
                    amount: controller.totalExpenses,
                    icon: Icons.trending_down,
                    color: Colors.orange,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),
          const Text(
            'Spending by Category',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Obx(() {
            final categoryTotals = controller.expensesByCategory;
            final total = controller.totalExpenses;

            if (categoryTotals.isEmpty) {
              return const Card(
                elevation: 0,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('No Expenses recorded yet.'),
                ),
              );
            }
            return Card(
              elevation: 0,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: categoryTotals.entries.map((entry) {
                    final percentage = total > 0 ? entry.value / total : 0.0;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  entry.key,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Text(
                                '₹${entry.value.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: percentage.clamp(0.0, 1.0),
                              minHeight: 8,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF123C69),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          }),
          const SizedBox(height: 28),
          const Text(
            'Quick Actions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _actionButton(
                icon: Icons.money,
                label: 'Add Expense',
                onTap: () => _showExpenseDialog(),
              ),
              const SizedBox(width: 12),

              _actionButton(
                icon: Icons.qr_code_scanner,
                label: 'Scan & Pay',
                onTap: () {},
              ),
              const SizedBox(width: 12),
              _actionButton(
                icon: Icons.add_circle_outline,
                label: 'Add Money',
                onTap: () => _showAddMoneyDialog(),
              ),
              const SizedBox(width: 12),
              _actionButton(
                icon: Icons.receipt_long,
                label: 'History',
                onTap: () {
                  Get.to(() => const TransactionHistoryView());
                },
              ),
            ],
          ),
          const SizedBox(height: 28),
          const Text(
            'Recent Transactions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          Obx(
            () => Column(
              children: controller.transactions.map((transaciton) {
                final amount = transaciton.amount;
                final isCredit = amount > 0;
                return Card(
                  elevation: 0,
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isCredit
                          ? Colors.green.shade50
                          : Colors.orange.shade50,
                      child: Icon(
                        isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                        color: isCredit ? Colors.green : Colors.orange,
                      ),
                    ),
                    title: Text(transaciton.title),
                    subtitle: Text(transaciton.category),
                    trailing: Text(
                      '${isCredit ? '+' : '-'}₹${amount.abs().toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isCredit ? Colors.green : Colors.black87,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddMoneyDialog() {
    final amountController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text('Add Demo Money'),
        content: TextField(
          controller: amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Amount',
            prefixText: '₹',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(amountController.text.trim());
              if (amount == null || amount <= 0) {
                Get.snackbar(
                  'Invalid amount',
                  'Enter an amount greater than zero.',
                );
                return;
              }
              controller.addMoney(amount);
              // amountController.dispose();
              Get.back();

              Get.snackbar('Success', 'Demo Wallet balance updated.');
            },
            child: const Text('Add Money'),
          ),
        ],
      ),
    ).whenComplete(amountController.dispose);
  }

  void _showExpenseDialog() {
    final titleController = TextEditingController();
    final amountController = TextEditingController();

    final categories = [
      'Food',
      'Shopping',
      'Transport',
      'Bills',
      'Health',
      'Other',
    ];
    String selectedCategory = 'Other';
    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Add Expense"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Expense title',
                      hintText: 'e.g. Lunch, Grocery shopping',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      prefixText: '₹',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedCategory = value;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: Get.back, child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  final title = titleController.text.trim();
                  final amount = double.tryParse(amountController.text.trim());

                  if (title.isEmpty) {
                    Get.snackbar(
                      'Missing title',
                      'Please enter an expense title.',
                    );
                    return;
                  }
                  if (amount == null || amount <= 0) {
                    Get.snackbar(
                      'Invalid amount',
                      'Please enter an amount greater than zero.',
                    );
                    return;
                  }
                  final success = controller.addExpense(
                    amount,
                    title: title,
                    category: selectedCategory,
                  );

                  if (success) {
                    Get.back();
                    Get.snackbar(
                      'Expense recorded',
                      'Your wallet balance has been updated.',
                    );
                  } else {
                    Get.snackbar(
                      'Insufficient balance',
                      'Your expense exceeds your availabe balance.',
                    );
                  }
                },
                child: const Text('Confirm'),
              ),
            ],
          );
        },
      ),
    ).whenComplete(() {
      titleController.dispose();
      amountController.dispose();
    });
  }
}

Widget _actionButton({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return Expanded(
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF123C69), size: 26),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _summaryCard({
  required String title,
  required double amount,
  required IconData icon,
  required Color color,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 26),
        const SizedBox(height: 12),
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 6),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            '₹${amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}
