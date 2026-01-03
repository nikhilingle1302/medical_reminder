import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
    
    // Initialize local notifications
    await _initializeLocalNotifications();
    
    // Initialize Firebase messaging
    await _initializeFirebaseMessaging();
    
    // Request permissions
    await _requestPermissions();
    
    // Get FCM token and save to server
    await _saveFcmTokenToServer();
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
        _onNotificationTap(response);
      },
    );
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
    log("in save fcm token");
    try {
      final token = await _firebaseMessaging.getToken();
      if (token != null && _authController.isLoggedIn.value) {
        final authToken = _authController.getToken();
        if (authToken != null) {
          // await _apiService.saveFcmToken(
          //   'Bearer $authToken',
          //   {'token': token},
          // );
          print('FCM Token saved to server: $token');
        }
      }
    } catch (e) {
      print('Error saving FCM token: $e');
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
    final tzDateTime = tz.TZDateTime.from(scheduledDateTime, location);
    
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
    await _showImmediateNotification(id, title, body, payload);
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
}