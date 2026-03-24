import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:medical_reminder/data/repositories/reminder_repository.dart';
import 'package:medical_reminder/data/models/reminder_model.dart';
import 'package:medical_reminder/data/models/medicine_model.dart';
import 'package:medical_reminder/data/services/notification_service.dart';
import 'package:medical_reminder/presentation/controllers/auth_controller.dart';

import 'package:intl/intl.dart';

class ReminderController extends GetxController {
  final ReminderRepository _reminderRepository;
  final AuthController _authController = Get.find<AuthController>();
  final notificationService = Get.find<NotificationService>();
  ReminderController(this._reminderRepository);
  
  final RxList<Reminder> reminders = <Reminder>[].obs;
  final RxList<Medicine> medicines = <Medicine>[].obs;
  final RxBool isLoading = false.obs;
  
  // For creating new reminder
  final Rx<Medicine?> selectedMedicine = Rx<Medicine?>(null);
  final TextEditingController dosageController = TextEditingController();
  final Rx<DateTime?> selectedTime = Rx<DateTime?>(null);
  final Rx<TimeOfDay?> selectedTimeOnly = Rx<TimeOfDay?>(null);
final Rx<DateTime?> selectedStartDate = Rx<DateTime?>(null);
final TextEditingController frequencyController = TextEditingController(text: "1");
  // final TextEditingController firebasePatientIdController = TextEditingController();
  // final TextEditingController firebaseCaretakerIdController = TextEditingController();
  
  @override
  void onInit() {
    super.onInit();
     fetchReminders();
     fetchMedicines();
  }
  
Future<void> fetchReminders() async {
  try {
    isLoading.value = true;
    
    // Call the API and get the ReminderResponse
    final ReminderResponse result = await _reminderRepository.getReminders();
    
    // Check if the response has any reminders
    if (result.reminders.isEmpty) {
      Get.snackbar(
        'No Reminders',
        'No reminders found!',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    
    // Assign all reminders to the observable list
    reminders.assignAll(result.reminders);
    
  } catch (e) {
    Get.snackbar(
      'Error',
      'Failed to fetch reminders: ${e.toString()}',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    isLoading.value = false;
  }
}
  
  Future<void> fetchMedicines() async {
    try {
      final result = await _reminderRepository.getMedicines();
      log("all medicines: ${result.toString()}");
      medicines.assignAll(result);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch medicines: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  
  // Future<void> createReminder() async {
  //   try {
  //     if (selectedMedicine.value == null || selectedTime.value == null) {
  //       Get.snackbar(
  //         'Error',
  //         'Please select medicine and time',
  //         backgroundColor: Colors.red,
  //         colorText: Colors.white,
  //       );
  //       return;
  //     }
      
  //     isLoading.value = true;
      
  //     // Format time for API
  //     final formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedTime.value!);
      
  //     // final request = CreateReminderRequest(
  //     //   medicineId: selectedMedicine.value!.id,
  //     //   dosage: dosageController.text.isNotEmpty ? dosageController.text : '1 tablet',
  //     //   reminderTime: formattedTime,
  //     //   firebasePatientId: firebasePatientIdController.text.isNotEmpty 
  //     //       ? firebasePatientIdController.text 
  //     //       : "++",
  //     //   firebaseCaretakerId: firebaseCaretakerIdController.text.isNotEmpty
  //     //       ? firebaseCaretakerIdController.text
  //     //       : null,
  //     // );
  //     final request = {
  //       "medicine_id": selectedMedicine.value!.id,
  //       "dosage": dosageController.text.isNotEmpty ? dosageController.text : '1 tablet',
  //       "reminder_time": formattedTime,
  //       "firebase_patient_id": firebasePatientIdController.text.isNotEmpty 
  //           ? firebasePatientIdController.text 
  //           : "++",
  //       // "firebase_caretaker_id": firebaseCaretakerIdController.text.isNotEmpty
  //       //     ? firebaseCaretakerIdController.text
  //       //     : null,
  //     };
  //     log("create reminder request: ${request.toString()}");
  //     final response = await _reminderRepository.createReminder(request);
  //     log("create reminder response: ${response.toString()}");
  //     if (response['message'] != null ) {
  //       // Clear form
  //       selectedMedicine.value = null;
  //       dosageController.clear();
  //       selectedTime.value = null;
  //       firebasePatientIdController.clear();
  //       firebaseCaretakerIdController.clear();
        
  //       // Refresh list
  //       await fetchReminders();
        
  //       Get.back();
  //       Get.snackbar(
  //         'Success',
  //         'Reminder created successfully',
  //         backgroundColor: Colors.green,
  //         colorText: Colors.white,
  //       );
  //     } else {
  //       throw Exception('Failed to create reminder');
  //     }
  //   } catch (e) {
  //     Get.snackbar(
  //       'Error',
  //       'Failed to create reminder: ${e.toString()}',
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //     );
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  
Future<void> createReminder() async {
  try {
    if (selectedMedicine.value == null ||
        selectedTimeOnly.value == null ||
        selectedStartDate.value == null) {
      Get.snackbar(
        'Error',
        'Please fill all required fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    final time = selectedTimeOnly.value!;
    final startDate = selectedStartDate.value!;

    // ✅ Format time (HH:mm:ss)
    final formattedTime =
        "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00";

    // ✅ Format date (yyyy-MM-dd)
    final formattedDate =
        DateFormat('yyyy-MM-dd').format(startDate);

    final frequency =
        int.tryParse(frequencyController.text.trim()) ?? 1;

final request = {
  "medicine": selectedMedicine.value!.id,
  "reminder_time": formattedTime,       // already computed above as "HH:mm:ss"
  "frequency_per_day": frequency,
  "start_date": formattedDate,          // already computed above as "yyyy-MM-dd"
};

    log("✅ NEW create reminder request: $request");

    final response = await _reminderRepository.createReminder(request);

    if (response != null) {
      /// ✅ SHOW IMMEDIATE CONFIRMATION
      await notificationService.showImmediateReminderCreatedNotification(
        medicineName: selectedMedicine.value!.name,
        dosage: "$frequency times/day",
        scheduledTime: formattedTime,
      );

      /// ✅ SCHEDULE LOCAL NOTIFICATION
      final scheduledDateTime = DateTime(
        startDate.year,
        startDate.month,
        startDate.day,
        time.hour,
        time.minute,
      );

      await notificationService.scheduleReminderNotificationFromDateTime(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        medicineName: selectedMedicine.value!.name,
        dosage: "$frequency times/day",
        scheduledDateTime: scheduledDateTime,
      );

      /// ✅ CLEAR FORM
      selectedMedicine.value = null;
      selectedTimeOnly.value = null;
      selectedStartDate.value = null;
      dosageController.clear();
      frequencyController.clear();

      await fetchReminders();

      Get.back();

      Get.snackbar(
        'Success',
        'Reminder created successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  } catch (e) {
    Get.snackbar(
      'Error',
      'Failed to create reminder: ${e.toString()}',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    isLoading.value = false;
  }
} 
  // Future<void> markAsTaken(int reminderId) async {
  //   try {
  //     final response = await _reminderRepository.markReminderTaken(reminderId);
      
  //     if (response.status?.toLowerCase() == 'success') {
  //       // Update local list
  //       final index = reminders.indexWhere((r) => r.id == reminderId);
  //       if (index != -1) {
  //         // Create updated reminder
  //         final updatedReminder = Reminder(
  //           id: reminders[index].id,
  //           medicineId: reminders[index].medicineId,
  //           firebasePatientId: reminders[index].firebasePatientId,
  //           //firebaseCaretakerId: reminders[index].firebaseCaretakerId,
  //           medicineName: reminders[index].medicineName,
  //           dosage: reminders[index].dosage,
  //           reminderTime: reminders[index].reminderTime,
  //           isTaken: true,
  //           //isSent: false,
  //         );
  //         reminders[index] = updatedReminder;
  //       }
        
  //       Get.snackbar(
  //         'Success',
  //         'Reminder marked as taken',
  //         backgroundColor: Colors.green,
  //         colorText: Colors.white,
  //       );
  //     }
  //   } catch (e) {
  //     Get.snackbar(
  //       'Error',
  //       'Failed to mark as taken: ${e.toString()}',
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //     );
  //   }
  // }
  Future<void> markAsTaken(int reminderId) async {
  try {
    await _reminderRepository.markReminderTaken(reminderId);

    // ✅ Just refresh from API instead of patching local model
    await fetchReminders();

    Get.snackbar(
      'Success',
      'Reminder marked as taken',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  } catch (e) {
    Get.snackbar(
      'Error',
      'Failed to mark as taken: ${e.toString()}',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}
  
  
  Future<void> getDueReminders() async {
    try {
      log("in get due reminders");
      final response = await _reminderRepository.getDueReminders();
      if(response!= null && response['status']=='success'){
         Get.snackbar(
        'Due Reminders',
        '${response['notifications_sent']} notifications sent',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
      }
    
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to get due reminders.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  
 List<Reminder> getTodayReminders() {
  final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

  return reminders.where((reminder) {
    // ✅ API no longer has isTaken, filter by startDate instead
    return reminder.startDate == today ||
        (reminder.startDate.compareTo(today) <= 0 &&
            (reminder.endDate == null ||
                reminder.endDate!.compareTo(today) >= 0));
  }).toList();
}
  
  List<Reminder> getUpcomingReminders() {
    final now = DateTime.now();
    
    return reminders.where((reminder) {
      try {
        final reminderDate = DateFormat('yyyy-MM-dd HH:mm:ss').parse(reminder.reminderTime);
        return reminderDate.isAfter(now);
      } catch (e) {
        return false;
      }
    }).toList();
  }
  
  // For FCM token management
  String? getFirebaseUserId() {
    // This should be implemented based on your FCM setup
    // For now, return a placeholder or get from storage
    final storage = GetStorage();
    return storage.read('firebase_user_id');
  }
}