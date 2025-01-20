import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:logger/logger.dart';
// import 'package:onesignal_flutter/src/notification.dart';

class Time {
  final int hour;
  final int minute;
  const Time(this.hour, this.minute);
}

class NotificationService {
  // static const String oneSignalAppId = 'YOUR_ONESIGNAL_APP_ID';
  final FlutterLocalNotificationsPlugin _localNotifications;
  final _logger = Logger();

  NotificationService()
      : _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    try {
      // Initialize timezone
      tz.initializeTimeZones();

      // Initialize OneSignal
      // OneSignal.initialize(oneSignalAppId);
      // await OneSignal.Notifications.requestPermission(true);

      // Initialize local notifications
      const initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await _localNotifications.initialize(initializationSettings);
      _logger.d('Notifications initialized successfully');
    } catch (e) {
      _logger.e('Error initializing notifications', error: e);
    }
  }

  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    try {
      final time = Time(hour, minute);

      await _localNotifications.zonedSchedule(
        0,
        title,
        body,
        _nextInstanceOfTime(time),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'food_tracker_reminders',
            'Meal Reminders',
            channelDescription: 'Daily reminders to log your meals',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      _logger.d('Scheduled daily reminder for $hour:$minute');
    } catch (e) {
      _logger.e('Error scheduling reminder', error: e);
    }
  }

  Future<void> cancelAllReminders() async {
    try {
      await _localNotifications.cancelAll();
      _logger.d('Cancelled all reminders');
    } catch (e) {
      _logger.e('Error cancelling reminders', error: e);
    }
  }

  Future<void> sendPushNotification({
    required String title,
    required String body,
    String? userId,
  }) async {
    try {
      // OneSignal code commented out
      // if (userId != null) {
      //   await OneSignal.User.addTags({'user_id': userId});
      // }
      // await OneSignal.Notifications.requestPermission(true);
      // await OneSignal.Notifications.sendDirectNotification(
      //   title: title,
      //   message: body,
      //   playerIds: userId != null ? [userId] : null,
      // );

      // Show local notification only
      await _localNotifications.show(
        0,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'food_tracker_notifications',
            'Food Tracker',
            channelDescription: 'Food tracker notifications',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
      );
      _logger.d('Sent notification: $title');
    } catch (e) {
      _logger.e('Error sending push notification', error: e);
    }
  }

  tz.TZDateTime _nextInstanceOfTime(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }
}
