import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'calendar_controller.dart';

class CalendarScreen extends StatelessWidget {
  CalendarScreen({Key? key}) : super(key: key);

  final CalendarController controller = Get.put(CalendarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Calendar'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Calendar Widget
          _buildCalendar(),
          
          SizedBox(height: 20.h),
          
          // Appointments Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                Text(
                  'Appointments',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 16.h),
          
          // Appointments List
          Expanded(
            child: Obx(() => _buildAppointmentsList()),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          // Month/Year Header
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: controller.previousMonth,
              ),
              Text(
                controller.getMonthYear(),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: controller.nextMonth,
              ),
            ],
          )),
          
          SizedBox(height: 16.h),
          
          // Weekday Headers
          _buildWeekdayHeaders(),
          
          SizedBox(height: 12.h),
          
          // Calendar Grid
          Obx(() => _buildCalendarGrid()),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeaders() {
    final weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekdays.map((day) => SizedBox(
        width: 40.w,
        child: Center(
          child: Text(
            day,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(
      controller.currentMonth.value.year,
      controller.currentMonth.value.month,
      1,
    );
    
    final lastDayOfMonth = DateTime(
      controller.currentMonth.value.year,
      controller.currentMonth.value.month + 1,
      0,
    );
    
    final firstWeekday = firstDayOfMonth.weekday % 7;
    final daysInMonth = lastDayOfMonth.day;
    
    List<Widget> dayWidgets = [];
    
    // Add empty cells for days before the first day of the month
    for (int i = 0; i < firstWeekday; i++) {
      dayWidgets.add(SizedBox(width: 40.w, height: 40.h));
    }
    
    // Add day cells
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(
        controller.currentMonth.value.year,
        controller.currentMonth.value.month,
        day,
      );
      dayWidgets.add(_buildDayCell(date));
    }
    
    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: dayWidgets,
    );
  }

  Widget _buildDayCell(DateTime date) {
    final isToday = date.year == DateTime.now().year &&
        date.month == DateTime.now().month &&
        date.day == DateTime.now().day;
    
    final isSelected = date.year == controller.selectedDate.value.year &&
        date.month == controller.selectedDate.value.month &&
        date.day == controller.selectedDate.value.day;
    
    final hasReminder = controller.hasReminder(date);

    return GestureDetector(
      onTap: () => controller.selectDate(date),
      child: Container(
        width: 40.w,
        height: 40.h,
        margin: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blue
              : isToday
                  ? Colors.blue.shade50
                  : Colors.transparent,
          shape: BoxShape.circle,
          border: hasReminder
              ? Border.all(color: Colors.blue, width: 2)
              : null,
        ),
        child: Center(
          child: Text(
            date.day.toString(),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: isToday || isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? Colors.white
                  : isToday
                      ? Colors.blue
                      : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentsList() {
    if (controller.appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 60.sp, color: Colors.grey.shade400),
            SizedBox(height: 16.h),
            Text(
              'No appointments',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: controller.appointments.length,
      itemBuilder: (context, index) {
        final appointment = controller.appointments[index];
        return _buildAppointmentCard(appointment);
      },
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Time
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              appointment.time,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          
          SizedBox(width: 16.w),
          
          // Title
          Expanded(
            child: Text(
              appointment.title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          
          // More options
          Icon(
            Icons.chevron_right,
            color: Colors.grey.shade400,
          ),
        ],
      ),
    );
  }
}

// ==================== Alternative Appointments Screen ====================

class AppointmentsScreen extends StatelessWidget {
  AppointmentsScreen({Key? key}) : super(key: key);

  final CalendarController controller = Get.put(CalendarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Appointments'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.appointments.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_note, size: 80.sp, color: Colors.grey.shade300),
                SizedBox(height: 20.h),
                Text(
                  'No Appointments',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Add your first appointment',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(20.w),
          itemCount: controller.appointments.length,
          itemBuilder: (context, index) {
            final appointment = controller.appointments[index];
            return _buildAppointmentListItem(appointment);
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add appointment functionality
          Get.snackbar('Info', 'Add appointment feature coming soon');
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAppointmentListItem(Appointment appointment) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.time,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      appointment.title,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
