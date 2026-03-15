import 'package:get/get.dart';
import 'package:medical_reminder/core/constants/app_constants.dart';
import 'package:medical_reminder/main.dart';
import 'package:medical_reminder/presentation/controllers/auth_controller.dart';
import 'package:medical_reminder/presentation/screens/auth/login_screen.dart';
import 'package:medical_reminder/presentation/screens/bmi_calculator/calculator_screen.dart';
import 'package:medical_reminder/presentation/screens/caretaker/caretaker_dashboard.dart';
import 'package:medical_reminder/presentation/screens/chat_bot/chatbot.dart';
import 'package:medical_reminder/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:medical_reminder/presentation/screens/pharmacy/pharmacy_dashboard.dart';
import 'package:medical_reminder/presentation/screens/profile/profile_screen.dart';
import 'package:medical_reminder/presentation/screens/reminders/add_reminder_screen.dart';
import 'package:medical_reminder/presentation/screens/reminders/reminder_details_screen.dart';

import '../../presentation/screens/auth/register_screen.dart';

abstract class AppPages {
  static const String initial = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String addReminder = '/add-reminder';
  static const String reminderDetail = '/reminder-detail';
  static const String profile = '/profile';
  static const String chatBot = '/chat-bot';
  static const String bmiCalculator = '/bmi-calculator';

  static final routes = [
    GetPage(
      name: initial,
      page: () => SplashScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: login,
      page: () => LoginScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: register,
      page: () => RegisterScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: dashboard,
      page: () {
        final authController = Get.find<AuthController>();
             final role = authController.userRole.value.trim().toLowerCase();

     

      if (role == AppConstants.caretakerRole.toLowerCase()) {
        return CaretakerDashboardScreen();
      } else if (role == AppConstants.sellerRole.toLowerCase()) {
        return SellerDashboardScreen();
      } else {
        return DashboardScreen();
      }
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: addReminder,
      page: () => AddReminderScreen(),
      transition: Transition.rightToLeft,
    ),
GetPage(
  name: '$reminderDetail/:id',  // Add parameter
  page: () => ReminderDetailScreen(),
  transition: Transition.rightToLeft,
),
    GetPage(
      name: profile,
      page: () => ProfileScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: chatBot,
      page: () => MedicalChatScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: bmiCalculator,
      page: () => CalculatorScreen(),
      transition: Transition.rightToLeft,
    ),
  ];
}