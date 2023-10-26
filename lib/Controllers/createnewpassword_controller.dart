import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lytics_lens/Constants/common_color.dart';
import 'package:lytics_lens/abstract/getstorage_abstract.dart';
import 'package:lytics_lens/utils/api.dart';
import 'package:lytics_lens/widget/snackbar/common_snackbar.dart';

import '../Services/baseurl_service.dart';

class CreatenewpasswordController extends GetxController with GetxStorage {
  bool isLoading = true;
  String email = '';

  TextEditingController passwordController = TextEditingController();
  TextEditingController retypePasswordController = TextEditingController();

  BaseUrlService baseUrlService = Get.find<BaseUrlService>();

  final formkey = GlobalKey<FormState>();

  bool securetext = true;
  bool securetext1 = true;

  @override
  void onInit() {
    if (Get.arguments != null) {
      email = Get.arguments.toString();
      update();
    }
    super.onInit();
  }

  @override
  void onReady() async {
    isLoading = false;
    update();
    super.onReady();
  }

  Future<void> createNewPassword() async {
    if (formkey.currentState!.validate()) {
      try {
        var data = await http.post(
            Uri.parse(baseUrlService.baseUrl + ApiData.resetpassword),
            body: {
              'email': email.toString(),
              'newPassword': retypePasswordController.text,
            });
        if (data.statusCode == 200) {
          Get.back();
          Get.back();
          Get.back();
          CustomSnackBar.showSnackBar(
              title: 'Password updated successfully',
              message: "",
              backgroundColor: CommonColor.snackbarColour,
              isWarning: false);
        } else {}
      } catch (e) {
        CustomSnackBar.showSnackBar(
            title: e.toString(),
            message: "",
            backgroundColor: CommonColor.snackbarColour,
            isWarning: false);
      }
    }
  }
}
