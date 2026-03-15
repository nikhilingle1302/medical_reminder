import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medical_reminder/core/constants/app_constants.dart';
import 'package:medical_reminder/core/routes/app_pages.dart';
import 'package:medical_reminder/presentation/controllers/auth_controller.dart';
import 'package:medical_reminder/presentation/widgets/custom_button.dart';

import '../../widgets/custom_text_field.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController _authController = Get.find<AuthController>();
  final RxBool _isPatientLogin = true.obs;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 80.h),
              
              // Logo/Title
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D9CDB).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Icon(
                        Icons.medical_services,
                        size: 40.sp,
                        color: const Color(0xFF2D9CDB),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'MEDICAL REMINDER',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2D9CDB),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Stay Healthy, Stay Reminded',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 60.h),
              
              // Login Type Selector
              // Container(
              //   decoration: BoxDecoration(
              //     color: const Color(0xFFF5F5F5),
              //     borderRadius: BorderRadius.circular(10.r),
              //   ),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: Obx(() => GestureDetector(
              //           onTap: () => _isPatientLogin.value = true,
              //           child: Container(
              //             padding: EdgeInsets.symmetric(vertical: 12.h),
              //             decoration: BoxDecoration(
              //               color: _isPatientLogin.value
              //                   ? const Color(0xFF2D9CDB)
              //                   : Colors.transparent,
              //               borderRadius: BorderRadius.circular(10.r),
              //             ),
              //             child: Center(
              //               child: Text(
              //                 'Patient Login',
              //                 style: TextStyle(
              //                   color: _isPatientLogin.value
              //                       ? Colors.white
              //                       : Colors.grey,
              //                   fontWeight: FontWeight.w600,
              //                   fontSize: 14.sp,
              //                 ),
              //               ),
              //             ),
              //           ),
              //         )),
              //       ),
              //       Expanded(
              //         child: Obx(() => GestureDetector(
              //           onTap: () => _isPatientLogin.value = false,
              //           child: Container(
              //             padding: EdgeInsets.symmetric(vertical: 12.h),
              //             decoration: BoxDecoration(
              //               color: !_isPatientLogin.value
              //                   ? const Color(0xFF2D9CDB)
              //                   : Colors.transparent,
              //               borderRadius: BorderRadius.circular(10.r),
              //             ),
              //             child: Center(
              //               child: Text(
              //                 'Caretaker Login',
              //                 style: TextStyle(
              //                   color: !_isPatientLogin.value
              //                       ? Colors.white
              //                       : Colors.grey,
              //                   fontWeight: FontWeight.w600,
              //                   fontSize: 14.sp,
              //                 ),
              //               ),
              //             ),
              //           ),
              //         )),
              //       ),
              //     ],
              //   ),
              // ),
Container(
  decoration: BoxDecoration(
    color: const Color(0xFFF5F5F5),
    borderRadius: BorderRadius.circular(10.r),
  ),
  child: Row(
    children: [
      _buildRoleButton("Patient", AppConstants.patientRole),
      _buildRoleButton("Caretaker", AppConstants.caretakerRole),
      _buildRoleButton("Seller", AppConstants.sellerRole),
    ],
  ),
),


              SizedBox(height: 32.h),
              
              // Username/Email Field
              Text(
                'Username',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),
              CustomTextField(
                controller: _authController.usernameController,
                hintText: 'Enter your username',
                prefixIconData: Icons.person_outline,
              ),
              
              SizedBox(height: 20.h),
              
              // Password Field
              Text(
                'Password',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),
              CustomTextField(
                controller: _authController.passwordController,
                hintText: 'Enter your password',
                prefixIconData: Icons.lock_outline,
                isPassword: true,
              ),
              
              SizedBox(height: 8.h),
              
              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Get.snackbar(
                      'Info',
                      'Please contact administrator to reset password',
                      backgroundColor: Colors.blue,
                      colorText: Colors.white,
                    );
                  },
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: const Color(0xFF2D9CDB),
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 32.h),
              
              // Login Button
              Obx(() => CustomButton(
                text: 'LOGIN',
                isLoading: _authController.isLoading.value,
                onPressed: () {
                  if (_authController.usernameController.text.isEmpty ||
                      _authController.passwordController.text.isEmpty) {
                    Get.snackbar(
                      'Error',
                      'Please enter username and password',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }
                  //_authController.login(isPatient: _isPatientLogin.value);
                  _authController.login(role: _authController.selectedRole.value);

                },
              )),
              
              SizedBox(height: 24.h),
              
              // Register Link
              Center(
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(AppPages.register);
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Don\'t have an account? ',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.sp,
                      ),
                      children: [
                        TextSpan(
                          text: 'Register',
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


// class LoginScreen extends StatelessWidget {
//   final AuthController _authController = Get.find();
//   final RxBool _isPatientLogin = true.obs;

//   LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 24.w),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 80.h),
              
//               // Logo/Title
//               Center(
//                 child: Column(
//                   children: [
//                     Text(
//                       'MEDICAL REMINDER SYSTEM',
//                       style: TextStyle(
//                         fontSize: 24.sp,
//                         fontWeight: FontWeight.bold,
//                         color: const Color(0xFF2D9CDB),
//                       ),
//                     ),
//                     SizedBox(height: 8.h),
//                     Text(
//                       'Stay Healthy, Stay Reminded',
//                       style: TextStyle(
//                         fontSize: 14.sp,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
              
//               SizedBox(height: 60.h),
              
//               // Login Type Selector
//               Container(
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF5F5F5),
//                   borderRadius: BorderRadius.circular(10.r),
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Obx(() => GestureDetector(
//                         onTap: () => _isPatientLogin.value = true,
//                         child: Container(
//                           padding: EdgeInsets.symmetric(vertical: 12.h),
//                           decoration: BoxDecoration(
//                             color: _isPatientLogin.value
//                                 ? const Color(0xFF2D9CDB)
//                                 : Colors.transparent,
//                             borderRadius: BorderRadius.circular(10.r),
//                           ),
//                           child: Center(
//                             child: Text(
//                               'Patient Login',
//                               style: TextStyle(
//                                 color: _isPatientLogin.value
//                                     ? Colors.white
//                                     : Colors.grey,
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 14.sp,
//                               ),
//                             ),
//                           ),
//                         ),
//                       )),
//                     ),
//                     Expanded(
//                       child: Obx(() => GestureDetector(
//                         onTap: () => _isPatientLogin.value = false,
//                         child: Container(
//                           padding: EdgeInsets.symmetric(vertical: 12.h),
//                           decoration: BoxDecoration(
//                             color: !_isPatientLogin.value
//                                 ? const Color(0xFF2D9CDB)
//                                 : Colors.transparent,
//                             borderRadius: BorderRadius.circular(10.r),
//                           ),
//                           child: Center(
//                             child: Text(
//                               'Caretaker Login',
//                               style: TextStyle(
//                                 color: !_isPatientLogin.value
//                                     ? Colors.white
//                                     : Colors.grey,
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 14.sp,
//                               ),
//                             ),
//                           ),
//                         ),
//                       )),
//                     ),
//                   ],
//                 ),
//               ),
              
//               SizedBox(height: 32.h),
              
//               Text(
//                 'Email / Username',
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.black87,
//                 ),
//               ),
//               SizedBox(height: 8.h),
//               CustomTextField(
//                 controller: _authController.usernameController,
//                 hintText: 'Enter your username',
//                 prefixIcon: Icon(Icons.person_outline),
//               ),
              
//               SizedBox(height: 20.h),
              
//               Text(
//                 'Password',
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.black87,
//                 ),
//               ),
//               SizedBox(height: 8.h),
//               CustomTextField(
//                 controller: _authController.passwordController,
//                 hintText: 'Enter your password',
//                 prefixIcon: Icon(Icons.lock_outline),
//                 isPassword: true,
//               ),
              
//               SizedBox(height: 8.h),
              
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: TextButton(
//                   onPressed: () {
//                     // Forgot password
//                   },
//                   child: Text(
//                     'Forgot password?',
//                     style: TextStyle(
//                       color: const Color(0xFF2D9CDB),
//                       fontSize: 14.sp,
//                     ),
//                   ),
//                 ),
//               ),
              
//               SizedBox(height: 32.h),
              
//               Obx(() => CustomButton(
//                 text: 'LOGIN',
//                 isLoading: _authController.isLoading.value,
//                 onPressed: () {
//                   _authController.login(isPatient: _isPatientLogin.value);
//                 },
//               )),
              
//               SizedBox(height: 24.h),
              
//               Center(
//                 child: GestureDetector(
//                   onTap: () {
//                     Get.toNamed('/register');
//                   },
//                   child: RichText(
//                     text: TextSpan(
//                       text: 'Don\'t have an account? ',
//                       style: TextStyle(
//                         color: Colors.grey,
//                         fontSize: 14.sp,
//                       ),
//                       children: [
//                         TextSpan(
//                           text: 'Register',
//                           style: TextStyle(
//                             color: const Color(0xFF2D9CDB),
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
              
//               SizedBox(height: 40.h),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
