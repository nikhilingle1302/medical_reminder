import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:get/get.dart';
import 'package:medical_reminder/data/models/reminder_model.dart';
import 'package:medical_reminder/data/services/api_service.dart';
import 'package:medical_reminder/presentation/controllers/auth_controller.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late FlutterLocalNotificationsPlugin _localNotificationsPlugin;
  final AuthController _authController = Get.find<AuthController>();
  final ApiService _apiService = Get.find();

  Future<void> initialize() async {
    log("in initialize notification service");
    
    // Initialize timezone
    tz.initializeTimeZones();

  tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
    // Initialize local notifications
    await _initializeLocalNotifications();
    
    // Initialize Firebase messaging
    await _initializeFirebaseMessaging();
    
    // Request permissions
    await _requestPermissions();
    
    // Get FCM token and save to server
    await _saveFcmTokenToServer();
  }

  // Future<void> _initializeLocalNotifications() async {
  //   const AndroidInitializationSettings androidInitializationSettings =
  //       AndroidInitializationSettings('@mipmap/ic_launcher');
    
  //   const DarwinInitializationSettings iosInitializationSettings =
  //       DarwinInitializationSettings(
  //     requestAlertPermission: true,
  //     requestBadgePermission: true,
  //     requestSoundPermission: true,
  //   );
    
  //   const InitializationSettings initializationSettings =
  //       InitializationSettings(
  //     android: androidInitializationSettings,
  //     iOS: iosInitializationSettings,
  //   );

  //   _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  //   await _localNotificationsPlugin.initialize(
  //     initializationSettings,
  //     onDidReceiveNotificationResponse: (NotificationResponse response) {
  //       // Handle notification tap
  //       _onNotificationTap(response);
  //     },
  //   );
  // }
  Future<void> _initializeLocalNotifications() async {
  _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// ---------------- ANDROID INITIALIZATION ----------------
  const AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  /// ---------------- iOS INITIALIZATION ----------------
  const DarwinInitializationSettings iosInitializationSettings =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  /// ---------------- GENERAL INITIALIZATION ----------------
  const InitializationSettings initializationSettings =
      InitializationSettings(
    android: androidInitializationSettings,
    iOS: iosInitializationSettings,
  );

  await _localNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      if (response.payload != null) {
        try {
          final data = json.decode(response.payload!);
          _navigateToReminderScreen(data);
        } catch (e) {
          print("❌ Error parsing notification payload: $e");
        }
      }
    },
  );

  /// ---------------- ANDROID CHANNEL CREATION ----------------
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'medication_channel_id', // MUST match your notification id
    'Medication Reminders',
    description: 'Notifications for medication reminders',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );

  final androidPlugin = _localNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  if (androidPlugin != null) {
    await androidPlugin.createNotificationChannel(channel);
  }

  print("✅ Local notification initialized successfully");
}


  Future<void> _initializeFirebaseMessaging() async {
    // Configure Firebase messaging
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Handle messages when app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showFirebaseNotification(message);
    });

    // Handle messages when app is in background/terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleBackgroundMessage(message);
    });
  }

  Future<void> _requestPermissions() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    }
  }

Future<void> _saveFcmTokenToServer() async {
  print('🔑 Attempting to get FCM token...');
  try {
    // First, check Firebase app is initialized
    if (Firebase.apps.isEmpty) {
      print('❌ Firebase not initialized!');
      return;
    }
    
    // Get FCM token
    final token = await _firebaseMessaging.getToken();
    print('📱 FCM Token: ${token ?? "NULL"}');
    
    if (token != null) {
      print('✅ FCM token obtained: ${token.substring(0, 20)}...');
      
      if (_authController.isLoggedIn.value) {
        final authToken = _authController.getToken();
        if (authToken != null) {
          print('📤 Saving FCM token to server...');
          
          await _apiService.saveFcmToken(
           
            {'token': token}
          );
          print('✅ FCM token saved to server');
        } else {
          print('⚠️ No auth token available, saving FCM token locally');
          // Save to local storage for later use
          final storage = GetStorage();
          await storage.write('fcm_token', token);
        }
      } else {
        print('⚠️ User not logged in, saving FCM token locally');
        final storage = GetStorage();
        await storage.write('fcm_token', token);
      }
    } else {
      print('❌ Failed to get FCM token');
    }
  } catch (e) {
    print('❌ Error getting/saving FCM token: $e');
    print('Stack trace: ${e.toString()}');
  }
}

 // In lib/core/services/notification_service.dart
Future<void> scheduleReminderNotification(Reminder reminder) async {
  try {
    // Parse the reminder time string to DateTime
    final reminderTime = _parseReminderTime(reminder.reminderTime);
    
    // Schedule notification 15 minutes before reminder time
    final scheduledTime = reminderTime.subtract(const Duration(minutes: 15));
    
    await _scheduleLocalNotification(
      id: reminder.id,
      title: 'Medication Reminder',
      body: 'Time to take ${reminder.medicineName} - ${reminder.dosage}',
      scheduledDateTime: scheduledTime,
      payload: {
        'type': 'reminder',
        'id': reminder.id.toString(),
        'medicine': reminder.medicineName,
        'dosage': reminder.dosage,
      },
    );
    
    print('Scheduled notification for reminder ${reminder.id} at $scheduledTime');
  } catch (e) {
    print('Error scheduling notification: $e');
  }
}

DateTime _parseReminderTime(String timeString) {
  try {
    // Try parsing with the format from API
    return DateFormat('yyyy-MM-dd HH:mm:ss').parse(timeString);
  } catch (e) {
    // Fallback to parsing with DateTime.parse
    return DateTime.parse(timeString);
  }
}

 Future<void> _scheduleLocalNotification({
  required int id,
  required String title,
  required String body,
  required DateTime scheduledDateTime,
  Map<String, dynamic>? payload,
}) async {
  try {
    // Initialize timezone if not already done
    tz.initializeTimeZones();
    
    // Get local timezone
    final location = tz.getLocation('Asia/Kolkata'); // Or your timezone
    
    // Create notification details
    const androidNotificationDetails = AndroidNotificationDetails(
      'medication_channel_id',
      'Medication Reminders',
      channelDescription: 'Notifications for medication reminders',
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: true,
      playSound: true,
    );
    
    const iosNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    final notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );
    
    // Create timezone aware datetime
   // final tzDateTime = tz.TZDateTime.from(scheduledDateTime, location);
   var tzDateTime = tz.TZDateTime.from(scheduledDateTime, location);

// If time already passed, schedule 5 seconds later (safety fallback)
if (tzDateTime.isBefore(tz.TZDateTime.now(location))) {
  tzDateTime = tz.TZDateTime.now(location).add(const Duration(seconds: 5));
  print("⚠️ Scheduled time was past. Adjusted to $tzDateTime");
}

    
    // Schedule notification
    await _localNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzDateTime,
      notificationDetails,
      payload: payload?.toString(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
    
    print('Notification scheduled for $tzDateTime');
  } catch (e) {
    print('Error scheduling notification: $e');
    // Show immediate notification for debugging
    //await _showImmediateNotification(id, title, body, payload);
  }
}

Future<void> _showImmediateNotification(
  int id,
  String title,
  String body,
  Map<String, dynamic>? payload,
) async {
  const androidNotificationDetails = AndroidNotificationDetails(
    'medication_channel_id',
    'Medication Reminders',
    channelDescription: 'Notifications for medication reminders',
    importance: Importance.max,
    priority: Priority.high,
  );
  
  const iosNotificationDetails = DarwinNotificationDetails();
  
  await _localNotificationsPlugin.show(
    id,
    title,
    body,
    const NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    ),
    payload: payload?.toString(),
  );
}

  Future<void> cancelNotification(int id) async {
    await _localNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _localNotificationsPlugin.cancelAll();
  }

  void _showFirebaseNotification(RemoteMessage message) {
    // Show local notification when Firebase message is received
    _localNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      message.notification?.title ?? 'Medication Reminder',
      message.notification?.body ?? 'New reminder notification',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'medication_channel_id',
          'Medication Reminders',
          channelDescription: 'Notifications for medication reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    // Handle notification tap when app was in background/terminated
    _navigateToReminderScreen(message.data);
  }

  void _onNotificationTap(NotificationResponse response) {
    if (response.payload != null) {
      try {
        // Parse payload and navigate
        final payload = response.payload!;
        _navigateToReminderScreen({'id': payload});
      } catch (e) {
        print('Error parsing notification payload: $e');
      }
    }
  }

  void _navigateToReminderScreen(Map<String, dynamic> data) {
    // Navigate to reminder detail screen
    if (data['type'] == 'reminder' && data['id'] != null) {
      Get.toNamed('/reminder-detail', arguments: {'id': int.parse(data['id'])});
    }
  }

  Future<void> sendTestNotification() async {
    try {
      final token = _authController.getToken();
      if (token != null) {
        //await _apiService.testFcm('Bearer $token');
        Get.snackbar(
          'Success',
          'Test notification sent',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send test notification',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Schedule daily reminder for appointments
  Future<void> scheduleAppointmentReminder({
    required int id,
    required String title,
    required DateTime appointmentTime,
    required String doctorName,
  }) async {
    // Schedule notification 1 hour before appointment
    final reminderTime = appointmentTime.subtract(const Duration(hours: 1));
    
    await _scheduleLocalNotification(
      id: id,
      title: 'Appointment Reminder',
      body: 'You have an appointment with $doctorName in 1 hour',
      scheduledDateTime: reminderTime,
      payload: {
        'type': 'appointment',
        'id': id.toString(),
        'title': title,
        'doctor': doctorName,
      },
    );
  }

  // Add this method to NotificationService class
Future<void> showImmediateReminderCreatedNotification({
  required String medicineName,
  required String dosage,
  String? scheduledTime,
}) async {
  try {
    final now = DateTime.now();
    final notificationId = now.millisecondsSinceEpoch ~/ 1000;
    
    const androidNotificationDetails = AndroidNotificationDetails(
      'reminder_creation_channel',
      'Reminder Creation',
      channelDescription: 'Notifications when reminders are created',
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification_sound'),
    );
    
    const iosNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
    );
    
    final notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );
    
    String body = 'Reminder set for $medicineName ($dosage)';
    if (scheduledTime != null) {
      body += ' at $scheduledTime';
    }
    
    await _localNotificationsPlugin.show(
      notificationId,
      'Reminder Created ✓',
      body,
      notificationDetails,
      payload: json.encode({
        'type': 'reminder_created',
        'medicine': medicineName,
        'dosage': dosage,
        'action': 'view_reminders',
      }),
    );
    
    log('📱 Immediate notification shown for new reminder');
  } catch (e) {
    log('⚠️ Error showing immediate notification: $e');
  }
}

Future<void> scheduleReminderNotificationFromDateTime({
  required int id,
  required String medicineName,
  required String dosage,
  required DateTime scheduledDateTime,
}) async {
  try {
    final now = DateTime.now();

    // Prevent scheduling past notifications
    if (scheduledDateTime.isBefore(now)) {
      log('⚠️ Cannot schedule notification in the past');
      return;
    }

    await _scheduleLocalNotification(
      id: id,
      title: 'Medication Reminder 💊',
      body: 'Time to take $medicineName ($dosage)',
      scheduledDateTime: scheduledDateTime,
      payload: {
        'type': 'reminder',
        'id': id.toString(),
        'medicine': medicineName,
        'dosage': dosage,
      },
    );

    log('✅ Local reminder scheduled at $scheduledDateTime');
  } catch (e) {
    log('❌ Error scheduling local reminder: $e');
  }
}


  // Add this method to NotificationService for testing
// Future<void> debugFCM() async {
//   print('🔍 FCM Debug Information:');
//   print('1. Firebase apps: ${Firebase.apps.length}');
  
//   try {
//     // Check permissions
//     final settings = await _firebaseMessaging.getNotificationSettings();
//     print('2. Notification settings:');
//     print('   - Authorization status: ${settings.authorizationStatus}');
//     print('   - Alert: ${settings.alert}');
//     print('   - Badge: ${settings.badge}');
//     print('   - Sound: ${settings.sound}');
    
//     // Try to get token
//     final token = await _firebaseMessaging.getToken();
//     print('3. FCM Token: ${token ?? "NULL"}');
    
//     // Check if we have a stored token
//     final storage = GetStorage();
//     final storedToken = storage.read('fcm_token');
//     print('4. Stored FCM token: ${storedToken ?? "NULL"}');
    
//     // Check auth status
//     print('5. Auth status:');
//     print('   - Logged in: ${_authController.isLoggedIn.value}');
//     print('   - User ID: ${_authController.userId.value}');
    
//   } catch (e) {
//     print('❌ Debug error: $e');
//   }
// }
}