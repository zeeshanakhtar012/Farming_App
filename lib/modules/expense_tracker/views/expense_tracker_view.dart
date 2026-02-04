import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/expense_tracker_controller.dart';
import '../models/expense_model.dart';

/// Expense Tracker View
/// Displays expenses and profit calculations
class ExpenseTrackerView extends StatelessWidget {
  const ExpenseTrackerView({super.key});

  @override
  Widget build(BuildContext context) {
    final ExpenseTrackerController controller =
        Get.find<ExpenseTrackerController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('expense_tracker'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.fetchExpenses(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.expenses.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // Summary Cards
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryCard(
                          title: 'total_cost'.tr,
                          amount: controller.getTotalCost(),
                          color: Colors.red,
                          icon: Icons.account_balance_wallet,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _SummaryCard(
                          title: 'estimated_profit'.tr,
                          amount: controller.getEstimatedProfit(),
                          color: controller.getEstimatedProfit() >= 0
                              ? Colors.green
                              : Colors.red,
                          icon: Icons.trending_up,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Estimated Revenue (Rs.)',
                      prefixIcon: const Icon(Icons.attach_money),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      controller.estimatedRevenue.value =
                          double.tryParse(value) ?? 0.0;
                    },
                  ),
                ],
              ),
            ),

            // Expense Types Breakdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Expense Breakdown',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      _ExpenseTypeRow(
                        type: 'seeds',
                        amount: controller.getCostByType('seeds'),
                        total: controller.getTotalCost(),
                      ),
                      _ExpenseTypeRow(
                        type: 'fertilizer',
                        amount: controller.getCostByType('fertilizer'),
                        total: controller.getTotalCost(),
                      ),
                      _ExpenseTypeRow(
                        type: 'labor',
                        amount: controller.getCostByType('labor'),
                        total: controller.getTotalCost(),
                      ),
                      _ExpenseTypeRow(
                        type: 'other',
                        amount: controller.getCostByType('other'),
                        total: controller.getTotalCost(),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Expenses List
            Expanded(
              child: controller.expenses.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No expenses recorded',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: controller.expenses.length,
                      itemBuilder: (context, index) {
                        final expense = controller.expenses[index];
                        return _ExpenseCard(
                          expense: expense,
                          onDelete: () =>
                              controller.deleteExpense(expense.expenseId),
                        );
                      },
                    ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddExpenseDialog(context, controller),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddExpenseDialog(
    BuildContext context,
    ExpenseTrackerController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => _AddExpenseDialog(controller: controller),
    );
  }
}

/// Summary Card Widget
class _SummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Rs. ${amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Expense Type Row Widget
class _ExpenseTypeRow extends StatelessWidget {
  final String type;
  final double amount;
  final double total;

  const _ExpenseTypeRow({
    required this.type,
    required this.amount,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = total > 0 ? (amount / total * 100) : 0.0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              type.capitalizeFirst ?? type,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            'Rs. ${amount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(width: 8),
          Text(
            '(${percentage.toStringAsFixed(1)}%)',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

/// Expense Card Widget
class _ExpenseCard extends StatelessWidget {
  final ExpenseModel expense;
  final VoidCallback onDelete;

  const _ExpenseCard({required this.expense, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: expense.getTypeColor(),
          child: Icon(expense.getTypeIcon(), color: Colors.white),
        ),
        title: Text(
          expense.description,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${expense.type}'),
            Text('Date: ${DateFormat('MMM dd, yyyy').format(expense.date)}'),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Rs. ${expense.amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Expense'),
                    content: const Text(
                      'Are you sure you want to delete this expense?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onDelete();
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Add Expense Dialog
class _AddExpenseDialog extends StatelessWidget {
  final ExpenseTrackerController controller;

  const _AddExpenseDialog({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Expense'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
              () => DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Expense Type'),
                value: controller.typeController.value,
                items: controller.expenseTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.capitalizeFirst ?? type),
                  );
                }).toList(),
                onChanged: (value) =>
                    controller.typeController.value = value ?? 'seeds',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Amount (Rs.)',
                prefixIcon: const Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => controller.amountController.value = value,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 2,
              onChanged: (value) =>
              controller.descriptionController.value = value,
            ),
            const SizedBox(height: 16),
            Obx(
              () => ListTile(
                title: Text('Date'),
                subtitle: Text(
                  DateFormat(
                    'MMM dd, yyyy',
                  ).format(controller.dateController.value),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: controller.dateController.value,
                    firstDate: DateTime.now().subtract(
                      const Duration(days: 365),
                    ),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    controller.dateController.value = date;
                  }
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('cancel'.tr),
        ),
        Obx(
          () => ElevatedButton(
            onPressed: controller.isLoading.value
                ? null
                : () async {
                    final success = await controller.addExpense();
                    if (success) {
                      Navigator.pop(context);
                      Get.snackbar('Success', 'Expense added successfully');
                    }
                  },
            child: controller.isLoading.value
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text('add'.tr),
          ),
        ),
      ],
    );
  }
}
