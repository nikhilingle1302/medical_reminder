import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medical_reminder/data/models/reminder_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medical_reminder/data/models/reminder_model.dart';
import 'package:intl/intl.dart';

class ReminderCard extends StatelessWidget {
  final Reminder reminder;
  final VoidCallback onTap;
  final VoidCallback onTaken;

  const ReminderCard({
    super.key,
    required this.reminder,
    required this.onTap,
    required this.onTaken,
  });

  @override
  Widget build(BuildContext context) {
    // Format the reminder time string
    final formattedTime = _formatReminderTime(reminder.reminderTime);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: reminder.isTaken ? Colors.grey[100] : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Status Indicator
            Container(
              width: 4.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: reminder.isTaken ? Colors.green : const Color(0xFF2D9CDB),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Medicine Name
                  Text(
                    reminder.medicineName, // This is a String directly
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: reminder.isTaken ? Colors.grey : Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  // Dosage and Time
                  Text(
                    '${reminder.dosage} • $formattedTime',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: reminder.isTaken ? Colors.grey : Colors.black87,
                    ),
                  ),
                  // Firebase IDs (if available)
                  // if (reminder.firebasePatientId != null || reminder.firebaseCaretakerId != null)
                    if (reminder.firebasePatientId != null )
                    Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: Text(
                        _formatFirebaseIds(reminder),
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Action Button
            if (!reminder.isTaken)
              IconButton(
                icon: Icon(
                  Icons.check_circle_outline,
                  color: const Color(0xFF2D9CDB),
                  size: 24.sp,
                ),
                onPressed: onTaken,
              )
            else
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 24.sp,
              ),
          ],
        ),
      ),
    );
  }

  String _formatReminderTime(String timeString) {
    try {
      // Try parsing with the API format
      final date = DateFormat('yyyy-MM-dd HH:mm:ss').parse(timeString);
      return DateFormat('hh:mm a').format(date);
    } catch (e) {
      try {
        // Fallback: try parsing as ISO string
        final date = DateTime.parse(timeString);
        return DateFormat('hh:mm a').format(date);
      } catch (e) {
        // If all parsing fails, return original string
        return timeString;
      }
    }
  }

  String _formatFirebaseIds(Reminder reminder) {
    final List<String> ids = [];
    if (reminder.firebasePatientId != null && reminder.firebasePatientId!.isNotEmpty) {
      ids.add('Patient: ${_truncateId(reminder.firebasePatientId!)}');
    }
    // if (reminder.firebaseCaretakerId != null && reminder.firebaseCaretakerId!.isNotEmpty) {
    //   ids.add('Caretaker: ${_truncateId(reminder.firebaseCaretakerId!)}');
    // }
    return ids.join(' | ');
  }

  String _truncateId(String id) {
    if (id.length <= 8) return id;
    return '${id.substring(0, 4)}...${id.substring(id.length - 4)}';
  }
}

// Alternative: Horizontal Reminder Card
class HorizontalReminderCard extends StatelessWidget {
  final Reminder reminder;
  final VoidCallback onTap;
  final VoidCallback onTaken;

  const HorizontalReminderCard({
    super.key,
    required this.reminder,
    required this.onTap,
    required this.onTaken,
  });

  @override
  Widget build(BuildContext context) {
    final formattedTime = _formatReminderTime(reminder.reminderTime);
    
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: reminder.isTaken ? Colors.grey[50] : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: reminder.isTaken ? Colors.green.withOpacity(0.3) : const Color(0xFF2D9CDB).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: reminder.isTaken ? Colors.green.withOpacity(0.1) : const Color(0xFF2D9CDB).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            reminder.isTaken ? Icons.check_circle : Icons.medical_services,
            color: reminder.isTaken ? Colors.green : const Color(0xFF2D9CDB),
            size: 20.sp,
          ),
        ),
        title: Text(
          reminder.medicineName,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: reminder.isTaken ? Colors.grey : Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${reminder.dosage} • $formattedTime',
              style: TextStyle(
                fontSize: 12.sp,
                color: reminder.isTaken ? Colors.grey : Colors.black87,
              ),
            ),
            if (!reminder.isTaken)
              Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: Text(
                  'Tap to mark as taken',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: const Color(0xFF2D9CDB),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
        trailing: !reminder.isTaken
            ? IconButton(
                icon: Icon(
                  Icons.check_circle_outline,
                  color: const Color(0xFF2D9CDB),
                  size: 24.sp,
                ),
                onPressed: onTaken,
              )
            : Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 24.sp,
              ),
        onTap: onTap,
      ),
    );
  }

  String _formatReminderTime(String timeString) {
    try {
      final date = DateFormat('yyyy-MM-dd HH:mm:ss').parse(timeString);
      return DateFormat('hh:mm a').format(date);
    } catch (e) {
      return timeString;
    }
  }
}

// Compact Reminder Card for lists
class CompactReminderCard extends StatelessWidget {
  final Reminder reminder;
  final VoidCallback onTap;

  const CompactReminderCard({
    super.key,
    required this.reminder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final formattedTime = _formatReminderTime(reminder.reminderTime);
    
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
      leading: CircleAvatar(
        backgroundColor: reminder.isTaken ? Colors.green.withOpacity(0.1) : const Color(0xFF2D9CDB).withOpacity(0.1),
        child: Icon(
          reminder.isTaken ? Icons.check : Icons.medical_services,
          color: reminder.isTaken ? Colors.green : const Color(0xFF2D9CDB),
          size: 18.sp,
        ),
      ),
      title: Text(
        reminder.medicineName,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: reminder.isTaken ? Colors.grey : Colors.black,
        ),
      ),
      subtitle: Text(
        '${reminder.dosage} • $formattedTime',
        style: TextStyle(
          fontSize: 12.sp,
          color: reminder.isTaken ? Colors.grey : Colors.black54,
        ),
      ),
      trailing: reminder.isTaken
          ? Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 20.sp,
            )
          : null,
      onTap: onTap,
    );
  }

  String _formatReminderTime(String timeString) {
    try {
      final date = DateFormat('yyyy-MM-dd HH:mm:ss').parse(timeString);
      return DateFormat('hh:mm a').format(date);
    } catch (e) {
      return timeString;
    }
  }
}