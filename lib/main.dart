import 'dart:async';
import 'dart:developer' as developer;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lytics_lens/Constants/common_color.dart';
import 'package:lytics_lens/Constants/constants.dart';
import 'package:lytics_lens/Services/pushNotificationSevice.dart';
import 'package:lytics_lens/dummy_project.dart';
import 'package:lytics_lens/views/dashboard_screen.dart';
import 'package:lytics_lens/views/login_screen.dart';
import 'package:resize/resize.dart';
import 'Services/baseurl_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await initServices();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: CommonColor.appBarColor,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: CommonColor.appBarColor,
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) {
    runZonedGuarded(() {
      runApp(LensApp());
    }, (dynamic error, dynamic stack) {
      developer.log("Something went wrong!", error: error, stackTrace: stack);
    });
  });
}

Future<void> initServices() async {
  await GetStorage.init();
  BaseUrlService baseUrlService = BaseUrlService();
  await Get.putAsync(() => baseUrlService.init());
  Get.log("Check Base Url ${baseUrlService.baseUrl}");
}

class LensApp extends StatelessWidget {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final storage = GetStorage();

  LensApp({super.key});

  @override
  Widget build(BuildContext context) {
    final pushNotificationService = PushNotificationService(_firebaseMessaging);
    pushNotificationService.initialise();
    return Resize(
        allowtextScaling: false,
        builder: () {
          return GetMaterialApp(
            title: "Lytics Lens",
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: const Color.fromRGBO(27, 29, 40, 1),
              textSelectionTheme: const TextSelectionThemeData(
                cursorColor: Color.fromRGBO(242, 106, 50, 1),
              ),
            ),
            //home:TabbarOptmization(),
            home: storage.hasData("AccessToken") == true
                ? const Dashboard()
                : const LoginScreen(),
            //home: ShareVideoWithOtherApps(),
          );
        });
  }
}
