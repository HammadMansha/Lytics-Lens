import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lytics_lens/Constants/constants.dart';
import 'package:lytics_lens/Controllers/home_controller.dart';
import 'package:lytics_lens/Services/internetcheck.dart';
import 'package:lytics_lens/Views/Login_Screen.dart';
import 'package:lytics_lens/abstract/getstorage_abstract.dart';
import 'package:lytics_lens/utils/api.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Constants/app_strrings.dart';
import '../Services/baseurl_service.dart';
import '../widget/snackbar/common_snackbar.dart';

class AccountController extends GetxController with GetxStorage {
  bool isLoading = true;
  bool selected = false;

  bool isShow = false;

  List updateList = [];

  String useremail = '';

  late NetworkController networkController;
  BaseUrlService baseUrlService = Get.find<BaseUrlService>();

  late HomeScreenController controller = Get.find<HomeScreenController>();

  static CollectionReference show =
      FirebaseFirestore.instance.collection('remotConfigFile');

  static CollectionReference isUpdate =
      FirebaseFirestore.instance.collection('updateApp');
  Uri url = Uri.parse("https://wa.me/?text=YourTextHere");

  @override
  void onReady() async {
    getUserEmail();
    getShow();
    getShowUpdate();
    isLoading = false;
    update();
    super.onReady();
  }

  void getUserEmail() async{
    useremail = await storage.read('email');

  }
  Future<void> getShow() async {
    try {
      Stream<QuerySnapshot> data = show.snapshots();
      await data.forEach((e) {
        for (var value in e.docs) {
          isShow = value.get('isShow');
        }
        update();
      }).catchError((e) {
        // CustomSnackBar.showSnackBar(title: AppStrings.unable, message: "", backgroundColor: Color(0xff48beeb));
      });
    } on FirebaseException {
      // CustomSnackBar.showSnackBar(title: AppStrings.unable, message: "", backgroundColor: Color(0xff48beeb));
    }
  }

  Future<void> getShowUpdate() async {
    try {
      Stream<QuerySnapshot> sdata = isUpdate.snapshots();
      await sdata.forEach((w) {
        updateList.clear();
        for (var value in w.docs) {
          updateList.add(value.data());
        }
        update();
      }).catchError((e) {});
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> sendDeviceToken() async {
    String token = await storage.read("AccessToken");

    var res = await http.post(
      Uri.parse(baseUrlService.baseUrl + ApiData.deviceToken),
      headers: {
        'Authorization': 'Bearer $token',
        "Content-type": 'application/json',
      },
      body: json.encode({
        "userId": storage.read('id'),
        "deviceToken": Constants.token.toString(),
        "addToken": "false",
      }),
    );


  }

  Future<void> logout() async {
    try {
      await sendDeviceToken();

      //  Get.offAll(() => LoginScreen());
      if (storage.hasData("Url") == true) {
        String url = storage.read("Url");
        String token = await storage.read("RefreshToken");
        if(kDebugMode){
          print("logout-----------------------${ Uri.parse(url + ApiData.logut)}");
        }
        await http.post(
          Uri.parse(url + ApiData.logut),
          body: {"refreshToken": token, "latest": "true"},
        );
        await storage.remove("RefreshToken");
        await storage.remove("AccessToken");
        await storage.remove("username");
        await storage.remove("password");
        await storage.remove("id");
        await storage.remove("firstName");
        await storage.remove("lastName");
        await storage.remove("UsersChannels");
        await storage.remove("isOnboard");
        controller.job.clear();
        controller.receivedJobsList.clear();
        controller.sentjob.clear();
        Constants.index = 0;
        // Get.delete<HomeScreenController>();
        // Get.delete<DashboardController>();
        // // Constants.homeScreenListner.cancel();
        // update();
        Get.offAll(() => const LoginScreen());
      } else {
        String token = await storage.read("RefreshToken");

        await http.post(
          Uri.parse(ApiData.baseUrl + ApiData.logut),
          body: {"refreshToken": token, "latest": "true"},
        );
        if (kDebugMode) {
          print("im in else condition--------------");
        }

        await storage.remove("RefreshToken");
        await storage.remove("AccessToken");
        await storage.remove("username");
        await storage.remove("password");
        await storage.remove("id");
        await storage.remove("firstName");
        await storage.remove("lastName");
        await storage.remove("UsersChannels");
        await storage.remove("isOnboard");
        controller.job.clear();
        controller.receivedJobsList.clear();
        controller.sentjob.clear();
        Constants.index = 0;
        // Get.delete<HomeScreenController>();
        //
        // Get.delete<DashboardController>();
        //Constants.homeScreenListner.cancel();
        update();
        Get.offAll(() => const LoginScreen());
      }
    } on SocketException {
      CustomSnackBar.showSnackBar(
          title: AppStrings.unable,
          message: "",
          backgroundColor: const Color(0xff22B161));
    } catch (e) {
      if (kDebugMode) {
        print("error-------------------------${e.toString()}");
      }
      CustomSnackBar.showSnackBar(
        title: AppStrings.unable,
        message: "",
        backgroundColor: const Color(0xff22B161),
        isWarning: true,
      );
    }
  }


  Future<void> launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }
}
