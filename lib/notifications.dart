import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:project_tutorial/widget/notifications_widget.dart';

class NotificationService {
  NotificationService();

  final _localNotifications = FlutterLocalNotificationsPlugin();

  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );

  void showNotification(
      BuildContext context, String title, String message, IconData icon) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notification'),
          content:
              CustomNotification(title: title, message: message, icon: icon),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            // TextButton(
            //   child: const Text('Open'),
            //   onPressed: () => Navigator.of(context).push(), //push inbox page
            // ),
          ],
        );
      },
    );
  }
}

//showNotification(
//  context, 'New Message', 
//            'You have a new message!', 
// Icons.notification_add)


//showNotification(
//  context, 'New Message', 
//            'You have a new message!', 
// Icons.notification_add)