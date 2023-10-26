import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Constants/common_color.dart';
import '../snackbar/common_snackbar.dart';

class DepreactedDialog {
  static void showDialogBox({required String title, required String message, required String link}) {
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
                    onPressed: () {
                      if (Platform.isAndroid) {
                        exit(0);
                      } else {
                        exit(0);
                      }
                    },
                    child: const Text(
                      "Close App",
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          color: CommonColor.cancelButtonColor, fontSize: 12),
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.0),
                      side: const BorderSide(
                        color: CommonColor.greenBorderColor,
                      ),
                    ),
                    onPressed: () async {
                      if (GetPlatform.isIOS) {
                        CustomSnackBar.showSnackBar(
                          title: "It will be available soon",
                          message: "",
                          isWarning: false,
                          backgroundColor: CommonColor.greenColor,
                        );
                      }
                      else{

                        if (!await launchUrl(
                          Uri.parse(link),
                          mode: LaunchMode.externalApplication,
                          // webViewConfiguration:
                          //     const WebViewConfiguration(enableJavaScript: false),
                        )) {
                          throw 'Could not launch $link';
                        }

                      }

                    },
                    minWidth: Get.width / 3.4,
                    height: 40,
                    color: CommonColor.greenColorWithOpacity,
                    child: const Text(
                      "Update Now",
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          color: CommonColor.greenTextColor, fontSize: 14),
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
