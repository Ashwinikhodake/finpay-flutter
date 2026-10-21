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
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF123C69), Color(0xFF1D5288)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF123C69).withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      color: Colors.white70,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Wallet Balance',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Obx(
                  () => FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '₹${controller.walletBalance.value.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.shield_outlined,
                        color: Colors.white70,
                        size: 17,
                      ),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Demo balance. No real money',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Row(
          //   children: [
          //     Expanded(
          //       child: Obx(
          //         () => _summaryCard(
          //           title: 'Total Income',
          //           amount: controller.totalIncome,
          //           icon: Icons.trending_up,
          //           color: Colors.green,
          //         ),
          //       ),
          //     ),
          //     const SizedBox(width: 12),
          //     Expanded(
          //       child: Obx(
          //         () => _summaryCard(
          //           title: 'Total Expenses',
          //           amount: controller.totalExpenses,
          //           icon: Icons.trending_down,
          //           color: Colors.orange,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 600;

              final incomeCard = Obx(
                () => _summaryCard(
                  title: 'Total Income',
                  amount: controller.totalIncome,
                  icon: Icons.trending_up,
                  color: Colors.green,
                ),
              );
              final expenseCard = Obx(
                () => _summaryCard(
                  title: 'Total Expenses',
                  amount: controller.totalExpenses,
                  icon: Icons.trending_down,
                  color: Colors.orange,
                ),
              );

              if (isMobile) {
                return Column(
                  children: [
                    incomeCard,
                    const SizedBox(height: 12),
                    expenseCard,
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(child: incomeCard),
                  const SizedBox(width: 12),
                  Expanded(child: expenseCard),
                ],
              );
            },
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
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE8EDF3)),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.pie_chart_outline,
                      color: Color(0xFF64748B),
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'No expenses yet.',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Your spending breakdown will appear here.',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
              // return const Card(
              //   elevation: 0,
              //   child: Padding(
              //     padding: EdgeInsets.all(20),
              //     child: Text('No Expenses recorded yet.'),
              //   ),
              // );
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

          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 600;

              final actions = [
                _actionButton(
                  icon: Icons.money,
                  label: 'Add Expense',
                  onTap: () => _showExpenseDialog(),
                ),

                _actionButton(
                  icon: Icons.qr_code_scanner,
                  label: 'Scan & Pay',
                  onTap: () {},
                ),

                _actionButton(
                  icon: Icons.add_circle_outline,
                  label: 'Add Money',
                  onTap: () => _showAddMoneyDialog(),
                ),

                _actionButton(
                  icon: Icons.receipt_long,
                  label: 'History',
                  onTap: () {
                    Get.to(() => const TransactionHistoryView());
                  },
                ),
              ];
              if (isMobile) {
                return GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.0,
                  children: actions
                      .map((action) => SizedBox(child: action))
                      .toList(),
                );
              }
              return Row(
                children: [
                  for (int i = 0; i < actions.length; i++) ...[
                    if (i > 0) const SizedBox(width: 12),
                    Expanded(child: actions[i]),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: 28),
          const Text(
            'Recent Transactions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Obx(
          //   () => Column(
          //     children: controller.transactions.map((transaciton) {
          //       final amount = transaciton.amount;
          //       final isCredit = amount > 0;
          //       return Card(
          //         elevation: 0,
          //         color: Colors.white,
          //         margin: const EdgeInsets.only(bottom: 10),
          //         child: ListTile(
          //           leading: CircleAvatar(
          //             backgroundColor: isCredit
          //                 ? Colors.green.shade50
          //                 : Colors.orange.shade50,
          //             child: Icon(
          //               isCredit ? Icons.arrow_downward : Icons.arrow_upward,
          //               color: isCredit ? Colors.green : Colors.orange,
          //             ),
          //           ),
          //           title: Text(transaciton.title),
          //           subtitle: Text(transaciton.category),
          //           trailing: Text(
          //             '${isCredit ? '+' : '-'}₹${amount.abs().toStringAsFixed(2)}',
          //             style: TextStyle(
          //               fontWeight: FontWeight.bold,
          //               color: isCredit ? Colors.green : Colors.black87,
          //             ),
          //           ),
          //         ),
          //       );
          //     }).toList(),
          //   ),
          // ),
          Obx(() {
            if (controller.transactions.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE8EDF3)),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      color: Color(0xFF64748B),
                      size: 24,
                    ),
                    SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        'Your recent transactions will appear here.',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Column(
              children: controller.transactions.take(3).map((transaction) {
                final amount = transaction.amount;
                final isCredit = amount > 0;
                final color = isCredit
                    ? const Color(0xFF269B45)
                    : const Color(0xFFF28C00);
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE8EDF3)),
                  ),

                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Icon(
                          isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                          color: color,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              transaction.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              transaction.category,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${isCredit ? '+' : '-'}₹${amount.abs().toStringAsFixed(2)}',
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          }),
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
  return Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 88,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: const Color(0xFF123C69), size: 24),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
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
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFFE8EDF3)),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(14),
          ),

          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  '₹${amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
