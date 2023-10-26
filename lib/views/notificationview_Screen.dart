// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lytics_lens/Constants/common_color.dart';
import 'package:lytics_lens/Controllers/notificationvController.dart';
import 'package:flutter_switch/flutter_switch.dart';

class NotificationViewScreen extends StatelessWidget {
  const NotificationViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColor.allScreenBackgroundColor,
      body: bodyData(context),
      appBar: AppBar(
        backgroundColor: CommonColor.allScreenBackgroundColor,
        title: Align(
          alignment: Alignment.centerLeft,
          child: const Text(
            "Notifications",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ).marginOnly(top: 15),
        ),
        elevation: 0.0,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.keyboard_backspace_rounded,
          ).marginOnly(left: 34, top: 15),
        ),
      ),
    );
  }

  Widget bodyData(context) {
    return GetBuilder<NotificationController>(
      init: NotificationController(),
      builder: (_) {
        final mqData = MediaQuery.of(context);
        final mqDataNew = mqData.copyWith(
            textScaleFactor:
                mqData.textScaleFactor > 1.0 ? 1.0 : mqData.textScaleFactor);

        return _.isLoading
            ? Center(
                child: Image.asset(
                  "assets/images/gif.gif",
                  height: 300.0,
                  width: 300.0,
                ),
              )
            : MediaQuery(
                data: mqDataNew,
                child: SizedBox(
                  height: Get.height,
                  width: Get.width,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              child: Text(
                                "${_.notificationsList[2]['title']}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                  fontStyle: FontStyle.normal,
                                  color: Colors.white,
                                ),
                              ).marginOnly(top: 64, left: 38),
                            ),
                            const Spacer(),
                            FlutterSwitch(
                                width: 55.0,
                                height: 26.0,
                                valueFontSize: 25.0,
                                toggleSize: 24.0,
                                padding: 0,
                                activeColor: const Color(0xff23B662),
                                inactiveColor: const Color(0xff323544),
                                value: _.notificationsList[2]['isShow'],
                                onToggle: (val) {
                                  _.notificationsList[2]['isShow'] = val;
                                  _.getUpdateValue(
                                      _.notificationsList[2]['docId'], val);

                                  _.update();
                                }).marginOnly(top: 64, right: 23)
                          ],
                        ),
                        const Divider(
                          indent: 38,
                          endIndent: 21,
                          color: Color(0xffC4C4C4),
                        ).marginOnly(top: 38),
                        //After divider line text

                        Row(
                          children: [
                            Container(
                              child: Text(
                                "${_.notificationsList[1]['title']}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ).marginOnly(top: 44, left: 38),
                            ),
                            const Spacer(),
                            FlutterSwitch(
                                width: 55.0,
                                height: 26.0,
                                valueFontSize: 25.0,
                                toggleSize: 24.0,
                                padding: 0,
                                activeColor: const Color(0xff23B662),
                                inactiveColor: const Color(0xff323544),
                                value: _.notificationsList[2]['isShow'] == false
                                    ? false
                                    : _.notificationsList[1]['isShow'],
                                onToggle: (val) {
                                  if (_.notificationsList[2]['isShow'] !=
                                      false) {
                                    _.notificationsList[1]['isShow'] = val;
                                    _.getUpdateValue(
                                        _.notificationsList[1]['docId'], val);
                                    _.update();
                                  }
                                }).marginOnly(top: 44, right: 23)
                          ],
                        ),
                        Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  child: Text(
                                    "${_.notificationsList[0]['title']}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ).marginOnly(top: 70, left: 38),
                                ),
                                Text(
                                  "${_.notificationsList[0]['subTitle']}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 13,
                                    color: Colors.white,
                                  ),
                                ).marginOnly(left: 20, top: 4)
                              ],
                            ),
                            const Spacer(),
                            FlutterSwitch(
                                width: 55.0,
                                height: 26.0,
                                valueFontSize: 25.0,
                                toggleSize: 24.0,
                                padding: 0,
                                activeColor: const Color(0xff23B662),
                                inactiveColor: const Color(0xff323544),
                                value: _.notificationsList[2]['isShow'] == false
                                    ? false
                                    : _.notificationsList[0]['isShow'],
                                onToggle: (val) {
                                  if (_.notificationsList[2]['isShow'] !=
                                      false) {
                                    _.notificationsList[0]['isShow'] = val;
                                    _.getUpdateValue(
                                        _.notificationsList[0]['docId'], val);
                                    _.update();
                                  }
                                }).marginOnly(top: 70, right: 23)
                          ],
                        ),
                        Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  child: Text(
                                    "${_.notificationsList[3]['title']}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ).marginOnly(top: 70, left: 38),
                                ),
                                Text(
                                  "${_.notificationsList[3]['subTitle']}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 13,
                                    color: Colors.white,
                                  ),
                                ).marginOnly(left: 25, top: 4)
                              ],
                            ),
                            const Spacer(),
                            FlutterSwitch(
                                width: 55.0,
                                height: 26.0,
                                valueFontSize: 25.0,
                                toggleSize: 24.0,
                                padding: 0,
                                activeColor: const Color(0xff23B662),
                                inactiveColor: const Color(0xff323544),
                                value: _.notificationsList[2]['isShow'] == false
                                    ? false
                                    : _.notificationsList[3]['isShow'],
                                onToggle: (val) {
                                  if (_.notificationsList[2]['isShow'] !=
                                      false) {
                                    _.notificationsList[3]['isShow'] = val;
                                    _.getUpdateValue(
                                        _.notificationsList[3]['docId'], val);
                                    _.update();
                                  }
                                }).marginOnly(top: 64, right: 23)
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }
}
