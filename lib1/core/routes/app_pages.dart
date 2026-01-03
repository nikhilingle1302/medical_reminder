import 'package:get/get.dart';
import 'app_routes.dart';
import '../../modules/profile/profile_screen.dart';
import '../../modules/auth/login_screen.dart';
import '../../modules/auth/register_screen.dart';
import '../../modules/calendar/calendar_screen.dart';
import '../../modules/home/home_screen.dart';
import '../../modules/medicines/medicines_screen.dart';
import '../../modules/reminders/add_reminder_screen.dart';
import '../../modules/reminders/reminders_screen.dart';
import '../../modules/splash/splash_screen.dart';


class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.REGISTER,
      page: () => RegisterScreen(),
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomeScreen(),
    ),
    GetPage(
      name: AppRoutes.REMINDERS,
      page: () => RemindersScreen(),
    ),
    GetPage(
      name: AppRoutes.ADD_REMINDER,
      page: () => const AddReminderScreen(),
    ),
    GetPage(
      name: AppRoutes.MEDICINES,
      page: () => MedicinesScreen(),
    ),
    GetPage(
      name: AppRoutes.CALENDAR,
      page: () => CalendarScreen(),
    ),
    GetPage(
      name: AppRoutes.PROFILE,
      page: () => ProfileScreen(),
    ),
  ];
}
