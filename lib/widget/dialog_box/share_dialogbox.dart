import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Constants/common_color.dart';

class ShareDialogbox {
  static void showDialogbox({required String title, required String subtitle, required void Function() onPressed,
  })
  {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xff131C3A),
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
                subtitle,
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
                  MaterialButton(
                    onPressed: () async {
                      Get.back();
                    },
                    minWidth: Get.width / 3.5,
                    height: 38,
                    child: const Text(
                      "Cancel",
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          color: CommonColor.whiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
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
                    onPressed: onPressed,
                    minWidth: Get.width / 3.5,
                    height: 38,
                    child: const Text(
                      "Share",
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          color: NewCommonColours.whiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
