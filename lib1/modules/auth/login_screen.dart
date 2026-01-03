import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';
import '../../core/routes/app_routes.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  // Use Get.find() if controller already exists, otherwise Get.put()
  final AuthController controller = Get.isRegistered<AuthController>() 
      ? Get.find<AuthController>() 
      : Get.put(AuthController());
      
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 80.h),
              
              // Medical Icon
              Container(
                width: 120.w,
                height: 120.h,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Icon(
                  Icons.medical_services,
                  size: 70.sp,
                  color: Colors.blue,
                ),
              ),
              
              SizedBox(height: 30.h),
              
              // Title
              Text(
                'MEDICAL\nREMINDER',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  height: 1.2,
                ),
              ),
              
              SizedBox(height: 8.h),
              
              Text(
                'SYSTEM',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              
              SizedBox(height: 50.h),
              
              // Email/Username Field
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'example@email.com',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black54,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 16.h),
              
              // Password Field
              Obx(() => Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: TextField(
                  controller: passwordController,
                  obscureText: !controller.isPasswordVisible.value,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: '••••••••',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black54,
                      fontSize: 14.sp,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                  ),
                ),
              )),
              
              SizedBox(height: 12.h),
              
              // Forget Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Get.snackbar(
                      'Info',
                      'Password reset feature coming soon',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  child: Text(
                    'Forget password?',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 20.h),
              
              // Login Button
              Obx(() => SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                          controller.login(
                            usernameController.text.trim(),
                            passwordController.text,
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    disabledBackgroundColor: Colors.blue.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: controller.isLoading.value
                      ? SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              )),
              
              SizedBox(height: 24.h),
              
              // Register Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14.sp,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.REGISTER),
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
// class LoginScreen extends StatelessWidget {
//   LoginScreen({Key? key}) : super(key: key);

//   final AuthController controller = Get.put(AuthController());
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: 24.w),
//           child: Column(
//             children: [
//               SizedBox(height: 80.h),
              
//               // Medical Icon
//               Container(
//                 width: 120.w,
//                 height: 120.h,
//                 decoration: BoxDecoration(
//                   color: Colors.blue.shade50,
//                   borderRadius: BorderRadius.circular(20.r),
//                 ),
//                 child: Icon(
//                   Icons.medical_services,
//                   size: 70.sp,
//                   color: Colors.blue,
//                 ),
//               ),
              
//               SizedBox(height: 30.h),
              
//               // Title
//               Text(
//                 'MEDICAL\nREMINDER',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 28.sp,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                   height: 1.2,
//                 ),
//               ),
              
//               SizedBox(height: 8.h),
              
//               Text(
//                 'SYSTEM',
//                 style: TextStyle(
//                   fontSize: 20.sp,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.black54,
//                 ),
//               ),
              
//               SizedBox(height: 50.h),
              
//               // Email/Username Field
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade100,
//                   borderRadius: BorderRadius.circular(12.r),
//                 ),
//                 child: TextField(
//                   controller: usernameController,
//                   decoration: InputDecoration(
//                     labelText: 'Email',
//                     hintText: 'example@email.com',
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.symmetric(
//                       horizontal: 16.w,
//                       vertical: 16.h,
//                     ),
//                     labelStyle: TextStyle(
//                       color: Colors.black54,
//                       fontSize: 14.sp,
//                     ),
//                   ),
//                 ),
//               ),
              
//               SizedBox(height: 16.h),
              
//               // Password Field
//               Obx(() => Container(
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade100,
//                   borderRadius: BorderRadius.circular(12.r),
//                 ),
//                 child: TextField(
//                   controller: passwordController,
//                   obscureText: !controller.isPasswordVisible.value,
//                   decoration: InputDecoration(
//                     labelText: 'Password',
//                     hintText: '••••••••',
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.symmetric(
//                       horizontal: 16.w,
//                       vertical: 16.h,
//                     ),
//                     labelStyle: TextStyle(
//                       color: Colors.black54,
//                       fontSize: 14.sp,
//                     ),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         controller.isPasswordVisible.value
//                             ? Icons.visibility
//                             : Icons.visibility_off,
//                         color: Colors.grey,
//                       ),
//                       onPressed: controller.togglePasswordVisibility,
//                     ),
//                   ),
//                 ),
//               )),
              
//               SizedBox(height: 12.h),
              
//               // Forget Password
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: TextButton(
//                   onPressed: () {},
//                   child: Text(
//                     'Forget password?',
//                     style: TextStyle(
//                       color: Colors.blue,
//                       fontSize: 14.sp,
//                     ),
//                   ),
//                 ),
//               ),
              
//               SizedBox(height: 20.h),
              
//               // Login Button
//               Obx(() => SizedBox(
//                 width: double.infinity,
//                 height: 50.h,
//                 child: ElevatedButton(
//                   onPressed: controller.isLoading.value
//                       ? null
//                       : () {
//                           controller.login(
//                             usernameController.text,
//                             passwordController.text,
//                           );
//                         },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12.r),
//                     ),
//                     elevation: 0,
//                   ),
//                   child: controller.isLoading.value
//                       ? SizedBox(
//                           width: 20.w,
//                           height: 20.h,
//                           child: const CircularProgressIndicator(
//                             color: Colors.white,
//                             strokeWidth: 2,
//                           ),
//                         )
//                       : Text(
//                           'LOGIN',
//                           style: TextStyle(
//                             fontSize: 16.sp,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                 ),
//               )),
              
//               SizedBox(height: 24.h),
              
//               // Register Link
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Don't have an account? ",
//                     style: TextStyle(
//                       color: Colors.black54,
//                       fontSize: 14.sp,
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () => Get.toNamed(AppRoutes.REGISTER),
//                     child: Text(
//                       'Register',
//                       style: TextStyle(
//                         color: Colors.blue,
//                         fontSize: 14.sp,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }