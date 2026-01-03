import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../auth/auth_controller.dart';
import 'home_controller.dart';
import '../../core/routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final HomeController controller = Get.put(HomeController());
  final AuthController authController = Get.isRegistered<AuthController>() 
      ? Get.find<AuthController>() 
      : Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text('Welcome, ${controller.username.value}!')),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Get.toNamed(AppRoutes.PROFILE),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Role Badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: authController.isPatient ? Colors.blue.shade50 : Colors.green.shade50,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    authController.isPatient ? Icons.person : Icons.medical_services,
                    size: 16.sp,
                    color: authController.isPatient ? Colors.blue : Colors.green,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    authController.isPatient ? 'Patient Mode' : 'Caretaker Mode',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: authController.isPatient ? Colors.blue : Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24.h),
            
            // Calendar Widget
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _buildMiniCalendar(),
                ],
              ),
            ),
            
            SizedBox(height: 30.h),
            
            Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            SizedBox(height: 16.h),
            
            // Quick Actions based on role
            if (authController.isPatient) ...[
              _buildPatientActions(),
            ] else ...[
              _buildCaretakerActions(),
            ],
          ],
        ),
      ),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: controller.selectedIndex.value,
        onTap: (index) {
          controller.changeTab(index);
          switch (index) {
            case 0:
              // Already on home
              break;
            case 1:
              Get.toNamed(AppRoutes.REMINDERS);
              break;
            case 2:
              Get.toNamed(AppRoutes.MEDICINES);
              break;
            case 3:
              Get.toNamed(AppRoutes.PROFILE);
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm),
            label: 'Reminders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication),
            label: 'Medicines',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      )),
    );
  }

  // Patient-specific actions
  Widget _buildPatientActions() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.alarm_add,
                label: 'My Reminders',
                color: Colors.blue,
                onTap: () => Get.toNamed(AppRoutes.REMINDERS),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _buildActionCard(
                icon: Icons.medication,
                label: 'Medicines',
                color: Colors.green,
                onTap: () => Get.toNamed(AppRoutes.MEDICINES),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.calendar_today,
                label: 'Calendar',
                color: Colors.orange,
                onTap: () => Get.toNamed(AppRoutes.CALENDAR),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _buildActionCard(
                icon: Icons.history,
                label: 'History',
                color: Colors.purple,
                onTap: () {
                  Get.snackbar('Info', 'History feature coming soon');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Caretaker-specific actions
  Widget _buildCaretakerActions() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.person_add,
                label: 'Manage Patients',
                color: Colors.green,
                onTap: () {
                  Get.snackbar('Info', 'Manage patients feature coming soon');
                },
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _buildActionCard(
                icon: Icons.alarm_add,
                label: 'Set Reminders',
                color: Colors.blue,
                onTap: () => Get.toNamed(AppRoutes.ADD_REMINDER),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.medication,
                label: 'Medicines',
                color: Colors.orange,
                onTap: () => Get.toNamed(AppRoutes.MEDICINES),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _buildActionCard(
                icon: Icons.analytics,
                label: 'Reports',
                color: Colors.purple,
                onTap: () {
                  Get.snackbar('Info', 'Reports feature coming soon');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMiniCalendar() {
    final now = DateTime.now();
    final daysInWeek = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: daysInWeek
              .map((day) => Text(
                    day,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ))
              .toList(),
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(7, (index) {
            final day = now.day - now.weekday + index + 1;
            final isToday = day == now.day;
            return Container(
              width: 32.w,
              height: 32.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isToday ? Colors.blue : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Text(
                day.toString(),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  color: isToday ? Colors.white : Colors.black,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Container(
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 28.sp, color: Colors.white),
            ),
            SizedBox(height: 12.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: color.darken(20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension ColorExtension on Color {
  Color darken([int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    final f = 1 - percent / 100;
    return Color.fromARGB(
      alpha,
      (red * f).round(),
      (green * f).round(),
      (blue * f).round(),
    );
  }
}