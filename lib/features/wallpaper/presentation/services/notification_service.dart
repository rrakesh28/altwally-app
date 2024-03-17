import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings('launcher_icon'));
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showLoadingNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'loading_channel',
      'Loading Channel',
      importance: Importance.high,
      priority: Priority.high,
      showProgress: true,
      indeterminate: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,
      'Loading...',
      'Please wait while we load.',
      platformChannelSpecifics,
      payload: 'loading',
    );
  }

  Future<void> showSuccessNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'success_channel',
      'Success Channel',
      importance: Importance.high,
      priority: Priority.high,
    );

    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      1,
      'Success!',
      'Task completed successfully.',
      platformChannelSpecifics,
      payload: 'success',
    );
  }

  Future<void> showFailedNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'failed_channel',
      'Failed Channel',
      importance: Importance.high,
      priority: Priority.high,
      playSound: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      2,
      'Failed!',
      'Task failed to complete.',
      platformChannelSpecifics,
      payload: 'failed',
    );
  }
}
