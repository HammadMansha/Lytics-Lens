import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lytics_lens/Services/internetcheck.dart';
import 'package:lytics_lens/abstract/getstorage_abstract.dart';
import 'package:lytics_lens/utils/api.dart';

// import 'package:lytics_lens/views/enter4DigitCode.dart';
import 'package:http/http.dart' as http;
import 'package:pin_code_fields/pin_code_fields.dart';

import '../Services/baseurl_service.dart';

class ForgotPasswordController extends GetxController with GetxStorage {
  bool isLoading = true;

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  final formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController pin = TextEditingController();
  BaseUrlService baseUrlService = Get.find<BaseUrlService>();

  String lastcode = '';

  late Timer otptimer;
  int start = 60;

  late NetworkController networkController;

  @override
  void onInit() {
    if (Get.isRegistered<NetworkController>()) {
      networkController = Get.find<NetworkController>();
    } else {
      networkController = Get.put(NetworkController());
    }
    errorController = StreamController<ErrorAnimationType>();
    super.onInit();
  }

  @override
  void onReady() async {
    isLoading = false;
    update();
    super.onReady();
  }

  Future<void> forgotPassword() async {
    if (formkey.currentState!.validate()) {
      pin.clear();

      var res = await http.post(
          Uri.parse(baseUrlService.baseUrl + ApiData.forgot),
          body: {'email': emailController.text});
      var data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        if (kDebugMode) {
          print("i am in forgot password");
          print(res.statusCode);

          print(res.body);
        }
        lastcode = data.toString();
        update();
        if (start == 0) {
          start = 60;
          startTimer();
        } else {
          start = 60;
          startTimer();
        }
      }
    }
  }

  void startTimer() {
    const onesec = Duration(seconds: 1);
    otptimer = Timer.periodic(onesec, (Timer timer) {
      if (start < 1) {
        timer.cancel();
      } else if (pin.text.isEmpty) {
        start = start - 1;
      } else if (pin.text.isNotEmpty) {
        start = start - 1;
      }
      update();
    });
  }
}
