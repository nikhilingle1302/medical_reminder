// lib/presentation/screens/reminders/reminder_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_reminder/data/models/reminder_model.dart';
import 'package:medical_reminder/presentation/controllers/reminder_controller.dart';
import 'package:medical_reminder/presentation/widgets/custom_button.dart';


class ReminderDetailScreen extends StatelessWidget {
  ReminderDetailScreen({super.key});
  
  void _showErrorAndNavigateBack(String message) {
    Future.delayed(Duration.zero, () {
      Get.back();
      Get.snackbar(
        'Error',
        message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    final paramId = Get.parameters['id'];
    
    print('Arguments: $arguments');
    print('Parameters: $paramId');
    
    Reminder? reminder;
    
    // 1. Try to get the reminder directly from arguments
    if (arguments != null && arguments['reminder'] != null) {
      print('Getting reminder from arguments');
      reminder = arguments['reminder'] as Reminder;
    }
    
    // 2. If not, try to get from allReminders in arguments
    if (reminder == null && arguments != null && arguments['allReminders'] != null) {
      print('Searching in allReminders from arguments');
      final paramId = Get.parameters['id'];
      if (paramId != null) {
        final reminderId = int.tryParse(paramId);
        if (reminderId != null) {
          final allReminders = arguments['allReminders'] as List<Reminder>;
          reminder = allReminders.firstWhereOrNull((r) => r.id == reminderId);
        }
      }
    }
    
    // 3. If still not found, fallback to controller (though it might be empty)
    if (reminder == null) {
      print('Falling back to controller lookup');
      final reminderController = Get.find<ReminderController>();
      final paramId = Get.parameters['id'];
      
      if (paramId != null) {
        final reminderId = int.tryParse(paramId);
        if (reminderId != null) {
          print('Current reminders in controller: ${reminderController.reminders.length}');
          reminder = reminderController.reminders.firstWhereOrNull(
            (r) => r.id == reminderId,
          );
        }
      }
    }
    
    // 4. If all fails, show error
    if (reminder == null) {
      print('ERROR: Could not find reminder');
      _showErrorAndNavigateBack('Reminder not found');
      return const SizedBox.shrink();
    }

    print('Found reminder: ${reminder.medicineName}');
    
    // Now use the reminder directly for the rest of your build method
    return _buildReminderDetail(reminder);
  }
  
  Widget _buildReminderDetail(Reminder reminder) {
    // Your existing build method logic goes here, using the reminder parameter
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reminder Details',
          style: TextStyle(fontSize: 18.sp),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _showDeleteConfirmation(reminder.id),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: reminder.isTaken
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      reminder.isTaken ? Icons.check_circle : Icons.access_time,
                      size: 14.sp,
                      color: reminder.isTaken ? Colors.green : Colors.orange,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      reminder.isTaken ? 'Taken' : 'Pending',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: reminder.isTaken ? Colors.green : Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 24.h),
              
              // Medicine Card
              _buildDetailCard(
                title: 'Medicine',
                icon: Icons.medical_services,
                content: reminder.medicineName,
              ),
              
              SizedBox(height: 16.h),
              
              // Dosage
              _buildDetailCard(
                title: 'Dosage',
                icon: Icons.medical_information,
                content: reminder.dosage,
              ),
              
              SizedBox(height: 16.h),
              
              // Time
              _buildDetailCard(
                title: 'Time',
                icon: Icons.access_time,
                content: _formatReminderTime(reminder.reminderTime),
              ),
              
              SizedBox(height: 16.h),
              
              // Firebase IDs (if available)
              if (reminder.firebasePatientId != null)
                _buildDetailCard(
                  title: 'Patient ID',
                  icon: Icons.person,
                  content: reminder.firebasePatientId!,
                ),
              
              if (reminder.firebasePatientId != null) SizedBox(height: 16.h),
              
              // if (reminder.firebaseCaretakerId != null)
              //   _buildDetailCard(
              //     title: 'Caretaker ID',
              //     icon: Icons.person,
              //     content: reminder.firebaseCaretakerId!,
              //   ),
              
              // if (reminder.firebaseCaretakerId != null) SizedBox(height: 16.h),
              
              // Taken Time (if taken)
              if (reminder.isTaken)
                _buildDetailCard(
                  title: 'Taken At',
                  icon: Icons.check_circle,
                  content: 'Marked as taken',
                ),
              
              SizedBox(height: 40.h),
              
              // Action Buttons
              if (!reminder.isTaken) ...[
                CustomButton(
                  text: 'MARK AS TAKEN',
                  onPressed: () {
                    // Need to get controller for this action
                    final reminderController = Get.find<ReminderController>();
                    reminderController.markAsTaken(reminder.id);
                    Get.back();
                  },
                ),
                SizedBox(height: 12.h),
              ],
              
              CustomButton(
                text: 'EDIT REMINDER',
                backgroundColor: Colors.grey,
                onPressed: () {
                  _showEditDialog(reminder);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildDetailCard({
    required String title,
    required IconData icon,
    required String content,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 18.sp,
                color: const Color(0xFF2D9CDB),
              ),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            content,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
  
  String _formatReminderTime(String timeString) {
    try {
      final date = DateTime.parse(timeString);
      return DateFormat('MMM dd, yyyy - hh:mm a').format(date);
    } catch (e) {
      // Try alternative format
      try {
        final date = DateFormat('yyyy-MM-dd HH:mm:ss').parse(timeString);
        return DateFormat('MMM dd, yyyy - hh:mm a').format(date);
      } catch (e2) {
        return timeString;
      }
    }
  }
  
  void _showDeleteConfirmation(int reminderId) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Delete Reminder',
          style: TextStyle(fontSize: 18.sp),
        ),
        content: Text(
          'Are you sure you want to delete this reminder?',
          style: TextStyle(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Info',
                'Delete functionality requires API support',
                backgroundColor: Colors.orange,
                colorText: Colors.white,
              );
            },
            child: Text(
              'Delete',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showEditDialog(Reminder reminder) {
    Get.snackbar(
      'Info',
      'Edit functionality requires API support',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }
}
// class ReminderDetailScreen extends StatelessWidget {
//   final ReminderController _reminderController = Get.find<ReminderController>();

//   ReminderDetailScreen({super.key});
  
//   void _showErrorAndNavigateBack(String message) {
//     Future.delayed(Duration.zero, () {
//       Get.back();
//       Get.snackbar(
//         'Error',
//         message,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // ***** CHANGED THIS SECTION *****
//     // Get reminder ID from ROUTE PARAMETERS (not arguments)
//     final paramId = Get.parameters['id'];
//     print('Route parameter ID: $paramId');
//     print('All parameters: ${Get.parameters}');
    
//     if (paramId == null) {
//       print('ERROR: No ID parameter in route');
//       _showErrorAndNavigateBack('Reminder ID not found in URL');
//       return const SizedBox.shrink();
//     }
    
//     final reminderId = int.tryParse(paramId);
//     print('Parsed reminder ID: $reminderId');
    
//     if (reminderId == null) {
//       print('ERROR: Invalid ID format: $paramId');
//       _showErrorAndNavigateBack('Invalid reminder ID format');
//       return const SizedBox.shrink();
//     }
//     // ***** END OF CHANGES *****
    
//     print('Current reminders count: ${_reminderController.reminders.length}');
//     print('Current reminder IDs: ${_reminderController.reminders.map((r) => r.id).toList()}');

//     // Find the reminder
//     final reminder = _reminderController.reminders.firstWhereOrNull(
//       (r) => r.id == reminderId,
//     );

//     if (reminder == null) {
//       print('ERROR: Could not find reminder with ID $reminderId');
//       _showErrorAndNavigateBack('Reminder not found');
//       return const SizedBox.shrink();
//     }

//     print('Found reminder: ${reminder.medicineName}');


//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Reminder Details',
//           style: TextStyle(fontSize: 18.sp),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Get.back(),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.delete_outline),
//             onPressed: () => _showDeleteConfirmation(reminder.id),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(24.w),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Status Badge
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
//                 decoration: BoxDecoration(
//                   color: reminder.isTaken
//                       ? Colors.green.withOpacity(0.1)
//                       : Colors.orange.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(20.r),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(
//                       reminder.isTaken ? Icons.check_circle : Icons.access_time,
//                       size: 14.sp,
//                       color: reminder.isTaken ? Colors.green : Colors.orange,
//                     ),
//                     SizedBox(width: 4.w),
//                     Text(
//                       reminder.isTaken ? 'Taken' : 'Pending',
//                       style: TextStyle(
//                         fontSize: 12.sp,
//                         fontWeight: FontWeight.w600,
//                         color: reminder.isTaken ? Colors.green : Colors.orange,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
              
//               SizedBox(height: 24.h),
              
//               // Medicine Card
//               _buildDetailCard(
//                 title: 'Medicine',
//                 icon: Icons.medical_services,
//                 content: reminder.medicineName,
//               ),
              
//               SizedBox(height: 16.h),
              
//               // Dosage
//               _buildDetailCard(
//                 title: 'Dosage',
//                 icon: Icons.medical_information,
//                 content: reminder.dosage,
//               ),
              
//               SizedBox(height: 16.h),
              
//               // Time
//               _buildDetailCard(
//                 title: 'Time',
//                 icon: Icons.access_time,
//                 content: _formatReminderTime(reminder.reminderTime),
//               ),
              
//               SizedBox(height: 16.h),
              
//               // Firebase IDs (if available)
//               if (reminder.firebasePatientId != null)
//                 _buildDetailCard(
//                   title: 'Patient ID',
//                   icon: Icons.person,
//                   content: reminder.firebasePatientId!,
//                 ),
              
//               if (reminder.firebasePatientId != null) SizedBox(height: 16.h),
              
//               // if (reminder.firebaseCaretakerId != null)
//               //   _buildDetailCard(
//               //     title: 'Caretaker ID',
//               //     icon: Icons.person,
//               //     content: reminder.firebaseCaretakerId!,
//               //   ),
              
//              // if (reminder.firebaseCaretakerId != null) SizedBox(height: 16.h),
              
//               // Taken Time (if taken)
//               if (reminder.isTaken)
//                 _buildDetailCard(
//                   title: 'Taken At',
//                   icon: Icons.check_circle,
//                   content: 'Marked as taken',
//                 ),
              
//               SizedBox(height: 40.h),
              
//               // Action Buttons
//               if (!reminder.isTaken)
//                 CustomButton(
//                   text: 'MARK AS TAKEN',
//                   onPressed: () {
//                     _reminderController.markAsTaken(reminder.id);
//                     Get.back();
//                   },
//                 ),
              
//               SizedBox(height: 12.h),
              
//               CustomButton(
//                 text: 'EDIT REMINDER',
//                 backgroundColor: Colors.grey,
//                 onPressed: () {
//                   // Navigate to edit screen or show edit dialog
//                   _showEditDialog(reminder);
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
  
//   Widget _buildDetailCard({
//     required String title,
//     required IconData icon,
//     required String content,
//   }) {
//     return Container(
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12.r),
//         border: Border.all(color: const Color(0xFFEEEEEE)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(
//                 icon,
//                 size: 18.sp,
//                 color: const Color(0xFF2D9CDB),
//               ),
//               SizedBox(width: 8.w),
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.grey,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 8.h),
//           Text(
//             content,
//             style: TextStyle(
//               fontSize: 16.sp,
//               fontWeight: FontWeight.w600,
//               color: Colors.black,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
  
//   String _formatReminderTime(String timeString) {
//     try {
//       final date = DateFormat('yyyy-MM-dd HH:mm:ss').parse(timeString);
//       return DateFormat('MMM dd, yyyy - hh:mm a').format(date);
//     } catch (e) {
//       return timeString;
//     }
//   }
  
//   void _showDeleteConfirmation(int reminderId) {
//     Get.dialog(
//       AlertDialog(
//         title: Text(
//           'Delete Reminder',
//           style: TextStyle(fontSize: 18.sp),
//         ),
//         content: Text(
//           'Are you sure you want to delete this reminder?',
//           style: TextStyle(fontSize: 14.sp),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Get.back(),
//             child: Text(
//               'Cancel',
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 color: Colors.grey,
//               ),
//             ),
//           ),
//           TextButton(
//             onPressed: () {
//               Get.back();
//               // Since delete endpoint is not in the API, we can't delete
//               // Show message instead
//               Get.snackbar(
//                 'Info',
//                 'Delete functionality requires API support',
//                 backgroundColor: Colors.orange,
//                 colorText: Colors.white,
//               );
//             },
//             child: Text(
//               'Delete',
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 color: Colors.red,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
  
//   void _showEditDialog(dynamic reminder) {
//     Get.snackbar(
//       'Info',
//       'Edit functionality requires API support',
//       backgroundColor: Colors.orange,
//       colorText: Colors.white,
//     );
//   }
// }