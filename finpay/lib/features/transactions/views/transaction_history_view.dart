import 'package:finpay/features/dashboard/controllers/dashboard_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionHistoryView extends GetView<DashboardController> {
  const TransactionHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final RxString selectedFilter = 'All'.obs;
    final RxString searchQuery = ''.obs;
    final RxString selectedSort = 'Newest'.obs;
    final RxString selectedDateFilter = 'All Time'.obs;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Transaction History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF5F7FA),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              onChanged: (value) {
                searchQuery.value = value.toLowerCase().trim();
              },
              decoration: InputDecoration(
                hintText: 'Search transactios...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(Icons.sort, size: 20),
                  const SizedBox(width: 8),
                  const Text('Sort by:'),
                  const SizedBox(width: 8),
                  DropdownButton<String>(
                    value: selectedSort.value,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(
                        value: 'Newest',
                        child: Text('Newest first'),
                      ),
                      DropdownMenuItem(
                        value: 'Oldest',
                        child: Text('Oldest first'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        selectedSort.value = value;
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Obx(
              () => Row(
                children: [
                  const Icon(Icons.calendar_month, size: 20),
                  const SizedBox(width: 8),
                  const Text('Date:'),
                  const SizedBox(width: 8),
                  DropdownButton<String>(
                    value: selectedDateFilter.value,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(
                        value: 'All Time',
                        child: Text('All Time'),
                      ),
                      DropdownMenuItem(value: 'Today', child: Text('Today')),
                      DropdownMenuItem(
                        value: 'This Week',
                        child: Text('This Week'),
                      ),
                      DropdownMenuItem(
                        value: 'This Month',
                        child: Text('This Month'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        selectedDateFilter.value = value;
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          Obx(
            () => Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Wrap(
                spacing: 8,
                children: ['All', 'Income', 'Expenses'].map((filter) {
                  return ChoiceChip(
                    label: Text(filter),
                    selected: selectedFilter.value == filter,
                    selectedColor: const Color(0xFF123C69),
                    labelStyle: TextStyle(
                      color: selectedFilter.value == filter
                          ? Colors.white
                          : Colors.black87,
                    ),
                    onSelected: (_) {
                      selectedFilter.value = filter;
                    },
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              final allTransactions = controller.transactions.toList();
              final query = searchQuery.value;
              final now = DateTime.now();
              final today = DateTime(now.year, now.month, now.day);
              final tomorrow = today.add(const Duration(days: 1));
              final startOfWeek = today.subtract(
                Duration(days: today.weekday - 1),
              );
              final startOfMonth = DateTime(now.year, now.month, 1);
              final filteredTransactions = allTransactions.where((transaction) {
                final transactionDate = transaction.date;

                final matchesDate = switch (selectedDateFilter.value) {
                  'Today' =>
                    !transactionDate.isBefore(today) &&
                        transactionDate.isBefore(tomorrow),
                  'This Week' =>
                    !transactionDate.isBefore(startOfWeek) &&
                        transactionDate.isBefore(tomorrow),
                  'This Month' =>
                    !transactionDate.isBefore(startOfMonth) &&
                        transactionDate.isBefore(tomorrow),

                  _ => true,
                };

                final matchesFilter = switch (selectedFilter.value) {
                  'Income' => transaction.isIncome,
                  'Expense' => !transaction.isIncome,
                  _ => true,
                };
                final matchesSearch =
                    transaction.title.toLowerCase().contains(query) ||
                    transaction.category.toLowerCase().contains(query);
                return matchesFilter && matchesSearch && matchesDate;
              }).toList();
              filteredTransactions.sort((a, b) {
                if (selectedSort.value == 'Newest') {
                  return b.date.compareTo(a.date);
                }
                return a.date.compareTo(b.date);
              });
              if (filteredTransactions.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.receipt_long_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        searchQuery.value.isNotEmpty
                            ? 'No matching transactions found'
                            : selectedFilter.value == 'All'
                            ? 'No transactions yet'
                            : 'No ${selectedFilter.value.toLowerCase()} found',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Your transaction will appear here.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),

                itemBuilder: (context, index) {
                  final transaction = filteredTransactions[index];
                  final isIncome = transaction.isIncome;

                  return Card(
                    elevation: 0,
                    color: Colors.white,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isIncome
                            ? Colors.green.shade50
                            : Colors.orange.shade50,
                        child: Icon(
                          isIncome ? Icons.south_west : Icons.north_east,
                          color: isIncome ? Colors.green : Colors.deepOrange,
                        ),
                      ),
                      title: Text(
                        transaction.title,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        '${transaction.category} ~ ${_formateDate(transaction.date)}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            transaction.formattedAmount,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isIncome ? Colors.green : Colors.red,
                            ),
                          ),

                          IconButton(
                            onPressed: () {
                              final titleController = TextEditingController(
                                text: transaction.title,
                              );
                              final amountController = TextEditingController(
                                text: transaction.amount.abs().toString(),
                              );
                              final categoryController = TextEditingController(
                                text: transaction.category,
                              );

                              Get.dialog(
                                AlertDialog(
                                  title: const Text('Edit Transaction'),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: titleController,
                                          decoration: const InputDecoration(
                                            labelText: 'Transaction Title',
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        TextField(
                                          controller: amountController,
                                          keyboardType:
                                              const TextInputType.numberWithOptions(
                                                decimal: true,
                                              ),
                                          decoration: const InputDecoration(
                                            labelText: 'Amount',
                                            prefixText: '₹ ',
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        DropdownButtonFormField<String>(
                                          initialValue:
                                              [
                                                'Food',
                                                'Shoping',
                                                'Utilities',
                                                'Transport',
                                                'Health',
                                                'Entertainment',
                                                'Other',
                                              ].contains(
                                                categoryController.text,
                                              )
                                              ? categoryController.text
                                              : 'Other',
                                          decoration: const InputDecoration(
                                            labelText: 'Category',
                                            border: OutlineInputBorder(),
                                          ),
                                          items:
                                              const [
                                                'Food',
                                                'Shoping',
                                                'Utilities',
                                                'Transport',
                                                'Health',
                                                'Entertainment',
                                                'Other',
                                              ].map((category) {
                                                return DropdownMenuItem<String>(
                                                  value: category,
                                                  child: Text(category),
                                                );
                                              }).toList(),
                                          onChanged: (value) {
                                            if (value != null) {
                                              categoryController.text = value;
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),

                                  actions: [
                                    TextButton(
                                      onPressed: () => Get.back(),
                                      child: const Text('Canel'),
                                    ),

                                    ElevatedButton(
                                      onPressed: () {
                                        final title = titleController.text
                                            .trim();
                                        final category = categoryController.text
                                            .trim();
                                        final amount = double.tryParse(
                                          amountController.text.trim(),
                                        );

                                        if (title.isEmpty ||
                                            category.isEmpty ||
                                            amount == null ||
                                            !amount.isFinite ||
                                            amount <= 0) {
                                          Get.snackbar(
                                            'Invalid input',
                                            'Enter a title, category, and valid positive amount.',
                                          );
                                          return;
                                        }

                                        final success = controller
                                            .editTransaction(
                                              transaction,
                                              title: title,
                                              category: category,
                                              amount: amount,
                                            );

                                        if (success) {
                                          Get.back();
                                          Get.snackbar(
                                            'Success',
                                            'Transaction updated successfully',
                                            snackPosition: SnackPosition.BOTTOM,
                                          );
                                        } else {
                                          Get.snackbar(
                                            'Update failed',
                                            'The wallet balance would become negative, or the transaction no longer exists.',
                                            snackPosition: SnackPosition.BOTTOM,
                                          );
                                        }
                                        // titleController.dispose();
                                        // amountController.dispose();
                                        // categoryController.dispose();
                                      },

                                      child: const Text('Save'),
                                    ),
                                  ],
                                ),
                              ).whenComplete(() {
                                titleController.dispose();
                                amountController.dispose();
                                categoryController.dispose();
                              });
                            },
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: Colors.blue,
                            ),
                            tooltip: 'Edit transaction',
                          ),
                          IconButton(
                            onPressed: () {
                              Get.dialog(
                                AlertDialog(
                                  title: const Text('Delete Transaction?'),
                                  content: Text(
                                    'Are you sure you want to delete "${transaction.title}"?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        controller.deleteTransaction(
                                          transaction,
                                        );
                                        Get.back();
                                        Get.snackbar(
                                          'Success',
                                          'Transaction deleted successfully',
                                        );
                                      },
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            tooltip: 'Delete transaction',
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemCount: filteredTransactions.length,
              );
            }),
          ),
        ],
      ),
    );
  }
}

String _formateDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  final day = date.day.toString().padLeft(2, '0');
  final month = months[date.month - 1];
  return '$day $month ${date.year}';
}
