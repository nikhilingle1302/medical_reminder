// lib/presentation/screens/auth/register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medical_reminder/core/constants/app_constants.dart';
import 'package:medical_reminder/presentation/controllers/auth_controller.dart';
import 'package:medical_reminder/presentation/widgets/custom_button.dart';
import 'package:medical_reminder/presentation/widgets/custom_text_field.dart';

class RegisterScreen extends StatelessWidget {
  final AuthController _authController = Get.find<AuthController>();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Create Account',
          style: TextStyle(fontSize: 18.sp),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.h),
              
              // Title
              Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Create an account to get started',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
              ),
              
              SizedBox(height: 40.h),
              
              // Username
              CustomTextField(
                controller: _authController.usernameController,
                hintText: 'Username',
                labelText: 'Username',
                prefixIconData: Icons.person_outline,
                isRequired: true,
              ),
              
              SizedBox(height: 20.h),
              Text(
                  'Email',
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8.h),
                CustomTextField(
                  controller: _authController.emailController,
                  hintText: 'Enter your email',
                  prefixIconData: Icons.email_outlined,
                ),
                SizedBox(height: 20.h),
              
              // Password
              CustomTextField(
                controller: _authController.passwordController,
                hintText: 'Password',
                labelText: 'Password',
                prefixIconData: Icons.lock_outline,
                isPassword: true,
                isRequired: true,
              ),
              
              SizedBox(height: 20.h),
              
              // Confirm Password
              CustomTextField(
                controller: _authController.confirmPasswordController,
                hintText: 'Confirm Password',
                labelText: 'Confirm Password',
                prefixIconData: Icons.lock_outline,
                isPassword: true,
                isRequired: true,
              ),
              
              SizedBox(height: 20.h),
              
              // Role Selection
              Text(
                'Select Role *',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),
              // Obx(() => Container(
              //   decoration: BoxDecoration(
              //     color: const Color(0xFFF5F5F5),
              //     borderRadius: BorderRadius.circular(10.r),
              //   ),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: GestureDetector(
              //           onTap: () => _authController.selectedRole.value = 'patient',
              //           child: Container(
              //             padding: EdgeInsets.symmetric(vertical: 12.h),
              //             decoration: BoxDecoration(
              //               color: _authController.selectedRole.value == 'patient'
              //                   ? const Color(0xFF2D9CDB)
              //                   : Colors.transparent,
              //               borderRadius: BorderRadius.circular(10.r),
              //             ),
              //             child: Center(
              //               child: Text(
              //                 'Patient',
              //                 style: TextStyle(
              //                   color: _authController.selectedRole.value == 'patient'
              //                       ? Colors.white
              //                       : Colors.grey,
              //                   fontWeight: FontWeight.w600,
              //                   fontSize: 14.sp,
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //       Expanded(
              //         child: GestureDetector(
              //           onTap: () => _authController.selectedRole.value = 'caretaker',
              //           child: Container(
              //             padding: EdgeInsets.symmetric(vertical: 12.h),
              //             decoration: BoxDecoration(
              //               color: _authController.selectedRole.value == 'caretaker'
              //                   ? const Color(0xFF2D9CDB)
              //                   : Colors.transparent,
              //               borderRadius: BorderRadius.circular(10.r),
              //             ),
              //             child: Center(
              //               child: Text(
              //                 'Caretaker',
              //                 style: TextStyle(
              //                   color: _authController.selectedRole.value == 'caretaker'
              //                       ? Colors.white
              //                       : Colors.grey,
              //                   fontWeight: FontWeight.w600,
              //                   fontSize: 14.sp,
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // )),
              Container(
  decoration: BoxDecoration(
    color: const Color(0xFFF5F5F5),
    borderRadius: BorderRadius.circular(10.r),
  ),
  child: Row(
    children: [
      _buildRoleButton("Patient", AppConstants.patientRole),
      //_buildRoleButton("Caretaker", AppConstants.caretakerRole),
      _buildRoleButton("Seller", AppConstants.sellerRole),
    ],
  ),
),

              SizedBox(height: 32.h),
              
              // Register Button
              Obx(() => CustomButton(
                text: 'REGISTER',
                isLoading: _authController.isLoading.value,
                onPressed: () {
                  _authController.register();
                },
              )),
              
              SizedBox(height: 24.h),
              
              // Login Link
              Center(
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.sp,
                      ),
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            color: const Color(0xFF2D9CDB),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
Widget _buildRoleButton(String title, String role) {
  final AuthController _authController = Get.find<AuthController>();

  return Expanded(
    child: Obx(() {
      final bool isSelected = _authController.selectedRole.value == role;

      return GestureDetector(
        onTap: () {
          _authController.selectedRole.value = role;
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF2D9CDB)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
      );
    }),
  );
}

