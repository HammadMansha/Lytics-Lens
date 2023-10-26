// ignore_for_file: unused_catch_clause, avoid_function_literals_in_foreach_calls

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lytics_lens/Constants/app_strrings.dart';
import 'package:lytics_lens/Constants/common_color.dart';
import 'package:lytics_lens/Controllers/account_controller.dart';
import 'package:lytics_lens/Controllers/dashboard.dart';
import 'package:lytics_lens/Controllers/home_controller.dart';
import 'package:lytics_lens/abstract/getstorage_abstract.dart';
import 'package:lytics_lens/widget/snackbar/common_snackbar.dart';
import 'package:lytics_lens/Services/internetcheck.dart';
import 'package:lytics_lens/utils/api.dart';
import 'package:lytics_lens/views/dashboard_screen.dart';
import 'package:local_auth/local_auth.dart';
import '../Constants/constants.dart';
import '../Services/baseurl_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../widget/dialog_box/deprecated_dialogbox.dart';
import '../widget/dialog_box/warning_dialogbox.dart';
import 'company_user/companyUser_controller.dart';

class LoginScreenController extends GetxController with GetxStorage {
  final formkey = GlobalKey<FormState>();

  //<----------- Device Info ----------->

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> deviceData = <String, dynamic>{};

  late NetworkController networkController;
  BaseUrlService baseUrlService = Get.find<BaseUrlService>();

  bool isLoading = false;
  bool isAuth = false;
  bool? hasBioScreen;
  RxBool deprecated = false.obs;
  RxBool warning = false.obs;

  bool securetext = true;
  List<BiometricType>? availableAuth;

  LocalAuthentication authentication = LocalAuthentication();

  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController linkController = TextEditingController();

  bool forced = true;
  bool appToken = true;
  String userId = '';
  String dbody = '';
  String wbody = '';
  String link = '';
  int dversion = 0;
  int wversion = 0;
  int limit = 0;
  FocusNode node = FocusNode();

  String firebaseUrl = '';

  int checkHits = 0;

  RxBool isHintText = false.obs;

  String deviceTokenOfNewUSer = '';
  String loggedUserId = '';
  String hintText = "";
  AccountController controller=Get.put(AccountController());

  //HomeScreenController cntrl= Get.put(HomeScreenController());

  //CompanyUserController companyUserController = Get.put(CompanyUserController());

  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title description
    importance: Importance.max,
  );

  @override
  void onInit() async {
    //  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    //     if (kDebugMode) {
    //       print(
    //           "------------------------------------------- The app is login open");
    //     }
    //     FlutterAppBadger.updateBadgeCount(message.data.length);
    //     hintText = message.data["hint"] ?? "";
    //     if (kDebugMode) {
    //       print(
    //           "-------------------------------------------login message${message.data}");
    //     }
    //     if (message.data["hint"].toString().contains("loginSuccess")) {
    //       await verifyEmailPassword();
    //     }
    //
    //     if (message.data["hint"].toString().contains("loginFailed")) {
    //       Get.snackbar(
    //           "${message.notification!.title}", "${message.notification!.body}",
    //           messageText: Text(
    //             "${message.notification!.body}",
    //             style: const TextStyle(),
    //           ),
    //           forwardAnimationCurve: Curves.easeOutBack,
    //           backgroundColor: CommonColor.snackbarColour,
    //           onTap: (value) async {});
    //     }
    //
    //
    //
    //
    //
    // });

    node.addListener(() {
      if (!node.hasFocus) {
        formatNickname();
      }
    });
    if (Get.isRegistered<NetworkController>()) {
      networkController = Get.find<NetworkController>();
    } else {
      networkController = Get.put(NetworkController());
    }

    //<---------- Assign BaseUrl to LinkController ----------->
    linkController.text = baseUrlService.baseUrl;
    update();
    super.onInit();
  }

  @override
  void onReady() async {
    await getVersionInfo();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int c = int.parse(packageInfo.buildNumber);
    var d = int.parse(packageInfo.buildNumber);
    if (wversion > c) {
      if (storage.hasData('warning_version') == false) {
        storage.write('warning_version', 0);
        warning.value = true;
      } else {
        if (storage.read('warning_version') > limit) {
          if (kDebugMode) {
            print("aaaaaaaaaaaaa" + storage.read('warning_version').toString());
          }
          warning.value = true;
        } else {
          int v = storage.read('warning_version');
          int c = v + 1;
          storage.write('warning_version', c);
        }
      }
    }
    if (storage.hasData('warning_version') == true) {
      if (storage.read('warning_version') > limit) {
        if (kDebugMode) {
          print("bbbbbbbbbbb" + storage.read('warning_version').toString());
        }
        warning.value = true;
      }
    }
    if (dversion >= d) {
      deprecated.value = true;
    }
    if (warning.value == true || deprecated.value == true) {
      if (deprecated.value == true && warning.value == true) {
        DepreactedDialog.showDialogBox(
            title: "UPDATE",
            message:
                'Please Update your App to the New Version',
            link: link);
      } else if (deprecated.value == true) {
        DepreactedDialog.showDialogBox(
            title: "UPDATE",
            message:
                'Please Update your App to the New Version',
            link: link);
      } else if (warning.value == true) {
        WarningDialog.showDialogBox(
            title: "WARNING",
            message: 'A new version of the application is available',
            limit: limit,
            link: link);
      }
    }
    isLoading = false;
    update();
    super.onReady();
  }

  void formatNickname() {
    userNameController.text = userNameController.text.replaceAll(" ", "");
  }

  //<--------- This function is used for verify Email and Password ----------->

  Future<void> verifyEmailPassword() async {
    if (formkey.currentState!.validate()) {
      try {

        var res = await http.post(
          Uri.parse(baseUrlService.baseUrl + ApiData.login),
          body: {
            'email': userNameController.text,
            'password': passwordController.text,
            'forced': 'APP',
          },
        );
        var data = json.decode(res.body);
        if (kDebugMode) {
          print("login status code-----------------------${res.statusCode}");
        }

        if (res.statusCode == 200) {
          var userdata = data["user"];
          var accessToken = data["tokens"]["access"];
          var token = data["tokens"]["refresh"];
          await storage.write("RefreshToken", token["token"]);
          await storage.write("UsersChannels", userdata['channelsWithSourceNames']);
          await storage.write("AccessToken", accessToken["token"]);
          await storage.write("Subscription", userdata['subscription']);
          await storage.write("email", userNameController.text);
          await storage.write("pass", passwordController.text);
          await storage.write("id", userdata['id']);
          await storage.write("firstName", userdata['firstName']);
          await storage.write("lastName", userdata['lastName']);
          await storage.write("company_id", userdata['company']['id']);
          controller.getUserEmail();
          //Constants.loginScreenListner.cancel();
          update();
          Get.offAll(() => const Dashboard());
        } else {
          String message = data["message"];

          if (message.contains("already logged in ")) {
            CustomSnackBar.showSnackBar(
                title: message,
                message: "",
                isWarning: true,
                backgroundColor: CommonColor.snackbarColour);
          } else {
            CustomSnackBar.showSnackBar(
              title: AppStrings.inncorrectUsername,
              message: "",
              isWarning: true,
              backgroundColor: CommonColor.snackbarColour,
            );
          }
        }

        // Get.log('Result is ${res.body}');
      } on SocketException catch (e) {
        // if (networkController.networkStatus == true) {
        //
        // }
        CustomSnackBar.showSnackBar(
            title: AppStrings.unableToConnect,
            message: "",
            isWarning: true,
            backgroundColor: CommonColor.snackbarColour);
      }
      catch (e) {
        if (e.toString().contains("access")) {
          CustomSnackBar.showSnackBar(
              title: AppStrings.inncorrectUsername,
              message: "",
              backgroundColor: CommonColor.snackbarColour,
              isWarning: true);
        }
      }
    }
  }

  //<----------- This Function Used for Update Baseurl ------->

  Future<void> getUrl() async {
    checkHits = 0;
    await storage.write("Url", linkController.text);
    await baseUrlService.isBaseUrlCheck();
    Get.back();
    Get.back();
    CustomSnackBar.showSnackBar(
        title: AppStrings.urlUpdated,
        message: "",
        backgroundColor: CommonColor.snackbarColour);
  }

  Future<void> checkBio() async {
    try {
      hasBioScreen = await authentication.canCheckBiometrics;
      if (hasBioScreen!) {
        getAuth();
      }
    } catch (e) {
      CustomSnackBar.showSnackBar(
        title: AppStrings.fingerPrint,
        message: "",
        isWarning: true,
        backgroundColor: CommonColor.snackbarColour,
      );
    }
  }

  Future<void> getAuth() async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await authentication.getAvailableBiometrics();
      if (availableBiometrics.contains(BiometricType.face) ||
          availableBiometrics.contains(BiometricType.fingerprint)) {
        isAuth = await authentication.authenticate(
          localizedReason: "Scan your Face/Finger to access the app",
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        );
        if (isAuth) {
          if (storage.hasData('email') == false &&
              storage.hasData('pass') == false) {
            CustomSnackBar.showSnackBar(
                title: AppStrings.fingerPrintError,
                message: "",
                backgroundColor: CommonColor.snackbarColour);
          } else {
            userNameController.text = storage.read("email").toString();
            passwordController.text = storage.read("pass").toString();
            update();
            await verifyEmailPassword();
          }
          // if()
        }
      } else {}
      availableAuth = availableBiometrics;
      update();
    } on PlatformException catch (e) {
      CustomSnackBar.showSnackBar(
          title: AppStrings.fingerPrint,
          isWarning: true,
          message: "",
          backgroundColor: CommonColor.snackbarColour);
    }
  }

  Future<void> eraseUrlStorage() async {
    storage.remove("Url");
    checkHits = 0;
    await baseUrlService.isBaseUrlCheck();
    linkController.text = baseUrlService.baseUrl;
    update();
    CustomSnackBar.showSnackBar(
        title: AppStrings.baseurlactive,
        message: "",
        backgroundColor: CommonColor.snackbarColour);
  }

  //<---------- Check Version --------------------->

  Future<void> getVersionInfo() async {
    try {
      var d = await ApiData.forceUpdate.get();
      d.docs.forEach((e) {
        dbody = e.get('body_deprecated');
        wbody = e.get('body_warning');
        dversion = e.get('depricated_version');
        wversion = e.get('warning_version');
        link = e.get('link');
        limit = e.get('limit');
      });
      update();
    } on FirebaseException catch (e) {
      CustomSnackBar.showSnackBar(
          title: AppStrings.unable,
          message: "",
          backgroundColor: CommonColor.snackbarColour,
          isWarning: true);
    }
  }

  Future<void> getFirebaseUrl() async {
    try {
      var d = await ApiData.urlInfo.get();
      d.docs.forEach((e) async {
        await storage.remove('Url');
        await storage.write("Url", e.get('url'));
        await baseUrlService.isBaseUrlCheck();
      });
      update();
      await verifyEmailPassword();
    } on FirebaseException catch (e) {
      CustomSnackBar.showSnackBar(
          title: AppStrings.unable,
          message: "",
          backgroundColor: CommonColor.snackbarColour,
          isWarning: true);
      // ignore: empty_catches
    } on SocketException catch (e) {}
  }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData = readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
    deviceData = deviceData;
    update();
  }

  Map<String, dynamic> readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'systemFeatures': build.systemFeatures,
      'displaySizeInches':
          ((build.displayMetrics.sizeInches * 10).roundToDouble() / 10),
      'displayWidthPixels': build.displayMetrics.widthPx,
      'displayWidthInches': build.displayMetrics.widthInches,
      'displayHeightPixels': build.displayMetrics.heightPx,
      'displayHeightInches': build.displayMetrics.heightInches,
      'displayXDpi': build.displayMetrics.xDpi,
      'displayYDpi': build.displayMetrics.yDpi,
    };
  }

  Map<String, dynamic> readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }
}
