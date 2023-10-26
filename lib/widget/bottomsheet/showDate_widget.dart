import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Constants/common_color.dart';
import '../../Controllers/searchbar_controller.dart';

class ShowDate extends StatelessWidget {
  const ShowDate({super.key, required this.controller});
  final SearchBarController controller;

  @override
  Widget build(BuildContext context) {
    List<Widget> g = [];
    for (int i = 0; i < controller.alldatelist1.length; i++) {
      g.add(FittedBox(
        fit: BoxFit.fill,
        child: Obx(() => GestureDetector(
              onTap: () {
                for (var e in controller.alldatelist1) {
                  e.check.value = false;
                  controller.filterlist
                      .removeWhere((item) => item == e.startDate);
                  controller.startDate.clear();
                  controller.startDate.clear();
                  controller.filterlist
                      .removeWhere((item) => item == e.endDate);
                }
                if (controller.alldatelist1[i].check.value == false) {
                  controller.alldatelist1[i].check.value = true;
                  controller.startDate.text =
                      controller.alldatelist1[i].startDate!;
                  controller.startDate.text =
                      controller.alldatelist1[i].endDate!;
                  controller.filterlist
                      .removeWhere((i) => i.toString().substring(0, 2) == '20');
                  controller.filterlist.add(
                      '${controller.alldatelist1[i].endDate} - ${controller.alldatelist1[i].startDate}');
                  controller.update();
                }
              },
              child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                      color: controller.alldatelist1[i].check.value == true
                          ? CommonColor.greenColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                          color: controller.alldatelist1[i].check.value == true
                              ? CommonColor.greenColor
                              : CommonColor.filterColor)),
                  child: Center(
                    child: Text(
                      "${controller.alldatelist1[i].name}",
                      style: TextStyle(
                          fontSize: 11.0,
                          fontWeight:
                              controller.alldatelist1[i].check.value == true
                                  ? FontWeight.w500
                                  : FontWeight.w300,
                          color: CommonColor.filterColor),
                    ).marginOnly(left: 20.0, right: 20.0),
                  )),
            )),
      ).marginOnly(right: 5.0, bottom: 8.62));
    }
    return Wrap(
      children: g,
    );
  }
}
