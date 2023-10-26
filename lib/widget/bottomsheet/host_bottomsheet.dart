import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lytics_lens/Constants/common_color.dart';
import 'package:lytics_lens/Models/hostmodel.dart';

import '../../Controllers/searchbar_controller.dart';
import '../search_package/alphabet_view_search.dart';

class HostBottomSheet {
  static void showBottomSheet({
    required List<HostModel> hostList,
    required RxList<dynamic> filterlist,
    required RxList<dynamic> filterHost,
    SearchBarController? controller,
    required bool isSearchScreen,
  }) {
    Get.bottomSheet(
      StatefulBuilder(builder: (context, setState) {
        return Column(
          children: [
            const SizedBox(
              height: 10.0,
            ),
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                height: 5.0,
                width: 60.0,
                decoration: BoxDecoration(
                    color: CommonColor.filterColor,
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: AlphabetSearchView.modelList(
                decoration: AlphabetSearchDecoration.fromContext(
                  context,
                  backgroundColor: Colors.transparent,
                  color: Colors.transparent,
                  dividerThickness: 0.0,
                  letterHeaderTextStyle:
                      const TextStyle(fontSize: 0.0, color: Colors.white),
                  withSearch: false,
                  titleStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                  subtitleStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.amber,
                  ),
                ),
                list: List.generate(hostList.length, (i) {
                  return AlphabetSearchModel(
                    title: hostList[i].name!,
                    subtitle: "",
                  );
                }).toList(),
                buildItem: (context, __, i) {
                  return isSearchScreen
                      ? InkWell(
                          splashColor: const Color(0xff22B161),
                          hoverColor: const Color(0xff22B161),
                          focusColor: const Color(0xff22B161),
                          onTap: () {
                            if (controller!.checkList(i.title) == i.title) {
                              setState(() {
                                filterlist.removeWhere(
                                    (element) => element == i.title);
                                filterHost.removeWhere(
                                    (element) => element == i.title);
                              });
                            } else {
                              setState(() {
                                filterlist.add(i.title);
                                filterHost.add(i.title);
                              });
                            }
                            // hostList[i].check.value = !hostList[i].check.value;
                            // if (hostList[i].check.value == true) {
                            //   filterlist.add(hostList[i].name.toString());
                            //   filterHost.add(hostList[i].name.toString());
                            // } else {
                            //   filterlist.removeWhere(
                            //           (element) => element == hostList[i].name);
                            //   filterHost.removeWhere(
                            //           (element) => element == hostList[i].name);
                            // }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Theme(
                                data: ThemeData(
                                    unselectedWidgetColor: Colors.white),
                                child: Checkbox(
                                  visualDensity: const VisualDensity(
                                      horizontal: -3.5, vertical: -2.5),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  side: const BorderSide(
                                      width: 1.0,
                                      color: CommonColor.filterColor),
                                  activeColor: CommonColor.greenColor,
                                  focusColor: CommonColor.filterColor,
                                  hoverColor: CommonColor.filterColor,
                                  value:
                                      controller!.checkList(i.title) == i.title
                                          ? true
                                          : false,
                                  onChanged: (val) {
                                    if (controller.checkList(i.title) ==
                                        i.title) {
                                      setState(() {
                                        filterlist.removeWhere(
                                            (element) => element == i.title);
                                        filterHost.removeWhere(
                                            (element) => element == i.title);
                                      });
                                    } else {
                                      setState(() {
                                        filterlist.add(i.title);
                                        filterHost.add(i.title);
                                      });
                                    }
                                    // hostList[i].check.value =
                                    // !hostList[i].check.value;
                                    // if (hostList[i].check.value == true) {
                                    //   filterlist.add(hostList[i].name.toString());
                                    //   filterHost.add(hostList[i].name.toString());
                                    // } else {
                                    //   filterlist.removeWhere(
                                    //           (element) => element == hostList[i].name);
                                    //   filterHost.removeWhere(
                                    //           (element) => element == hostList[i].name);
                                    // }
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 5.0,
                              ),
                              Flexible(
                                child: Text(
                                  i.title,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Roboto',
                                    letterSpacing: 0.4,
                                    color: Color(0xffffffff),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox();
                },
              ).marginOnly(left: 20),
              // ListView.separated(
              //   itemCount: hostList.length,
              //   shrinkWrap: true,
              //   separatorBuilder: (c, e) {
              //     return const SizedBox(
              //       width: 20.0,
              //     );
              //   },
              //   itemBuilder: (c, i) {
              //     return InkWell(
              //       splashColor: Color(0xff22B161),
              //       hoverColor: Color(0xff22B161),
              //       focusColor: Color(0xff22B161),
              //       onTap: () {
              //         hostList[i].check.value = !hostList[i].check.value;
              //         if (hostList[i].check.value == true) {
              //           filterlist.add(hostList[i].name.toString());
              //           filterHost.add(hostList[i].name.toString());
              //         } else {
              //           filterlist.removeWhere(
              //               (element) => element == hostList[i].name);
              //           filterHost.removeWhere(
              //               (element) => element == hostList[i].name);
              //         }
              //       },
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.start,
              //         children: [
              //           Theme(
              //             child: Obx(
              //               () => Checkbox(
              //                 visualDensity:
              //                     VisualDensity(horizontal: -3.5, vertical: -2.5),
              //                 materialTapTargetSize:
              //                     MaterialTapTargetSize.shrinkWrap,
              //                 side: BorderSide(
              //                     width: 1.0, color: CommonColor.filterColor),
              //                 activeColor: CommonColor.greenColor,
              //                 focusColor: CommonColor.filterColor,
              //                 hoverColor: CommonColor.filterColor,
              //                 value: hostList[i].check.value,
              //                 onChanged: (val) {
              //                   hostList[i].check.value =
              //                       !hostList[i].check.value;
              //                   if (hostList[i].check.value == true) {
              //                     filterlist.add(hostList[i].name.toString());
              //                     filterHost.add(hostList[i].name.toString());
              //                   } else {
              //                     filterlist.removeWhere(
              //                         (element) => element == hostList[i].name);
              //                     filterHost.removeWhere(
              //                         (element) => element == hostList[i].name);
              //                   }
              //                 },
              //               ),
              //             ),
              //             data: ThemeData(unselectedWidgetColor: Colors.white),
              //           ),
              //           SizedBox(
              //             width: 5.0,
              //           ),
              //           Flexible(
              //             child: Text(
              //               "${hostList[i].name}",
              //               overflow: TextOverflow.ellipsis,
              //               maxLines: 1,
              //               style: TextStyle(
              //                 fontSize: 13.0,
              //                 fontWeight: FontWeight.w400,
              //                 fontFamily: 'Roboto',
              //                 letterSpacing: 0.4,
              //                 color: CommonColor.filterColor,
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     );
              //   },
              // ).marginOnly(left: 20.0, right: 20.0),
            ),
          ],
        );
      }),
      backgroundColor: CommonColor.backgroundColour,
    );
  }
}
