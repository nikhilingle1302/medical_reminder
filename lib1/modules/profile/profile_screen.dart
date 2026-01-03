
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../auth/auth_controller.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  final storage = GetStorage();
  final AuthController authController = Get.isRegistered<AuthController>() 
      ? Get.find<AuthController>() 
      : Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final username = storage.read('username') ?? 'User';
    final role = storage.read('user_role') ?? 'patient';
    final userId = storage.read('user_id') ?? 0;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    width: 100.w,
                    height: 100.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade400, Colors.blue.shade600],
                      ),
                    ),
                    child: Icon(
                      role == 'patient' ? Icons.person : Icons.medical_services,
                      size: 50.sp,
                      color: Colors.white,
                    ),
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Username
                  Text(
                    username,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  
                  SizedBox(height: 8.h),
                  
                  // Role Badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: role == 'patient' ? Colors.blue.shade50 : Colors.green.shade50,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      role == 'patient' ? 'Patient' : 'Caretaker',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: role == 'patient' ? Colors.blue : Colors.green,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 8.h),
                  
                  Text(
                    'ID: $userId',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 20.h),
            
            // Profile Options
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                children: [
                  _buildProfileOption(
                    icon: Icons.person_outline,
                    title: 'Edit Profile',
                    onTap: () {
                      Get.snackbar('Info', 'Edit profile feature coming soon');
                    },
                  ),
                  _buildDivider(),
                  _buildProfileOption(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {},
                      activeColor: Colors.blue,
                    ),
                    onTap: null,
                  ),
                  _buildDivider(),
                  _buildProfileOption(
                    icon: Icons.lock_outline,
                    title: 'Change Password',
                    onTap: () {
                      Get.snackbar('Info', 'Change password feature coming soon');
                    },
                  ),
                  _buildDivider(),
                  _buildProfileOption(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    onTap: () {
                      Get.snackbar('Info', 'Help & support feature coming soon');
                    },
                  ),
                  _buildDivider(),
                  _buildProfileOption(
                    icon: Icons.info_outline,
                    title: 'About',
                    onTap: () {
                      _showAboutDialog(context);
                    },
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 20.h),
            
            // Logout Button
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showLogoutDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout, color: Colors.white),
                    SizedBox(width: 8.w),
                    Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(icon, color: Colors.blue, size: 22.sp),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: trailing ?? Icon(Icons.chevron_right, color: Colors.grey.shade400),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.shade200,
      indent: 72.w,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              authController.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('About'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Medical Reminder System',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text('Version 1.0.0'),
            SizedBox(height: 16.h),
            Text(
              'A comprehensive medication reminder and management system.',
              style: TextStyle(fontSize: 14.sp),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
