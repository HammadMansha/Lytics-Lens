import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lytics_lens/Constants/app_strrings.dart';
import 'package:lytics_lens/Constants/common_color.dart';
import 'package:lytics_lens/widget/bottomsheet/channel_bottomsheet.dart';
import 'package:lytics_lens/widget/bottomsheet/guest_bottomsheet.dart';
import 'package:lytics_lens/widget/bottomsheet/host_bottomsheet.dart';
import 'package:lytics_lens/widget/bottomsheet/searchProgram_bottomsheet.dart';
import 'package:lytics_lens/widget/bottomsheet/showSource_widget.dart';
import 'package:lytics_lens/widget/snackbar/common_snackbar.dart';
import '../../Controllers/searchbar_controller.dart';
import '../../views/Search_Screen.dart';
import '../common_button/common_button.dart';
import '../common_textstyle/common_text_style.dart';

class FilterBottomSheet {
  static void showBottomSheet({required SearchBarController cntrl,})
  {
    Get.bottomSheet(
      StatefulBuilder(builder: (ctx, setState) {
        final mqData = MediaQuery.of(ctx);
        final mqDataNew = mqData.copyWith(
            textScaleFactor:
                mqData.textScaleFactor > 1.0 ? 1.0 : mqData.textScaleFactor);

        return MediaQuery(
          data: mqDataNew,
          child: SizedBox(
            width: Get.width,
            height: Get.height / 1.2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10.0,
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 5.0,
                      width: Get.width / 6,
                      decoration: BoxDecoration(
                        color: CommonColor.textFieldBorderColor,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Filters',
                              style: TextStyle(
                                letterSpacing: 0.4,
                                fontSize: 18.0,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                                onTap: () {
                                  // Get.back();
                                  setState(() {
                                    cntrl.startData=null;
                                    cntrl.endData=null;
                                    cntrl.daysDiff=0;
                                    cntrl.startDate.text =
                                        '${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day - 1}';
                                    cntrl.endDate.text =
                                        '${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}';
                                    cntrl.filterChannelList.clear();
                                    cntrl.filterProgramType.clear();
                                    cntrl.filterHost.clear();
                                    cntrl.filterGuests.clear();
                                    cntrl.filterSourceList.clear();
                                    cntrl.selectedchannel.clear();
                                    cntrl.selectformDate.value = DateTime.now();
                                    cntrl.selecttoDate.value = DateTime.now();
                                    cntrl.filterlist.clear();
                                    cntrl.filterlist.add('All');
                                    cntrl.filterlist.add('All Channels');
                                    cntrl.selectedchannel.add('All Channels');

                                    cntrl.searchContentTypeSelect = false;
                                    cntrl.searchChannelSelect = false;
                                    cntrl.searchStartDateSelect = false;
                                    cntrl.searchEndDateSelect = false;
                                    cntrl.searchHostSelect = false;
                                    cntrl.searchGuestSelect = false;

                                    for (var element in cntrl.filterlist) {
                                      if (element == 'All Channels') {
                                        for (var e in cntrl.channellist) {
                                          if (e.name != 'All Channels') {
                                            cntrl.filterChannelList.add(e.name);
                                          }
                                        }
                                      }
                                    }
                                    for (var e in cntrl.channellist) {
                                      if (e.name == 'All Channels') {
                                        e.check.value = true;
                                      } else {
                                        e.check.value = false;
                                      }
                                    }
                                    cntrl.filterlist.forEach((element) {
                                      if (element == 'All') {
                                        cntrl.sourceModelList.forEach((e) {
                                          if (e.name != 'All') {
                                            cntrl.filterSourceList.add(e.name);
                                          }
                                        });
                                      }
                                    });
                                    cntrl.sourceModelList.forEach((e) {
                                      if (e.name == 'All') {
                                        e.check.value = true;
                                      } else {
                                        e.check.value = false;
                                      }
                                    });
                                    for (var element in cntrl.programType) {
                                      element.check.value = false;
                                    }
                                    for (var element in cntrl.alldatelist1) {
                                      element.check.value = false;
                                    }
                                    cntrl.startTime.clear();
                                    cntrl.endTime.clear();
                                    cntrl.hostselect.value.clear();
                                  });
                                  cntrl.update();
                                },
                                child: Row(
                                  children: const [
                                    Text(
                                      'Clear All',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        letterSpacing: 0.4,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                    // Image.asset(
                                    //     "assets/images/trashcntrlfull.png")
                                    //     .marginOnly(left: 5, bottom: 3),
                                  ],
                                )),
                            const SizedBox(
                              width: 2.0,
                            ),
                          ],
                        ).marginOnly(top: 22, right: 18),
                        const SizedBox(
                          height: 26.0,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Source',
                            style: NewTextStyle.font9Weight500,
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),

                        SizedBox(
                            width: Get.width,
                            child: ShowSource(
                              controller: cntrl,
                            )),
                        const SizedBox(
                          height: 26.0,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text('Channel',
                              style: NewTextStyle.font9Weight500),
                        ),
                        const SizedBox(
                          height: 7.0,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                cntrl.searchContentTypeSelect = false;
                                cntrl.searchChannelSelect = true;
                                cntrl.searchStartDateSelect = false;
                                cntrl.searchEndDateSelect = false;
                                cntrl.searchHostSelect = false;
                                cntrl.searchGuestSelect = false;
                              });
                              // channelSheet(ctx, cntrl);
                              ChannelBottomSheet.showBottomheet(
                                channellist: cntrl.channellist,
                                filterlist: cntrl.filterlist,
                                filterChannelList: cntrl.filterChannelList,
                              );
                              // channelBottomSheet(cntrl);
                            },
                            child: Container(
                              height: 50.0,
                              width: Get.width,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: cntrl.searchChannelSelect == true
                                      ? NewCommonColours.filterGreenBorderColor
                                      : NewCommonColours.filterTopBtnBorder,
                                ),
                                borderRadius: BorderRadius.circular(2.0),
                              ),
                              child: Obx(
                                () => Row(
                                  children: [
                                    SizedBox(
                                      width: Get.width / 1.37,
                                      child: Text(
                                        cntrl.filterChannelList.length ==
                                                cntrl.channellist.length - 1
                                            ? 'All Channels'
                                            : cntrl.listToString(
                                                cntrl.filterChannelList),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: cntrl.filterChannelList.length ==
                                            cntrl.channellist.length - 1?NewTextStyle.fonT14Weight300:NewTextStyle.fonT14Weight300,
                                      ).marginOnly(left: 12.0, right: 5.0),
                                    ),
                                    const Spacer(),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 20,
                                      color:
                                          NewCommonColours.filterDropDownColor,
                                    ).marginOnly(right: 21)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        //--------------------Show Program type bottom sheet---------
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text('Content Type',
                                  style: NewTextStyle.font9Weight500)
                              .marginOnly(bottom: 7),
                        ).marginOnly(top: 23),

                        Align(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                cntrl.searchContentTypeSelect = true;
                                cntrl.searchChannelSelect = false;
                                cntrl.searchStartDateSelect = false;
                                cntrl.searchEndDateSelect = false;
                                cntrl.searchHostSelect = false;
                                cntrl.searchGuestSelect = false;
                              });
                              ShowProgramSheet.showBottomSheet(cntrl: cntrl);
                            },
                            child: Container(
                              height: 50.0,
                              width: Get.width,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: cntrl.searchContentTypeSelect == true
                                      ? NewCommonColours.filterGreenBorderColor
                                      : NewCommonColours.filterTopBtnBorder,
                                ),
                                borderRadius: BorderRadius.circular(2.0),
                              ),
                              child: Obx(
                                () => Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: Get.width / 1.37,
                                      child: Text(
                                              cntrl.filterProgramType.isEmpty
                                                  ? 'Select'
                                                  : cntrl.listToString(
                                                      cntrl.filterProgramType),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style:cntrl.filterProgramType.isEmpty?
                                                  NewTextStyle.font14Weight300:NewTextStyle.fonT14Weight300
                                      )
                                          .marginOnly(left: 12.0, right: 5.0),
                                    ),
                                    const Spacer(),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      color:
                                          NewCommonColours.filterDropDownColor,
                                      size: 20,
                                    ).marginOnly(right: 21)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        //-------------------Date section----------
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text('Start Date',
                                      style: NewTextStyle.font9Weight500),
                                ).marginOnly(top: 23),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      cntrl.searchContentTypeSelect = false;
                                      cntrl.searchChannelSelect = false;
                                      cntrl.searchStartDateSelect = true;
                                      cntrl.searchEndDateSelect = false;
                                      cntrl.searchHostSelect = false;
                                      cntrl.searchGuestSelect = false;
                                      cntrl.showCalendar(ctx);
                                    });
                                  },
                                  child: Container(
                                          height: 50,
                                          width: Get.width / 2.5,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color:
                                                  cntrl.searchStartDateSelect ==
                                                          true
                                                      ? NewCommonColours
                                                          .filterGreenBorderColor
                                                      : NewCommonColours
                                                          .filterTopBtnBorder,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(2.0),
                                          ),
                                          child: cntrl.startData == null
                                              ? Center(
                                                  child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      cntrl.startDate.text,
                                                      style: NewTextStyle
                                                          .font14Weight300,
                                                    ).marginOnly(left: 15),
                                                    Icon(
                                                      Icons
                                                          .calendar_month_outlined,
                                                      color: const Color(
                                                              0xff22b161)
                                                          .withOpacity(0.79),
                                                      size: 18,
                                                    ).marginOnly(right: 14)
                                                  ],
                                                ))
                                              : Center(
                                                  child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      cntrl.startData
                                                          .toString()
                                                          .split(" ")
                                                          .first,
                                                      style: NewTextStyle
                                                          .fonT14Weight300,
                                                    ).marginOnly(left: 15),
                                                    Icon(
                                                      Icons
                                                          .calendar_month_outlined,
                                                      color: const Color(
                                                              0xff22b161)
                                                          .withOpacity(0.79),
                                                      size: 18,
                                                    ).marginOnly(right: 14)
                                                  ],
                                                )))
                                      .marginOnly(top: 10),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text('End Date',
                                      style: NewTextStyle.font9Weight500),
                                ).marginOnly(top: 23, left: 15),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      cntrl.searchContentTypeSelect = false;
                                      cntrl.searchChannelSelect = false;
                                      cntrl.searchStartDateSelect = false;
                                      cntrl.searchEndDateSelect = true;
                                      cntrl.searchHostSelect = false;
                                      cntrl.searchGuestSelect = false;
                                      cntrl.showCalendar(ctx);
                                    });
                                  },
                                  child: Container(
                                          height: 50,
                                          width: Get.width / 2.4,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: cntrl.searchEndDateSelect ==
                                                      true
                                                  ? NewCommonColours
                                                      .filterGreenBorderColor
                                                  : NewCommonColours
                                                      .filterTopBtnBorder,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(2.0),
                                          ),
                                          child: cntrl.endData == null
                                              ? Center(
                                                  child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      cntrl.endDate.text,
                                                      style: NewTextStyle
                                                          .font14Weight300,
                                                    ).marginOnly(left: 15),
                                                    Icon(
                                                      Icons
                                                          .calendar_month_outlined,
                                                      color: const Color(
                                                              0xff22b161)
                                                          .withOpacity(0.79),
                                                      size: 18,
                                                    ).marginOnly(right: 14)
                                                  ],
                                                ))
                                              : Center(
                                                  child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      cntrl.endData
                                                          .toString()
                                                          .split(" ")
                                                          .first,
                                                      style: NewTextStyle
                                                          .fonT14Weight300,
                                                    ).marginOnly(left: 15),
                                                    Icon(
                                                      Icons
                                                          .calendar_month_outlined,
                                                      color: const Color(
                                                              0xff22b161)
                                                          .withOpacity(0.79),
                                                      size: 18,
                                                    ).marginOnly(right: 14)
                                                  ],
                                                )))
                                      .marginOnly(top: 10, left: 15),
                                ),
                              ],
                            ),
                          ],
                        ),

                        //-----------------select host bottom sheet-----------
                        Align(
                          alignment: Alignment.topLeft,
                          child:
                              Text('Host', style: NewTextStyle.font9Weight500)
                                  .marginOnly(bottom: 7),
                        ).marginOnly(top: 23),

                        Align(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                cntrl.searchContentTypeSelect = false;
                                cntrl.searchChannelSelect = false;
                                cntrl.searchStartDateSelect = false;
                                cntrl.searchEndDateSelect = false;
                                cntrl.searchHostSelect = true;
                                cntrl.searchGuestSelect = false;
                              });
                              HostBottomSheet.showBottomSheet(
                                hostList: cntrl.hostList,
                                filterlist: cntrl.filterlist,
                                filterHost: cntrl.filterHost,
                                isSearchScreen: true,
                                controller: cntrl,
                              );
                            },
                            child: Container(
                              height: 50.0,
                              width: Get.width,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: cntrl.searchHostSelect == true
                                      ? NewCommonColours.filterGreenBorderColor
                                      : NewCommonColours.filterTopBtnBorder,
                                ),
                                borderRadius: BorderRadius.circular(2.0),
                              ),
                              child: Obx(
                                () => Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: Get.width / 1.37,
                                      child: Text(
                                              cntrl.filterHost.isEmpty
                                                  ? 'Select Host'
                                                  : cntrl.listToString(
                                                      cntrl.filterHost),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style:cntrl.filterHost.isEmpty?
                                                  NewTextStyle.font14Weight300: NewTextStyle.fonT14Weight300)
                                          .marginOnly(left: 12.0, right: 5.0),
                                    ),
                                    const Spacer(),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      color:
                                          NewCommonColours.filterDropDownColor,
                                      size: 20,
                                    ).marginOnly(right: 21)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        //----------Select Guest bottom sheet-------
                        Align(
                          alignment: Alignment.topLeft,
                          child:
                              Text('Guest', style: NewTextStyle.font9Weight500)
                                  .marginOnly(bottom: 7),
                        ).marginOnly(top: 23),

                        Align(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                cntrl.searchContentTypeSelect = false;
                                cntrl.searchChannelSelect = false;
                                cntrl.searchStartDateSelect = false;
                                cntrl.searchEndDateSelect = false;
                                cntrl.searchHostSelect = false;
                                cntrl.searchGuestSelect = true;
                              });
                              GuestBottomSheet.showBottomSheet(cntrl: cntrl);
                            },
                            child: Container(
                              height: 50.0,
                              width: Get.width,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: cntrl.searchGuestSelect == true
                                      ? NewCommonColours.filterGreenBorderColor
                                      : NewCommonColours.filterTopBtnBorder,
                                ),
                                borderRadius: BorderRadius.circular(2.0),
                              ),
                              child: Obx(
                                () => Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: Get.width / 1.37,
                                      child: Text(
                                              cntrl.filterGuests.isEmpty
                                                  ? 'Select Guest'
                                                  : cntrl.listToString(
                                                      cntrl.filterGuests),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style:cntrl.filterGuests.isEmpty?
                                                  NewTextStyle.font14Weight300:NewTextStyle.fonT14Weight300)
                                          .marginOnly(left: 12.0, right: 5.0),
                                    ),
                                    const Spacer(),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      color:
                                          NewCommonColours.filterDropDownColor,
                                      size: 20,
                                    ).marginOnly(right: 21)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: Get.width / 3.2,
                      child: CommonFilterButton(
                        fillColor: NewCommonColours.filterClearBtnColor,
                        textStyle: NewTextStyle.font12Weight400,
                        onPressed: () {
                          Get.back();
                        },
                        text: "Cancel",
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    SizedBox(
                      width: Get.width / 3.2,
                      child: CommonFilterButton(
                        fillColor: NewCommonColours.filterApplyBtnColor,
                        textStyle: NewTextStyle.font12Weight400,
                        onPressed: () async {
                          // var diff = cntrl.startData!
                          //     .difference(cntrl.endData!)
                          //     .inDays;
                          if(cntrl.daysDiff>180){
                            Get.log("Range errorrrrrrrrrrr ${cntrl.daysDiff}");

                            CustomSnackBar.showSnackBar(
                                title: AppStrings.dateRangeError,
                                message: "",
                                backgroundColor: CommonColor.snackbarColour,
                                isWarning: true);
                          }

                          else if (cntrl.searchText.value.text.isEmpty) {
                            //Todo Shsow Toast
                            CustomSnackBar.showSnackBar(
                                title: AppStrings.searchBarEmpty,
                                message: "",
                                backgroundColor: CommonColor.snackbarColour,
                                isWarning: true);
                          } else {
                            if (Get.currentRoute.toString() == '/SearchScreen') {
                              Get.back();
                              await cntrl.getFilterJobs(
                                  cntrl.searchText.value.text, 1);
                            } else {
                              Get.back();
                              Get.to(() => const SearchScreen());
                              await cntrl.getFilterJobs(
                                  cntrl.searchText.value.text, 1);
                            }
                          }

                          // if(cntrl.searchText.value=='' ||  cntrl.searchdata.value.text.isEmpty){
                          //   Get.log("aaaaaaaaaaaa");
                          //   CustomSnackBar.showSnackBar(
                          //       title: AppStrings.searchBarEmpty,
                          //       message: "",
                          //       backgroundColor: CommonColor.snackbarColour,
                          //       isWarning: true);
                          // }
                          // if (cntrl.searchdata.value.text != '' ||
                          //     cntrl.searchdata.value.text.isNotEmpty) {
                          //   Get.log("bbbbbbbbb");
                          //
                          //   cntrl.update();
                          //   if (diff >= 0 && diff <= 183) {
                          //     Get.log("cccccccccc");
                          //     Get.back();
                          //     if (Get.currentRoute == '/search') {
                          //       Get.log("dddddddddddd");
                          //
                          //       Get.to(() => const SearchScreen());
                          //       await cntrl.getFilterJobs(
                          //           cntrl.searchText.value.text, 1);
                          //     } else {
                          //       Get.log("eeeeeeeeeeeee");
                          //
                          //       await cntrl.getFilterJobs(
                          //           cntrl.searchdata.value.text, 1);
                          //     }
                          //   } else if (diff < 0) {
                          //     Get.log("ffffffffff");
                          //
                          //     CustomSnackBar.showSnackBar(
                          //         title: AppStrings.dateerror,
                          //         message: "",
                          //         backgroundColor: CommonColor.snackbarColour,
                          //         isWarning: true);
                          //   } else {
                          //     Get.log("gggggggggggg");
                          //
                          //     CustomSnackBar.showSnackBar(
                          //         title: AppStrings.difference,
                          //         message: "",
                          //         backgroundColor: CommonColor.snackbarColour,
                          //         isWarning: true);
                          //   }
                          // } else {
                          //   if (cntrl.searchdata.value.text == '' &&
                          //       cntrl.searchdata.value.text.isEmpty) {
                          //     Get.log("hhhhhhhhh");
                          //     CustomSnackBar.showSnackBar(
                          //         title: AppStrings.searchBarEmpty,
                          //         message: "",
                          //         backgroundColor: CommonColor.snackbarColour,
                          //         isWarning: true);
                          //   }

                          // cntrl.searchdata.value.text =
                          //     cntrl.lastSearchText.value.text;
                          // if (diff >= 0 && diff <= 183) {
                          //   Get.log("iiiiiiiiiiiii");
                          //
                          //   Get.back();
                          //   await cntrl.getFilterJobs(
                          //       cntrl.searchdata.value.text, 1);
                          // } else if (diff < 0) {
                          //   Get.log("jjjjjjjjjjjjj");
                          //
                          //   CustomSnackBar.showSnackBar(
                          //       title: AppStrings.dateerror,
                          //       message: "",
                          //       backgroundColor: CommonColor.snackbarColour,
                          //       isWarning: true);
                          // } else {
                          //   Get.log("kkkkkkkkkkkk");
                          //
                          //   CustomSnackBar.showSnackBar(
                          //       title: AppStrings.difference,
                          //       message: "",
                          //       backgroundColor: CommonColor.snackbarColour,
                          //       isWarning: true);
                          // }
                          // }
                        },
                        text: "Apply Filter",
                      ),
                    ),
                  ],
                ).marginOnly(top: 31.0, bottom: 40.0),
              ],
            ).marginOnly(left: 30.0, right: 18.0),
          ),
        );
      }),
      isScrollControlled: true,
      backgroundColor: NewCommonColours.playerDetailScreenColor,
    );
  }
}
