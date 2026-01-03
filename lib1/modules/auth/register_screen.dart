import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  // Use existing controller if available
  final AuthController controller = Get.isRegistered<AuthController>() 
      ? Get.find<AuthController>() 
      : Get.put(AuthController());
      
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 40.h),
              
              // Medical Icon
              Container(
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Icon(
                  Icons.medical_services,
                  size: 60.sp,
                  color: Colors.blue,
                ),
              ),
              
              SizedBox(height: 25.h),
              
              Text(
                'MEDICAL\nREMINDER',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  height: 1.2,
                ),
              ),
              
              SizedBox(height: 6.h),
              
              Text(
                'SYSTEM',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              
              SizedBox(height: 40.h),
              
              // Username Field
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
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
              
              // Email Field
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
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
              
              SizedBox(height: 24.h),
              
              // Role Selection
              Obx(() => Row(
                children: [
                  Expanded(
                    child: _buildRoleOption('Patient', 'patient'),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: _buildRoleOption('Caretaker', 'caretaker'),
                  ),
                ],
              )),
              
              SizedBox(height: 30.h),
              
              // Register Button
              Obx(() => SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                          controller.register(
                            usernameController.text.trim(),
                            passwordController.text,
                            //emailController.text.trim(),
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
                          'REGISTER',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              )),
              
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleOption(String label, String value) {
    final isSelected = controller.selectedRole.value == value;
    
    return GestureDetector(
      onTap: () => controller.setRole(value),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}

// class RegisterScreen extends StatelessWidget {
//   RegisterScreen({Key? key}) : super(key: key);

//   final AuthController controller = Get.find();
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Get.back(),
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: 24.w),
//           child: Column(
//             children: [
//               SizedBox(height: 40.h),
              
//               // Medical Icon
//               Container(
//                 width: 100.w,
//                 height: 100.h,
//                 decoration: BoxDecoration(
//                   color: Colors.blue.shade50,
//                   borderRadius: BorderRadius.circular(20.r),
//                 ),
//                 child: Icon(
//                   Icons.medical_services,
//                   size: 60.sp,
//                   color: Colors.blue,
//                 ),
//               ),
              
//               SizedBox(height: 25.h),
              
//               Text(
//                 'MEDICAL\nREMINDER',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 24.sp,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                   height: 1.2,
//                 ),
//               ),
              
//               SizedBox(height: 6.h),
              
//               Text(
//                 'SYSTEM',
//                 style: TextStyle(
//                   fontSize: 18.sp,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.black54,
//                 ),
//               ),
              
//               SizedBox(height: 40.h),
              
//               // Username Field
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade100,
//                   borderRadius: BorderRadius.circular(12.r),
//                 ),
//                 child: TextField(
//                   controller: usernameController,
//                   decoration: InputDecoration(
//                     labelText: 'Username',
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.symmetric(
//                       horizontal: 16.w,
//                       vertical: 16.h,
//                     ),
//                   ),
//                 ),
//               ),
              
//               SizedBox(height: 16.h),
              
//               // Email Field
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade100,
//                   borderRadius: BorderRadius.circular(12.r),
//                 ),
//                 child: TextField(
//                   controller: emailController,
//                   keyboardType: TextInputType.emailAddress,
//                   decoration: InputDecoration(
//                     labelText: 'Email',
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.symmetric(
//                       horizontal: 16.w,
//                       vertical: 16.h,
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
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.symmetric(
//                       horizontal: 16.w,
//                       vertical: 16.h,
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
              
//               SizedBox(height: 30.h),
              
//               // Register Button
//               Obx(() => SizedBox(
//                 width: double.infinity,
//                 height: 50.h,
//                 child: ElevatedButton(
//                   onPressed: controller.isLoading.value
//                       ? null
//                       : () {
//                           controller.register(
//                             usernameController.text,
//                             passwordController.text,
//                             emailController.text,
//                           );
//                         },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12.r),
//                     ),
//                   ),
//                   child: controller.isLoading.value
//                       ? const CircularProgressIndicator(color: Colors.white)
//                       : Text(
//                           'REGISTER',
//                           style: TextStyle(
//                             fontSize: 16.sp,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                 ),
//               )),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }