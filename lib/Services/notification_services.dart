// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';

// class NotificationService extends GetxService {
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   //initilize

//   Future<NotificationService> init() async {
//     await initialize();
//     return this;
//   }

//   Future initialize() async {
//     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();

//     AndroidInitializationSettings androidInitializationSettings =
//         const AndroidInitializationSettings(
//       "ic_launcher_background",
//     );

//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: androidInitializationSettings,
//     );

//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   //Stylish Notification
//   Future stylishNotification() async {
//     var android = const AndroidNotificationDetails(
//         "high_importance_channel", "High Importance Notifications",
//         color: Colors.deepOrange,
//         enableLights: true,
//         enableVibration: true,
//         importance: Importance.high,
//         priority: Priority.high

//         // largeIcon: DrawableResourceAndroidBitmap("ic_launcher"),
//         );

//     var platform = NotificationDetails(android: android);

//     await _flutterLocalNotificationsPlugin.show(
//         1234, "Demo Stylish notification", "Tap to do something", platform);
//   }

//   //Cancel notification

//   // Future cancelNotification() async {
//   //   await _flutterLocalNotificationsPlugin.cancelAll();
//   // }
// }
