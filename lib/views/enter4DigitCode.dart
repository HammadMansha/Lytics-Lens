// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lytics_lens/Controllers/enter4Digit_controller.dart';
import 'package:resize/resize.dart';

class Enter4DigitCode extends StatelessWidget {
  const Enter4DigitCode({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Enter4DigitController>(
      init: Enter4DigitController(),
      builder: (_) {
        return Scaffold(
          backgroundColor: const Color.fromRGBO(27, 29, 40, 1),
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(27, 29, 40, 1),
            elevation: 0.0,
          ),
          body: Obx(
            () {
              return _.networkController.networkStatus.value == false
                  ? noInternetConnection()
                  : GestureDetector(
                      onTap: () {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                      },
                      child: SingleChildScrollView(
                        child: SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/email.png",
                                height: 123.0.h,
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              Center(
                                  child: Text(
                                "Enter 4 Digit Code",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24.0.sp),
                              )),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                "Enter the verification code we have \njust sent to your email address",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: const Color(0xFFD3D3D3),
                                    fontSize: 12.sp,
                                    letterSpacing: 0.5),
                              ),
                              const SizedBox(
                                height: 30.0,
                              ),
                              otpBox(_),
                              const SizedBox(
                                height: 30.0,
                              ),
                              MaterialButton(
                                onPressed: () => _.enterButton(),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                minWidth: 267.0,
                                height: 36,
                                color: const Color.fromRGBO(72, 190, 235, 1),
                                child: const Text(
                                  "ENTER CODE",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
            },
          ),
        );
      },
    );
  }

  Widget otpBox(Enter4DigitController _) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: 50.0,
              height: 50.0,
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(45, 47, 58, 1),
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: textFieldOTP(_.firstDigit, "5")),
          const SizedBox(
            width: 7,
          ),
          Container(
              width: 50.0,
              height: 50.0,
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(45, 47, 58, 1),
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: textFieldOTP(_.secondDigit, "4")),
          const SizedBox(
            width: 7,
          ),
          Container(
              width: 50.0,
              height: 50.0,
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(45, 47, 58, 1),
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: textFieldOTP(_.thirdDigit, "7")),
          const SizedBox(
            width: 7,
          ),
          Container(
              width: 50.0,
              height: 50.0,
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(45, 47, 58, 1),
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: textFieldOTP(_.fourthDigit, "2")),
          const SizedBox(
            width: 7,
          ),
        ],
      ),
    );
  }

  Widget noInternetConnection() {
    return Center(
      child: Container(
        width: Get.width / 3,
        height: Get.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/wifi.png',
            ),
          ),
        ),
      ),
    );
  }

  Widget textFieldOTP(control, String hint) {
    return TextFormField(
      controller: control,
      textInputAction: TextInputAction.next,
      maxLength: 1,
      autofocus: true,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white, fontSize: 25.0),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        counterText: "",
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38, fontSize: 25.0),
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
    );
  }
}
