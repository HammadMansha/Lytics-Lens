// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

class Constants {
  static int index = 0;
  static bool isSearch = false;
  static String? token;
  bool status = false;
  bool status2 = false;
  bool status3 = false;
  bool status4 = false;
  static var subscription;
  // static var message = FirebaseMessaging.onMessage;
  //
  // static late StreamSubscription<RemoteMessage> loginScreenListner;
  // static late StreamSubscription<RemoteMessage> homeScreenListner;
}