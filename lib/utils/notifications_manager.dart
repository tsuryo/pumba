import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationsManager {
  final FlutterLocalNotificationsPlugin _notificationsPlugin;

  NotificationsManager()
      : _notificationsPlugin = FlutterLocalNotificationsPlugin() {
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();
    const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings, iOS: initializationSettingsDarwin);

    await _notificationsPlugin.initialize(initSettings);
  }

  Future<bool?> _requestNotificationPermission() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    final isGranted = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    return isGranted;
  }

  Future<DateTime?> scheduleNotification() async {
    await _requestNotificationPermission();
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'pumba_channel_id',
      'Pumba Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    DateTime scheduleTime = DateTime.now().add(
      Duration(minutes: 2),
    );
    final tz.TZDateTime scheduledTZTime = tz.TZDateTime.from(
      scheduleTime,
      tz.local,
    );

    await _notificationsPlugin.zonedSchedule(
      123,
      'Pumba notification',
      'This is our Pumba Notification!',
      scheduledTZTime,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
    return scheduleTime;
  }
}
