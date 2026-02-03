import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/calendar_controller.dart';
import '../models/calendar_event_model.dart';

/// Calendar View
/// Displays farming calendar with events and allows adding new events
class CalendarView extends StatelessWidget {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    final CalendarController controller = Get.find<CalendarController>();

    return Scaffold(
      appBar: AppBar(title: Text('farming_calendar'.tr)),
      body: Column(
        children: [
          // Calendar Widget
          Obx(
            () => _CalendarWidget(
              selectedDate: controller.selectedDate.value,
              events: controller.events,
              onDateSelected: (date) => controller.setSelectedDate(date),
            ),
          ),

          // Events List for Selected Date
          Expanded(
            child: Obx(() {
              final selectedEvents = controller.getEventsForDate(
                controller.selectedDate.value,
              );

              if (selectedEvents.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.event_busy,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No events for this date',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: selectedEvents.length,
                itemBuilder: (context, index) {
                  final event = selectedEvents[index];
                  return _EventCard(
                    event: event,
                    onDelete: () =>
                        controller.deleteEvent(event.eventId, event.reminderId),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEventDialog(context, controller),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddEventDialog(
    BuildContext context,
    CalendarController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => _AddEventDialog(controller: controller),
    );
  }
}

/// Calendar Widget
class _CalendarWidget extends StatelessWidget {
  final DateTime selectedDate;
  final List<CalendarEventModel> events;
  final Function(DateTime) onDateSelected;

  const _CalendarWidget({
    required this.selectedDate,
    required this.events,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Month/Year Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    final prevMonth = DateTime(
                      selectedDate.year,
                      selectedDate.month - 1,
                    );
                    onDateSelected(prevMonth);
                  },
                ),
                Text(
                  DateFormat('MMMM yyyy').format(selectedDate),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    final nextMonth = DateTime(
                      selectedDate.year,
                      selectedDate.month + 1,
                    );
                    onDateSelected(nextMonth);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Simple Calendar Grid
            _buildCalendarGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid(BuildContext context) {
    final firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    final lastDayOfMonth = DateTime(
      selectedDate.year,
      selectedDate.month + 1,
      0,
    );
    final daysInMonth = lastDayOfMonth.day;
    final startingWeekday = firstDayOfMonth.weekday;

    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Column(
      children: [
        // Weekday headers
        Row(
          children: weekdays
              .map(
                (day) => Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),

        // Calendar days
        ...List.generate(6, (weekIndex) {
          return Row(
            children: List.generate(7, (dayIndex) {
              final dayNumber = weekIndex * 7 + dayIndex - startingWeekday + 2;

              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const Expanded(child: SizedBox());
              }

              final date = DateTime(
                selectedDate.year,
                selectedDate.month,
                dayNumber,
              );
              final hasEvents = events.any(
                (e) =>
                    e.date.year == date.year &&
                    e.date.month == date.month &&
                    e.date.day == date.day,
              );
              final isSelected =
                  date.year == selectedDate.year &&
                  date.month == selectedDate.month &&
                  date.day == selectedDate.day;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onDateSelected(date),
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            dayNumber.toString(),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          if (hasEvents)
                            Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.orange,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ],
    );
  }
}

/// Event Card Widget
class _EventCard extends StatelessWidget {
  final CalendarEventModel event;
  final VoidCallback onDelete;

  const _EventCard({required this.event, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: event.getTypeColor(),
          child: Icon(event.getTypeIcon(), color: Colors.white),
        ),
        title: Text(
          event.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${event.type}'),
            if (event.cropName != null) Text('Crop: ${event.cropName}'),
            Text(
              'Time: ${DateFormat('MMM dd, yyyy HH:mm').format(event.date)}',
            ),
            if (event.description != null) Text(event.description!),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete Event'),
                content: const Text(
                  'Are you sure you want to delete this event?',
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
      ),
    );
  }
}

/// Add Event Dialog
class _AddEventDialog extends StatelessWidget {
  final CalendarController controller;

  const _AddEventDialog({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('add_event'.tr),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
              () => TextField(
                decoration: InputDecoration(labelText: 'event_title'.tr),
                onChanged: (value) => controller.titleController.value = value,
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Event Type'),
                value: controller.typeController.value,
                items: controller.eventTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.capitalizeFirst ?? type),
                  );
                }).toList(),
                onChanged: (value) =>
                    controller.typeController.value = value ?? 'sowing',
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => ListTile(
                title: Text('event_date'.tr),
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
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                        controller.dateController.value,
                      ),
                    );
                    if (time != null) {
                      controller.dateController.value = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        time.hour,
                        time.minute,
                      );
                    }
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => TextField(
                decoration: InputDecoration(labelText: 'Crop Name (Optional)'),
                onChanged: (value) =>
                    controller.cropNameController.value = value,
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => TextField(
                decoration: InputDecoration(
                  labelText: 'Description (Optional)',
                ),
                maxLines: 3,
                onChanged: (value) =>
                    controller.descriptionController.value = value,
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => CheckboxListTile(
                title: const Text('Enable Reminder'),
                value: controller.reminderEnabled.value,
                onChanged: (value) =>
                    controller.reminderEnabled.value = value ?? true,
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
                    final success = await controller.addEvent();
                    if (success) {
                      Navigator.pop(context);
                      Get.snackbar('Success', 'Event added successfully');
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
