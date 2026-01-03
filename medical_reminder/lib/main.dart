import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:medical_reminder/core/app_bindings.dart';
import 'package:medical_reminder/core/routes/app_pages.dart';
import 'package:medical_reminder/core/theme/app_theme.dart';
import 'package:medical_reminder/data/services/notification_service.dart';
import 'package:medical_reminder/firebase_options.dart';
import 'package:medical_reminder/presentation/controllers/auth_controller.dart';
import 'package:medical_reminder/presentation/screens/auth/login_screen.dart';
import 'package:medical_reminder/presentation/screens/caretaker/caretaker_dashboard.dart';
import 'package:medical_reminder/presentation/screens/dashboard/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage FIRST
  await GetStorage.init();
  
  // Initialize Firebase ONCE
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize ScreenUtil
  await ScreenUtil.ensureScreenSize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          title: 'Medical Reminder',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
          initialBinding: AppBindings(),
          initialRoute: AppPages.initial,
          getPages: AppPages.routes,
          defaultTransition: Transition.cupertino,
          home: FutureBuilder(
            future: _initializeApp(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SplashScreen();
              }
              return const AuthWrapper();
            },
          ),
        );
      },
    );
  }
  
  Future<void> _initializeApp() async {
    // Add a small delay for splash screen
    await Future.delayed(const Duration(seconds: 1));
    
    // Get auth controller and check login status
    final authController = Get.find<AuthController>();
    await authController.checkLoginStatus();
     await Get.find<NotificationService>().initialize();
    // Optional: You can add other initialization here
    return;
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    
    return Obx(() {
      print('🔄 AuthWrapper rebuild - isLoggedIn: ${authController.isLoggedIn.value}');
      
      if (authController.isLoggedIn.value) {
        return const DashboardWrapper();
      } else {
        return LoginScreen();
      }
    });
  }
}

class DashboardWrapper extends StatelessWidget {
  const DashboardWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    
    return Obx(() {
      if (authController.isCaretaker()) {
        return CaretakerDashboardScreen();
      } else {
        return DashboardScreen();
      }
    });
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D9CDB),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Icon(
                Icons.medical_services,
                size: 60.sp,
                color: const Color(0xFF2D9CDB),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Medical Reminder',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'Stay Healthy, Stay Reminded',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            SizedBox(height: 40.h),
            const CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}