import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/services/notification_service.dart';
import '../models/calendar_event_model.dart';

/// Calendar Controller
/// Manages farming calendar events and notifications
class CalendarController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  final NotificationService _notificationService = NotificationService();

  // Observable state
  final RxBool isLoading = false.obs;
  final RxList<CalendarEventModel> events = <CalendarEventModel>[].obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxString errorMessage = ''.obs;

  // Form controllers
  final titleController = ''.obs;
  final typeController = 'sowing'.obs;
  final dateController = DateTime.now().obs;
  final cropNameController = ''.obs;
  final descriptionController = ''.obs;
  final reminderEnabled = true.obs;

  // Event types
  final List<String> eventTypes = [
    'sowing',
    'fertilizing',
    'irrigation',
    'harvesting',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  /// Fetch events from Firestore
  Future<void> fetchEvents() async {
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
            .collection('calendar_events')
            .where('userId', isEqualTo: userId)
            .orderBy('date')
            .get();

        events.value = snapshot.docs.map((doc) {
          return CalendarEventModel.fromFirestore(
            doc.data() as Map<String, dynamic>,
            doc.id,
          );
        }).toList();
      } catch (e) {
        // If Firestore fails, use empty list
        events.value = [];
      }

      isLoading.value = false;
    } catch (e) {
      errorMessage.value = 'Error fetching events: ${e.toString()}';
      isLoading.value = false;
    }
  }

  /// Get events for a specific date
  List<CalendarEventModel> getEventsForDate(DateTime date) {
    return events.where((event) {
      return event.date.year == date.year &&
          event.date.month == date.month &&
          event.date.day == date.day;
    }).toList();
  }

  /// Add new event
  Future<bool> addEvent() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Validate inputs
      if (titleController.value.isEmpty) {
        errorMessage.value = 'Please enter event title';
        isLoading.value = false;
        return false;
      }

      final userId = _firebaseService.currentUser?.uid;
      if (userId == null) {
        errorMessage.value = 'User not logged in';
        isLoading.value = false;
        return false;
      }

      // Generate reminder ID
      final reminderId = DateTime.now().millisecondsSinceEpoch;

      // Create event model
      final event = CalendarEventModel(
        eventId: '',
        userId: userId,
        title: titleController.value,
        type: typeController.value,
        date: dateController.value,
        cropName: cropNameController.value.isEmpty
            ? null
            : cropNameController.value,
        reminderEnabled: reminderEnabled.value,
        description: descriptionController.value.isEmpty
            ? null
            : descriptionController.value,
        reminderId: reminderId,
      );

      // Save to Firestore
      final docRef = await _firebaseService.firestore
          .collection('calendar_events')
          .add(event.toFirestore());

      // Schedule notification if enabled
      if (reminderEnabled.value) {
        await _notificationService.scheduleNotification(
          id: reminderId,
          title: 'Farming Reminder: ${event.title}',
          body: event.description ?? 'Don\'t forget your farming task!',
          scheduledDate: event.date.subtract(
            const Duration(hours: 24),
          ), // Remind 24 hours before
          payload: docRef.id,
        );
      }

      // Refresh events
      await fetchEvents();

      // Clear form
      clearForm();

      isLoading.value = false;
      return true;
    } catch (e) {
      errorMessage.value = 'Error adding event: ${e.toString()}';
      isLoading.value = false;
      return false;
    }
  }

  /// Delete event
  Future<void> deleteEvent(String eventId, int? reminderId) async {
    try {
      isLoading.value = true;

      // Cancel notification if exists
      if (reminderId != null) {
        await _notificationService.cancelNotification(reminderId);
      }

      // Delete from Firestore
      await _firebaseService.deleteDocument('calendar_events', eventId);

      // Refresh events
      await fetchEvents();

      isLoading.value = false;
    } catch (e) {
      errorMessage.value = 'Error deleting event: ${e.toString()}';
      isLoading.value = false;
    }
  }

  /// Clear form
  void clearForm() {
    titleController.value = '';
    typeController.value = 'sowing';
    dateController.value = DateTime.now();
    cropNameController.value = '';
    descriptionController.value = '';
    reminderEnabled.value = true;
  }

  /// Set selected date
  void setSelectedDate(DateTime date) {
    selectedDate.value = date;
  }
}
