// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lytics_lens/Controllers/searchbar_controller.dart';
import 'package:lytics_lens/Views/player_Screen.dart';
import 'package:lytics_lens/widget/bottomsheet/user_bottomsheet.dart';
import 'package:lytics_lens/widget/dialog_box/share_dialogbox.dart';
import 'package:lytics_lens/widget/dialog_box/ticker_dialogbox.dart';
import 'package:lytics_lens/widget/textFields/searchfield.dart';
import 'package:share/share.dart';
import '../Constants/app_strrings.dart';
import '../Constants/common_color.dart';
import '../Controllers/playerController.dart';
import '../Controllers/searchScreen_controller.dart';
import '../widget/bottomsheet/filter_bottimsheet.dart';
import '../widget/common_containers/common_container.dart';
import '../widget/common_containers/ticker_container.dart';
import '../widget/common_containers/trendingkeyword_container.dart';
import '../widget/common_containers/twitter_container.dart';
import '../widget/internet_connectivity/internetconnectivity_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchScreenController>(
      init: SearchScreenController(),
      builder: (_) {
        final mqData = MediaQuery.of(context);
        final mqDataNew = mqData.copyWith(
            textScaleFactor:
                mqData.textScaleFactor > 1.0 ? 1.0 : mqData.textScaleFactor);

        return Obx(() {
          return MediaQuery(
            data: mqDataNew,
            child: WillPopScope(
              onWillPop: () async {
                if (kDebugMode) {
                  print("Will pop press");
                }
                _.searchBarController.searchText.value.clear();
                _.searchBarController.searchtopiclist.clear();
                _.searchBarController.isShowList = false;
                _.searchBarController.update();
                DateTime searchDate =
                    DateTime.now().subtract(const Duration(days: 1));
                _.searchBarController.startDate.text =
                    searchDate.toString().split(" ").first;
                _.searchBarController.endDate.text =
                    '${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}';

                _.searchBarController.startData =
                    DateTime.now().subtract(const Duration(days: 1));
                _.searchBarController.endData = DateTime.now();
                _.searchBarController.filterChannelList.clear();
                _.searchBarController.filterProgramType.clear();
                _.searchBarController.filterHost.clear();
                _.searchBarController.filterGuests.clear();
                _.searchBarController.filterSourceList.clear();
                _.searchBarController.selectedchannel.clear();
                _.searchBarController.selectformDate.value = DateTime.now();
                _.searchBarController.selecttoDate.value = DateTime.now();
                _.searchBarController.filterlist.clear();
                _.searchBarController.filterlist.add('All');
                _.searchBarController.filterlist.add('All Channels');
                _.searchBarController.selectedchannel.add('All Channels');
                _.searchBarController.searchContentTypeSelect = false;
                _.searchBarController.searchChannelSelect = false;
                _.searchBarController.searchStartDateSelect = false;
                _.searchBarController.searchEndDateSelect = false;
                _.searchBarController.searchHostSelect = false;
                _.searchBarController.searchGuestSelect = false;
                for (var element in _.searchBarController.filterlist) {
                  if (element == 'All Channels') {
                    for (var e in _.searchBarController.channellist) {
                      if (e.name != 'All Channels') {
                        _.searchBarController.filterChannelList.add(e.name);
                      }
                    }
                  }
                }
                for (var e in _.searchBarController.channellist) {
                  if (e.name == 'All Channels') {
                    e.check.value = true;
                  } else {
                    e.check.value = false;
                  }
                }
                _.searchBarController.filterlist.forEach((element) {
                  if (element == 'All') {
                    _.searchBarController.sourceModelList.forEach((e) {
                      if (e.name != 'All') {
                        _.searchBarController.filterSourceList.add(e.name);
                      }
                    });
                  }
                });
                _.searchBarController.sourceModelList.forEach((e) {
                  if (e.name == 'All') {
                    e.check.value = true;
                  } else {
                    e.check.value = false;
                  }
                });
                for (var element in _.searchBarController.programType) {
                  element.check.value = false;
                }
                for (var element in _.searchBarController.alldatelist1) {
                  element.check.value = false;
                }
                _.searchBarController.startTime.clear();
                _.searchBarController.endTime.clear();
                _.searchBarController.hostselect.value.clear();
                _.searchBarController.update();
                _.searchBarController.isLoading.value = false;
                Get.back();
                return false;
              },
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: CommonColor.appBarColor,
                // drawer: GlobalDrawer(),
                appBar: AppBar(
                  elevation: 0.0,
                  backgroundColor: const Color(0xff000425),
                  titleSpacing: 0,
                  leading: GestureDetector(
                    onTap: () {
                      _.searchBarController.searchText.value.clear();
                      _.searchBarController.searchtopiclist.clear();
                      _.searchBarController.isShowList = false;
                      _.searchBarController.update();

                      DateTime searchDate =
                          DateTime.now().subtract(const Duration(days: 1));
                      _.searchBarController.startDate.text =
                          searchDate.toString().split(" ").first;
                      _.searchBarController.endDate.text =
                          '${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}';

                      _.searchBarController.startData =
                          DateTime.now().subtract(const Duration(days: 1));
                      _.searchBarController.endData = DateTime.now();

                      _.searchBarController.filterChannelList.clear();
                      _.searchBarController.filterProgramType.clear();
                      _.searchBarController.filterHost.clear();
                      _.searchBarController.filterGuests.clear();
                      _.searchBarController.filterSourceList.clear();
                      _.searchBarController.selectedchannel.clear();
                      _.searchBarController.selectformDate.value =
                          DateTime.now();
                      _.searchBarController.selecttoDate.value = DateTime.now();
                      _.searchBarController.filterlist.clear();
                      _.searchBarController.filterlist.add('All');
                      _.searchBarController.filterlist.add('All Channels');
                      _.searchBarController.selectedchannel.add('All Channels');
                      _.searchBarController.searchContentTypeSelect = false;
                      _.searchBarController.searchChannelSelect = false;
                      _.searchBarController.searchStartDateSelect = false;
                      _.searchBarController.searchEndDateSelect = false;
                      _.searchBarController.searchHostSelect = false;
                      _.searchBarController.searchGuestSelect = false;

                      for (var element in _.searchBarController.filterlist) {
                        if (element == 'All Channels') {
                          for (var e in _.searchBarController.channellist) {
                            if (e.name != 'All Channels') {
                              _.searchBarController.filterChannelList
                                  .add(e.name);
                            }
                          }
                        }
                      }

                      for (var e in _.searchBarController.channellist) {
                        if (e.name == 'All Channels') {
                          e.check.value = true;
                        } else {
                          e.check.value = false;
                        }
                      }
                      _.searchBarController.filterlist.forEach((element) {
                        if (element == 'All') {
                          _.searchBarController.sourceModelList.forEach((e) {
                            if (e.name != 'All') {
                              _.searchBarController.filterSourceList
                                  .add(e.name);
                            }
                          });
                        }
                      });
                      _.searchBarController.sourceModelList.forEach((e) {
                        if (e.name == 'All') {
                          e.check.value = true;
                        } else {
                          e.check.value = false;
                        }
                      });
                      for (var element in _.searchBarController.programType) {
                        element.check.value = false;
                      }
                      for (var element in _.searchBarController.alldatelist1) {
                        element.check.value = false;
                      }
                      _.searchBarController.startTime.clear();
                      _.searchBarController.endTime.clear();
                      _.searchBarController.hostselect.value.clear();
                      _.searchBarController.update();
                      _.searchBarController.isLoading.value = false;

                      Get.back();
                    },
                    child: const Icon(
                      Icons.keyboard_backspace_rounded,
                    ),
                  ),
                  actions: [
                    GestureDetector(
                      onTap: () {
                        if (_.searchBarController.isLoading.value != true) {
                          FilterBottomSheet.showBottomSheet(
                              cntrl: _.searchBarController);
                        }

                        // if (_.searchBarController.job.isEmpty &&
                        //     _.searchBarController.searchjob.isEmpty &&
                        //     _.searchBarController.searchdata.value.text == '') {
                        //   // CustomSnackBar.showSnackBar(
                        //   //   title: AppStrings.enterSomeText,
                        //   //   message: "",
                        //   //   backgroundColor: CommonColor.snackbarColour,
                        //   //   isWarning: true,
                        //   // );
                        // } else if (_.searchBarController.isLoading.value != true) {
                        //   FilterBottomSheet.showBottomSheet(
                        //     cntrl: _.searchBarController
                        //   );
                        // }
                      },
                      child: Image.asset(
                        "assets/images/search_filter.png",
                        height: 12,
                        width: 16,
                        fit: BoxFit.contain,
                      ).marginOnly(right: 10),
                    ),
                    // IconButton(
                    //
                    //     onPressed: () {
                    //       if (_.searchBarController.job.isEmpty &&
                    //           _.searchBarController.searchjob.isEmpty &&
                    //           _.searchBarController.searchdata.value.text == '') {
                    //         // CustomSnackBar.showSnackBar(
                    //         //   title: AppStrings.enterSomeText,
                    //         //   message: "",
                    //         //   backgroundColor: CommonColor.snackbarColour,
                    //         //   isWarning: true,
                    //         // );
                    //       } else if (_.searchBarController.isLoading.value != true) {
                    //         showbottomsheet(context, _);
                    //       }
                    //     },
                    //     icon: Icon(Icons.tune, color: Colors.white,)
                    // ),
                  ],
                  flexibleSpace: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 55.0, top: 0.0, right: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          SearchField(
                            _.searchBarController.searchText.value,
                            (c) {},
                            _.searchBarController.isLoading.value
                                ? "Searching"
                                : "${_.searchBarController.searchjob.length} Results",
                            (v) async {
                              // _.searchBarController.channellist.forEach((element) {
                              //   element.check.value = false;
                              // });
                              // _.searchBarController.programType.forEach((element) {
                              //   element.check.value = false;
                              // });
                              // _.searchBarController.filterChannelList.clear();
                              // _.searchBarController.filterProgramType.clear();
                              // _.searchBarController.filterlist.clear();
                              // _.searchBarController.filterGuests.clear();
                              // _.searchBarController.filterHost.clear();
                              if (v != '') {
                                await _.searchBarController.getFilterJobs(v, 1);
                              }
                            },
                            () async {
                              if (_.searchBarController.searchdata.value.text !=
                                  '') {
                                await _.searchBarController.getFilterJobs(
                                    _.searchBarController.searchdata.value.text,
                                    1);
                              }
                            },
                            () {
                              if (_.searchBarController.isLoading.value ==
                                  false) {
                                _.searchBarController.searchdata.value.clear();
                                _.searchBarController.searchText.value.clear();
                              }
                            },
                            () async {
                              if (_.searchBarController.searchdata.value.text !=
                                  '') {
                                await _.searchBarController.getFilterJobs(
                                    _.searchBarController.searchdata.value.text,
                                    1);
                              }
                            },
                          ).marginOnly(right: 30),
                        ],
                      ),
                    ),
                  ),
                ),
                // bottomNavigationBar: GlobalBottomNav(),
                body: _.searchBarController.isSocketError.value
                    ? InterConnectivity(
                        onPressed: () async {
                          _.searchBarController.isLoading.value = true;
                          await _.searchBarController.getFilterJobs(
                              _.searchBarController.searchdata.value.text, 1);
                          _.searchBarController.isLoading.value = false;
                        },
                      )
                    : _.searchBarController.isLoading.value
                        ? Center(
                            child: Image.asset(
                              "assets/images/gif.gif",
                              height: 300.0,
                              width: 300.0,
                            ),
                          )
                        : Container(
                            height: Get.height,
                            width: Get.width,
                            // decoration: BoxDecoration(
                            //   gradient: RadialGradient(
                            //     colors: [
                            //       Color(0xff1b1d28).withOpacity(.95),
                            //       Color(0xff1b1d28),
                            //     ],
                            //   ),
                            // ),
                            color: const Color(0xff000425),

                            child: GestureDetector(
                              onTap: () {
                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                              },
                              onVerticalDragCancel: () {
                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                              },
                              child:
                                  _.searchBarController.job.isEmpty &&
                                          _.searchBarController.searchjob
                                              .isEmpty
                                      ? TrendingKeyword(
                                          controller: _,
                                          title: 'No Matches Found for',
                                          searchText: _.searchBarController
                                              .searchText.value.text,
                                          subTitle:
                                              'Please check your spelling or try different keywords',
                                          heading: 'Trending Topics',
                                        )
                                      : Column(
                                          children: [
                                            Expanded(
                                              child: ListView.separated(
                                                shrinkWrap: true,
                                                itemCount: _.searchBarController
                                                        .searchjob.isEmpty
                                                    ? _.searchBarController.job
                                                        .length
                                                    : _.searchBarController
                                                        .searchjob.length,
                                                separatorBuilder: (c, e) {
                                                  return const SizedBox(
                                                    height: 5.0,
                                                  );
                                                },
                                                itemBuilder: (ctx, index) {
                                                  if (_.searchBarController.job
                                                      .isNotEmpty) {
                                                    if (_.searchBarController
                                                            .job.length ==
                                                        index + 1) {
                                                      _.searchBarController
                                                          .tpageno.value = _
                                                              .searchBarController
                                                              .tpageno
                                                              .value +
                                                          1;
                                                      _.searchBarController
                                                          .getFilterJobs(
                                                              _
                                                                  .searchBarController
                                                                  .searchdata
                                                                  .value
                                                                  .text,
                                                              _.searchBarController
                                                                  .tpageno.value);
                                                    } else {
                                                      _.searchBarController
                                                          .isMore.value = false;
                                                    }
                                                  } else if (_
                                                      .searchBarController
                                                      .searchjob
                                                      .isNotEmpty) {
                                                    if (_.searchBarController
                                                            .searchjob.length ==
                                                        index + 1) {
                                                      _.searchBarController
                                                          .tpageno.value = _
                                                              .searchBarController
                                                              .tpageno
                                                              .value +
                                                          1;
                                                      _.searchBarController
                                                          .getFilterJobs(
                                                              _
                                                                  .searchBarController
                                                                  .searchdata
                                                                  .value
                                                                  .text,
                                                              _.searchBarController
                                                                  .tpageno.value);
                                                    } else {
                                                      _.searchBarController
                                                          .isMore.value = false;
                                                    }
                                                  }
                                                  return Column(
                                                    children: [
                                                      _.searchBarController
                                                                          .searchjob[
                                                                      index]
                                                                  ['source'] ==
                                                              'Social'
                                                          ? TwitterContainer(
                                                              onContainerTap:
                                                                  () {
                                                                Fluttertoast
                                                                    .showToast(
                                                                  msg: AppStrings
                                                                      .toastmessage,
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .BOTTOM,
                                                                );
                                                              },
                                                              programUser: _
                                                                      .searchBarController
                                                                      .searchjob[index]
                                                                  [
                                                                  'programUser'],
                                                              thumbnail:
                                                                  "${_.searchBarController.baseUrlService.baseUrl}/uploads/${_.searchBarController.searchjob[index]['thumbnailPath']}",
                                                              username:
                                                                  "${_.searchBarController.searchjob[index]['channel']}",
                                                              content: _.searchBarController.searchjob[index]['transcription'].runtimeType
                                                                          .toString() ==
                                                                      'String'
                                                                  ? _.searchBarController.content(json.decode(_
                                                                          .searchBarController
                                                                          .searchjob[index]
                                                                      [
                                                                      'transcription']))
                                                                  : _.searchBarController.content(_
                                                                          .searchBarController
                                                                          .searchjob[index]
                                                                      ['transcription']),
                                                              topic: _
                                                                  .searchBarController
                                                                  .getTopicString(_
                                                                          .searchBarController
                                                                          .searchjob[index]
                                                                      [
                                                                      'segments']),
                                                              source: _
                                                                      .searchBarController
                                                                      .searchjob[
                                                                  index]['platform'],
                                                              date: _
                                                                  .searchBarController
                                                                  .convertDateUtc(_
                                                                      .searchBarController
                                                                      .searchjob[
                                                                          index]
                                                                          [
                                                                          'programDate']
                                                                      .toString()),
                                                              time: _
                                                                  .searchBarController
                                                                  .convertTimeIntoUtc(_
                                                                          .searchBarController
                                                                          .searchjob[index]
                                                                      [
                                                                      'broadcastDate']),
                                                              isUrdu: _.searchBarController
                                                                              .searchjob[index]
                                                                          [
                                                                          'language'] ==
                                                                      "ENGLISH"
                                                                  ? false
                                                                  : true,
                                                              isShare: true,
                                                              onTap: () {
                                                                if (_
                                                                        .searchBarController
                                                                        .searchjob[
                                                                            index]
                                                                            [
                                                                            'transcription']
                                                                        .runtimeType
                                                                        .toString() ==
                                                                    'String') {
                                                                  _.searchBarController
                                                                      .transcription = _.searchBarController.content(json.decode(_
                                                                          .searchBarController
                                                                          .searchjob[index]
                                                                      [
                                                                      'transcription']));
                                                                } else {
                                                                  _.searchBarController
                                                                      .transcription = _.searchBarController.content(_
                                                                          .searchBarController
                                                                          .searchjob[index]
                                                                      [
                                                                      'transcription']);
                                                                }
                                                                _.searchBarController
                                                                    .source = _
                                                                        .searchBarController
                                                                        .searchjob[
                                                                    index]["source"];
                                                                _.searchBarController
                                                                    .channelName = _
                                                                        .searchBarController
                                                                        .searchjob[index]
                                                                    ["channel"];
                                                                _showMyDialog(
                                                                  context,
                                                                  _.searchBarController,
                                                                  _.searchBarController
                                                                          .searchjob[
                                                                      index]['id'],
                                                                  "${_.searchBarController.baseUrlService.baseUrl}/uploads/${_.searchBarController.searchjob[index]['thumbnailPath']}",
                                                                );
                                                              },
                                                            )
                                                          : _.searchBarController
                                                                              .searchjob[
                                                                          index]
                                                                      [
                                                                      'source'] ==
                                                                  'Ticker'
                                                              ? TickerContainer(
                                                                  onContainerTap:
                                                                      () {
                                                                    TickerDialog.showDialog(
                                                                        channelPath:
                                                                            '${_.searchBarController.baseUrlService.baseUrl}/uploads/${_.searchBarController.searchjob[index]['channelLogoPath']}',
                                                                        thumbnailPath:
                                                                            '${_.searchBarController.baseUrlService.baseUrl}/uploads/${_.searchBarController.searchjob[index]['thumbnailPath']}',
                                                                        programDate: _.searchBarController.convertDateUtc(_
                                                                            .searchBarController
                                                                            .searchjob[index][
                                                                                'programDate']
                                                                            .toString()),
                                                                        programTime:
                                                                            '${_.searchBarController.convertTimeIntoUtc(_.searchBarController.searchjob[index]['broadcastDate'])}',
                                                                        isSearch:
                                                                            true);
                                                                  },
                                                                  thumbnail:
                                                                      "${_.searchBarController.baseUrlService.baseUrl}/uploads/${_.searchBarController.searchjob[index]['channelLogoPath']}",
                                                                  username:
                                                                      "${_.searchBarController.searchjob[index]['channel']}",
                                                                  content: _.searchBarController.searchjob[index]['transcription'].runtimeType
                                                                              .toString() ==
                                                                          'String'
                                                                      ? _.searchBarController.content(json.decode(_
                                                                              .searchBarController
                                                                              .searchjob[index]
                                                                          [
                                                                          'transcription']))
                                                                      : _.searchBarController.content(_
                                                                          .searchBarController
                                                                          .searchjob[index]['transcription']),
                                                                  topic: _
                                                                      .searchBarController
                                                                      .getTopicString(_
                                                                          .searchBarController
                                                                          .searchjob[index]['segments']),
                                                                  source: _.searchBarController
                                                                              .searchjob[
                                                                          index]
                                                                      [
                                                                      'platform'],
                                                                  date: _.searchBarController.convertDateUtc(_
                                                                      .searchBarController
                                                                      .searchjob[
                                                                          index]
                                                                          [
                                                                          'programDate']
                                                                      .toString()),
                                                                  time: _
                                                                      .searchBarController
                                                                      .convertTimeIntoUtc(_
                                                                          .searchBarController
                                                                          .searchjob[index]['broadcastDate']),
                                                                  isUrdu: _.searchBarController.searchjob[index]
                                                                              [
                                                                              'language'] ==
                                                                          "ENGLISH"
                                                                      ? false
                                                                      : true,
                                                                  isShare: true,
                                                                  onTap: () {
                                                                    if (_
                                                                            .searchBarController
                                                                            .searchjob[index]['transcription']
                                                                            .runtimeType
                                                                            .toString() ==
                                                                        'String') {
                                                                      _.searchBarController
                                                                          .transcription = _.searchBarController.content(json.decode(_
                                                                              .searchBarController
                                                                              .searchjob[index]
                                                                          [
                                                                          'transcription']));
                                                                    } else {
                                                                      _.searchBarController
                                                                          .transcription = _.searchBarController.content(_
                                                                              .searchBarController
                                                                              .searchjob[index]
                                                                          [
                                                                          'transcription']);
                                                                    }
                                                                    _.searchBarController
                                                                        .source = _
                                                                            .searchBarController
                                                                            .searchjob[index]
                                                                        [
                                                                        "source"];
                                                                    _.searchBarController
                                                                        .channelName = _
                                                                            .searchBarController
                                                                            .searchjob[index]
                                                                        [
                                                                        "channel"];
                                                                    _showMyDialog(
                                                                      context,
                                                                      _.searchBarController,
                                                                      _.searchBarController
                                                                              .searchjob[index]
                                                                          [
                                                                          "id"],
                                                                      "${_.searchBarController.baseUrlService.baseUrl}/uploads/${_.searchBarController.searchjob[index]['thumbnailPath']}",
                                                                    );
                                                                  },
                                                                )
                                                              : Obx(() {
                                                                  return CommonContainer(
                                                                    onPressed:
                                                                        () {
                                                                      _
                                                                          .searchBarController
                                                                          .isMore
                                                                          .value = false;
                                                                      if (_
                                                                          .searchBarController
                                                                          .searchjob
                                                                          .isEmpty) {
                                                                        if (_.searchBarController.escalationsJob(_.searchBarController.job[index]['escalations']).toString() ==
                                                                            'false') {
                                                                          _.searchBarController.jobStatus(
                                                                              _.searchBarController.job[index]['id'],
                                                                              _.searchBarController.searchjob.isEmpty
                                                                                  ? _.searchBarController.storage.hasData("Url")
                                                                                      ? "${_.searchBarController.storage.read("Url").toString()}/uploads/${_.searchBarController.job[index]['thumbnailPath']}"
                                                                                      : "${_.searchBarController.baseUrlService.baseUrl}/uploads/${_.searchBarController.job[index]['thumbnailPath']}"
                                                                                  : _.searchBarController.storage.hasData("Url")
                                                                                      ? "${_.searchBarController.storage.read("Url").toString()}/uploads/${_.searchBarController.searchjob[index]['thumbnailPath']}"
                                                                                      : "${_.searchBarController.baseUrlService.baseUrl}/uploads/${_.searchBarController.searchjob[index]['thumbnailPath']}");
                                                                        } else {
                                                                          Get.delete<
                                                                              VideoController>();
                                                                          Get.to(
                                                                            () =>
                                                                                const PlayerScreen(),
                                                                            arguments: {
                                                                              "receiverName": "",
                                                                              "searchValue": _.searchBarController.searchdata.value.text,
                                                                              "id": _.searchBarController.searchjob.isEmpty ? _.searchBarController.job[index]['id'] : _.searchBarController.searchjob[index]['id'],
                                                                              "image": _.searchBarController.searchjob.isEmpty
                                                                                  ? _.searchBarController.storage.hasData("Url")
                                                                                      ? "${_.searchBarController.storage.read("Url").toString()}/uploads/${_.searchBarController.job[index]['thumbnailPath']}"
                                                                                      : "${_.searchBarController.baseUrlService.baseUrl}/uploads/${_.searchBarController.job[index]['thumbnailPath']}"
                                                                                  : _.searchBarController.storage.hasData("Url")
                                                                                      ? "${_.searchBarController.storage.read("Url").toString()}/uploads/${_.searchBarController.searchjob[index]['thumbnailPath']}"
                                                                                      : "${_.searchBarController.baseUrlService.baseUrl}/uploads/${_.searchBarController.searchjob[index]['thumbnailPath']}",
                                                                            },
                                                                          );
                                                                        }
                                                                      } else {
                                                                        if (_.searchBarController.escalationsJob(_.searchBarController.searchjob[index]['escalations']).toString() ==
                                                                            'false') {
                                                                          _.searchBarController.jobStatus(
                                                                              _.searchBarController.searchjob[index]['id'],
                                                                              _.searchBarController.searchjob.isEmpty
                                                                                  ? _.searchBarController.storage.hasData("Url")
                                                                                      ? "${_.searchBarController.storage.read("Url").toString()}/uploads/${_.searchBarController.job[index]['thumbnailPath']}"
                                                                                      : "${_.searchBarController.baseUrlService.baseUrl}/uploads/${_.searchBarController.job[index]['thumbnailPath']}"
                                                                                  : _.searchBarController.storage.hasData("Url")
                                                                                      ? "${_.searchBarController.storage.read("Url").toString()}/uploads/${_.searchBarController.searchjob[index]['thumbnailPath']}"
                                                                                      : "${_.searchBarController.baseUrlService.baseUrl}/uploads/${_.searchBarController.searchjob[index]['thumbnailPath']}");
                                                                        } else {
                                                                          Get.delete<
                                                                              VideoController>();
                                                                          Get.to(
                                                                            () =>
                                                                                const PlayerScreen(),
                                                                            arguments: {
                                                                              "receiverName": "",
                                                                              "searchValue": _.searchBarController.searchdata.value.text,
                                                                              "id": _.searchBarController.searchjob.isEmpty ? _.searchBarController.job[index]['id'] : _.searchBarController.searchjob[index]['id'],
                                                                              "image": _.searchBarController.searchjob.isEmpty
                                                                                  ? _.searchBarController.storage.hasData("Url")
                                                                                      ? "${_.searchBarController.storage.read("Url").toString()}/uploads/${_.searchBarController.job[index]['thumbnailPath']}"
                                                                                      : "${_.searchBarController.baseUrlService.baseUrl}/uploads/${_.searchBarController.job[index]['thumbnailPath']}"
                                                                                  : _.searchBarController.storage.hasData("Url")
                                                                                      ? "${_.searchBarController.storage.read("Url").toString()}/uploads/${_.searchBarController.searchjob[index]['thumbnailPath']}"
                                                                                      : "${_.searchBarController.baseUrlService.baseUrl}/uploads/${_.searchBarController.searchjob[index]['thumbnailPath']}",
                                                                            },
                                                                          );
                                                                        }
                                                                      }
                                                                    },
                                                                    publisher: _.searchBarController.searchjob[index]['platform'].toLowerCase() == 'website' ||
                                                                            _.searchBarController.searchjob[index]['platform'].toLowerCase() ==
                                                                                'blog' ||
                                                                            _.searchBarController.searchjob[index]['platform'].toLowerCase() ==
                                                                                'print'
                                                                        ? ""
                                                                        : _.searchBarController.searchjob[index]
                                                                            [
                                                                            'publisher'],
                                                                    isRead: _
                                                                            .searchBarController
                                                                            .searchjob
                                                                            .isEmpty
                                                                        ? _.searchBarController.escalationsJob(_.searchBarController.job[index]['escalations']).toString() ==
                                                                                'false'
                                                                            ? false
                                                                            : true
                                                                        : _.searchBarController.escalationsJob(_.searchBarController.searchjob[index]['escalations']).toString() ==
                                                                                'false'
                                                                            ? false
                                                                            : true,
                                                                    imgUrl: _
                                                                            .searchBarController
                                                                            .searchjob
                                                                            .isEmpty
                                                                        ? _.searchBarController.storage.hasData("Url")
                                                                            ? "${_.searchBarController.storage.read("Url").toString()}/uploads/${_.searchBarController.job[index]['thumbnailPath']}"
                                                                            : "${_.searchBarController.baseUrlService.baseUrl}/uploads/${_.searchBarController.job[index]['thumbnailPath']}"
                                                                        : _.searchBarController.storage.hasData("Url")
                                                                            ? "${_.searchBarController.storage.read("Url").toString()}/uploads/${_.searchBarController.searchjob[index]['thumbnailPath']}"
                                                                            : "${_.searchBarController.baseUrlService.baseUrl}/uploads/${_.searchBarController.searchjob[index]['thumbnailPath']}",
                                                                    title: _
                                                                            .searchBarController
                                                                            .searchjob
                                                                            .isEmpty
                                                                        ? _.searchBarController.job[index]
                                                                            [
                                                                            'programName']
                                                                        : _.searchBarController.searchjob[index]
                                                                            [
                                                                            'programName'],
                                                                    des: _
                                                                            .searchBarController
                                                                            .searchjob
                                                                            .isEmpty
                                                                        ? _.searchBarController.job[index]
                                                                            [
                                                                            'programName']
                                                                        : _.searchBarController.searchjob[index]
                                                                            [
                                                                            'programName'],
                                                                    anchor: _
                                                                            .searchBarController
                                                                            .searchjob
                                                                            .isEmpty
                                                                        ? _.searchBarController.job[index]
                                                                            [
                                                                            'anchor']
                                                                        : _.searchBarController.searchjob[index]
                                                                            [
                                                                            'anchor'],
                                                                    segments: _
                                                                            .searchBarController
                                                                            .searchjob
                                                                            .isEmpty
                                                                        ? _.searchBarController.getTopicString(_.searchBarController.job[index]
                                                                            [
                                                                            'segments'])
                                                                        : _.searchBarController.getTopicString(_
                                                                            .searchBarController
                                                                            .searchjob[index]['segments']),
                                                                    guests: _
                                                                            .searchBarController
                                                                            .searchjob
                                                                            .isEmpty
                                                                        ? _.searchBarController.getGuestsString(_.searchBarController.job[index]
                                                                            [
                                                                            'guests'])
                                                                        : _.searchBarController.getGuestsString(_
                                                                            .searchBarController
                                                                            .searchjob[index]['guests']),
                                                                    source: _
                                                                            .searchBarController
                                                                            .searchjob
                                                                            .isEmpty
                                                                        ? _.searchBarController.job[index]
                                                                            [
                                                                            'platform']
                                                                        : _.searchBarController.searchjob[index]
                                                                            [
                                                                            'platform'],
                                                                    channelName: _
                                                                            .searchBarController
                                                                            .searchjob
                                                                            .isEmpty
                                                                        ? _.searchBarController.job[index]
                                                                            [
                                                                            'channel']
                                                                        : _.searchBarController.searchjob[index]
                                                                            [
                                                                            'channel'],
                                                                    channelLogo:
                                                                        "${_.searchBarController.baseUrlService.baseUrl}/uploads/${_.searchBarController.searchjob[index]['channelLogoPath']}",
                                                                    date: _
                                                                            .searchBarController
                                                                            .searchjob
                                                                            .isEmpty
                                                                        ? _.searchBarController.convertDateUtc(_.searchBarController.job[index]
                                                                            [
                                                                            'programDate'])
                                                                        : _.searchBarController.convertDateUtc(_
                                                                            .searchBarController
                                                                            .searchjob[index]['programDate']),
                                                                    time: _
                                                                            .searchBarController
                                                                            .searchjob
                                                                            .isEmpty
                                                                        ? _.searchBarController.job[index]['source'].toString().toLowerCase() ==
                                                                                'tv'
                                                                            ? _.searchBarController.convertTimeIntoUtc(_.searchBarController.job[index][
                                                                                'broadcastDate'])
                                                                            : _.searchBarController.convertTimeIntoUtc(_.searchBarController.job[index][
                                                                                'broadcastDate'])
                                                                        : _.searchBarController.searchjob[index]['source'].toString().toLowerCase() ==
                                                                                'tv'
                                                                            ? _.searchBarController.convertTimeIntoUtc(_.searchBarController.searchjob[index]['broadcastDate'])
                                                                            : _.searchBarController.convertTimeIntoUtc(_.searchBarController.searchjob[index]['broadcastDate']),
                                                                    isProgress:
                                                                        true,
                                                                    // progressValue: _
                                                                    //     .generateRandomNumber(
                                                                    //     index),
                                                                  );
                                                                }),
                                                      _.searchBarController
                                                              .isMore.value
                                                          ? Center(
                                                              child:
                                                                  Image.asset(
                                                                "assets/images/gif.gif",
                                                                height: 120.0,
                                                                width: 120.0,
                                                              ),
                                                            )
                                                          : const SizedBox()
                                                    ],
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                            ),
                          ),
              ),
            ),
          );
        });
      },
    );
  }
  //-------------Sharing Dialouge box-------------

  Future<void> _showMyDialog(context, SearchBarController _,
      String sharingJobId, String thumbnailPath) async {
    if (kDebugMode) {
      print("ticker and twitter job id-------------$sharingJobId");
    }
    return showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Obx(() {
          return AlertDialog(
            backgroundColor: const Color(0xff131C3A),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            title: const Text(
              'Share?',
              textScaleFactor: 1.0,
              style: TextStyle(
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
                  const Text(
                    'Are you sure you want to share with in app or other?',
                    textScaleFactor: 1.0,
                    style: TextStyle(
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
                          UserBottomSheet.showBottomSheet(onPressed: () async {
                            ShareDialogbox.showDialogbox(
                              title: 'Are you sure?',
                              subtitle:
                                  'You’ll share the clip with the people you selected',
                              onPressed: () async {
                                Get.back();
                                await _.sharing(sharingJobId);
                              },
                            );
                          });
                        },
                        minWidth: Get.width / 3.2,
                        height: 38,
                        child: const Text(
                          "Lytics App",
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
                      _.downloadLoader.value == false
                          ? MaterialButton(
                              color: NewCommonColours.greenButton,
                              shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    color: NewCommonColours.greenButton,
                                  ),
                                  borderRadius: BorderRadius.circular(9.0)),
                              onPressed: () async {
                                await _.downloadImage(thumbnailPath);
                                // _.launchInBrowser(_.url);
                                Get.back();
                                onShare(context, _);
                              },
                              minWidth: Get.width / 3.7,
                              height: 38,
                              child: const Text(
                                "Other",
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    color: NewCommonColours.whiteColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700),
                              ),
                            )
                          : SizedBox(
                              width: Get.width / 3.7,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: NewCommonColours.shareBtnColor,
                                ),
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  onShare(BuildContext context, SearchBarController _) async {
    List<String> thumbnailPath = [];
    thumbnailPath.insert(0, _.localPath);

    List<String> myList = [];
    myList.insert(0, _.source);
    myList.insert(1, _.channelName);
    myList.insert(2, _.transcription);

    String myString = myList.toString();
    myString = myString.substring(1, myString.length - 1);

    await Share.shareFiles(thumbnailPath, text: myString);
  }
}
