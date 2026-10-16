import 'package:finpay/features/dashboard/controllers/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionHistoryView extends GetView<DashboardController> {
  const TransactionHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Transaction History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF5F7FA),
      ),
      body: Obx(() {
        final transactions = controller.transactions;
        if (transactions.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 12),
                Text(
                  'No Transaction yet',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 6),
                Text(
                  'Your transaction will appear here.',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            final transaction = transactions[index];
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
                    isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                  ),
                ),
                title: Text(
                  transaction.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  '${transaction.category} ~ ${_formateDate(transaction.date)}',
                ),
                trailing: Text(
                  transaction.formattedAmount,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isIncome ? Colors.green : Colors.red,
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemCount: transactions.length,
        );
      }),
    );
  }
}

String _formateDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}
