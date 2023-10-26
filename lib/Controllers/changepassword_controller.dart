import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lytics_lens/Constants/app_strrings.dart';
import 'package:lytics_lens/Constants/common_color.dart';
import 'package:lytics_lens/abstract/getstorage_abstract.dart';
import 'package:lytics_lens/widget/snackbar/common_snackbar.dart';
import 'package:lytics_lens/utils/api.dart';

import '../Services/baseurl_service.dart';

class ChangePasswordController extends GetxController with GetxStorage {
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  bool securetext = true;
  bool securetext1 = true;
  bool securetext2 = true;
  TextEditingController linkController = TextEditingController();
  BaseUrlService baseUrlService = Get.find<BaseUrlService>();
  final formKey = GlobalKey<FormState>();

  Future<void> changePassword() async {
    try {
      String email = storage.read("email");
      var res = await http.post(
        Uri.parse(baseUrlService.baseUrl + ApiData.changePassword),
        body: {
          "email": email,
          "oldPassword": oldPassword.text,
          "newPassword": newPassword.text,
        },
      );
      // var data = json.decode(res.body);

      if (res.statusCode == 200) {
        await storage.write("pass", newPassword.text);
        Get.back();
        CustomSnackBar.showSnackBar(
          title: AppStrings.passwordChanged,
          message: "",
          backgroundColor: CommonColor.snackbarColour,
        );
      } else {
        CustomSnackBar.showSnackBar(
            title: AppStrings.passwordDoesNotMatch,
            message: "",
            backgroundColor: CommonColor.snackbarColour,
            isWarning: true);
      }
    } catch (e) {
      // Get.snackbar('Error', e.toString().contains("SocketException"), backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
