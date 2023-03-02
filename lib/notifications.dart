import 'dart:io';
import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService();

  final _localNotifications = FlutterLocalNotificationsPlugin();

  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
    //onDidReceiveLocalNotification: onDidReceiveLocalNotification
  );

  // void onDidReceiveLocalNotification(
  //     int id, String? title, String? body, String? payload) {
  //   print('id $id');
  // }
}
