import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Firebase Service
class FirebaseService {
  static FirebaseMessaging? _messaging;
  
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
      _messaging = FirebaseMessaging.instance;
      
      // Request permission
      await _requestPermission();
      
      // Get FCM token
      final token = await _messaging!.getToken();
      print('FCM Token: $token');
      
      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      
      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    } catch (e) {
      print('Firebase initialization error: $e');
    }
  }
  
  static Future<void> _requestPermission() async {
    final settings = await _messaging!.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('Permission status: ${settings.authorizationStatus}');
  }
  
  static Future<String?> getToken() async {
    return await _messaging?.getToken();
  }
  
  static void _handleForegroundMessage(RemoteMessage message) {
    print('Foreground message: ${message.notification?.title}');
    NotificationService.showNotification(
      title: message.notification?.title ?? 'Reminder',
      body: message.notification?.body ?? '',
    );
  }
}

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Background message: ${message.notification?.title}');
}

// Notification Service
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  
  static Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
  }
  
  static void _onNotificationTap(NotificationResponse response) {
    print('Notification tapped: ${response.payload}');
  }
  
  static Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'medical_reminder_channel',
      'Medical Reminders',
      channelDescription: 'Notifications for medication reminders',
      importance: Importance.high,
      priority: Priority.high,
    );
    
    const iosDetails = DarwinNotificationDetails();
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notifications.show(
      DateTime.now().millisecond,
      title,
      body,
      details,
      payload: payload,
    );
  }
  
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'medical_reminder_channel',
      'Medical Reminders',
      channelDescription: 'Notifications for medication reminders',
      importance: Importance.high,
      priority: Priority.high,
    );
    
    const iosDetails = DarwinNotificationDetails();
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    // await _notifications.zonedSchedule(
    //   id,
    //   title,
    //   body,
    //   scheduledDate.toLocal(),
    //   details,
    //   androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    //   uiLocalNotificationDateInterpretation:
    //       UILocalNotificationDateInterpretation.absoluteTime,
    // );
  }
}