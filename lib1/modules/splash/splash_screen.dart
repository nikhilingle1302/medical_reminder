import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../auth/auth_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // Wait for 2 seconds
    await Future.delayed(const Duration(seconds: 2));
    
    // Check login status
    final AuthController authController = Get.put(AuthController());
    authController.checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Medical Icon
            Container(
              width: 150.w,
              height: 150.h,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Icon(
                Icons.medical_services,
                size: 80.sp,
                color: Colors.blue,
              ),
            ),
            
            SizedBox(height: 30.h),
            
            // Title
            Text(
              'MEDICAL REMINDER',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            
            SizedBox(height: 8.h),
            
            Text(
              'SYSTEM',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
            
            SizedBox(height: 50.h),
            
            // Loading Indicator
            const CircularProgressIndicator(
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}

// class SplashScreen extends StatelessWidget {
//   SplashScreen({Key? key}) : super(key: key);

//   final AuthController controller = Get.put(AuthController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 150.w,
//               height: 150.h,
//               decoration: BoxDecoration(
//                 color: Colors.blue.shade50,
//                 borderRadius: BorderRadius.circular(30.r),
//               ),
//               child: Icon(
//                 Icons.medical_services,
//                 size: 80.sp,
//                 color: Colors.blue,
//               ),
//             ),
//             SizedBox(height: 30.h),
//             Text(
//               'MEDICAL REMINDER',
//               style: TextStyle(
//                 fontSize: 24.sp,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             SizedBox(height: 8.h),
//             Text(
//               'SYSTEM',
//               style: TextStyle(
//                 fontSize: 18.sp,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.black54,
//               ),
//             ),
//             SizedBox(height: 50.h),
//             const CircularProgressIndicator(),
//           ],
//         ),
//       ),
//     );
//   }
// }