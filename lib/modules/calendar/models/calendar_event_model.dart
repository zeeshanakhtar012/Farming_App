import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Calendar Event Model
/// Represents farming calendar events
class CalendarEventModel {
  final String eventId;
  final String userId;
  final String title;
  final String type; // sowing, fertilizing, irrigation, harvesting
  final DateTime date;
  final String? cropName;
  final bool reminderEnabled;
  final String? description;
  final int? reminderId; // For notification cancellation

  CalendarEventModel({
    required this.eventId,
    required this.userId,
    required this.title,
    required this.type,
    required this.date,
    this.cropName,
    this.reminderEnabled = true,
    this.description,
    this.reminderId,
  });

  /// Create CalendarEventModel from Firestore
  factory CalendarEventModel.fromFirestore(
    Map<String, dynamic> data,
    String eventId,
  ) {
    return CalendarEventModel(
      eventId: eventId,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      type: data['type'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      cropName: data['cropName'],
      reminderEnabled: data['reminderEnabled'] ?? true,
      description: data['description'],
      reminderId: data['reminderId'],
    );
  }

  /// Convert CalendarEventModel to Map
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'type': type,
      'date': Timestamp.fromDate(date),
      if (cropName != null) 'cropName': cropName,
      'reminderEnabled': reminderEnabled,
      if (description != null) 'description': description,
      if (reminderId != null) 'reminderId': reminderId,
    };
  }

  /// Get event type icon
  IconData getTypeIcon() {
    switch (type.toLowerCase()) {
      case 'sowing':
        return Icons.agriculture;
      case 'fertilizing':
        return Icons.science;
      case 'irrigation':
        return Icons.water_drop;
      case 'harvesting':
        return Icons.eco;
      default:
        return Icons.event;
    }
  }

  /// Get event type color
  Color getTypeColor() {
    switch (type.toLowerCase()) {
      case 'sowing':
        return Colors.green;
      case 'fertilizing':
        return Colors.orange;
      case 'irrigation':
        return Colors.blue;
      case 'harvesting':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }
}
