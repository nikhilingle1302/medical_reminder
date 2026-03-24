import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_reminder/data/models/medicine_model.dart';
import 'package:medical_reminder/presentation/controllers/reminder_controller.dart';
import 'package:medical_reminder/presentation/controllers/auth_controller.dart';
import 'package:medical_reminder/presentation/widgets/custom_button.dart';
import 'package:medical_reminder/presentation/widgets/custom_text_field.dart';
class AddReminderScreen extends StatelessWidget {
  final ReminderController _controller = Get.find<ReminderController>();

  AddReminderScreen({super.key});

  // ✅ Separate date picker — sets selectedStartDate
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      _controller.selectedStartDate.value = picked;
    }
  }

  // ✅ Separate time picker — sets selectedTimeOnly
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      _controller.selectedTimeOnly.value = picked;
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    if (args != null && args['medicineId'] != null) {
      Future.delayed(Duration.zero, () {
        final medicine = _controller.medicines
            .firstWhereOrNull((m) => m.id == args['medicineId']);
        if (medicine != null) {
          _controller.selectedMedicine.value = medicine;
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Reminder', style: TextStyle(fontSize: 18.sp)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Medicine ──────────────────────────────────────
              // ── Medicine ──────────────────────────────────────
Text('Medicine *', style: _labelStyle()),
SizedBox(height: 8.h),
Obx(() {
  if (_controller.medicines.isEmpty) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          const Icon(Icons.medical_services, color: Colors.grey),
          SizedBox(width: 10.w),
          Text("Loading medicines...",
              style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
        ],
      ),
    );
  }

  // ✅ Actual dropdown to select medicine
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    decoration: BoxDecoration(
      color: const Color(0xFFF5F5F5),
      borderRadius: BorderRadius.circular(10.r),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<Medicine>(
        value: _controller.selectedMedicine.value,
        isExpanded: true,
        hint: Row(
          children: [
            const Icon(Icons.medical_services, color: Colors.blue),
            SizedBox(width: 10.w),
            Text("Select Medicine",
                style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
          ],
        ),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
        items: _controller.medicines.map((medicine) {
          return DropdownMenuItem<Medicine>(
            value: medicine,
            child: Row(
              children: [
                const Icon(Icons.medication, color: Colors.blue, size: 18),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    medicine.name ?? "Unknown",
                    style: TextStyle(fontSize: 14.sp),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {
          // ✅ Actually sets the selected medicine
          _controller.selectedMedicine.value = value;
        },
      ),
    ),
  );
}),

              SizedBox(height: 20.h),

              // ── Frequency ─────────────────────────────────────
              Text('Times per day *', style: _labelStyle()),
              SizedBox(height: 8.h),
              CustomTextField(
                controller: _controller.frequencyController,
                hintText: 'e.g., 1, 2, 3',
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.repeat),
              ),

              SizedBox(height: 20.h),

              // ── Start Date ────────────────────────────────────
              Text('Start Date *', style: _labelStyle()),
              SizedBox(height: 8.h),
              Obx(() => GestureDetector(
                onTap: () => _selectStartDate(context),
                child: _pickerContainer(
                  icon: Icons.calendar_today,
                  text: _controller.selectedStartDate.value != null
                      ? DateFormat('MMM dd, yyyy')
                          .format(_controller.selectedStartDate.value!)
                      : 'Select Start Date',
                  hasValue: _controller.selectedStartDate.value != null,
                ),
              )),

              SizedBox(height: 20.h),

              // ── Reminder Time ─────────────────────────────────
              Text('Reminder Time *', style: _labelStyle()),
              SizedBox(height: 8.h),
              Obx(() => GestureDetector(
                onTap: () => _selectTime(context),
                child: _pickerContainer(
                  icon: Icons.access_time,
                  text: _controller.selectedTimeOnly.value != null
                      ? _controller.selectedTimeOnly.value!.format(context)
                      : 'Select Time',
                  hasValue: _controller.selectedTimeOnly.value != null,
                ),
              )),

              SizedBox(height: 40.h),

              // ── Save Button ───────────────────────────────────
              Obx(() => CustomButton(
                text: 'SAVE REMINDER',
                isLoading: _controller.isLoading.value,
                onPressed: () => _controller.createReminder(),
              )),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _labelStyle() => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      );

  Widget _pickerContainer({
    required IconData icon,
    required String text,
    required bool hasValue,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          SizedBox(width: 12.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              color: hasValue ? Colors.black87 : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
// class AddReminderScreen extends StatelessWidget {
//   final ReminderController _controller = Get.find<ReminderController>();
//   final AuthController _authController = Get.find<AuthController>();

//   AddReminderScreen({super.key});

//   Future<void> _selectDateTime(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 365)),
//     );
    
//     if (picked != null) {
//       final TimeOfDay? time = await showTimePicker(
//         context: context,
//         initialTime: TimeOfDay.now(),
//       );
      
//       if (time != null) {
//         _controller.selectedTime.value = DateTime(
//           picked.year,
//           picked.month,
//           picked.day,
//           time.hour,
//           time.minute,
//         );
//       }
//     }
//   }

//   @override
// Widget build(BuildContext context) {
//   final args = Get.arguments;

//   if (args != null && args['medicineId'] != null) {
//     final medicineId = args['medicineId'];

//     // 🔥 Auto select medicine
//     Future.delayed(Duration.zero, () {
//       final medicine = _controller.medicines
//           .firstWhereOrNull((m) => m.id == medicineId);

//       if (medicine != null) {
//         _controller.selectedMedicine.value = medicine;
//       }
//     });
//   }
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Add Reminder',
//           style: TextStyle(fontSize: 18.sp),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Get.back(),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(24.w),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Medicine *',
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.black87,
//                 ),
//               ),
//               SizedBox(height: 8.h),
//               // Obx(() => Container(
//               //   padding: EdgeInsets.symmetric(horizontal: 16.w),
//               //   decoration: BoxDecoration(
//               //     color: const Color(0xFFF5F5F5),
//               //     borderRadius: BorderRadius.circular(10.r),
//               //   ),
//               //   child: DropdownButton<Medicine>(
//               //     value: _controller.selectedMedicine.value,
//               //     hint: Text(
//               //       'Select Medicine',
//               //       style: TextStyle(color: Colors.grey, fontSize: 14.sp),
//               //     ),
//               //     isExpanded: true,
//               //     underline: const SizedBox(),
//               //     icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
//               //     items: _controller.medicines.map((medicine) {
//               //       return DropdownMenuItem<Medicine>(
//               //         value: medicine,
//               //         child: Text(
//               //           '${medicine.name} (${medicine.company})',
//               //           style: TextStyle(fontSize: 14.sp),
//               //         ),
//               //       );
//               //     }).toList(),
//               //     onChanged: (value) {
//               //       _controller.selectedMedicine.value = value;
//               //     },
//               //   ),
//               // )),
//               Obx(() {
//   final medicine = _controller.selectedMedicine.value;

//   return Container(
//     padding: EdgeInsets.all(16),
//     decoration: BoxDecoration(
//       color: const Color(0xFFF5F5F5),
//       borderRadius: BorderRadius.circular(10.r),
//     ),
//     child: Row(
//       children: [
//         Icon(Icons.medical_services, color: Colors.blue),
//         SizedBox(width: 10),
//         Text(
//           medicine?.name ?? "Select Medicine",
//           style: TextStyle(fontSize: 14.sp),
//         ),
//       ],
//     ),
//   );
// }),
//               SizedBox(height: 20.h),
              
//               Text(
//                 'Dosage',
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.black87,
//                 ),
//               ),
//               SizedBox(height: 8.h),
//               CustomTextField(
//                 controller: _controller.dosageController,
//                 hintText: 'e.g., 1 tablet, 5mg (Default: 1 tablet)',
//                 prefixIcon: Icon(Icons.medical_services_outlined),
//               ),
              
//               SizedBox(height: 20.h),
              
//               Text(
//                 'Reminder Time *',
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.black87,
//                 ),
//               ),
//               SizedBox(height: 8.h),
//               Obx(() => GestureDetector(
//                 onTap: () => _selectDateTime(context),
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF5F5F5),
//                     borderRadius: BorderRadius.circular(10.r),
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.access_time, color: Colors.grey),
//                       SizedBox(width: 12.w),
//                       Text(
//                         _controller.selectedTime.value != null
//                             ? DateFormat('MMM dd, yyyy - hh:mm a').format(_controller.selectedTime.value!)
//                             : 'Select Date & Time',
//                         style: TextStyle(
//                           fontSize: 14.sp,
//                           color: _controller.selectedTime.value != null
//                               ? Colors.black87
//                               : Colors.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               )),
              
//               // Only show these fields for caretakers
//               if (_authController.isCaretaker()) ...[
//                 SizedBox(height: 20.h),
//                 Text(
//                   'Patient Firebase ID',
//                   style: TextStyle(
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 SizedBox(height: 8.h),
//                 // CustomTextField(
//                 //   controller: _controller.firebasePatientIdController,
//                 //   hintText: 'Enter patient Firebase ID',
//                 //   prefixIcon: Icon(Icons.person_outline),
//                 // ),
//               ],
              
//               // Show caretaker ID for patients
//               if (_authController.isPatient()) ...[
//                 SizedBox(height: 20.h),
//                 Text(
//                   'Caretaker Firebase ID (Optional)',
//                   style: TextStyle(
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 SizedBox(height: 8.h),
//                 // CustomTextField(
//                 //   controller: _controller.firebaseCaretakerIdController,
//                 //   hintText: 'Enter caretaker Firebase ID',
//                 //   prefixIcon: Icon(Icons.person_outline),
//                 // ),
//               ],
              
//               SizedBox(height: 40.h),
              
//               Obx(() => CustomButton(
//                 text: 'SAVE REMINDER',
//                 isLoading: _controller.isLoading.value,
//                 onPressed: () {
//                   _controller.createReminder();
//                 },
//               )),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }