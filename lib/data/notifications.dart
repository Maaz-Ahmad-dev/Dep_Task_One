import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> onNotificationReceieved(
      NotificationResponse notificationResponse) async {}

  static Future<void> init() async {
    //Andriod initilization
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("ic_launcher");

    //Initialization
    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    //Plugin Initialize
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationReceieved,
        onDidReceiveBackgroundNotificationResponse: onNotificationReceieved);

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

// Show NOtification
  static Future<void> showNotification(String title, String body) async {
    const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails("channelId", "channelName",
            priority: Priority.high, importance: Importance.high));

    await _flutterLocalNotificationsPlugin.show(
        0, title, body, notificationDetails);
  }

  // Schedule NOtification
  static Future<void> scheduleNotification(
      int id, String title, String body, DateTime scheduledDate) async {
    const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails("channelId", "channelName",
            priority: Priority.high, importance: Importance.high));

    await _flutterLocalNotificationsPlugin.zonedSchedule(id, title, body,
        tz.TZDateTime.from(scheduledDate, tz.local), notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime);
  }

  //Reminder after every
  // static Future<void> reminderNotification(
  //   String title,
  //   String body,
  // ) async {
  //   const NotificationDetails notificationDetails = NotificationDetails(
  //       android: AndroidNotificationDetails("channelId", "channelName",
  //           priority: Priority.high, importance: Importance.high));

  //   await _flutterLocalNotificationsPlugin.periodicallyShow(
  //       0, title, body, RepeatInterval.hourly, notificationDetails);
  // }

  // Delete Reminder
  static Future<void> removeNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }
}
