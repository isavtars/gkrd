import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone_updated_gradle/flutter_native_timezone.dart';
import 'package:gkrd/tools/Reminders/models/task_models.dart';
import 'package:gkrd/tools/Reminders/sql/sql_lite_helper.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationHelper {
  Future<void> initilizationsNotifications() async {
    await configureLocalTimeZone();
    // Init for Android
    var androidInit =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    // Configuring for multiple platforms
    var initSetting = InitializationSettings(
      android: androidInit,
    );

    // Initializing flutterLocalNotifications
    await flutterLocalNotificationsPlugin.initialize(initSetting,
        onDidReceiveNotificationResponse: (NotificationResponse response) {});
  }

  Future<void> displayNotfications(
      {required String title, required String body}) async {
    // Android platform channel specific settings
    AndroidNotificationDetails androidPlatformChannelSpecfic =
        const AndroidNotificationDetails("Todo App", "Todo App",
            importance: Importance.max,
            priority: Priority.high,
            playSound: true);

    // Configuring the NotificationDetails for multiple platforms
    NotificationDetails platformspecfic =
        NotificationDetails(android: androidPlatformChannelSpecfic);

    await flutterLocalNotificationsPlugin.show(0, title, body, platformspecfic,
        payload: title);
  }

  /// Schedule notifications
  Future<void> scheduledNotification(
      int hours, int minutes, ReminderTask task) async {
    AndroidNotificationDetails androidDetails =
        const AndroidNotificationDetails("GharKharcha App", "GharKharcha App",
            priority: Priority.max, importance: Importance.max);
    DarwinNotificationDetails iosDetails = const DarwinNotificationDetails(
        presentAlert: true, presentBadge: true, presentSound: true);
    NotificationDetails notiDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    tz.TZDateTime scheduledDate = _convertDate(hours, minutes);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id!,
      task.title,
      task.note,
      scheduledDate,
      notiDetails,
      androidScheduleMode: AndroidScheduleMode.exact,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: "notification-payload",
    );
  }

  Future<void> configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  tz.TZDateTime _convertDate(int hours, int minutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hours, minutes);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  void showNotification2() async {
    AndroidNotificationDetails androidDetails =
        const AndroidNotificationDetails(
            "notifications-youtube", "YouTube Notifications",
            priority: Priority.max, importance: Importance.max);
    DarwinNotificationDetails iosDetails = const DarwinNotificationDetails(
        presentAlert: true, presentBadge: true, presentSound: true);
    NotificationDetails notiDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    DateTime scheduleDate = DateTime.now().add(const Duration(seconds: 5));

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      "Helooo",
      "Bibek chhetri ke xa kbr",
      tz.TZDateTime.from(scheduleDate, tz.local),
      notiDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      androidScheduleMode: AndroidScheduleMode.exact,
      payload: "notification-payload",
    );
  }

  Future<void> checkForNotification() async {
    NotificationAppLaunchDetails? details =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (details != null) {
      if (details.didNotificationLaunchApp) {
        NotificationResponse? response = details.notificationResponse;

        if (response != null) {
          String? payload = response.payload;
          logger.i("Notification Payload: $payload");
        }
      }
    }
  }

  Future<void> requestAndroidPermissions() async {
    final status = await Permission.notification.request();
    if (status.isGranted) {
      // Permissions granted
    } else if (status.isDenied) {
      // Permissions denied
    } else if (status.isPermanentlyDenied) {
      // Permissions permanently denied, navigate to app settings
      openAppSettings();
    }
  }
}
