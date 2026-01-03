import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../core/services/services.dart';
import '../../data/models/api_models.dart';
import '../../data/repo/medical_repo.dart';
import '../medicines/medicines_controller.dart';

class AddReminderScreen extends StatefulWidget {
  const AddReminderScreen({Key? key}) : super(key: key);

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final MedicinesController medicinesController = Get.put(MedicinesController());
  final MedicalRepository repository = MedicalRepository();
  final storage = GetStorage();
  
  final dosageController = TextEditingController();
  final caretakerIdController = TextEditingController();
  
  Medicine? selectedMedicine;
  DateTime? selectedDateTime;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    // Get Firebase token for patient
    try {
      final token = await FirebaseService.getToken();
      print('Firebase Token: $token');
    } catch (e) {
      print('Firebase token error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Reminder'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Medicine Dropdown
            Text(
              'Select Medicine',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            
            Obx(() {
              if (medicinesController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (medicinesController.medicines.isEmpty) {
                return Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    'No medicines available. Please add medicines first.',
                    style: TextStyle(color: Colors.orange.shade700),
                  ),
                );
              }
              
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Medicine>(
                    value: selectedMedicine,
                    hint: const Text('Select Medicine'),
                    isExpanded: true,
                    items: medicinesController.medicines.map((medicine) {
                      return DropdownMenuItem(
                        value: medicine,
                        child: Text(medicine.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => selectedMedicine = value);
                    },
                  ),
                ),
              );
            }),
            
            SizedBox(height: 20.h),
            
            // Dosage Field
            Text(
              'Dosage',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            _buildInputField('e.g., 1 tablet', dosageController),
            
            SizedBox(height: 20.h),
            
            // Reminder Time Picker
            Text(
              'Reminder Time',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            InkWell(
              onTap: _selectDateTime,
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDateTime == null
                          ? 'Select Date & Time'
                          : _formatDateTime(selectedDateTime!),
                      style: TextStyle(
                        color: selectedDateTime == null
                            ? Colors.grey.shade600
                            : Colors.black87,
                        fontSize: 14.sp,
                      ),
                    ),
                    Icon(Icons.calendar_today, color: Colors.grey.shade600),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20.h),
            
            // Caretaker Firebase ID (Optional)
            Text(
              'Caretaker Firebase ID (Optional)',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            _buildInputField('Enter caretaker Firebase ID', caretakerIdController),
            
            SizedBox(height: 40.h),
            
            // Save Button
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: isLoading ? null : _createReminder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  disabledBackgroundColor: Colors.blue.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: isLoading
                    ? SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'SAVE REMINDER',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String hint, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
        ),
      ),
    );
  }

  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      
      if (time != null) {
        setState(() {
          selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _createReminder() async {
    // Validation
    if (selectedMedicine == null) {
      Get.snackbar(
        'Error',
        'Please select a medicine',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (dosageController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter dosage',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (selectedDateTime == null) {
      Get.snackbar(
        'Error',
        'Please select reminder time',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // Get Firebase token for patient
      final firebaseToken = await FirebaseService.getToken();
      final userId = storage.read('user_id') ?? 1;
      
      // Create patient Firebase ID (you can customize this format)
      final firebasePatientId = firebaseToken ?? 'patient_$userId';
      
      // Format datetime as "YYYY-MM-DD HH:MM:SS"
      final formattedDateTime = 
          '${selectedDateTime!.year}-${selectedDateTime!.month.toString().padLeft(2, '0')}-${selectedDateTime!.day.toString().padLeft(2, '0')} '
          '${selectedDateTime!.hour.toString().padLeft(2, '0')}:${selectedDateTime!.minute.toString().padLeft(2, '0')}:00';
      
      final request = CreateReminderRequest(
        firebasePatientId: firebasePatientId,
        firebaseCaretakerId: caretakerIdController.text.isEmpty 
            ? null 
            : caretakerIdController.text,
        medicineId: selectedMedicine!.id,
        dosage: dosageController.text,
        reminderTime: formattedDateTime,
      );

      print('Creating reminder: ${request.toJson()}');
      
      await repository.createReminder(request);
      
      Get.snackbar(
        'Success',
        'Reminder created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      await Future.delayed(const Duration(milliseconds: 500));
      Get.back();
      
    } catch (e) {
      print('Error creating reminder: $e');
      Get.snackbar(
        'Error',
        'Failed to create reminder: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    dosageController.dispose();
    caretakerIdController.dispose();
    super.dispose();
  }
}