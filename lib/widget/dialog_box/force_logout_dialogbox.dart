import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Constants/common_color.dart';
import '../snackbar/common_snackbar.dart';

class ForceLogout {
  static void showDialogBox(
      {
        required String title, required String message,required  void Function() onPressed1, required void Function() onPressed2,


      }

      )
  {
    Get.dialog(
      AlertDialog(
        backgroundColor: CommonColor.bottomSheetBackgroundColour,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        title: Text(
          title,
          textScaleFactor: 1.0,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.white,
            letterSpacing: 0.4,
            fontFamily: 'Roboto',
          ),
        ),
        content: SizedBox(
          height: 100.0,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                textScaleFactor: 1.0,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                    letterSpacing: 0.4,
                    fontFamily: 'Roboto'),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: onPressed1,
                    child: const Text(
                      "Cancel",
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          color: CommonColor.cancelButtonColor, fontSize: 12),
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  MaterialButton(
                    color: NewCommonColours.greenButton,
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: NewCommonColours.greenButton,
                        ),
                        borderRadius: BorderRadius.circular(9.0)),
                    onPressed: onPressed2,
                    minWidth: Get.width / 3.5,
                    height: 38,
                    child: const Text(
                      "Logout",
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          color: NewCommonColours.whiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
