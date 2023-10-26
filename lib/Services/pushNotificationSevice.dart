// ignore_for_file: file_names

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lytics_lens/Constants/constants.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm;
  final storage = GetStorage();

  PushNotificationService(this._fcm);

  Future initialise() async {
    Constants.token = await _fcm.getToken();
    if (kDebugMode) {
      Get.log("FirebaseMessaging token: ${Constants.token}");
    }

    // Future<void> firebaseMessagingBackgroundHandler(
    //     RemoteMessage message) async {
    //   if (kDebugMode) {
    //     print("onBackground ${message.data}");
    //   }
    // }

    // FirebaseMessaging.onBackgroundMessage((firebaseMessagingBackgroundHandler));

    // FirebaseMessaging.instance
    //     .getInitialMessage()
    //     .then((RemoteMessage? message) async {
    //   if (message != null) {
    //     Get.log('getInitialMessage data: ${message.data}');
    //   }
    // });

    // FirebaseMessaging.instance.requestPermission(
    //   alert: true,
    //   badge: true,
    //   sound: true,
    // );

    // // replacement for onResume: When the app is in the background and opened directly from the push notification.

    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {

    //   if (message.data["jobID"].toString().isNotEmpty ||
    //       message.data["jobID"].toString() != '') {
    //   } else {}
    // });
  }
}
