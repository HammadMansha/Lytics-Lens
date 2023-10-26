import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lytics_lens/widget/search_package/alphabet_view_search.dart';

import '../../Constants/common_color.dart';
import '../../Controllers/searchbar_controller.dart';

class GuestBottomSheet{
  static void showBottomSheet({
    required SearchBarController cntrl,
  }){
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
                list: List.generate(cntrl.guestModelList.length, (i) {
                  return AlphabetSearchModel(
                    title: cntrl.guestModelList[i].name!,
                    subtitle: "",
                  );
                }).toList(),
                buildItem: (context, __, i) {
                  return InkWell(
                    splashColor: const Color(0xff22B161),
                    hoverColor: const Color(0xff22B161),
                    focusColor: const Color(0xff22B161),
                    onTap: () {
                      if (cntrl.checkGuestList(i.title) == i.title) {
                        setState(() {
                          cntrl.filterlist
                              .removeWhere((element) => element == i.title);
                          cntrl.filterGuests
                              .removeWhere((element) => element == i.title);
                        });
                      } else {
                        setState(() {
                          cntrl.filterlist.add(i.title);
                          cntrl.filterGuests.add(i.title);
                        });
                      }
                      // cntrl.hostList[i].check.value = !cntrl.hostList[i].check.value;
                      // if (cntrl.hostList[i].check.value == true) {
                      //   cntrl.filterlist.add(cntrl.hostList[i].name.toString());
                      //   cntrl.filterHost.add(cntrl.hostList[i].name.toString());
                      // } else {
                      //   cntrl.filterlist.removeWhere(
                      //           (element) => element == cntrl.hostList[i].name);
                      //   cntrl.filterHost.removeWhere(
                      //           (element) => element == cntrl.hostList[i].name);
                      // }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Theme(
                          data: ThemeData(unselectedWidgetColor: Colors.white),
                          child: Checkbox(
                            visualDensity: const VisualDensity(
                                horizontal: -3.5, vertical: -2.5),
                            materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                            side: const BorderSide(
                                width: 1.0, color: CommonColor.filterColor),
                            activeColor: CommonColor.greenColor,
                            focusColor: CommonColor.filterColor,
                            hoverColor: CommonColor.filterColor,
                            value: cntrl.checkGuestList(i.title) == i.title
                                ? true
                                : false,
                            onChanged: (val) {
                              if (cntrl.checkGuestList(i.title) == i.title) {
                                setState(() {
                                  cntrl.filterlist.removeWhere(
                                          (element) => element == i.title);
                                  cntrl.filterGuests.removeWhere(
                                          (element) => element == i.title);
                                });
                              } else {
                                setState(() {
                                  cntrl.filterlist.add(i.title);
                                  cntrl.filterGuests.add(i.title);
                                });
                              }
                              // _.hostList[i].check.value =
                              // !_.hostList[i].check.value;
                              // if (_.hostList[i].check.value == true) {
                              //   _.filterlist.add(_.hostList[i].name.toString());
                              //   _.filterHost.add(_.hostList[i].name.toString());
                              // } else {
                              //   _.filterlist.removeWhere(
                              //           (element) => element == _.hostList[i].name);
                              //   _.filterHost.removeWhere(
                              //           (element) => element == _.hostList[i].name);
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
                  );
                },
              ).marginOnly(left: 20),
            ),
            const SizedBox(
              height: 10.0,
            ),
          ],
        );
      }),
      backgroundColor: CommonColor.backgroundColour,
    );
  
  }
}