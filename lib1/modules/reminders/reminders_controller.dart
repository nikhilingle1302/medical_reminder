import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../data/models/api_models.dart';
import '../../data/repo/medical_repo.dart';
class RemindersController extends GetxController {
  final MedicalRepository _repository = MedicalRepository();
  final storage = GetStorage();
  
  final reminders = <Reminder>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchReminders();
  }

  Future<void> fetchReminders() async {
    try {
      isLoading.value = true;
      final data = await _repository.getReminders();
      reminders.value = data;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsTaken(int id) async {
    try {
      await _repository.markReminderTaken(id);
      Get.snackbar(
        'Success',
        'Reminder marked as taken',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      await fetchReminders(); // Refresh the list
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> refreshReminders() async {
    await fetchReminders();
  }

  // Get reminders for today
  List<Reminder> get todayReminders {
    final today = DateTime.now();
    return reminders.where((reminder) {
      try {
        final reminderDate = DateTime.parse(reminder.reminderTime);
        return reminderDate.year == today.year &&
               reminderDate.month == today.month &&
               reminderDate.day == today.day;
      } catch (e) {
        return false;
      }
    }).toList();
  }

  // Get upcoming reminders
  List<Reminder> get upcomingReminders {
    final now = DateTime.now();
    return reminders.where((reminder) {
      try {
        final reminderDate = DateTime.parse(reminder.reminderTime);
        return reminderDate.isAfter(now);
      } catch (e) {
        return false;
      }
    }).toList();
  }

  // Get missed reminders
  List<Reminder> get missedReminders {
    final now = DateTime.now();
    return reminders.where((reminder) {
      try {
        final reminderDate = DateTime.parse(reminder.reminderTime);
        return reminderDate.isBefore(now) && !(reminder.isTaken ?? false);
      } catch (e) {
        return false;
      }
    }).toList();
  }
}

// class RemindersController extends GetxController {
//   final MedicalRepository _repository = MedicalRepository();
//   final storage = GetStorage();
  
//   final reminders = <Reminder>[].obs;
//   final isLoading = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchReminders();
//   }

//   Future<void> fetchReminders() async {
//     try {
//       isLoading.value = true;
//       final data = await _repository.getReminders();
//       reminders.value = data;
//     } catch (e) {
//       Get.snackbar('Error', e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> markAsTaken(int id) async {
//     try {
//       await _repository.markReminderTaken(id);
//       Get.snackbar('Success', 'Reminder marked as taken');
//       fetchReminders();
//     } catch (e) {
//       Get.snackbar('Error', e.toString());
//     }
//   }

//   Future<void> deleteReminder(int id) async {
//     try {
//       await _repository.deleteReminder(id);
//       Get.snackbar('Success', 'Reminder deleted');
//       fetchReminders();
//     } catch (e) {
//       Get.snackbar('Error', e.toString());
//     }
//   }
// }