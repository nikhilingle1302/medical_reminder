// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'firebase_options.dart';
// import 'core/routes/app_pages.dart';
// import 'core/routes/app_routes.dart';
// import 'core/services/services.dart';
// import 'core/theme/app_theme.dart';


// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
// );
//   // Initialize GetStorage
//   await GetStorage.init();
  
//   // Initialize Firebase
//   await FirebaseService.initialize();
  
//   // Initialize Notification Service
//   await NotificationService.initialize();
  
//   // Set preferred orientations
//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);
  
//   // Set system UI overlay style
//   SystemChrome.setSystemUIOverlayStyle(
//     const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.dark,
//       systemNavigationBarColor: Colors.white,
//       systemNavigationBarIconBrightness: Brightness.dark,
//     ),
//   );
  
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(375, 812), // iPhone X design size
//       minTextAdapt: true,
//       splitScreenMode: true,
//       builder: (context, child) {
//         return GetMaterialApp(
//           title: 'Medical Reminder',
//           debugShowCheckedModeBanner: false,
//           theme: AppTheme.lightTheme,
//           initialRoute: AppRoutes.SPLASH,
//           getPages: AppPages.pages,
//           defaultTransition: Transition.cupertino,
//           transitionDuration: const Duration(milliseconds: 300),
//           builder: (context, widget) {
//             // Ensure text scale factor is always 1.0
//             return MediaQuery(
//               data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
//               child: widget!,
//             );
//           },
//         );
//       },
//     );
//   }
// }