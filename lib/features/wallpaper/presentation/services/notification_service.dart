import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> showLoadingNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'loading_channel',
      'Loading Channel',
      importance: Importance.high,
      priority: Priority.high,
      showProgress: true,
      indeterminate: true,
      icon: "@mipmap/ic_launcher",
      ongoing: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,
      'Uploading the wallpaper..',
      'Please wait while we upload your wallpaper.',
      platformChannelSpecifics,
      payload: 'uploading',
    );
  }

  Future<void> showSuccessNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'success_channel',
      'Success Channel',
      importance: Importance.high,
      priority: Priority.high,
      icon: "@mipmap/ic_launcher",
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      1,
      'Success!',
      'Wallpaper upload successfully!!.',
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
      icon: "@mipmap/ic_launcher",
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

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
