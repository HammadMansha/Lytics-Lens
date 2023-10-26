// ignore_for_file: unused_catch_clause, empty_catches

import 'dart:collection';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:lytics_lens/Controllers/company_user/companyUser_controller.dart';
import 'package:lytics_lens/Controllers/home_controller.dart';
import 'package:lytics_lens/Controllers/searchScreen_controller.dart';
import 'package:lytics_lens/Controllers/searchbar_controller.dart';
import 'package:lytics_lens/abstract/getstorage_abstract.dart';
import 'package:lytics_lens/views/Search_Screen.dart';
import 'package:lytics_lens/views/player_Screen.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../utils/api.dart';
import '../widget/dialog_box/deprecated_dialogbox.dart';
import '../widget/dialog_box/force_logout_dialogbox.dart';
import '../widget/dialog_box/warning_dialogbox.dart';

class DashboardController extends GetxController with GetxStorage {
  int currentindex = 0;
  ListQueue<int> navigationQueue = ListQueue();
  String dbody = '';
  String wbody = '';
  String link = '';
  int dversion = 0;
  int wversion = 0;
  int limit = 0;
  RxBool deprecated = false.obs;
  RxBool warning = false.obs;

  late CompanyUserController companyUserController;


  @override
  void onInit() {

    Get.delete<HomeScreenController>();
    if (Get.arguments != null) {
      Get.to(() => const PlayerScreen(),
          arguments: {"id": Get.arguments.toString(),
            "receiverName":" "
          });
    }
    if (Get.isRegistered<CompanyUserController>()) {
      companyUserController = Get.find<CompanyUserController>();
    } else {
      companyUserController = Get.put(CompanyUserController());
    }
    super.onInit();
  }

  @override
  void onReady() async {
    await getVersionInfo();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int c = int.parse(packageInfo.buildNumber);

    var d = int.parse(packageInfo.buildNumber);
    if (kDebugMode) {
      print("build number ${c}");
    }

    if (wversion > c) {
      if (storage.hasData('warning_version') == false) {
        storage.write('warning_version', 0);
      } else {
        if (storage.read('warning_version') > limit) {
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
    update();
    super.onReady();
  }

  void changeTabIndex(int index) {
    currentindex = index;

    if (index == currentindex) {
      navigationQueue.clear();
      // navigationQueue.removeWhere((element) => element == index);
      navigationQueue.addLast(index);
      currentindex = index;
      update();
    }
    update();
  }

  Future<void> getVersionInfo() async {
    try {
      var d = await ApiData.forceUpdate.get();
      for (var e in d.docs) {
        dbody = e.get('body_deprecated');
        wbody = e.get('body_warning');
        dversion = e.get('depricated_version');
        wversion = e.get('warning_version');
        link = e.get('link');
        limit = e.get('limit');
      }
      update();
    } on FirebaseException catch (e) {}
  }
}
