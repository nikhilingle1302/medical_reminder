
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../data/models/api_models.dart';
import '../../data/repo/medical_repo.dart';


class CalendarController extends GetxController {
  final MedicalRepository _repository = MedicalRepository();
  
  final selectedDate = DateTime.now().obs;
  final currentMonth = DateTime.now().obs;
  final reminders = <Reminder>[].obs;
  final isLoading = false.obs;
  final appointments = <Appointment>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRemindersForMonth();
    loadAppointments();
  }

  Future<void> fetchRemindersForMonth() async {
    try {
      isLoading.value = true;
      final data = await _repository.getReminders();
      reminders.value = data;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void loadAppointments() {
    // Sample appointments - replace with actual API call
    appointments.value = [
      Appointment(
        time: '5:00 AM',
        title: 'Medication Refill',
      ),
      Appointment(
        time: '10:00 AM',
        title: 'Doctor\'s Appointment',
      ),
      Appointment(
        time: '7:00 PM',
        title: 'Lab Test',
      ),
    ];
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
  }

  void previousMonth() {
    currentMonth.value = DateTime(
      currentMonth.value.year,
      currentMonth.value.month - 1,
    );
    fetchRemindersForMonth();
  }

  void nextMonth() {
    currentMonth.value = DateTime(
      currentMonth.value.year,
      currentMonth.value.month + 1,
    );
    fetchRemindersForMonth();
  }

  bool hasReminder(DateTime date) {
    return reminders.any((reminder) {
      final reminderDate = DateTime.parse(reminder.reminderTime);
      return reminderDate.year == date.year &&
          reminderDate.month == date.month &&
          reminderDate.day == date.day;
    });
  }

  List<Reminder> getRemindersForDate(DateTime date) {
    return reminders.where((reminder) {
      final reminderDate = DateTime.parse(reminder.reminderTime);
      return reminderDate.year == date.year &&
          reminderDate.month == date.month &&
          reminderDate.day == date.day;
    }).toList();
  }

  String getMonthYear() {
    return DateFormat('MMMM yyyy').format(currentMonth.value);
  }
}

// Simple Appointment model
class Appointment {
  final String time;
  final String title;

  Appointment({
    required this.time,
    required this.title,
  });
}
