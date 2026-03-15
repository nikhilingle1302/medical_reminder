// lib/presentation/screens/profile/profile_screen.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:medical_reminder/data/services/notification_service.dart';
import 'package:medical_reminder/presentation/controllers/auth_controller.dart';
import 'package:medical_reminder/presentation/widgets/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  final AuthController _authController = Get.find<AuthController>();

  ProfileScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(fontSize: 18.sp),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        final user = _authController.currentUser.value;
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // In your settings or debug screen
// ElevatedButton(
//   onPressed: () async {
//     final notificationService = Get.find<NotificationService>();
//     await notificationService.debugFCM();
//   },
//   child: Text('Debug FCM'),
// ),

// ElevatedButton(
//   onPressed: () async {
//     try {
//       final messaging = FirebaseMessaging.instance;
//       final token = await messaging.getToken();
//       Get.snackbar(
//         'FCM Token',
//         token ?? 'No token',
//         duration: Duration(seconds: 10),
//       );
//       print('Token: $token');
//     } catch (e) {
//       Get.snackbar('Error', e.toString());
//     }
//   },
//   child: Text('Get FCM Token'),
// ),
                // Profile Header
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 100.w,
                        height: 100.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D9CDB).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person,
                          size: 40.sp,
                          color: const Color(0xFF2D9CDB),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        user.username,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: user.role == 'patient'
                              ? Colors.green.withOpacity(0.1)
                              : Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          user.role ?? '',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: user.role == 'patient' ? Colors.green : Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                FcmTokenCard(),
                SizedBox(height: 40.h),
                
                // Account Information
                Text(
                  'Account Information',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                
                SizedBox(height: 16.h),
                
                _buildInfoCard(
                  icon: Icons.person,
                  title: 'User ID',
                  value: user.id.toString(),
                ),
                
                SizedBox(height: 12.h),
                
                _buildInfoCard(
                  icon: Icons.account_circle,
                  title: 'Username',
                  value: user.username,
                ),
                
                SizedBox(height: 12.h),
                
                _buildInfoCard(
                  icon: Icons.medical_services,
                  title: 'Role',
                  value: user.role ??"-",
                ),
                
                SizedBox(height: 40.h),
                
                // Settings Section
                Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                
                SizedBox(height: 16.h),
                
                _buildSettingItem(
                  icon: Icons.notifications,
                  title: 'Notifications',
                  onTap: () {
                    // Navigate to notification settings
                  },
                ),
                
                SizedBox(height: 12.h),
                
                _buildSettingItem(
                  icon: Icons.security,
                  title: 'Privacy & Security',
                  onTap: () {
                    // Navigate to privacy settings
                  },
                ),
                
                SizedBox(height: 12.h),
                
                _buildSettingItem(
                  icon: Icons.help,
                  title: 'Help & Support',
                  onTap: () {
                    // Navigate to help screen
                  },
                ),
                
                SizedBox(height: 40.h),
                
                // Logout Button
                CustomButton(
                  text: 'LOGOUT',
                  backgroundColor: Colors.red,
                  onPressed: () {
                    _showLogoutConfirmation();
                  },
                ),
                
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      }),
    );
  }
  
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
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
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF2D9CDB),
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF2D9CDB),
              size: 20.sp,
            ),
            SizedBox(width: 12.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
  
  void _showLogoutConfirmation() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Logout',
          style: TextStyle(fontSize: 18.sp),
        ),
        content: Text(
          'Are you sure you want to logout?',
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
              _authController.logout();
            },
            child: Text(
              'Logout',
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
}
class FcmTokenCard extends StatelessWidget {
  FcmTokenCard({super.key});

  final GetStorage storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    final String? fcmToken = storage.read<String>('fcm_token');

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'FCM Token',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),

            /// Token display
            SelectableText(
              fcmToken ?? 'Token not available',
              maxLines: 3,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 12),

            /// Copy button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.copy, size: 18),
                label: const Text('Copy'),
                onPressed: fcmToken == null
                    ? null
                    : () {
                        Clipboard.setData(
                          ClipboardData(text: fcmToken),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('FCM token copied to clipboard'),
                          ),
                        );
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

