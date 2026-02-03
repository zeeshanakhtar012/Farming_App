import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/services/firebase_service.dart';
import '../models/expense_model.dart';

/// Expense Tracker Controller
/// Manages expense tracking and profit calculations
class ExpenseTrackerController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();

  // Observable state
  final RxBool isLoading = false.obs;
  final RxList<ExpenseModel> expenses = <ExpenseModel>[].obs;
  final RxString errorMessage = ''.obs;

  // Form controllers
  final typeController = 'seeds'.obs;
  final amountController = ''.obs;
  final descriptionController = ''.obs;
  final dateController = DateTime.now().obs;

  // Expense types
  final List<String> expenseTypes = ['seeds', 'fertilizer', 'labor', 'other'];

  // Estimated revenue (for profit calculation)
  final RxDouble estimatedRevenue = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchExpenses();
  }

  /// Fetch expenses from Firestore
  Future<void> fetchExpenses() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final userId = _firebaseService.currentUser?.uid;
      if (userId == null) {
        errorMessage.value = 'User not logged in';
        isLoading.value = false;
        return;
      }

      // Try to fetch from Firestore
      try {
        final QuerySnapshot snapshot = await _firebaseService.firestore
            .collection('expenses')
            .where('userId', isEqualTo: userId)
            .orderBy('date', descending: true)
            .get();

        expenses.value = snapshot.docs.map((doc) {
          return ExpenseModel.fromFirestore(
            doc.data() as Map<String, dynamic>,
            doc.id,
          );
        }).toList();
      } catch (e) {
        // If Firestore fails, use empty list
        expenses.value = [];
      }

      isLoading.value = false;
    } catch (e) {
      errorMessage.value = 'Error fetching expenses: ${e.toString()}';
      isLoading.value = false;
    }
  }

  /// Add new expense
  Future<bool> addExpense() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Validate inputs
      if (amountController.value.isEmpty) {
        errorMessage.value = 'Please enter amount';
        isLoading.value = false;
        return false;
      }

      final amount = double.tryParse(amountController.value);
      if (amount == null || amount <= 0) {
        errorMessage.value = 'Please enter a valid amount';
        isLoading.value = false;
        return false;
      }

      if (descriptionController.value.isEmpty) {
        errorMessage.value = 'Please enter description';
        isLoading.value = false;
        return false;
      }

      final userId = _firebaseService.currentUser?.uid;
      if (userId == null) {
        errorMessage.value = 'User not logged in';
        isLoading.value = false;
        return false;
      }

      // Create expense model
      final expense = ExpenseModel(
        expenseId: '',
        userId: userId,
        type: typeController.value,
        amount: amount,
        description: descriptionController.value,
        date: dateController.value,
      );

      // Save to Firestore
      await _firebaseService.addDocument('expenses', expense.toFirestore());

      // Refresh expenses
      await fetchExpenses();

      // Clear form
      clearForm();

      isLoading.value = false;
      return true;
    } catch (e) {
      errorMessage.value = 'Error adding expense: ${e.toString()}';
      isLoading.value = false;
      return false;
    }
  }

  /// Delete expense
  Future<void> deleteExpense(String expenseId) async {
    try {
      isLoading.value = true;

      // Delete from Firestore
      await _firebaseService.deleteDocument('expenses', expenseId);

      // Refresh expenses
      await fetchExpenses();

      isLoading.value = false;
    } catch (e) {
      errorMessage.value = 'Error deleting expense: ${e.toString()}';
      isLoading.value = false;
    }
  }

  /// Calculate total cost
  double getTotalCost() {
    return expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  /// Calculate cost by type
  double getCostByType(String type) {
    return expenses
        .where((expense) => expense.type == type)
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }

  /// Calculate estimated profit
  double getEstimatedProfit() {
    return estimatedRevenue.value - getTotalCost();
  }

  /// Clear form
  void clearForm() {
    typeController.value = 'seeds';
    amountController.value = '';
    descriptionController.value = '';
    dateController.value = DateTime.now();
  }
}
