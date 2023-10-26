// ignore_for_file: file_names
import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lytics_lens/views/barCharts.dart';
import 'package:lytics_lens/widget/common_textstyle/common_text_style.dart';
import 'package:lytics_lens/widget/graph/guest_graph.dart';

import '../Constants/app_strrings.dart';
import '../Constants/common_color.dart';
import '../Controllers/reports_controller.dart';
import '../widget/common_button/common_button.dart';
import '../widget/search_package/src/alphabet_search_decoration.dart';
import '../widget/search_package/src/alphabet_search_model.dart';
import '../widget/search_package/src/alphabet_search_view.dart';
import '../widget/snackbar/common_snackbar.dart';
import '../widget/internet_connectivity/internetconnectivity_screen.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final mqDataNew = mqData.copyWith(
        textScaleFactor:
            mqData.textScaleFactor > 1.0 ? 1.0 : mqData.textScaleFactor);

    return GetBuilder<ReportsController>(
      init: ReportsController(),
      builder: (_) {
        return MediaQuery(
          data: mqDataNew,
          child: Scaffold(
              body: Container(
            width: Get.width,
            height: Get.height,
            color: CommonColor.appBarColor,
            child: _.isSocket
                ? InterConnectivity(
                    onPressed: () async {
                      _.isLoading = true;
                      _.isSocket = false;
                      _.update();
                      _.filterlist.clear();
                      _.filterlist1.clear();
                      _.filterlist.add("All Channels");
                      _.filterlist1.add("All Channels");
                      await _.getAllHost();
                      await _.getChannels();
                      await _.getProgram();
                      await _.getProgramType();
                      await _.getTopic();
                      await _.firstTimeGraphData('Top 10');
                      await _.firstTimePieChartData();
                      _.getdates();
                      _.isLoading = false;
                      _.update();
                    },
                  )
                : _.isLoading
                    ? Center(
                        child: Image.asset(
                          "assets/images/gif.gif",
                          height: 300.0,
                          width: 300.0,
                        ),
                      ).marginOnly(bottom: 50.0)
                    : GestureDetector(
                        onTap: () {
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                        },
                        onVerticalDragCancel: () {
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                        },
                        child: SafeArea(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 10.0,
                                ),
                                // <---------------- Trending Heading --------->
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Trending Topics',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        letterSpacing: 0.4,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        trendingBottomSheet(context, _);

                                      },
                                      child: Container(
                                        height: 30,
                                        width: 20,
                                        child: Image.asset(
                                          "assets/images/search_filter.png",
                                          height: 12,
                                          width: 16,
                                          fit: BoxFit.scaleDown,
                                        ),
                                      ),
                                    ),

                                  ],
                                ).marginOnly(left: 16, right: 6, bottom: 0),
                                // <------------- Graph 1st COntainer ---------->
                                Container(
                                  width: double.infinity,
                                  height: 280,
                                  decoration: BoxDecoration(
                                    color:
                                        CommonColor.transparent,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: firstContainer(_, context),
                                ).marginOnly(left: 5, right: 5,top: 10),

                                // <---------------- 2nd Graph ----------->
                                // Container(
                                //   color: CommonColor.transparent,
                                //   //color: Color(0xff2d2f3a),
                                //   width: double.infinity,
                                //   //previously its 260
                                //   // height: 260,
                                //   child: Column(
                                //     children: [
                                //       //<------------- Heading ----------->
                                //       Container(
                                //         height: 50,
                                //         color: CommonColor.appBarColor,
                                //         child: Align(
                                //           alignment: Alignment.topLeft,
                                //           child: Row(
                                //             mainAxisAlignment:
                                //                 MainAxisAlignment.spaceBetween,
                                //             children: [
                                //               const Text(
                                //                 'Top 5 Guests',
                                //                 style: TextStyle(
                                //                   fontSize: 24.0,
                                //                   fontWeight: FontWeight.w500,
                                //                   color: Colors.white,
                                //                 ),
                                //               ),
                                //               GestureDetector(
                                //                 onTap: (){
                                //                   guestBottomSheet(context, _);
                                //
                                //                 },
                                //                 child: Container(
                                //                   height: 30,
                                //                   width: 20,
                                //                   child: Image.asset(
                                //                     "assets/images/search_filter.png",
                                //                     height: 12,
                                //                     width: 16,
                                //                     fit: BoxFit.scaleDown,
                                //                   ),
                                //                 ),
                                //               ),
                                //             ],
                                //           ),
                                //         ).marginOnly(
                                //           left: 16,
                                //           right: 0,
                                //         ),
                                //       ),
                                //       // Todo Comment code 2nd graph
                                //       seconContainer(_, context),
                                //     ],
                                //   ),
                                // ).marginOnly(left: 5, right: 5),
                              ],
                            ),
                          ),
                        ),
                      ),
          )),
        );
      },
    );
  }

  //<----------- Graph One Filter -------------->

  void trendingBottomSheet(BuildContext ctx, ReportsController _) {
    showModalBottomSheet(
      elevation: 10,
      backgroundColor: CommonColor.bottomSheetBackgroundColour,
      isScrollControlled: true,
      // shape: const RoundedRectangleBorder(
      //   borderRadius: BorderRadius.only(
      //     topLeft: Radius.circular(10.0),
      //     topRight: Radius.circular(10.0),
      //   ),
      // ),
      context: ctx,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setState) {
        final mqData = MediaQuery.of(ctx);
        final mqDataNew = mqData.copyWith(
            textScaleFactor:
                mqData.textScaleFactor > 1.0 ? 1.0 : mqData.textScaleFactor);

        return MediaQuery(
          data: mqDataNew,
          child: SizedBox(
            width: Get.width,
            height: Get.height / 1.7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10.0,
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Center(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Filters',
                              style: TextStyle(
                                letterSpacing: 0.4,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _.trendingStartData = null;
                                  _.trendingEndData=null;
                                  DateTime temp=DateTime.now();
                                  _.filter1DaysDifference=0;

                                  _.startSearchDate.text=DateTime(temp.year,temp.month-1,temp.day).toString().split(" ").first;
                                  _.endSearchDate.text=DateTime.now().toString().split(" ").first;
                                  Get.log("--------------------${_.startSearchDate.text}");
                                  Get.log("--------------------${_.endSearchDate.text}");


                                  _.trendingContentTypeSelect = false;
                                  _.trendingChannelSelect = false;
                                  _.trendingStartDateSelect = false;
                                  _.trendingEndDateSelect = false;
                                  _.filterlist1.clear();
                                  _.selectedchannel.clear();
                                  _.channelsearchlist.clear();

                                  for (var e in _.channellist2) {
                                    if (e.name != 'All Channels') {
                                      e.check.value = false;
                                      _.channelsearchlist.add(e.name);
                                    } else {
                                      e.check.value = true;
                                    }
                                  }
                                  _.programslist.clear();
                                  for (var e in _.programType1) {
                                    e.check.value = false;
                                  }
                                  _.programtypegraph.clear();
                                  for (var element in _.alldatelist1) {
                                    element.check.value = false;
                                  }
                                  _.filterlist1.add('All Channels');
                                  _.selectedchannel.add('All Channels');
                                });
                                _.update();
                              },
                              child: Row(
                                children: [
                                  const Text(
                                    'Clear All',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      letterSpacing: 0.4,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                  // Image.asset("assets/images/trash_full.png")
                                  //     .marginOnly(left: 5, bottom: 5),
                                ],
                              ).marginOnly(top: 20),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                setState(() {
                                  _.isTop10Select = false;
                                  _.filterlist1.clear();
                                  _.selectedchannel.clear();
                                  _.channelsearchlist.clear();
                                  for (var e in _.channellist2) {
                                    if (e.name != 'All Channels') {
                                      e.check.value = false;
                                      _.channelsearchlist.add(e.name);
                                    } else {
                                      e.check.value = true;
                                    }
                                  }
                                  for (var e in _.programType1) {
                                    e.check.value = false;
                                  }
                                  _.programtypegraph.clear();
                                  _.programslist.clear();
                                  for (var element in _.alldatelist1) {
                                    element.check.value = false;
                                  }
                                  _.filterlist1.add('All Channels');
                                  _.selectedchannel.add('All Channels');
                                  // _.hostselect.value.clear();
                                });
                                _.update();
                                Get.back();
                                await _.firstTimeGraphData('Top 5');
                              },
                              child: Container(
                                height: 30.0,
                                width: 87,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _.isTop10Select == true
                                        ? NewCommonColours.filterTopBtnBorder
                                        : Colors.transparent,
                                  ),

                                  color: _.isTop10Select == false
                                      ? NewCommonColours.filterGreenBorderColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(5.0),
                                  // gradient: const LinearGradient(
                                  //   begin: Alignment.topLeft,
                                  //   end: Alignment.bottomLeft,
                                  //   colors: [
                                  //     CommonColor.gradientColor,
                                  //     CommonColor.gradientColor2,
                                  //   ],
                                  // ),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Top 5 ',
                                    style: TextStyle(
                                        fontSize: 11.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 0.4),
                                  ),
                                ),
                              ).marginOnly(top: 18, bottom: 23),
                            ),
                            GestureDetector(
                              onTap: () async {
                                setState(() {
                                  _.isTop10Select = true;
                                  _.filterlist1.clear();
                                  _.selectedchannel.clear();
                                  _.channelsearchlist.clear();
                                  for (var e in _.channellist2) {
                                    if (e.name != 'All Channels') {
                                      e.check.value = false;
                                      _.channelsearchlist.add(e.name);
                                    } else {
                                      e.check.value = true;
                                    }
                                  }
                                  for (var e in _.programType1) {
                                    e.check.value = false;
                                  }
                                  _.programtypegraph.clear();
                                  _.programslist.clear();
                                  for (var element in _.alldatelist1) {
                                    element.check.value = false;
                                  }
                                  _.filterlist1.add('All Channels');
                                  _.selectedchannel.add('All Channels');
                                  // _.hostselect.value.clear();
                                });
                                _.update();
                                Get.back();
                                await _.firstTimeGraphData('Top 10');
                                // setState(() {
                                //   _.filterlist1.clear();
                                //   _.channellist2.forEach((e) {
                                //     e.check.value = false;
                                //   });
                                //   _.programslist.clear();
                                //   _.programType1.forEach((e) {
                                //     e.check.value = false;
                                //   });
                                //   _.programtypegraph.clear();
                                //   _.alldatelist1.forEach((element) {
                                //     element.check.value = false;
                                //   });
                                //   // _.hostselect.value.clear();
                                // });
                                // _.update();
                              },
                              child: Container(
                                height: 30.0,
                                width: 87,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _.isTop10Select == false
                                        ? NewCommonColours.filterTopBtnBorder
                                        : Colors.transparent,
                                  ),
                                  color: _.isTop10Select == true
                                      ? NewCommonColours.filterGreenBorderColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(5.0),

                                  // gradient: const LinearGradient(
                                  //   begin: Alignment.topLeft,
                                  //   end: Alignment.bottomLeft,
                                  //   colors: [
                                  //     CommonColor.gradientColor,
                                  //     CommonColor.gradientColor2,
                                  //   ],
                                  // ),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Top 10 ',
                                    style: TextStyle(
                                        fontSize: 11.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 0.4),
                                  ),
                                ),
                              ).marginOnly(top: 18, bottom: 23, left: 6),
                            ),
                          ],
                        ),
                        // Obx(
                        //   () => Wrap(
                        //     children: <Widget>[
                        //       for (int index = 0;
                        //           index < _.filterlist1.length;
                        //           index++)
                        //         FittedBox(
                        //             fit: BoxFit.fill,
                        //             child: GestureDetector(
                        //               onTap: () {
                        //                 for (var q in _.programType1) {
                        //                   if (q.name == _.filterlist1[index]) {
                        //                     q.check.value = false;
                        //                     _.programtypegraph
                        //                         .remove(_.filterlist1[index]);
                        //                     _.filterlist1.remove(_.filterlist1[index]);
                        //                   }
                        //                 }
                        //                 _.deleteDataFromFilterList(
                        //                     _.filterlist1[index]);
                        //               },
                        //               child: Container(
                        //                 height: 20,
                        //                 decoration: BoxDecoration(
                        //                   color: CommonColor.greenColor,
                        //                   borderRadius:
                        //                       BorderRadius.circular(2.0),
                        //                   border: Border.all(
                        //                     color: CommonColor.greenColor,
                        //                   ),
                        //                 ),
                        //                 child: Row(
                        //                   crossAxisAlignment:
                        //                       CrossAxisAlignment.center,
                        //                   children: [
                        //                     Text(
                        //                       "${_.filterlist1[index]}",
                        //                       overflow: TextOverflow.ellipsis,
                        //                       maxLines: 1,
                        //                       style: GoogleFonts.roboto(
                        //                         fontSize: 11.0,
                        //                         fontWeight: FontWeight.w500,
                        //                         color: Colors.white,
                        //                       ),
                        //                     ),
                        //                     const SizedBox(
                        //                       width: 10.0,
                        //                     ),
                        //                     Container(
                        //                       height: 12.0,
                        //                       width: 12.0,
                        //                       decoration: const BoxDecoration(
                        //                           color: Colors.white,
                        //                           shape: BoxShape.circle),
                        //                       child: const Icon(
                        //                         Icons.clear,
                        //                         color: CommonColor.greenColor,
                        //                         size: 10.0,
                        //                       ),
                        //                     )
                        //                   ],
                        //                 ).marginOnly(left: 5.0, right: 5.0),
                        //               ),
                        //             ).marginAll(5.0))
                        //     ],
                        //   ),
                        // ),
                        // Container(
                        //   width: Get.width,
                        //   child: showFilter1(_),
                        // ),

                        Align(
                          alignment: Alignment.topLeft,
                          child: Text('Channel',
                                  style: NewTextStyle.font9Weight500)
                              .marginOnly(bottom: 7),
                        ),

                        Align(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _.trendingChannelSelect = true;
                                _.trendingStartDateSelect = false;
                                _.trendingEndDateSelect = false;
                                _.trendingContentTypeSelect = false;
                              });
                              channelBottomSheet(_);
                            },
                            child: Container(
                              height: 50.0,
                              width: Get.width,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: _.trendingChannelSelect == true
                                      ? NewCommonColours.filterGreenBorderColor
                                      : NewCommonColours.filterBorderColor,
                                ),
                                borderRadius: BorderRadius.circular(2.0),
                              ),
                              child: Obx(
                                () => Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: Get.width / 1.25,
                                      child: Text(
                                        _.channelsearchlist.length ==
                                                _.channellist2.length - 1
                                            ? 'All Channel'
                                            : _.listToString(
                                                _.channelsearchlist),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style:  _.channelsearchlist.length ==
                                            _.channellist2.length - 1?NewTextStyle.fonT14Weight300:NewTextStyle.fonT14Weight300,
                                      ).marginOnly(left: 12.0, right: 5),
                                    ),
                                    const Spacer(),
                                     Icon(
                                      Icons.keyboard_arrow_down,
                                        color:
                                        NewCommonColours.filterDropDownColor,
                                        size: 20 ,
                                    ).marginOnly(right: 20)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 23.0,
                        ),

                        //-----------------------Program Type----------------
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text('Content Type',
                                  style: NewTextStyle.font9Weight500)
                              .marginOnly(bottom: 7),
                        ),

                        Align(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _.trendingContentTypeSelect = true;
                                _.trendingChannelSelect = false;
                                _.trendingStartDateSelect = false;
                                _.trendingEndDateSelect = false;
                              });
                              showTrendingProgramBtmSheet(_);
                            },
                            child: Container(
                              height: 50.0,
                              width: Get.width,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: _.trendingContentTypeSelect == true
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
                                      width: Get.width / 1.25,
                                      child: Text(
                                              _.programtypegraph.isEmpty
                                                  ? 'Select'
                                                  : _.listToString(
                                                      _.programtypegraph),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style:_.programtypegraph.isEmpty?
                                                  NewTextStyle.font14Weight300:NewTextStyle.fonT14Weight300)
                                          .marginOnly(left: 12.0, right: 5.0),
                                    ),
                                    const Spacer(),
                                     Icon(
                                      Icons.keyboard_arrow_down,
                                      color:
                                      NewCommonColours.filterDropDownColor,
                                      size: 20 ,
                                    ).marginOnly(right: 20)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // <----------------- Dates section ----------------->
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
                                      _.trendingStartDateSelect = true;
                                      _.trendingEndDateSelect = false;
                                      _.trendingContentTypeSelect = false;
                                      _.trendingChannelSelect = false;
                                      _.showTrendingCalendar(ctx);

                                    });
                                  },
                                  child: Container(
                                    height: 50,
                                    width: Get.width / 2.35,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: _.trendingStartDateSelect == true
                                            ? NewCommonColours
                                                .filterGreenBorderColor
                                            : NewCommonColours
                                                .filterBorderColor,
                                      ),
                                      borderRadius: BorderRadius.circular(2.0),
                                    ),
                                    child: _.trendingStartData == null
                                        ? Center(
                                            child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${_.startSearchDate.text}",
                                                style: NewTextStyle
                                                    .font14Weight300,
                                              ).marginOnly(left: 15),
                                              Icon(
                                                Icons.calendar_month_outlined,
                                                color: Color(0xff22b161)
                                                    .withOpacity(0.79),
                                                size: 18,
                                              ).marginOnly(right: 14)
                                            ],
                                          ))
                                        : Center(
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${_.trendingStartData.toString().split(" ").first}",
                                              style: NewTextStyle
                                                  .fonT14Weight300,
                                            ).marginOnly(left: 15),
                                            Icon(
                                              Icons.calendar_month_outlined,
                                              color: Color(0xff22b161)
                                                  .withOpacity(0.79),
                                              size: 18,
                                            ).marginOnly(right: 14)
                                          ],
                                        )),
                                  ).marginOnly(top: 10),
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
                                      _.trendingStartDateSelect = false;
                                      _.trendingEndDateSelect = true;
                                      _.trendingContentTypeSelect = false;
                                      _.trendingChannelSelect = false;
                                      _.showTrendingCalendar(ctx);
                                    });
                                  },
                                  child: Container(
                                    height: 50,
                                    width: Get.width / 2.25,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: _.trendingEndDateSelect == true
                                            ? NewCommonColours
                                                .filterGreenBorderColor
                                            : NewCommonColours
                                                .filterBorderColor,
                                      ),
                                      borderRadius: BorderRadius.circular(2.0),
                                    ),
                                    child: _.trendingEndData== null
                                        ? Center(
                                            child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${_.endSearchDate.text}",
                                                style: NewTextStyle
                                                    .font14Weight300,
                                              ).marginOnly(left: 15),
                                              Icon(
                                                Icons.calendar_month_outlined,
                                                color: Color(0xff22b161)
                                                    .withOpacity(0.79),
                                                size: 18,
                                              ).marginOnly(right: 14)
                                            ],
                                          ))
                                        : Center(
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${_.trendingEndData.toString().split(" ").first}",
                                              style: NewTextStyle
                                                  .fonT14Weight300,
                                            ).marginOnly(left: 15),
                                            Icon(
                                              Icons.calendar_month_outlined,
                                              color: Color(0xff22b161)
                                                  .withOpacity(0.79),
                                              size: 18,
                                            ).marginOnly(right: 14)
                                          ],
                                        )),
                                  ).marginOnly(top: 10, left: 15),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // const SizedBox(
                        //   height: 10.0,
                        // ),
                        // SizedBox(
                        //   width: Get.width,
                        //   child: showDates1(_),
                        // ),
                        // const SizedBox(
                        //   height: 20.0,
                        // ),
                        // // <----------------- Program Type ----------------->
                        // const Align(
                        //   alignment: Alignment.topLeft,
                        //   child: Text(
                        //     'Program Type',
                        //     style: TextStyle(
                        //       letterSpacing: 0.4,
                        //       fontSize: 13.0,
                        //       fontWeight: FontWeight.w500,
                        //       color: Colors.white,
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(
                        //   height: 10.0,
                        // ),

                        // showProgramTypeFilter1(_),
                        // const SizedBox(
                        //   height: 20.0,
                        // ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: Get.width / 3.5,
                      child: CommonFilterButton(
                        fillColor: NewCommonColours.filterClearBtnColor,
                        text: "Cancel",
                        textStyle: NewTextStyle.font12Weight400,
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    SizedBox(
                      width: Get.width / 3.5,
                      child: CommonFilterButton(
                        fillColor: NewCommonColours.filterApplyBtnColor,
                        text: "Apply filter",
                        textStyle: NewTextStyle.font12Weight400,
                        onPressed: () async {
                          // _.viewFilterData();
                          if (_.startSearchDate.text == '' && _.endpaichartSearchDate.text == '') {
                            CustomSnackBar.showSnackBar(
                                title: AppStrings.selectdate,
                                message: "",
                                backgroundColor: CommonColor.snackbarColour,
                                isWarning: true);
                          }
                          else if(_.filter1DaysDifference>180){
                            CustomSnackBar.showSnackBar(
                                title: AppStrings.dateRangeError,
                                message: "",
                                backgroundColor: CommonColor.snackbarColour,
                                isWarning: true);
                          }

                          else if (_.selectedchannel.isEmpty) {
                            CustomSnackBar.showSnackBar(
                                title: AppStrings.channellist,
                                message: "",
                                backgroundColor: CommonColor.snackbarColour,
                                isWarning: true);
                          } else if (_.programtypegraph.isEmpty) {
                            CustomSnackBar.showSnackBar(
                                title: AppStrings.programlist,
                                message: "",
                                backgroundColor: CommonColor.snackbarColour,
                                isWarning: true);
                          } else {
                            Get.back();
                            await _.getGraphData();
                          }
                        },
                      ),
                    ),

                    // SizedBox(
                    //   width: Get.width / 3,
                    //   child: MaterialButton(
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(5.0),
                    //       side: const BorderSide(
                    //         color: CommonColor.greenBorderColor,
                    //       ),
                    //     ),
                    //     onPressed: () async {
                    //       // _.viewFilterData();
                    //       if (_.startSearchDate.text == '' &&
                    //           _.endpaichartSearchDate.text == '') {
                    //         CustomSnackBar.showSnackBar(
                    //             title: AppStrings.selectdate,
                    //             message: "",
                    //             backgroundColor: CommonColor.snackbarColour,
                    //             isWarning: true);
                    //       } else if (_.selectedchannel.isEmpty) {
                    //         CustomSnackBar.showSnackBar(
                    //             title: AppStrings.channellist,
                    //             message: "",
                    //             backgroundColor: CommonColor.snackbarColour,
                    //             isWarning: true);
                    //       } else if (_.programtypegraph.isEmpty) {
                    //         CustomSnackBar.showSnackBar(
                    //             title: AppStrings.programlist,
                    //             message: "",
                    //             backgroundColor: CommonColor.snackbarColour,
                    //             isWarning: true);
                    //       } else {
                    //         Get.back();
                    //         await _.getGraphData();
                    //       }
                    //     },
                    //     minWidth: 120,
                    //     height: 38,
                    //     color: CommonColor.greenColorWithOpacity,
                    //     child: const Text(
                    //       "APPLY FILTER",
                    //       style: TextStyle(
                    //           letterSpacing: 0.4,
                    //           color: CommonColor.greenColor,
                    //           fontSize: 13.0,
                    //           fontWeight: FontWeight.w500),
                    //     ),
                    //   ),
                    // ),
                  ],
                ).marginOnly(top: 30.0, bottom: 40.0),
              ],
            ).marginOnly(left: 15.0, right: 15.0),
          ),
        );
      }),
    );
  }

  void channelBottomSheet(ReportsController _) {
    Get.bottomSheet(
      Column(
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
            child: ListView.separated(
              itemCount: _.channellist2.length,
              shrinkWrap: true,
              separatorBuilder: (c, e) {
                return const SizedBox(
                  width: 20.0,
                );
              },
              itemBuilder: (c, i) {
                return InkWell(
                  splashColor: const Color(0xff22B161),
                  hoverColor: const Color(0xff22B161),
                  focusColor: const Color(0xff22B161),
                  onTap: () {
                    _.channellist2[i].check.value =
                        !_.channellist2[i].check.value;
                    if (_.channellist2[i].check.value == true) {
                      if (_.channellist2[i].name == 'All Channels') {
                        _.filterlist1.add(_.channellist2[i].name);
                        _.channelsearchlist.clear();
                        for (var e in _.channellist2) {
                          if (e.name != 'All Channels') {
                            _.filterlist1.remove(e.name);
                            e.check.value = false;
                            _.channelsearchlist.add(e.name);
                          }
                        }
                      } else {
                        for (var q in _.channellist2) {
                          if (q.name == 'All Channels') {
                            if (q.check.value == true) {
                              _.channelsearchlist.clear();
                              q.check.value = false;
                              _.filterlist1.remove(q.name);
                            }
                          }
                        }
                        _.channelsearchlist.add(_.channellist2[i].name);
                        _.filterlist1.add(_.channellist2[i].name);
                      }
                    } else {
                      if (_.channellist2[i].name != 'All Channels') {
                        _.filterlist1.remove(_.channellist2[i].name);
                        _.channelsearchlist.remove(_.channellist2[i].name);
                        for (var e in _.channellist2) {
                          if (e.name == 'All Channels') {
                            e.check.value = false;
                          }
                        }
                        if (_.channelsearchlist.isEmpty) {
                          for (var e in _.channellist2) {
                            if (e.name != 'All Channels') {
                              _.channelsearchlist.add(e.name);
                            } else {
                              _.filterlist1.add(e.name);
                              e.check.value = true;
                            }
                          }
                        }
                      } else {
                        _.channelsearchlist.clear();
                        for (var e in _.channellist2) {
                          if (e.name != 'All Channels') {
                            _.channelsearchlist.add(e.name);
                            e.check.value = false;
                          }
                        }
                        _.filterlist1.remove('All Channels');
                        for (var q in _.channellist2) {
                          if (q.name == 'All Channels') {
                            _.filterlist1.add(q.name);
                            q.check.value = true;
                          }
                        }
                      }
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Theme(
                        data: ThemeData(unselectedWidgetColor: Colors.white),
                        child: Obx(
                          () => Checkbox(
                            visualDensity: const VisualDensity(
                                horizontal: -3.5, vertical: -2.5),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            side: const BorderSide(
                                width: 1.0, color: CommonColor.filterColor),
                            activeColor: CommonColor.greenColor,
                            focusColor: CommonColor.filterColor,
                            hoverColor: CommonColor.filterColor,
                            value: _.channellist2[i].check.value,
                            onChanged: (val) {
                              _.channellist2[i].check.value =
                                  !_.channellist2[i].check.value;
                              if (_.channellist2[i].check.value == true) {
                                if (_.channellist2[i].name == 'All Channels') {
                                  _.filterlist1.add(_.channellist2[i].name);
                                  _.channelsearchlist.clear();
                                  for (var e in _.channellist2) {
                                    if (e.name != 'All Channels') {
                                      _.filterlist1.remove(e.name);
                                      e.check.value = false;
                                      _.channelsearchlist.add(e.name);
                                    }
                                  }
                                } else {
                                  for (var q in _.channellist2) {
                                    if (q.name == 'All Channels') {
                                      if (q.check.value == true) {
                                        _.channelsearchlist.clear();
                                        q.check.value = false;
                                        _.filterlist1.remove(q.name);
                                      }
                                    }
                                  }
                                  _.channelsearchlist
                                      .add(_.channellist2[i].name);
                                  _.filterlist1.add(_.channellist2[i].name);
                                }
                              } else {
                                if (_.channellist2[i].name != 'All Channels') {
                                  _.filterlist1.remove(_.channellist2[i].name);
                                  _.channelsearchlist
                                      .remove(_.channellist2[i].name);
                                  for (var e in _.channellist2) {
                                    if (e.name == 'All Channels') {
                                      e.check.value = false;
                                    }
                                  }
                                  if (_.channelsearchlist.isEmpty) {
                                    for (var e in _.channellist2) {
                                      if (e.name != 'All Channels') {
                                        _.channelsearchlist.add(e.name);
                                      } else {
                                        _.filterlist1.add(e.name);
                                        e.check.value = true;
                                      }
                                    }
                                  }
                                } else {
                                  _.channelsearchlist.clear();
                                  for (var e in _.channellist2) {
                                    if (e.name != 'All Channels') {
                                      _.channelsearchlist.add(e.name);
                                      e.check.value = false;
                                    }
                                  }
                                  _.filterlist1.remove('All Channels');
                                  for (var q in _.channellist2) {
                                    if (q.name == 'All Channels') {
                                      _.filterlist1.add(q.name);
                                      q.check.value = true;
                                    }
                                  }
                                }
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Flexible(
                        child: _.channellist2[i].type != ''
                            ? Text(
                                "${_.channellist2[i].name} (${_.channellist2[i].type})",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: GoogleFonts.roboto(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.4,
                                  color: CommonColor.filterColor,
                                ),
                              )
                            : Text(
                                "${_.channellist2[i].name}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: GoogleFonts.roboto(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.4,
                                  color: CommonColor.filterColor,
                                ),
                              ),
                      ),
                    ],
                  ),
                );
              },
            ).marginOnly(left: 20.0, right: 20.0),
          ),
        ],
      ),
      backgroundColor: CommonColor.backgroundColour,
    );
  }

  void channelBottomSheetPieChart(ReportsController _) {
    Get.bottomSheet(

      Column(
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
            child: ListView.separated(
              itemCount: _.channellist.length,
              shrinkWrap: true,
              separatorBuilder: (c, e) {
                return const SizedBox(
                  width: 20.0,
                );
              },
              itemBuilder: (c, i) {
                return InkWell(
                  splashColor: const Color(0xff22B161),
                  hoverColor: const Color(0xff22B161),
                  focusColor: const Color(0xff22B161),
                  onTap: () {
                    _.channellist[i].check.value =
                        !_.channellist[i].check.value;
                    if (_.channellist[i].check.value == true) {
                      if (_.channellist[i].name == 'All Channels') {
                        _.filterlist.add(_.channellist[i].name);
                        _.paichartchannel.clear();
                        for (var e in _.channellist) {
                          if (e.name != 'All Channels') {
                            _.filterlist.remove(e.name);
                            e.check.value = false;
                            _.paichartchannel.add(e.name);
                          }
                        }
                      } else {
                        for (var q in _.channellist) {
                          if (q.name == 'All Channels') {
                            if (q.check.value == true) {
                              _.paichartchannel.clear();
                              q.check.value = false;
                              _.filterlist.remove(q.name);
                            }
                          }
                        }
                        _.paichartchannel.add(_.channellist[i].name);
                        _.filterlist.add(_.channellist[i].name);
                      }
                    } else {
                      if (_.channellist[i].name != 'All Channels') {
                        _.filterlist.remove(_.channellist[i].name);
                        _.paichartchannel.remove(_.channellist[i].name);
                        for (var e in _.channellist) {
                          if (e.name == 'All Channels') {
                            e.check.value = false;
                          }
                        }
                        if (_.paichartchannel.isEmpty) {
                          for (var e in _.channellist) {
                            if (e.name != 'All Channels') {
                              _.paichartchannel.add(e.name);
                            } else {
                              _.filterlist.add(e.name);
                              e.check.value = true;
                            }
                          }
                        }
                      } else {
                        _.paichartchannel.clear();
                        for (var e in _.channellist) {
                          if (e.name != 'All Channels') {
                            _.paichartchannel.add(e.name);
                            e.check.value = false;
                          }
                        }
                        _.filterlist.remove('All Channels');
                        for (var q in _.channellist) {
                          if (q.name == 'All Channels') {
                            _.filterlist.add(q.name);
                            q.check.value = true;
                          }
                        }
                      }
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Theme(
                        data: ThemeData(unselectedWidgetColor: Colors.white),
                        child: Obx(
                          () => Checkbox(
                            visualDensity: const VisualDensity(
                                horizontal: -3.5, vertical: -2.5),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            side: const BorderSide(
                                width: 1.0, color: CommonColor.filterColor),
                            activeColor: CommonColor.greenColor,
                            focusColor: CommonColor.filterColor,
                            hoverColor: CommonColor.filterColor,
                            value: _.channellist[i].check.value,
                            onChanged: (val) {
                              _.channellist[i].check.value =
                                  !_.channellist[i].check.value;
                              if (_.channellist[i].check.value == true) {
                                if (_.channellist[i].name == 'All Channels') {
                                  _.filterlist.add(_.channellist[i].name);
                                  _.paichartchannel.clear();
                                  for (var e in _.channellist) {
                                    if (e.name != 'All Channels') {
                                      _.filterlist.remove(e.name);
                                      e.check.value = false;
                                      _.paichartchannel.add(e.name);
                                    }
                                  }
                                } else {
                                  for (var q in _.channellist) {
                                    if (q.name == 'All Channels') {
                                      if (q.check.value == true) {
                                        _.paichartchannel.clear();
                                        q.check.value = false;
                                        _.filterlist.remove(q.name);
                                      }
                                    }
                                  }
                                  _.paichartchannel.add(_.channellist[i].name);
                                  _.filterlist.add(_.channellist[i].name);
                                }
                              } else {
                                if (_.channellist[i].name != 'All Channels') {
                                  _.filterlist.remove(_.channellist[i].name);
                                  _.paichartchannel
                                      .remove(_.channellist[i].name);
                                  for (var e in _.channellist) {
                                    if (e.name == 'All Channels') {
                                      e.check.value = false;
                                    }
                                  }
                                  if (_.paichartchannel.isEmpty) {
                                    for (var e in _.channellist) {
                                      if (e.name != 'All Channels') {
                                        _.paichartchannel.add(e.name);
                                      } else {
                                        _.filterlist.add(e.name);
                                        e.check.value = true;
                                      }
                                    }
                                  }
                                } else {
                                  _.paichartchannel.clear();
                                  for (var e in _.channellist) {
                                    if (e.name != 'All Channels') {
                                      _.paichartchannel.add(e.name);
                                      e.check.value = false;
                                    }
                                  }
                                  _.filterlist.remove('All Channels');
                                  for (var q in _.channellist) {
                                    if (q.name == 'All Channels') {
                                      _.filterlist.add(q.name);
                                      q.check.value = true;
                                    }
                                  }
                                }
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Flexible(
                        child: Text(
                          _.channellist[i].type != ''
                              ? "${_.channellist[i].name} (${_.channellist[i].type})"
                              : "${_.channellist[i].name}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: GoogleFonts.roboto(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.4,
                            color: CommonColor.filterColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ).marginOnly(left: 20.0, right: 20.0),
          ),
        ],
      ),
      backgroundColor: CommonColor.backgroundColour,
    );
  }

  Widget showDates1(ReportsController _) {
    List<Widget> g = [];
    for (int i = 0; i < _.alldatelist1.length; i++) {
      g.add(FittedBox(
        fit: BoxFit.fill,
        child: Obx(() => GestureDetector(
              onTap: () {
                for (var e in _.alldatelist1) {
                  e.check.value = false;
                  _.filterlist1.removeWhere((item) => item == e.startDate);
                  _.startSearchDate.clear();
                  _.endSearchDate.clear();
                  _.filterlist1.removeWhere((item) => item == e.endDate);
                }
                if (_.alldatelist1[i].check.value == false) {
                  _.alldatelist1[i].check.value = true;
                  _.startSearchDate.text = _.alldatelist1[i].startDate!;
                  _.endSearchDate.text = _.alldatelist1[i].endDate!;
                  _.filterlist1
                      .removeWhere((i) => i.toString().substring(0, 2) == '20');
                  _.filterlist1.add(
                      '${_.alldatelist1[i].endDate} - ${_.alldatelist1[i].startDate}');
                  _.update();
                }
              },
              child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                      color: _.alldatelist1[i].check.value == true
                          ? CommonColor.greenColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                          color: _.alldatelist1[i].check.value == true
                              ? CommonColor.greenColor
                              : CommonColor.filterColor)),
                  child: Center(
                    child: Text(
                      "${_.alldatelist1[i].name}",
                      style: TextStyle(
                          fontSize: 11.0,
                          fontWeight: _.alldatelist1[i].check.value == true
                              ? FontWeight.w500
                              : FontWeight.w300,
                          color: CommonColor.filterColor),
                    ).marginOnly(left: 20.0, right: 20.0),
                  )),
            )),
      ).marginOnly(left: 0.0, right: 5.0, bottom: 8.62));
    }
    return Wrap(
      children: g,
    );
  }

  Widget showchannel1(ReportsController _) {
    List<Widget> g = [];
    for (int i = 0; i < _.channellist2.length; i++) {
      g.add(
        SizedBox(
          width: Get.width / 3.5,
          child: Row(
            children: [
              Theme(
                data: ThemeData(unselectedWidgetColor: Colors.white),
                child: Obx(
                  () => Checkbox(
                    visualDensity:
                        const VisualDensity(horizontal: -3.5, vertical: -2.5),
                    side: const BorderSide(
                        width: 1.0, color: CommonColor.filterColor),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    activeColor: CommonColor.greenColor,
                    focusColor: CommonColor.filterColor,
                    hoverColor: CommonColor.filterColor,
                    value: _.channellist2[i].check.value,
                    onChanged: (val) {
                      if (_.channellist2[i].check.value == false) {
                        _.channellist2[i].check.value = true;
                        if (_.channellist2[i].name == 'All Channels') {
                          _.filterlist1.clear();
                          if (_.endSearchDate.text != '' &&
                              _.startSearchDate.text != '') {
                            _.filterlist1.add(
                                '${_.endSearchDate.text} - ${_.startSearchDate.text}');
                          }
                          // _.searchFunction(_.channellist2[i].name!);
                          _.channellist2[i].check.value = true;
                          _.filterlist1.add(_.channellist2[i].name);
                          for (var element in _.channellist2) {
                            if (element.name != 'All Channels') {
                              _.filterlist1
                                  .removeWhere((item) => item == element.name);
                              _.channelsearchlist
                                  .removeWhere((item) => item == element.name);
                              _.channelsearchlist.add(element.name);
                              element.check.value = false;
                              _.update();
                            }
                          } // Idhr tk Function Bilkul Perfect Hai
                        } else if (_.channellist2[i].name != 'All Channels') {
                          for (int i = 0; i < _.filterlist1.length; i++) {
                            if (_.filterlist1[i] == 'All Channels') {
                              _.filterlist1.removeWhere(
                                  (item) => item == 'All Channels');
                              _.filterlist1.removeWhere(
                                  (item) => item == 'All Programs Name');
                              _.programslist.clear();
                              _.channelsearchlist.clear();
                              _.programsearchlist.clear();
                            }
                          }
                          // _.searchFunction(_.channellist2[i].name!);
                          for (var element in _.channellist2) {
                            if (element.name == 'All Channels') {
                              element.check.value = false;
                            }
                          }
                          _.filterlist1.add(_.channellist[i].name);
                          _.channelsearchlist.add(_.channellist[i].name);
                          _.update();
                        } // YeAh Function b iDhr tk Bilkul Perfect Hai
                      } else {
                        _.channellist2[i].check.value = false;
                        if (_.channellist2[i].name == 'All Channels') {
                          _.filterlist1.removeWhere(
                              (item) => item == _.channellist2[i].name);
                          _.filterlist1.removeWhere(
                              (item) => item == 'All Programs Name');
                          _.programslist.clear();
                          for (var element in _.channellist2) {
                            if (element.name != 'All Channels') {
                              _.channelsearchlist
                                  .removeWhere((item) => item == element.name);
                              element.check.value = false;
                              _.update();
                            }
                          } // Idhr Tk If ki Condition Bilkul Perfect Hai
                        } else {
                          _.deleteSearchChannelProgram(_.channellist[i].name!);
                          _.filterlist1.removeWhere(
                              (item) => item == _.channellist[i].name);
                          _.channelsearchlist.removeWhere(
                              (item) => item == _.channellist[i].name);
                          _.update();
                        }
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(
                width: 2.0,
              ),
              Flexible(
                child: Text(
                  "${_.channellist2[i].name}",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: GoogleFonts.roboto(
                      fontSize: 11.0,
                      fontWeight: FontWeight.w400,
                      color: CommonColor.filterColor),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Wrap(
      children: g,
    );
  }

  Widget showProgramName(ReportsController _, ctx) {
    return StatefulBuilder(builder: (ctx, setstate) {
      return Obx(() {
        return GridView.builder(
          itemCount: _.programslist.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 5.5 / 1.7,
          ),
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              width: Get.width / 3.25,
              child: GestureDetector(
                onTap: () {
                  setstate(() {
                    if (_.programslist[index].check.value == false) {
                      _.programslist[index].check.value = true;
                      if (_.programslist[index].name == 'All Programs Name') {
                        _.searchFunction('All Channels');
                      } else {
                        _.programsearchlist.add(_.programslist[index].name);
                        _.filterlist1.add(_.programslist[index].name);
                        _.update();
                      }
                    } else {
                      _.programslist[index].check.value = false;
                      if (_.programslist[index].name == 'All Programs Name') {
                        _.filterlist1.removeWhere(
                            (item) => item == _.programslist[index].name);
                        _.programsearchlist.clear();
                      } else {
                        _.filterlist1.removeWhere(
                            (item) => item == _.programslist[index].name);
                        _.programsearchlist.removeWhere(
                            (item) => item == _.programslist[index].name);
                      }
                      _.update();
                    }
                  });
                },
                child: Container(
                  height: 32,
                  decoration: BoxDecoration(
                    color: _.programslist[index].check.value == true
                        ? const Color(0xff22B161)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                        color: _.programslist[index].check.value == true
                            ? const Color(0xff22B161)
                            : Colors.white),
                  ),
                  child: Center(
                    child: Text(
                      "${_.programslist[index].name}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: GoogleFonts.roboto(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ).marginOnly(left: 5.0, right: 5.0),
                ),
              ).marginAll(5.0),
            );
          },
        );
      });
    });
  }

  Widget firstContainer(ReportsController _, context) {
    return Container(
      height: 280,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          color: CommonColor.transparent),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Center(
              child: _.dataValues.isEmpty
                  ? const Text(
                      "No Data Available",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      height: 330.0,
                      child: AbsorbPointer(
                        absorbing: true,
                        child: Charts(
                          _.dataValues,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ).marginOnly(bottom: 10.0, left: 2.0, right: 0),
    ).marginOnly(
      left: 2.0,
      right: 0.0,
    );
  }

  Widget seconContainer(ReportsController _, context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: Get.width,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.transparent,
        ),
        child: _.chartdata.isEmpty
            ? SizedBox(
                height: Get.height / 3.2,
                child: const Center(
                  child: Text(
                    "No Data Available",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ).marginOnly(bottom: 5)
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // const Text("Below graph values are in %",
                  //     style: TextStyle(
                  //         fontSize: 12,
                  //         fontWeight: FontWeight.w500,
                  //         color: Colors.white)),
                  Container(
                    color: Colors.transparent,
                    height: Get.height / 3.2,
                    child: AbsorbPointer(
                      absorbing: true,
                      child: PieChartClass(
                        sections: _.chartdata,
                        indicator: _.indicatorList,
                      ).marginOnly(top: 0, bottom: 20),
                    ),
                  )
                ],
              ),
      ).marginOnly(left: 9, right: 9, top: 10),
    );
  }

  //<---------- Pai Chart Filter ---------->

  void guestBottomSheet(BuildContext ctx, ReportsController _) {
    showModalBottomSheet(
      elevation: 10,
      backgroundColor: CommonColor.bottomSheetBackgroundColour,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      context: ctx,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setState) {
        final mqData = MediaQuery.of(ctx);
        final mqDataNew = mqData.copyWith(
            textScaleFactor:
                mqData.textScaleFactor > 1.0 ? 1.0 : mqData.textScaleFactor);

        return MediaQuery(
          data: mqDataNew,
          child: SizedBox(
            width: Get.width,
            height: Get.height /1.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10.0,
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Center(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Filter',
                              style: TextStyle(
                                letterSpacing: 0.4,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                // Get.back();
                                setState(() {

                                  _.filter2DaysDifference=0;
                                  DateTime temp=DateTime.now();
                                  _.startpaichartSearchDate.text=DateTime(temp.year,temp.month-1,temp.day).toString().split(" ").first;
                                  _.endpaichartSearchDate.text=DateTime.now().toString().split(" ").first;
                                  _.guestChannelSelect=false;
                                  _.guestContentTypeSelect=false;
                                  _.guestStartDateSelect=false;
                                  _.guestEndDateSelect=false;
                                  _.guestHostSelect=false;

                                  for (var element in _.hostList) {
                                    element.check.value = false;
                                  }
                                  _.filterlist.clear();
                                  _.filterHost.clear();
                                  _.paichartchannel.clear();
                                  _.paichartprogramtype.clear();
                                  _.guestGraphStartDate=null;
                                  _.guestGraphEndDate=null;
                                  for (var e in _.channellist) {
                                    if (e.name != 'All Channels') {
                                      e.check.value = false;
                                      _.paichartchannel.add(e.name);
                                    } else {
                                      e.check.value = true;
                                    }
                                  }
                                  // for (var e in _.channellist) {
                                  //   e.check.value = false;
                                  // }
                                  for (var element in _.programType) {
                                    element.check.value = false;
                                  }
                                  for (var element in _.alldatelist) {
                                    element.check.value = false;
                                  }
                                  _.hostselect.value.clear();
                                  _.filterlist.add('All Channels');
                                });
                                _.update();
                              },
                              child: Row(
                                children: [
                                  const Text(
                                    'Clear All',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      letterSpacing: 0.4,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                  // Image.asset("assets/images/trash_full.png")
                                  //     .marginOnly(left: 5, bottom: 5),
                                ],
                              ),
                            ),
                          ],
                        ).marginOnly(top: 22),
                        // Row(
                        //   children: [
                        //     GestureDetector(
                        //       onTap: () async {
                        //         setState(() {
                        //           for (var element in _.hostList) {
                        //             element.check.value = false;
                        //           }
                        //           _.filterlist.clear();
                        //           _.filterHost.clear();
                        //           _.paichartchannel.clear();
                        //           _.paichartprogramtype.clear();
                        //           _.endpaichartSearchDate.clear();
                        //           _.startpaichartSearchDate.clear();
                        //           for (var e in _.channellist) {
                        //             if (e.name != 'All Channels') {
                        //               e.check.value = false;
                        //               _.paichartchannel.add(e.name);
                        //             } else {
                        //               e.check.value = true;
                        //             }
                        //           }
                        //           for (var element in _.programType) {
                        //             element.check.value = false;
                        //           }
                        //           for (var element in _.alldatelist) {
                        //             element.check.value = false;
                        //           }
                        //           _.hostselect.value.clear();
                        //         });
                        //         _.indicatorList.clear();
                        //         _.chartdata.clear();
                        //         _.piechartlist.clear();
                        //         _.graphchartlist.clear();
                        //         _.filterlist.add('All Channels');
                        //         _.update();
                        //         Get.back();
                        //         await _.firstTimePieChartData();
                        //       },
                        //       child: Container(
                        //         height: 30.0,
                        //         width: 99,
                        //         decoration: BoxDecoration(
                        //             color: NewCommonColours.filterGreenBorderColor,
                        //             borderRadius: BorderRadius.circular(5.0),
                        //             // gradient: const LinearGradient(
                        //             //   begin: Alignment.topLeft,
                        //             //   end: Alignment.bottomLeft,
                        //             //   colors: [
                        //             //     CommonColor.gradientColor,
                        //             //     CommonColor.gradientColor2,
                        //             //   ],
                        //             // ),
                        //         ),
                        //         child: const Center(
                        //           child: Text(
                        //             'Top 5 Guests',
                        //             style: TextStyle(
                        //                 fontSize: 11.0,
                        //                 color: Colors.white,
                        //                 fontWeight: FontWeight.w400,
                        //                 letterSpacing: 0.4),
                        //           ),
                        //         ),
                        //       ).marginOnly(top: 15, right: 6, bottom: 7),
                        //     ),
                        //   ],
                        // ),
                        // Obx(
                        //   () => Wrap(
                        //     children: <Widget>[
                        //       for (int index = 0;
                        //           index < _.filterlist.length;
                        //           index++)
                        //         FittedBox(
                        //             fit: BoxFit.fill,
                        //             child: GestureDetector(
                        //               onTap: () {
                        //                 setState(() {
                        //                   for (var element in _.hostList) {
                        //                     if (element.name ==
                        //                         _.filterlist[index]) {
                        //                       element.check.value = false;
                        //                       _.filterlist.removeWhere((item) =>
                        //                           item == _.filterlist[index]);
                        //                     }
                        //                   }
                        //                   for (var element in _.programType) {
                        //                     if (element.name ==
                        //                         _.filterlist[index]) {
                        //                       element.check.value = false;
                        //                       _.filterlist.removeWhere((item) =>
                        //                           item == _.filterlist[index]);
                        //                     }
                        //                   }
                        //                   _.filterHost.removeWhere((item) =>
                        //                       item == _.filterlist[index]);
                        //                 });
                        //                 _.deleteDataFromFilterListPia(
                        //                     _.filterlist[index]);
                        //                 _.anchorList.removeWhere((element) =>
                        //                     element == _.filterlist[index]);
                        //               },
                        //               child: Container(
                        //                 height: 20,
                        //                 decoration: BoxDecoration(
                        //                   color: const Color(0xff22B161),
                        //                   borderRadius:
                        //                       BorderRadius.circular(2.0),
                        //                   border: Border.all(
                        //                       color: const Color(0xff22B161)),
                        //                 ),
                        //                 child: Row(
                        //                   crossAxisAlignment:
                        //                       CrossAxisAlignment.center,
                        //                   children: [
                        //                     Text(
                        //                       "${_.filterlist[index]}",
                        //                       overflow: TextOverflow.ellipsis,
                        //                       maxLines: 1,
                        //                       style: GoogleFonts.roboto(
                        //                         fontSize: 11.0,
                        //                         fontWeight: FontWeight.w500,
                        //                         color: Colors.white,
                        //                       ),
                        //                     ),
                        //                     const SizedBox(
                        //                       width: 10.0,
                        //                     ),
                        //                     Container(
                        //                       height: 12.0,
                        //                       width: 12.0,
                        //                       decoration: const BoxDecoration(
                        //                           color: Colors.white,
                        //                           shape: BoxShape.circle),
                        //                       child: const Icon(
                        //                         Icons.clear,
                        //                         color: Color(0xff22B161),
                        //                         size: 10.0,
                        //                       ),
                        //                     )
                        //                   ],
                        //                 ).marginOnly(left: 5.0, right: 5.0),
                        //               ),
                        //             ).marginAll(5.0))
                        //     ],
                        //   ),
                        // ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Channel',
                            style: NewTextStyle.font9Weight500,
                          ).marginOnly(bottom: 7, top: 26),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _.guestChannelSelect=true;
                                _.guestContentTypeSelect=false;
                                _.guestStartDateSelect=false;
                                _.guestEndDateSelect=false;
                                _.guestHostSelect=false;
                              });
                              channelBottomSheetPieChart(_);
                            },
                            child: Container(
                              height: 50.0,
                              width: Get.width,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: _.guestChannelSelect == true
                                      ? NewCommonColours.filterGreenBorderColor
                                      : NewCommonColours.filterBorderColor,
                                ),
                                borderRadius: BorderRadius.circular(2.0),
                              ),
                              child: Obx(
                                () => Row(
                                  children: [
                                    SizedBox(
                                      width: Get.width / 1.3,
                                      child: Text(
                                              _.paichartchannel.length ==
                                                      _.channellist.length - 1
                                                  ? 'All Channels'
                                                  : _.listToString(
                                                      _.paichartchannel),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: _.paichartchannel.length ==
                                                  _.channellist.length - 1?
                                                  NewTextStyle.fonT14Weight300:NewTextStyle.fonT14Weight300)
                                          .marginOnly(left: 15.0, right: 5.0),
                                    ),
                                    const Spacer(),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      color:
                                          NewCommonColours.filterDropDownColor,
                                        size:20,
                                    ).marginOnly(right: 21)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            width: Get.width / 2.5,
                            // child: DropDownMultiSelect(
                            //   filterlist: _.filterlist,
                            //   readOnly: true,
                            //   onChanged: (List<String> x) {
                            //     setState(() {
                            //       _.filterchannellist = x;
                            //       _.update();
                            //       print('Filter Selected is Called');
                            //       _.filterchannellist.forEach((element) {
                            //         _.filterlist.removeWhere((e) =>
                            //         e.toString() ==
                            //             element.toString());
                            //       });
                            //       _.filterchannellist.forEach((element) {
                            //         _.filterchannellist.add(element);
                            //       });
                            //       _.filterchannellist.forEach((element) {});
                            //     });
                            //   },
                            //   options: _.allDropdownChannels,
                            //   selectedValues: _.filterHost,
                            //   whenEmpty: 'All Channels',
                            // ),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),

                        //------------------------Content Type-----------
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text('Content Type',
                              style: NewTextStyle.font9Weight500)
                              .marginOnly(bottom: 7),
                        ),

                        Align(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _.guestChannelSelect=false;
                                _.guestContentTypeSelect=true;
                                _.guestStartDateSelect=false;
                                _.guestEndDateSelect=false;
                                _.guestHostSelect=false;
                              });
                              showPieProgramBtmSheet(_);
                            },
                            child: Container(
                              height: 50.0,
                              width: Get.width,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: _.guestContentTypeSelect == true
                                      ? NewCommonColours.filterGreenBorderColor
                                      : NewCommonColours.filterBorderColor,
                                ),
                                borderRadius: BorderRadius.circular(2.0),
                              ),
                              child: Obx(
                                    () => Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: Get.width / 1.3,
                                      child: Text(
                                          _.paichartprogramtype.isEmpty
                                              ? 'Select'
                                              : _.listToString(
                                              _.paichartprogramtype),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: _.paichartprogramtype.isEmpty?
                                          NewTextStyle.font14Weight300:NewTextStyle.fonT14Weight300)
                                          .marginOnly(left: 12.0, right: 5.0),
                                    ),
                                    const Spacer(),
                                     Icon(
                                      Icons.keyboard_arrow_down,
                                      color:NewCommonColours.filterDropDownColor,
                                         size:20,
                                    ).marginOnly(right: 21)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),



                        // <----------------- Pie Chart Dates ----------------->

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
                                      _.guestChannelSelect=false;
                                      _.guestContentTypeSelect=false;
                                      _.guestStartDateSelect=true;
                                      _.guestEndDateSelect=false;
                                      _.guestHostSelect=false;
                                    });
                                    _.showGuestGraphCalendar(ctx);
                                  },
                                  child: Container(
                                    height: 50,
                                    width: Get.width / 2.35,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: _.guestStartDateSelect == true
                                            ? NewCommonColours
                                            .filterGreenBorderColor
                                            : NewCommonColours
                                            .filterBorderColor,
                                      ),
                                      borderRadius: BorderRadius.circular(2.0),
                                    ),
                                    child: _.guestGraphStartDate == null
                                        ? Center(
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${_.startpaichartSearchDate.text}",
                                              style: NewTextStyle
                                                  .font14Weight300,
                                            ).marginOnly(left: 15),
                                            Icon(
                                              Icons.calendar_month_outlined,
                                              color: Color(0xff22b161)
                                                  .withOpacity(0.79),
                                              size: 18,
                                            ).marginOnly(right: 14)
                                          ],
                                        ))
                                        : Center(
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${_.guestGraphStartDate.toString().split(" ").first}",
                                            style: NewTextStyle
                                                .fonT14Weight300,
                                          ).marginOnly(left: 15),
                                          Icon(
                                            Icons.calendar_month_outlined,
                                            color: Color(0xff22b161)
                                                .withOpacity(0.79),
                                            size: 18,
                                          ).marginOnly(right: 14)
                                        ],
                                      ),
                                    ),
                                  ).marginOnly(top: 10),
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
                                      _.guestChannelSelect=false;
                                      _.guestContentTypeSelect=false;
                                      _.guestStartDateSelect=false;
                                      _.guestEndDateSelect=true;
                                      _.guestHostSelect=false;
                                    });
                                    _.showGuestGraphCalendar(ctx);
                                  },
                                  child: Container(
                                    height: 50,
                                    width: Get.width / 2.25,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: _.guestEndDateSelect == true
                                            ? NewCommonColours
                                            .filterGreenBorderColor
                                            : NewCommonColours
                                            .filterBorderColor,
                                      ),
                                      borderRadius: BorderRadius.circular(2.0),
                                    ),
                                    child: _.guestGraphEndDate == null
                                        ? Center(
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${_.endpaichartSearchDate.text}",
                                              style: NewTextStyle
                                                  .font14Weight300,
                                            ).marginOnly(left: 15),
                                            Icon(
                                              Icons.calendar_month_outlined,
                                              color: Color(0xff22b161)
                                                  .withOpacity(0.79),
                                              size: 18,
                                            ).marginOnly(right: 14)
                                          ],
                                        ))
                                        : Center(
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${_.guestGraphEndDate.toString().split(" ").first}",
                                              style: NewTextStyle
                                                  .fonT14Weight300,
                                            ).marginOnly(left: 15),
                                            Icon(
                                              Icons.calendar_month_outlined,
                                              color: Color(0xff22b161)
                                                  .withOpacity(0.79),
                                              size: 18,
                                            ).marginOnly(right: 14)
                                          ],
                                        ),
                                    ),
                                  ).marginOnly(top: 10, left: 15),
                                ),
                              ],
                            ),
                          ],
                        ),
                        //  Align(
                        //   alignment: Alignment.topLeft,
                        //   child: Text(
                        //     'Date',
                        //     style: NewTextStyle.font9Weight500,
                        //   ),
                        // ).marginOnly(top: 23),
                        // const SizedBox(
                        //   height: 7.0,
                        // ),
                        // SizedBox(
                        //   width: Get.width,
                        //   child: showDates(_),
                        // ),
                        // const SizedBox(
                        //   height: 20.0,
                        // ),
                        // <----------------- PieChart Program Type ----------------->
                        // const Align(
                        //   alignment: Alignment.topLeft,
                        //   child: Text(
                        //     'Program Type',
                        //     style: TextStyle(
                        //       letterSpacing: 0.4,
                        //       fontSize: 13.0,
                        //       fontWeight: FontWeight.w500,
                        //       color: Colors.white,
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(
                        //   height: 10.0,
                        // ),
                        // SizedBox(
                        //   width: Get.width,
                        //   child: _.programType.isEmpty
                        //       ? const Text(
                        //           'No Program Type Available',
                        //           style: TextStyle(
                        //               letterSpacing: 0.4, color: Colors.white),
                        //         )
                        //       : showProgramType(_),
                        // ),
                        // const SizedBox(
                        //   height: 20.0,
                        // ),
                        // <----------------- Host ----------------->
                        Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children:  [
                              Text(
                                'Host',
                                style: NewTextStyle.font9Weight500
                              ),
                            ],
                          ),
                        ).marginOnly(top: 23),
                        const SizedBox(
                          height: 10.0,
                        ),
                        _.hostList.isEmpty
                            ? const Text(
                                'No Host Available',
                                style: TextStyle(
                                    letterSpacing: 0.4, color: Colors.white),
                              )
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _.guestChannelSelect=false;
                                    _.guestContentTypeSelect=false;
                                    _.guestStartDateSelect=false;
                                    _.guestEndDateSelect=false;
                                    _.guestHostSelect=true;
                                  });
                                  hostBottomSheet(_);
                                },
                                child: Container(
                                  height: 50.0,
                                  width: Get.width ,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: _.guestHostSelect == true
                                          ? NewCommonColours
                                          .filterGreenBorderColor
                                          : NewCommonColours
                                          .filterBorderColor,
                                    ),
                                    borderRadius: BorderRadius.circular(2.0),
                                  ),
                                  child: Obx(
                                    () => Row(
                                      children: [
                                        SizedBox(
                                          width: Get.width /1.3,
                                          child: Text(
                                            _.filterHost.isEmpty
                                                ? 'Select Host'
                                                : _.listToString(_.filterHost),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style:_.filterHost.isEmpty?NewTextStyle.font14Weight300:NewTextStyle.fonT14Weight300,
                                          ).marginOnly(left: 15.0, right: 5.0),
                                        ),
                                        const Spacer(),
                                        Icon(
                                          Icons.keyboard_arrow_down,
                                          color:NewCommonColours.filterDropDownColor,
                                          size:20,
                                        ).marginOnly(right: 21),
                                      ],
                                    ),
                                  ),
                                  // DropDownMultiSelect(
                                  //   filterlist: _.filterlist,
                                  //   onChanged: (List<String> x) {
                                  //     setState(() {
                                  //       _.filterHost = x;
                                  //       // _.filterHost.forEach((element) {
                                  //       //   _.filterlist.removeWhere(
                                  //       //       (e) => e == element);
                                  //       // });
                                  //       // _.filterHost.forEach((element) {
                                  //       //   _.filterlist.add(element);
                                  //       // });
                                  //     });
                                  //   },
                                  //   options: _.anchorList,
                                  //   selectedValues: _.filterHost,
                                  //   whenEmpty: 'Select Host',
                                  // ),

                                  // CommonDropDownField(
                                  //   screenController: _,
                                  //   controller: _.hostselect.value,
                                  //   values: _.anchorList,
                                  //   checkedvalue: _.hostselect.value,
                                  //   placeholder: "",
                                  //   doCallback: _.addhostdata,
                                  // ),
                                ),
                              ),
                        // Align(
                        //   alignment: Alignment.topLeft,
                        //   child: Container(
                        //     width: Get.width / 2.25,
                        //     child: Text(
                        //       'Host',
                        //       style: TextStyle(
                        //         letterSpacing: 0.4,
                        //         fontSize: 13.0,
                        //         fontWeight: FontWeight.w500,
                        //         color: Colors.white,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        // _.anchorList.length == 1 || _.anchorList.length == 0
                        //     ? Align(
                        //         alignment: Alignment.topLeft,
                        //         child: Text(
                        //           'No Host Available',
                        //           style: TextStyle(
                        //               letterSpacing: 0.4, color: Colors.white),
                        //         ),
                        //       )
                        //     : Align(
                        //         alignment: Alignment.topLeft,
                        //         child: Container(
                        //           width: Get.width / 2.5,
                        //           child: DropDownMultiSelect(
                        //             filterlist: _.filterlist,
                        //             readOnly: true,
                        //             onChanged: (List<String> x) {
                        //               setState(() {
                        //                 _.filterHost = x;
                        //                 _.update();
                        //                 print('Filter Selected is Called');
                        //                 _.filterHost.forEach((element) {
                        //                   _.filterlist.removeWhere((e) =>
                        //                       e.toString() ==
                        //                       element.toString());
                        //                 });
                        //                 _.filterHost.forEach((element) {
                        //                   _.filterlist.add(element);
                        //                 });
                        //                 _.filterlist.forEach((element) {});
                        //               });
                        //             },
                        //             options: _.anchorList,
                        //             selectedValues: _.filterHost,
                        //             whenEmpty: 'Select Host',
                        //           ),
                        //         ),
                        //       ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: Get.width/3,
                      child: CommonFilterButton(fillColor: NewCommonColours.filterClearBtnColor,
                        onPressed:(){
                          Get.back();

                        } ,
                        text:"Cancel",
                        textStyle: NewTextStyle.font12Weight400,

                      ),
                    ),

                    // SizedBox(
                    //   width: Get.width / 3,
                    //   child: MaterialButton(
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(5.0),
                    //     ),
                    //     onPressed: () {
                    //       Get.back();
                    //     },
                    //     minWidth: 120,
                    //     height: 38,
                    //     child: const Text(
                    //       "CANCEL",
                    //       style: TextStyle(
                    //           letterSpacing: 0.4,
                    //           color: CommonColor.cancelButtonColor,
                    //           fontSize: 16.0,
                    //           fontWeight: FontWeight.w700),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(
                      width: 16.0,
                    ),

                    SizedBox(
                      width: Get.width/3,
                      child: CommonFilterButton(fillColor: NewCommonColours.filterApplyBtnColor,
                        onPressed: () async {
                          // Get.back();
                          if (_.startpaichartSearchDate.text == '' &&
                              _.endpaichartSearchDate.text == '') {
                            CustomSnackBar.showSnackBar(
                              title: AppStrings.selectdate,
                              message: "",
                              backgroundColor: CommonColor.snackbarColour,
                              isWarning: true,
                            );
                          }
                          else if(_.filter2DaysDifference>180){
                            CustomSnackBar.showSnackBar(
                                title: AppStrings.dateRangeError,
                                message: "",
                                backgroundColor: CommonColor.snackbarColour,
                                isWarning: true);
                          }
                          else if (_.paichartprogramtype.isEmpty) {
                            CustomSnackBar.showSnackBar(
                                title: AppStrings.programlist,
                                message: "",
                                backgroundColor: CommonColor.snackbarColour,
                                isWarning: true);
                          }
                          else {
                            Get.back();
                            _.indicatorList.clear();
                            _.update();
                            await _.getPieChartData();
                          }
                        },
                        text:"Apply Filter",
                        textStyle: NewTextStyle.font12Weight400,

                      ),
                    ),

                    // SizedBox(
                    //   width: Get.width / 3,
                    //   child: MaterialButton(
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(5.0),
                    //       side: const BorderSide(
                    //         color: CommonColor.greenBorderColor,
                    //       ),
                    //     ),
                    //     onPressed: () async {
                    //       // Get.back();
                    //       if (_.startpaichartSearchDate.text == '' &&
                    //           _.endpaichartSearchDate.text == '') {
                    //         CustomSnackBar.showSnackBar(
                    //           title: AppStrings.selectdate,
                    //           message: "",
                    //           backgroundColor: CommonColor.snackbarColour,
                    //           isWarning: true,
                    //         );
                    //       } else {
                    //         Get.back();
                    //         _.indicatorList.clear();
                    //         _.update();
                    //         await _.getPieChartData();
                    //       }
                    //     },
                    //     minWidth: 120,
                    //     height: 38,
                    //     color: CommonColor.greenColorWithOpacity,
                    //     child: const Text(
                    //       "APPLY FILTER",
                    //       style: TextStyle(
                    //           letterSpacing: 0.4,
                    //           color: CommonColor.greenButtonTextColor,
                    //           fontSize: 13.0,
                    //           fontWeight: FontWeight.w700),
                    //     ),
                    //   ),
                    // ),
                  ],
                ).marginOnly(top: 10.0, bottom: 40.0),
              ],
            ).marginOnly(left: 15.0, right: 15.0),
          ),
        );
      }),
    );
  }

  void hostBottomSheet(ReportsController _) {
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
                      GoogleFonts.roboto(fontSize: 0.0, color: Colors.white),
                  withSearch: false,
                  titleStyle: GoogleFonts.roboto(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                  subtitleStyle: GoogleFonts.roboto(
                    fontWeight: FontWeight.w100,
                    color: Colors.amber,
                  ),
                ),
                list: List.generate(_.hostList.length, (i) {
                  return AlphabetSearchModel(
                    title: _.hostList[i].name!,
                    subtitle: "",
                  );
                }).toList(),
                buildItem: (context, i, c) {
                  return InkWell(
                    splashColor: const Color(0xff22B161),
                    hoverColor: const Color(0xff22B161),
                    focusColor: const Color(0xff22B161),
                    onTap: () {
                      _.hostList[i].check.value = !_.hostList[i].check.value;
                      if (_.hostList[i].check.value == true) {
                        _.filterlist.add(_.hostList[i].name.toString());
                        _.filterHost.add(_.hostList[i].name.toString());
                      } else {
                        _.filterlist.removeWhere(
                            (element) => element == _.hostList[i].name);
                        _.filterHost.removeWhere(
                            (element) => element == _.hostList[i].name);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Theme(
                          data: ThemeData(unselectedWidgetColor: Colors.white),
                          child: Obx(
                            () => Checkbox(
                              visualDensity: const VisualDensity(
                                  horizontal: -3.5, vertical: -2.5),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              side: const BorderSide(
                                  width: 1.0, color: CommonColor.filterColor),
                              activeColor: CommonColor.greenColor,
                              focusColor: CommonColor.filterColor,
                              hoverColor: CommonColor.filterColor,
                              value: _.hostList[i].check.value,
                              onChanged: (val) {
                                _.hostList[i].check.value =
                                    !_.hostList[i].check.value;
                                if (_.hostList[i].check.value == true) {
                                  _.filterlist
                                      .add(_.hostList[i].name.toString());
                                  _.filterHost
                                      .add(_.hostList[i].name.toString());
                                } else {
                                  _.filterlist.removeWhere((element) =>
                                      element == _.hostList[i].name);
                                  _.filterHost.removeWhere((element) =>
                                      element == _.hostList[i].name);
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Flexible(
                          child: Text(
                            "${_.hostList[i].name}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: GoogleFonts.roboto(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.4,
                              color: CommonColor.filterColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ).marginOnly(left: 20.0, right: 20.0),
            ),
          ],
        );
      }),
      backgroundColor: CommonColor.backgroundColour,
    );
  }

  Widget showDates(ReportsController _) {
    List<Widget> g = [];
    for (int i = 0; i < _.alldatelist.length; i++) {
      g.add(FittedBox(
        fit: BoxFit.fill,
        child: Obx(() => GestureDetector(
              onTap: () {
                for (var e in _.alldatelist) {
                  e.check.value = false;
                  _.filterlist.removeWhere((item) => item == e.startDate);
                  _.startpaichartSearchDate.clear();
                  _.endpaichartSearchDate.clear();
                  _.filterlist.removeWhere((item) => item == e.endDate);
                }
                if (_.alldatelist[i].check.value == false) {
                  _.alldatelist[i].check.value = true;
                  _.startpaichartSearchDate.text = _.alldatelist[i].startDate!;
                  _.endpaichartSearchDate.text = _.alldatelist[i].endDate!;
                  _.filterlist
                      .removeWhere((i) => i.toString().substring(0, 2) == '20');
                  _.filterlist.add(
                      '${_.alldatelist[i].endDate} - ${_.alldatelist[i].startDate}');
                  _.update();
                }

                // _.alldatelist.forEach((e) {
                //   e.check.value = false;
                //   _.filterlist.removeWhere((item) => item == e.startDate);
                //   _.startpaichartSearchDate.clear();
                //   _.endpaichartSearchDate.clear();
                //   _.filterlist.removeWhere((item) => item == e.endDate);
                // });
                // if (_.alldatelist[i].check.value == false) {
                //   _.alldatelist[i].check.value = true;
                //   _.startpaichartSearchDate.text = _.alldatelist[i].startDate!;
                //   _.endpaichartSearchDate.text = _.alldatelist[i].endDate!;
                //   _.filterlist.add(_.alldatelist[i].endDate);
                //   _.filterlist.add(_.alldatelist[i].startDate);
                //   _.update();
                //   print('Start Date is ${_.startSearchDate.text}');
                // }
              },
              child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                      color: _.alldatelist[i].check.value == true
                          ? const Color(0xff22B161)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                          color: _.alldatelist[i].check.value == true
                              ? const Color(0xff22B161)
                              : Colors.white)),
                  child: Center(
                    child: Row(
                      children: [
                        Text(
                          "${_.alldatelist[i].name}",
                          style: TextStyle(
                            fontSize: 11.0,
                            fontWeight: _.alldatelist[i].check.value == true
                                ? FontWeight.w500
                                : FontWeight.w300,
                            color: Colors.white,
                          ),
                        ).marginOnly(left: 20.0, right: 20.0),
                      ],
                    ),
                  )),
            )),
      ).marginAll(5.0));
    }
    return Wrap(
      children: g,
    );
  }

  // <------- Graph Properties ------------->
  //
  // SfCircularChart buildSmartLabelPieChart(ReportsController _) {
  //   return SfCircularChart(
  //     series: gettSmartLabelPieSeries(_.chartdata),
  //     tooltipBehavior: TooltipBehavior(enable: true, header: ''),
  //   );
  // }
  //
  // List<PieSeries<ChartSampleData, String>> gettSmartLabelPieSeries(
  //     List<ChartSampleData>? chartdataSource) {
  //   return <PieSeries<ChartSampleData, String>>[
  //     PieSeries<ChartSampleData, String>(
  //         dataSource: chartdataSource,
  //         xValueMapper: (ChartSampleData data, _) => data.x as String,
  //         yValueMapper: (ChartSampleData data, _) => data.y,
  //         dataLabelMapper: (ChartSampleData data, _) =>
  //             data.x + ': ' + (data.y).toString() as String,
  //         radius: '50%',
  //         dataLabelSettings: const DataLabelSettings(
  //           margin: EdgeInsets.zero,
  //           isVisible: true,
  //           textStyle: TextStyle(
  //               color: Colors.white,
  //                ,
  //               overflow: TextOverflow.ellipsis,
  //               fontSize: 10.0,
  //               fontWeight: FontWeight.w300),
  //           // labelPosition: ChartDataLabelPosition.outside,
  //           connectorLineSettings:
  //               ConnectorLineSettings(type: ConnectorType.curve, length: '0%'),
  //           labelIntersectAction: LabelIntersectAction.shift,
  //         ))
  //   ];
  // }
  //
  // SfCircularChart buildDefaultDoughnutChart(ReportsController _) {
  //   return SfCircularChart(
  //     enableMultiSelection: false,
  //
  //     margin: const EdgeInsets.all(0),
  //     legend: Legend(
  //       toggleSeriesVisibility: false,
  //       position: LegendPosition.right,
  //       //iconBorderColor: Colors.transparent,
  //       isResponsive: true,
  //       borderWidth: 1,
  //       //overflowMode: LegendItemOverflowMode.wrap,
  //       textStyle: GoogleFonts.roboto(
  //           color: Colors.white,
  //           fontWeight: FontWeight.w400,
  //           fontSize: 9,
  //           overflow: TextOverflow.ellipsis),
  //       isVisible: true,
  //       // Legend title
  //       //alignment: ChartAlignment.near,
  //       padding: 5.0,
  //       title: LegendTitle(
  //         alignment: ChartAlignment.center,
  //         text: "Guests",
  //         textStyle: GoogleFonts.roboto(
  //             color: Colors.white,
  //             fontSize: 16,
  //             fontStyle: FontStyle.normal,
  //             fontWeight: FontWeight.w900),
  //       ),
  //     ),
  //     // title: ChartTitle(text: isCardView ? '' : 'Composition of ocean water'),
  //     // legend: Legend(
  //     //     isVisible: !isCardView, overflowMode: LegendItemOverflowMode.wrap),
  //     series: _getDefaultDoughnutSeries(_.chartdata),
  //     //tooltipBehavior: _tooltip,
  //   );
  // }
  //
  // /// Returns the doughnut series which need to be render.
  // List<DoughnutSeries<ChartSampleData, String>> _getDefaultDoughnutSeries(
  //     List<ChartSampleData>? chartdataSource) {
  //   return <DoughnutSeries<ChartSampleData, String>>[
  //     DoughnutSeries<ChartSampleData, String>(
  //         radius: '90%',
  //         explode: false,
  //         explodeOffset: '10%',
  //         dataSource: chartdataSource,
  //
  //         //<ChartSampleData>[
  //
  //         // ChartSampleDatFa(x: 'Chlorine', y: 55, text: '55%'),
  //         // ChartSampleData(x: 'Sodium', y: 31, text: '31%'),
  //         // ChartSampleData(x: 'Magnesium', y: 7.7, text: '7.7%'),
  //         // ChartSampleData(x: 'Sulfur', y: 3.7, text: '3.7%'),
  //         // ChartSampleData(x: 'Calcium', y: 1.2, text: '1.2%'),
  //         // ChartSampleData(x: 'Others', y: 1.4, text: '1.4%'),
  //
  //         //],
  //         enableTooltip: true,
  //         xValueMapper: (ChartSampleData data, _) => data.x as String,
  //         yValueMapper: (ChartSampleData data, _) => data.y,
  //         dataLabelMapper: (ChartSampleData chartdataSource, _) =>
  //             chartdataSource.text,
  //         dataLabelSettings: const DataLabelSettings(
  //             isVisible: true,
  //             textStyle: TextStyle(
  //                 fontSize: 12,
  //                 overflow: TextOverflow.ellipsis,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.white)))
  //   ];
  // }

  // <--------- Channel Widget ---------------->

  Widget showchannel(ReportsController _) {
    List<Widget> g = [];
    for (int i = 0; i < _.channellist.length; i++) {
      g.add(
        SizedBox(
          width: Get.width / 3.4,
          child: Row(
            children: [
              Theme(
                data: ThemeData(unselectedWidgetColor: Colors.white),
                child: Obx(
                  () => Checkbox(
                    visualDensity:
                        const VisualDensity(horizontal: -3.5, vertical: -2.5),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    activeColor: const Color(0xff22B161),
                    focusColor: Colors.white,
                    hoverColor: Colors.white,
                    value: _.channellist[i].check.value,
                    onChanged: (val) {
                      if (_.channellist[i].check.value == false) {
                        _.channellist[i].check.value = true;
                        if (_.channellist[i].name == 'All Channels') {
                          // _.filterlist.clear();
                          if (_.endpaichartSearchDate.text != '' &&
                              _.startpaichartSearchDate.text != '') {
                            _.filterlist.add(
                                '${_.endpaichartSearchDate.text} - ${_.startpaichartSearchDate.text}');
                          }
                          _.channellist[i].check.value = true;
                          _.filterlist.add(_.channellist[i].name);
                          for (var element in _.channellist) {
                            if (element.name != 'All Channels') {
                              _.filterlist
                                  .removeWhere((item) => item == element.name);
                              _.paichartchannel
                                  .removeWhere((item) => item == element.name);
                              _.paichartchannel.add(element.name);
                              element.check.value = false;
                              _.update();
                            }
                          } // Idhr tk Function Bilkul Perfect Hai
                        } else if (_.channellist[i].name != 'All Channels') {
                          for (int i = 0; i < _.filterlist.length; i++) {
                            if (_.filterlist[i] == 'All Channels') {
                              _.filterlist.removeWhere(
                                  (item) => item == 'All Channels');

                              _.paichartchannel.clear();
                            }
                          }
                          for (var element in _.channellist) {
                            if (element.name == 'All Channels') {
                              element.check.value = false;
                            }
                          }
                          _.filterlist.add(_.channellist[i].name);
                          _.paichartchannel.add(_.channellist[i].name);
                          _.update();
                        } // YeAh Function b iDhr tk Bilkul Perfect Hai
                      } else {
                        _.channellist[i].check.value = false;
                        if (_.channellist[i].name == 'All Channels') {
                          _.filterlist.removeWhere(
                              (item) => item == _.channellist[i].name);
                          _.programslist.clear();
                          for (var element in _.channellist) {
                            if (element.name != 'All Channels') {
                              _.paichartchannel
                                  .removeWhere((item) => item == element.name);
                              element.check.value = false;
                              _.update();
                            }
                          } // Idhr Tk If ki Condition Bilkul Perfect Hai
                        } else {
                          _.filterlist.removeWhere(
                              (item) => item == _.channellist[i].name);
                          _.paichartchannel.removeWhere(
                              (item) => item == _.channellist[i].name);
                          _.update();
                        }
                      }

                      // if (_.channellist[i].check.value == false) {
                      //   _.channellist[i].check.value = true;
                      //   if (_.channellist[i].name == 'All Channels') {
                      //     _.channellist[i].check.value = true;
                      //     _.filterlist.add(_.channellist[i].name);
                      //     _.channellist.forEach((element) {
                      //       if (element.name != 'All Channels') {
                      //         _.paichartchannel.add(element.name);
                      //         element.check.value = false;
                      //         _.update();
                      //       }
                      //     });
                      //   } else {
                      //     _.filterlist.add(_.channellist[i].name);
                      //     _.paichartchannel.add(_.channellist[i].name);
                      //     _.update();
                      //   }
                      // }
                      // else {
                      //   _.channellist[i].check.value = false;
                      //   if (_.channellist[i].name == 'All Channels') {
                      //     _.channellist.forEach((element) {
                      //       if (element.name != 'All Channels') {
                      //         _.filterlist.clear();
                      //         _.channelsearchlist.clear();
                      //         _.paichartchannel.clear();
                      //         element.check.value = false;
                      //         _.update();
                      //       }
                      //     });
                      //   }
                      //   _.paichartchannel.removeWhere(
                      //       (item) => item == _.channellist[i].name);
                      //   _.filterlist.removeWhere(
                      //       (item) => item == _.channellist[i].name);
                      //   _.update();
                      // }
                    },
                  ),
                ),
              ),
              const SizedBox(
                width: 2.0,
              ),
              Flexible(
                child: Text(
                  "${_.channellist[i].name}",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: GoogleFonts.roboto(
                      fontSize: 11.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Wrap(
      children: g,
    );
  }

  //<--------- Trending Program Type Widget ---------------->

  void showTrendingProgramBtmSheet(ReportsController _) {
    Get.bottomSheet(
      Column(
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
            child: ListView.separated(
              itemCount: _.programType1.length,
              shrinkWrap: true,
              separatorBuilder: (c, e) {
                return const SizedBox(
                  width: 20.0,
                );
              },
              itemBuilder: (c, i) {
                return InkWell(
                  splashColor: const Color(0xff22B161),
                  hoverColor: const Color(0xff22B161),
                  focusColor: const Color(0xff22B161),
                  onTap: () {
                    if (_.programType1[i].check.value == false) {
                      _.programType1[i].check.value = true;
                      _.filterlist1.add(_.programType1[i].name);
                      _.programtypegraph.add(_.programType1[i].name);
                    } else {
                      _.programType1[i].check.value = false;
                      _.programtypegraph.removeWhere(
                          (item) => item == _.programType1[i].name);
                      _.filterlist1.removeWhere(
                          (item) => item == _.programType1[i].name);
                      _.update();
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Theme(
                        data: ThemeData(unselectedWidgetColor: Colors.white),
                        child: Obx(
                          () => Checkbox(
                            visualDensity: const VisualDensity(
                                horizontal: -3.5, vertical: -2.5),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            side: const BorderSide(
                                width: 1.0, color: CommonColor.filterColor),
                            activeColor: CommonColor.greenColor,
                            focusColor: CommonColor.filterColor,
                            hoverColor: CommonColor.filterColor,
                            value: _.programType1[i].check.value,
                            onChanged: (val) {
                              if (_.programType1[i].check.value == false) {
                                _.programType1[i].check.value = true;
                                _.filterlist1.add(_.programType1[i].name);
                                _.programtypegraph.add(_.programType1[i].name);
                              } else {
                                _.programType1[i].check.value = false;
                                _.programtypegraph.removeWhere(
                                    (item) => item == _.programType1[i].name);
                                _.filterlist1.removeWhere(
                                    (item) => item == _.programType1[i].name);
                                _.update();
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Flexible(
                          child: Text(
                        "${_.programType1[i].name}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: GoogleFonts.roboto(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.4,
                          color: CommonColor.filterColor,
                        ),
                      )),
                    ],
                  ),
                );
              },
            ).marginOnly(left: 20.0, right: 20.0),
          ),
        ],
      ),
      backgroundColor: CommonColor.backgroundColour,
    );
  }

  //<--------------------Pie Chart Content Type bottom sheet-------------
  void showPieProgramBtmSheet(ReportsController _) {
    Get.bottomSheet(
      Column(
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
            child: ListView.separated(
              itemCount: _.programType.length,
              shrinkWrap: true,
              separatorBuilder: (c, e) {
                return const SizedBox(
                  width: 20.0,
                );
              },
              itemBuilder: (c, i) {
                return InkWell(
                  splashColor: const Color(0xff22B161),
                  hoverColor: const Color(0xff22B161),
                  focusColor: const Color(0xff22B161),
                  onTap: () {
                    if (_.programType[i].check.value == false) {
                      _.programType[i].check.value = true;
                      _.filterlist.add(_.programType[i].name);
                      _.paichartprogramtype.add(_.programType[i].name);
                    } else {
                      _.programType[i].check.value = false;
                      _.paichartprogramtype.removeWhere(
                              (item) => item == _.programType[i].name);
                      _.filterlist.removeWhere(
                              (item) => item == _.programType[i].name);
                      _.update();
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Theme(
                        data: ThemeData(unselectedWidgetColor: Colors.white),
                        child: Obx(
                              () => Checkbox(
                            visualDensity: const VisualDensity(
                                horizontal: -3.5, vertical: -2.5),
                            materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                            side: const BorderSide(
                                width: 1.0, color: CommonColor.filterColor),
                            activeColor: CommonColor.greenColor,
                            focusColor: CommonColor.filterColor,
                            hoverColor: CommonColor.filterColor,
                            value: _.programType[i].check.value,
                            onChanged: (val) {
                              if (_.programType[i].check.value == false) {
                                _.programType[i].check.value = true;
                                _.filterlist.add(_.programType[i].name);
                                _.paichartprogramtype.add(_.programType[i].name);
                              } else {
                                _.programType[i].check.value = false;
                                _.paichartprogramtype.removeWhere(
                                        (item) => item == _.programType[i].name);
                                _.filterlist.removeWhere(
                                        (item) => item == _.programType[i].name);
                                _.update();
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Flexible(
                          child: Text(
                            "${_.programType[i].name}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: GoogleFonts.roboto(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.4,
                              color: CommonColor.filterColor,
                            ),
                          )),
                    ],
                  ),
                );
              },
            ).marginOnly(left: 20.0, right: 20.0),
          ),
        ],
      ),
      backgroundColor: CommonColor.backgroundColour,
    );
  }



//----------------------- Pie chart program type-----------
  Widget showProgramType(ReportsController _) {
    List<Widget> g = [];
    for (int i = 0; i < _.programType.length; i++) {
      g.add(FittedBox(
        fit: BoxFit.fill,
        child: Obx(() => GestureDetector(
              onTap: () {
                // _.programType.forEach((e) {
                //   e.check.value = false;
                // });
                if (_.programType[i].check.value == false) {
                  _.programType[i].check.value = true;
                  _.filterlist.add(_.programType[i].name);
                  _.paichartprogramtype.add(_.programType[i].name);
                } else {
                  _.programType[i].check.value = false;
                  _.paichartprogramtype
                      .removeWhere((item) => item == _.programType[i].name);
                  _.filterlist
                      .removeWhere((item) => item == _.programType[i].name);
                  _.update();
                }
              },
              child: Container(
                  height: 32,
                  decoration: BoxDecoration(
                      color: _.programType[i].check.value == true
                          ? const Color(0xff22B161)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                          color: _.programType[i].check.value == true
                              ? const Color(0xff22B161)
                              : Colors.white)),
                  child: Center(
                    child: Text(
                      "${_.programType[i].name}",
                      style: TextStyle(
                          fontSize: 11.0,
                          fontWeight: _.programType[i].check.value == true
                              ? FontWeight.w500
                              : FontWeight.w300,
                          color: Colors.white),
                    ).marginOnly(left: 10.0, right: 10.0),
                  )),
            )),
      ).marginOnly(right: 5.0, bottom: 5.0));
    }
    return Wrap(
      children: g,
    );
  }

  Widget showProgramTypeFilter1(ReportsController _) {
    List<Widget> g = [];
    for (int i = 0; i < _.programType1.length; i++) {
      g.add(FittedBox(
        fit: BoxFit.fill,
        child: Obx(() => GestureDetector(
              onTap: () {
                // _.programType.forEach((e) {
                //   e.check.value = false;
                // });
                if (_.programType1[i].check.value == false) {
                  _.programType1[i].check.value = true;
                  _.filterlist1.add(_.programType1[i].name);
                  _.programtypegraph.add(_.programType1[i].name);
                } else {
                  _.programType1[i].check.value = false;
                  _.programtypegraph
                      .removeWhere((item) => item == _.programType1[i].name);
                  _.filterlist1
                      .removeWhere((item) => item == _.programType1[i].name);
                  _.update();
                }
              },
              child: Container(
                  height: 32,
                  decoration: BoxDecoration(
                      color: _.programType1[i].check.value == true
                          ? CommonColor.greenColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                          color: _.programType1[i].check.value == true
                              ? CommonColor.greenColor
                              : CommonColor.filterColor)),
                  child: Center(
                    child: Text(
                      "${_.programType1[i].name}",
                      style: TextStyle(
                          fontSize: 11.0,
                          fontWeight: _.programType1[i].check.value == true
                              ? FontWeight.w500
                              : FontWeight.w300,
                          color: CommonColor.filterColor),
                    ).marginOnly(left: 10.0, right: 10.0),
                  )),
            )),
      ).marginOnly(right: 5.0, bottom: 10.0));
    }
    return Wrap(
      children: g,
    );
  }

  Widget bulletColor({Color? bordercolor, Color? containercolor}) {
    return Container(
      width: 10.0,
      height: 10.0,
      decoration: BoxDecoration(
        border: Border.all(color: bordercolor!),
        borderRadius: BorderRadius.circular(50.0),
        color: containercolor,
      ),
    );
  }



}
