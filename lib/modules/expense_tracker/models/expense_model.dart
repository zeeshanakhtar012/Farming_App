import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Expense Model
/// Represents farming expense data
class ExpenseModel {
  final String expenseId;
  final String userId;
  final String type; // seeds, fertilizer, labor, other
  final double amount;
  final String description;
  final DateTime date;

  ExpenseModel({
    required this.expenseId,
    required this.userId,
    required this.type,
    required this.amount,
    required this.description,
    required this.date,
  });

  /// Create ExpenseModel from Firestore
  factory ExpenseModel.fromFirestore(
    Map<String, dynamic> data,
    String expenseId,
  ) {
    return ExpenseModel(
      expenseId: expenseId,
      userId: data['userId'] ?? '',
      type: data['type'] ?? '',
      amount: (data['amount'] as num).toDouble(),
      description: data['description'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  /// Convert ExpenseModel to Map
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'type': type,
      'amount': amount,
      'description': description,
      'date': Timestamp.fromDate(date),
    };
  }

  /// Get expense type icon
  IconData getTypeIcon() {
    switch (type.toLowerCase()) {
      case 'seeds':
        return Icons.eco;
      case 'fertilizer':
        return Icons.science;
      case 'labor':
        return Icons.people;
      case 'other':
        return Icons.receipt;
      default:
        return Icons.attach_money;
    }
  }

  /// Get expense type color
  Color getTypeColor() {
    switch (type.toLowerCase()) {
      case 'seeds':
        return Colors.green;
      case 'fertilizer':
        return Colors.orange;
      case 'labor':
        return Colors.blue;
      case 'other':
        return Colors.grey;
      default:
        return Colors.purple;
    }
  }
}
