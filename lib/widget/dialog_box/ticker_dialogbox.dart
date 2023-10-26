// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class TickerDialog {
  static void showDialog({
    required String channelPath,
    required String thumbnailPath,
    required String programDate,
    required String programTime,
    bool isSearch = false,
  }) {
    Get.dialog(
      AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        backgroundColor: const Color(0xff031347),
        content: Container(
          height: 130,
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xffFF1717),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: channelPath,
                          placeholder: (c, e) => Lottie.asset(
                              "assets/images/circular_loader_image.json",
                              fit: BoxFit.cover),
                          errorWidget: (c, e, r) => Lottie.asset(
                              "assets/images/circular_loader_image.json",
                              fit: BoxFit.cover),
                          fit: BoxFit.contain,
                          height: 20.0,
                          width: 20.0,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          if (isSearch == true) {
                            if (Get.isSnackbarOpen == true) {
                              Get.back(canPop: false);
                            } else {
                              Get.back();
                            }
                          } else {
                            Get.back(closeOverlays: true);
                          }
                        },
                        child: SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                            )),
                      ),
                    ]),
                const SizedBox(height: 15),
                SizedBox(
                  height: 30.0,
                  width: Get.width,
                  child: CachedNetworkImage(
                      imageUrl: thumbnailPath,
                      placeholder: (c, e) => Lottie.asset(
                          "assets/images/circular_loader_image.json",
                          height: 30,
                          width: 30),
                      errorWidget: (c, e, r) => Lottie.asset(
                          "assets/images/circular_loader_image.json",
                          height: 30,
                          width: 30),
                      fit: BoxFit.fill,
                      height: 30,
                      width: 30),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 10.0,
                            color: Colors.white,
                          ).marginOnly(bottom: 7),
                          const SizedBox(
                            width: 3.0,
                          ),
                          Text(
                            programDate,
                            textScaleFactor: 1.0,
                            // showDate[widget.index],
                            style: const TextStyle(
                              color: Colors.white,
                              letterSpacing: 0.4,
                              fontFamily: 'Roboto',
                              fontSize: 9,
                            ),
                          ).marginOnly(bottom: 5),
                          Container(
                            height: 3.0,
                            width: 3.0,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                          ).marginOnly(bottom: 5, left: 4, right: 4),
                          Padding(
                            padding: const EdgeInsets.only(right: 0),
                            child: Text(
                              programTime,
                              textScaleFactor: 1.0,
                              // showTime[widget.index],
                              style: const TextStyle(
                                color: Colors.white,
                                letterSpacing: 0.4,
                                fontSize: 9.0,
                              ),
                            ).marginOnly(bottom: 5),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
