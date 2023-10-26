// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lytics_lens/Controllers/chekyourmail_controller.dart';
import 'package:lytics_lens/Views/enter4DigitCode.dart';
import 'package:resize/resize.dart';

class CheckYourMail extends StatelessWidget {
  const CheckYourMail({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckYourMailController>(
      init: CheckYourMailController(),
      builder: (_) {
        return Scaffold(
          backgroundColor: const Color.fromRGBO(27, 29, 40, 1),
          appBar: AppBar(
            elevation: 0.0,
          ),
          body: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/email.png",
                    height: 123.0.h,
                  ),
                  SizedBox(
                    height: 50.0.h,
                  ),
                  Text(
                    "Check Your Mail",
                    style: TextStyle(
                        fontSize: 22.0.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 21.0.h,
                  ),
                  Text(
                    "We have sent password recovery\n options to your email",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12.0.sp, color: const Color(0xFFD3D3D3)),
                  ),
                  SizedBox(
                    height: 50.0.h,
                  ),
                  MaterialButton(
                    onPressed: () {
                      Get.to(() => const Enter4DigitCode());
                    },
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    minWidth: 267.0,
                    height: 36,
                    color: const Color.fromRGBO(72, 190, 235, 1),
                    child: const Text(
                      "OKAY",
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
    );
  }
}
