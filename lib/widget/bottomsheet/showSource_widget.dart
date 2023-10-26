import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Constants/common_color.dart';
import '../../Controllers/searchbar_controller.dart';

class ShowSource extends StatelessWidget {
  const ShowSource({super.key , required this.controller});
  final SearchBarController controller;

  @override
  Widget build(BuildContext context) {
    List<Widget> source = [];
    for (int i = 0; i < controller.sourceModelList.length; i++) {
      source.add(FittedBox(
          fit: BoxFit.fill,
          alignment: Alignment.topLeft,
          child: Obx(() => GestureDetector(
                onTap: () {
                  controller.sourceModelList[i].check.value = !controller.sourceModelList[i].check.value;
                  if (controller.sourceModelList[i].check.value == true) {
                    if (controller.sourceModelList[i].name == 'All') {
                      controller.filterlist.add(controller.sourceModelList[i].name);
                      controller.filterSourceList.clear();
                      for (var e in controller.sourceModelList) {
                        if (e.name != 'All') {
                          controller.filterlist.remove(e.name);
                          e.check.value = false;
                          controller.filterSourceList.add(e.name);
                          controller.update();
                        }
                      }
                    } else {
                      for (var q in controller.sourceModelList) {
                        if (q.name == 'All') {
                          if (q.check.value == true) {
                            controller.filterSourceList.clear();
                            q.check.value = false;
                            controller.filterlist.remove(q.name);
                            controller.update();

                          }
                        }
                      }
                      controller.filterSourceList.add(controller.sourceModelList[i].name);
                      controller.filterlist.add(controller.sourceModelList[i].name);
                      controller.update();

                    }
                  } else {
                    if (controller.sourceModelList[i].name != 'All') {
                      controller.filterlist.remove(controller.sourceModelList[i].name);
                      controller.filterSourceList.remove(controller.sourceModelList[i].name);
                      controller.update();

                      for (var e in controller.sourceModelList) {
                        if (e.name == 'All') {
                          e.check.value = false;
                          controller.update();

                        }
                      }
                      if (controller.filterSourceList.isEmpty) {
                        for (var e in controller.sourceModelList) {
                          if (e.name != 'All') {
                            controller.filterSourceList.add(e.name);
                            controller.update();

                          } else {
                            controller.filterlist.add(e.name);
                            e.check.value = true;
                            controller.update();

                          }
                        }
                      }
                    } else {
                      controller.filterSourceList.clear();
                      controller.update();

                      for (var e in controller.sourceModelList) {
                        if (e.name != 'All') {
                          controller.filterSourceList.add(e.name);
                          e.check.value = false;
                          controller.update();

                        }
                      }
                      controller.filterlist.remove('All');
                      for (var q in controller.sourceModelList) {
                        if (q.name == 'All') {
                          controller.filterlist.add(q.name);
                          q.check.value = true;
                          controller.update();

                        }
                      }
                    }
                  }

                },
                child: Container(
                  height: 32,
                  width: 56,
                  decoration: BoxDecoration(
                      color: controller.sourceModelList[i].check.value == true
                          ? CommonColor.greenColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                          color: controller.sourceModelList[i].check.value == true
                              ? CommonColor.greenColor
                              : NewCommonColours.filterBorderColor)),
                  child: Center(
                    child: Text(
                      controller.sourceModelList[i].name=="Online"?"Video": controller.sourceModelList[i].name=="Blog"?"Web": controller.sourceModelList[i].name=="Tv"?"TV":"${controller.sourceModelList[i].name}",

                      style: TextStyle(
                          fontSize: 11.0,
                          fontFamily: 'Roboto',
                          letterSpacing: 0.4,
                          fontWeight: controller.sourceModelList[i].check.value == true
                              ? FontWeight.w500
                              : FontWeight.w300,
                          color: CommonColor.filterColor),
                    ).marginOnly(left: 10.0, right: 10.0),
                  ),
                ),
              ))
          // Obx(
          //   () =>
          // ),
          ).marginOnly(right: 5.0, bottom: 10.0, left: 0.0));
    }
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.end,
      children: source,
    );
  }
}
