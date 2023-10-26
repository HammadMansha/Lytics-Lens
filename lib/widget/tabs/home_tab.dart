import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:lytics_lens/Constants/app_strrings.dart';
import 'package:lytics_lens/Constants/common_color.dart';
import 'package:lytics_lens/Controllers/home_controller.dart';
import 'package:lytics_lens/Controllers/playerController.dart';
import 'package:lytics_lens/Views/player_Screen.dart';
import 'package:lytics_lens/widget/bottomsheet/user_bottomsheet.dart';
import 'package:lytics_lens/widget/common_containers/common_container.dart';
import 'package:lytics_lens/widget/common_containers/nodatafound_container.dart';
import 'package:lytics_lens/widget/common_containers/ticker_container.dart';
import 'package:lytics_lens/widget/common_containers/twitter_container.dart';
import 'package:lytics_lens/widget/dialog_box/share_dialogbox.dart';
import 'package:lytics_lens/widget/dialog_box/ticker_dialogbox.dart';
import 'package:share/share.dart';

import '../snackbar/common_snackbar.dart';

class HomeTabs extends StatelessWidget {
  const HomeTabs(
      {super.key,
      required this.selectedTab,
      required this.homeScreenController});

  final String selectedTab;
  final HomeScreenController homeScreenController;

  @override
  Widget build(BuildContext context) {
    switch (selectedTab) {
      case "All":
        return Obx(() {
          return Expanded(
            child: GestureDetector(
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
              child: RefreshIndicator(
                onRefresh: () => homeScreenController.getJobs(1),
                child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: homeScreenController.searchjob.isEmpty
                        ? homeScreenController.job.length
                        : homeScreenController.searchjob.length,
                    separatorBuilder: (c, e) {
                      return const SizedBox(
                        height: 5.0,
                      );
                    },
                    itemBuilder: (ctx, index) {
                      // if (kDebugMode) {
                      //   print("--------------More loading value ${homeScreenController.isMore.value}");
                      // }
                      if (homeScreenController.job.isNotEmpty) {
                        if (homeScreenController.job.length == index + 1) {
                          if (homeScreenController.totalPages == 1) {
                            homeScreenController.isMore.value = false;
                          } else {
                            homeScreenController.isMore.value = true;
                          }
                          homeScreenController.tpageno.value =
                              homeScreenController.tpageno.value + 1;
                          homeScreenController
                              .getJobs(homeScreenController.tpageno.value);
                        } else {
                          homeScreenController.isMore.value = false;
                        }
                        // ignore: preferhomeScreenControllerishomeScreenControllerempty
                      } else if (homeScreenController.searchjob.isNotEmpty) {
                        if (homeScreenController.searchjob.length ==
                            index + 1) {
                          if (homeScreenController.totalPages == 1) {
                            homeScreenController.isMore.value = false;
                          } else {
                            homeScreenController.isMore.value = true;
                          }
                          homeScreenController.tpageno.value =
                              homeScreenController.tpageno.value + 1;
                          homeScreenController
                              .getJobs(homeScreenController.tpageno.value);
                        } else {
                          homeScreenController.isMore.value = false;
                        }
                      }
                      return SwipeActionCell(
                        key: ObjectKey(homeScreenController.job[index]),
                        trailingActions: <SwipeAction>[
                          SwipeAction(
                            title: "Delete",
                            onTap: (CompletionHandler handler) async {
                              await homeScreenController.deleteEscalationJobs(
                                  homeScreenController.job[index]['id']);
                              if (homeScreenController.statusCode == 200) {
                                homeScreenController.job.removeAt(index);
                              } else {
                                CustomSnackBar.showSnackBar(
                                    title: AppStrings.somethingWentWrong,
                                    message: "",
                                    isWarning: true,
                                    backgroundColor:
                                        CommonColor.snackbarColour);
                              }
                            },
                            color: Colors.red,
                          ),
                        ],
                        child: Column(
                          children: [
                            homeScreenController.job[index]['source'] ==
                                    'Social'
                                ? TwitterContainer(
                                    onContainerTap: () {
                                      Fluttertoast.showToast(
                                        msg: AppStrings.toastmessage,
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                      );
                                    },
                                    thumbnail:
                                        "${homeScreenController.baseUrlService.baseUrl}/uploads/${homeScreenController.job[index]['thumbnailPath']}",
                                    username:
                                        "${homeScreenController.job[index]['channel']}",
                                    content: homeScreenController
                                                .job[index]['transcription']
                                                .runtimeType
                                                .toString() ==
                                            'String'
                                        ? homeScreenController.content(
                                            json.decode(homeScreenController
                                                .job[index]['transcription']))
                                        : homeScreenController.content(
                                            homeScreenController.job[index]
                                                ['transcription']),
                                    topic: homeScreenController.getTopicString(
                                        homeScreenController.job[index]
                                            ['segments']),
                                    source: homeScreenController.job[index]
                                        ['platform'],
                                    date: homeScreenController.convertDateUtc(
                                        homeScreenController.job[index]
                                                ['programDate']
                                            .toString()),
                                    time:
                                        homeScreenController.convertTimeIntoUtc(
                                            homeScreenController.job[index]
                                                ['broadcastDate']),
                                    isUrdu: homeScreenController.job[index]
                                                ['language'] ==
                                            "ENGLISH"
                                        ? false
                                        : true,
                                    programUser: homeScreenController.job[index]
                                        ['programUser'],
                                    isShare: true,
                                    onTap: () {
                                      if (homeScreenController
                                              .job[index]['transcription']
                                              .runtimeType
                                              .toString() ==
                                          'String') {
                                        homeScreenController.transcription =
                                            homeScreenController.content(
                                                json.decode(homeScreenController
                                                        .job[index]
                                                    ['transcription']));
                                      } else {
                                        homeScreenController.transcription =
                                            homeScreenController.content(
                                                homeScreenController.job[index]
                                                    ['transcription']);
                                      }
                                      homeScreenController.source =
                                          homeScreenController.job[index]
                                              ["source"];
                                      homeScreenController.channelName =
                                          homeScreenController.job[index]
                                              ["channel"];
                                      _showMyDialog(
                                        context,
                                        homeScreenController,
                                        homeScreenController.job[index]["id"],
                                        "${homeScreenController.baseUrlService.baseUrl}/uploads/${homeScreenController.job[index]['thumbnailPath']}",
                                      );
                                    },
                                  )
                                : homeScreenController.job[index]['source'] ==
                                        'Ticker'
                                    ? TickerContainer(
                                        onContainerTap: () {
                                          TickerDialog.showDialog(
                                            channelPath:
                                                '${homeScreenController.baseUrlService.baseUrl}/uploads/${homeScreenController.job[index]['channelLogoPath']}',
                                            thumbnailPath:
                                                '${homeScreenController.baseUrlService.baseUrl}/uploads/${homeScreenController.job[index]['thumbnailPath']}',
                                            programDate: homeScreenController
                                                .convertDateUtc(
                                                    homeScreenController
                                                        .job[index]
                                                            ['programDate']
                                                        .toString()),
                                            programTime:
                                                '${homeScreenController.convertTimeIntoUtc(homeScreenController.job[index]['broadcastDate'])}',
                                          );
                                        },
                                        thumbnail:
                                            '${homeScreenController.baseUrlService.baseUrl}/uploads/${homeScreenController.job[index]['channelLogoPath']}',
                                        username:
                                            "${homeScreenController.job[index]['channel']}",
                                        content: homeScreenController
                                                    .job[index]['transcription']
                                                    .runtimeType
                                                    .toString() ==
                                                'String'
                                            ? homeScreenController.content(
                                                json.decode(homeScreenController
                                                        .job[index]
                                                    ['transcription']))
                                            : homeScreenController.content(
                                                homeScreenController.job[index]
                                                    ['transcription']),
                                        topic:
                                            homeScreenController.getTopicString(
                                                homeScreenController.job[index]
                                                    ['segments']),
                                        source: homeScreenController.job[index]
                                            ['platform'],
                                        date: homeScreenController
                                            .convertDateUtc(homeScreenController
                                                .job[index]['programDate']
                                                .toString()),
                                        time: homeScreenController
                                            .convertTimeIntoUtc(
                                                homeScreenController.job[index]
                                                    ['broadcastDate']),
                                        isUrdu: homeScreenController.job[index]
                                                    ['language'] ==
                                                "ENGLISH"
                                            ? false
                                            : true,
                                        isShare: true,
                                        onTap: () {
                                          if (homeScreenController
                                                  .job[index]['transcription']
                                                  .runtimeType
                                                  .toString() ==
                                              'String') {
                                            homeScreenController.transcription =
                                                homeScreenController.content(
                                                    json.decode(
                                                        homeScreenController
                                                                .job[index]
                                                            ['transcription']));
                                          } else {
                                            homeScreenController.transcription =
                                                homeScreenController.content(
                                                    homeScreenController
                                                            .job[index]
                                                        ['transcription']);
                                          }
                                          homeScreenController.source =
                                              homeScreenController.job[index]
                                                  ["source"];
                                          homeScreenController.channelName =
                                              homeScreenController.job[index]
                                                  ["channel"];
                                          _showMyDialog(
                                            context,
                                            homeScreenController,
                                            homeScreenController.job[index]
                                                ["id"],
                                            "${homeScreenController.baseUrlService.baseUrl}/uploads/${homeScreenController.job[index]['thumbnailPath']}",
                                          );
                                        },
                                      )
                                    : CommonContainer(
                                        onPressed: () {
                                          homeScreenController.isMore.value =   false;
                                          if (homeScreenController .searchjob.isEmpty) {
                                            if (homeScreenController .escalationsJob(homeScreenController.job[index]['escalations']) .toString() == 'false') {
                                              homeScreenController.jobStatus(homeScreenController.job[index]['id'],
                                              );
                                            } 
                                            else {
                                              
                                              Get.delete<VideoController>();
                                              if (kDebugMode) {
                                                print(
                                                    "----------job id on home screen---${homeScreenController.job[index]['id']}");
                                              }
                                              Get.to(
                                                () => const PlayerScreen(),
                                                arguments: {
                                                  "id": homeScreenController
                                                          .searchjob.isEmpty
                                                      ? homeScreenController
                                                          .job[index]['id']
                                                      : homeScreenController
                                                              .searchjob[index]
                                                          ['id'],
                                                  "receiverName": " "
                                                },
                                              );
                                            }
                                          } else {
                                            if (homeScreenController
                                                    .escalationsJob(
                                                        homeScreenController
                                                                    .searchjob[
                                                                index]
                                                            ['escalations'])
                                                    .toString() ==
                                                'false') {
                                              homeScreenController.jobStatus(
                                                homeScreenController
                                                    .searchjob[index]['id'],
                                              );
                                            } else {
                                              if (kDebugMode) {
                                                print(
                                                    "----------job id on home screen1---${homeScreenController.job[index]['id']}");
                                              }
                                              Get.delete<VideoController>();
                                              Get.to(
                                                () => const PlayerScreen(),
                                                arguments: {
                                                  "id": homeScreenController
                                                          .searchjob.isEmpty
                                                      ? homeScreenController
                                                          .job[index]['id']
                                                      : homeScreenController
                                                              .searchjob[index]
                                                          ['id'],
                                                  "receiverName": " "
                                                },
                                              );
                                            }
                                          }
                                        },
                                        id: homeScreenController.id,
                                        publisher: homeScreenController.searchjob.isEmpty
                                            ? homeScreenController.job[index]
                                                ['publisher']
                                            : homeScreenController.searchjob[index]
                                                ['publisher'],
                                        isClipped: false,
                                        isAudio: false,
                                        isRead: homeScreenController
                                                .searchjob.isEmpty
                                            ? homeScreenController.escalationsJob(homeScreenController.job[index]['escalations']).toString() ==
                                                    'false'
                                                ? false
                                                : true
                                            : homeScreenController.escalationsJob(homeScreenController.searchjob[index]['escalations']).toString() ==
                                                    'false'
                                                ? false
                                                : true,
                                        imgUrl:
                                            "${homeScreenController.baseUrlService.baseUrl}/uploads/${homeScreenController.job[index]['thumbnailPath']}",
                                        title: homeScreenController.job[index]
                                            ['programName'],
                                        des: homeScreenController.job[index]
                                            ['programName'],
                                        anchor: homeScreenController.searchjob.isEmpty
                                            ? homeScreenController.job[index]
                                                ['anchor']
                                            : homeScreenController.searchjob[index]
                                                ['anchor'],
                                        segments: homeScreenController.searchjob.isEmpty
                                            ? homeScreenController
                                                .getTopicString(homeScreenController.job[index]['segments'])
                                            : homeScreenController.getTopicString(homeScreenController.searchjob[index]['segments']),
                                        guests: homeScreenController.searchjob.isEmpty ? homeScreenController.getGuestsString(homeScreenController.job[index]['guests']) : homeScreenController.getGuestsString(homeScreenController.searchjob[index]['guests']),
                                        source: homeScreenController.searchjob.isEmpty ? homeScreenController.job[index]['platform'] : homeScreenController.searchjob[index]['platform'],
                                        channelName: homeScreenController.searchjob.isEmpty ? homeScreenController.job[index]['channel'] : homeScreenController.searchjob[index]['channel'],
                                        channelLogo: homeScreenController.searchjob.isEmpty
                                            ? homeScreenController.storage.hasData("Url")
                                                ? homeScreenController.job[index]['channelLogoPath'].toString().contains('http')
                                                    ? homeScreenController.job[index]['channelLogoPath']
                                                    : "${homeScreenController.storage.read("Url").toString()}/uploads//${homeScreenController.job[index]['channelLogoPath']}"
                                                : homeScreenController.job[index]['channelLogoPath'].toString().contains('http')
                                                    ? homeScreenController.job[index]['channelLogoPath']
                                                    : "${homeScreenController.baseUrlService.baseUrl}/uploads/${homeScreenController.job[index]['channelLogoPath']}"
                                            : homeScreenController.searchjob[index]['channelLogoPath'].toString().contains('http')
                                                ? homeScreenController.searchjob[index]['channelLogoPath']
                                                : "${homeScreenController.baseUrlService.baseUrl}/uploads/${homeScreenController.job[index]['channelLogoPath']}",
                                        date: homeScreenController.searchjob.isEmpty ? homeScreenController.convertDateUtc(homeScreenController.job[index]['programDate'].toString()) : homeScreenController.convertDateUtc(homeScreenController.searchjob[index]['programDate'].toString()),
                                        time: homeScreenController.searchjob.isEmpty
                                            ? homeScreenController.job[index]['source'].toString().toLowerCase() == 'tv'
                                                ? homeScreenController.convertTimeIntoUtc(homeScreenController.job[index]['broadcastDate'])
                                                : homeScreenController.convertTimeIntoUtc(homeScreenController.job[index]['broadcastDate'])
                                            : homeScreenController.searchjob[index]['source'].toString().toLowerCase() == 'tv'
                                                ? homeScreenController.convertTimeIntoUtc(homeScreenController.searchjob[index]['broadcastDate'])
                                                : homeScreenController.convertTimeIntoUtc(homeScreenController.searchjob[index]['broadcastDate'])),
                            homeScreenController.isMore.value
                                ? Container(
                                    color: NewCommonColours
                                        .paginationBackgroundColor,
                                    child: Center(
                                      child: Image.asset(
                                        "assets/images/gif.gif",
                                        height: 80.0,
                                        width: 120.0,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  )
                                : const SizedBox()
                          ],
                        ),
                      );
                    }),
              ),
            ),
          );
        });
      case "Tv":
        return homeScreenController.isLoadingsource.value
            ? Center(
                child: Image.asset(
                  "assets/images/gif.gif",
                  height: 300.0,
                  width: 300.0,
                ),
              ).marginOnly(bottom: 50.0, top: 100)
            : Obx(() {
                return Expanded(
                  child: GestureDetector(
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
                    child: RefreshIndicator(
                      onRefresh: () =>
                          homeScreenController.getJobBySource('["Tv"]', 1),
                      child: homeScreenController.sourcejob.isEmpty
                          ? NoDataFound(
                              onPressed: () {
                                homeScreenController.getJobBySource(
                                    '["Tv"]', 1);
                              },
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              itemCount: homeScreenController.sourcejob.length,
                              separatorBuilder: (c, e) {
                                return const SizedBox(
                                  height: 5.0,
                                );
                              },
                              itemBuilder: (ctx, index) {
                                if (homeScreenController.sourcejob.isNotEmpty) {
                                  if (homeScreenController.sourcejob.length ==
                                      index + 1) {
                                    if (homeScreenController.sourcetotalPages ==
                                        1) {
                                      homeScreenController.isSMore.value =
                                          false;
                                    } else {
                                      homeScreenController.isSMore.value = true;
                                    }
                                    homeScreenController.spageno.value =
                                        homeScreenController.spageno.value + 1;
                                    homeScreenController.getJobBySource(
                                        '["Tv"]',
                                        homeScreenController.spageno.value);
                                  } else {
                                    homeScreenController.isSMore.value = false;
                                  }
                                } else if (homeScreenController
                                    .searchjob.isNotEmpty) {
                                  if (homeScreenController.searchjob.length ==
                                      index + 1) {
                                    if (homeScreenController.sourcetotalPages ==
                                        1) {
                                      homeScreenController.isSMore.value =
                                          false;
                                    } else {
                                      homeScreenController.isSMore.value = true;
                                    }
                                    homeScreenController.spageno.value =
                                        homeScreenController.spageno.value + 1;
                                    homeScreenController.getJobBySource(
                                        '["Tv"]',
                                        homeScreenController.spageno.value);
                                  } else {
                                    homeScreenController.isSMore.value = false;
                                  }
                                }
                                return SwipeActionCell(
                                  key: ObjectKey(
                                      homeScreenController.sourcejob[index]),
                                  trailingActions: <SwipeAction>[
                                    SwipeAction(
                                      title: "Delete",
                                      onTap: (CompletionHandler handler) async {
                                        await homeScreenController
                                            .deleteEscalationJobs(
                                                homeScreenController
                                                    .sourcejob[index]['id']);
                                        if (homeScreenController.statusCode ==
                                            200) {
                                          homeScreenController.sourcejob
                                              .removeAt(index);
                                        } else {
                                          CustomSnackBar.showSnackBar(
                                              title:
                                                  AppStrings.somethingWentWrong,
                                              message: "",
                                              isWarning: true,
                                              backgroundColor:
                                                  CommonColor.snackbarColour);
                                        }
                                      },
                                      color: Colors.red,
                                    ),
                                  ],
                                  child: Column(
                                    children: [
                                      CommonContainer(
                                        onPressed: () {
                                          homeScreenController.isSMore.value =
                                              false;
                                          if (homeScreenController
                                              .searchjob.isEmpty) {
                                            if (homeScreenController
                                                    .escalationsJob(
                                                        homeScreenController
                                                                    .sourcejob[
                                                                index]
                                                            ['escalations'])
                                                    .toString() ==
                                                'false') {
                                              homeScreenController.jobStatus(
                                                homeScreenController
                                                    .sourcejob[index]['id'],
                                              );
                                            } else {
                                              Get.delete<VideoController>();
                                              if (kDebugMode) {
                                                print(
                                                    "----------job id on home screen---${homeScreenController.sourcejob[index]['id']}");
                                              }
                                              Get.to(
                                                () => const PlayerScreen(),
                                                arguments: {
                                                  "id": homeScreenController
                                                          .searchjob.isEmpty
                                                      ? homeScreenController
                                                              .sourcejob[index]
                                                          ['id']
                                                      : homeScreenController
                                                              .searchjob[index]
                                                          ['id'],
                                                  "receiverName": " "
                                                },
                                              );
                                            }
                                          } else {
                                            if (homeScreenController
                                                    .escalationsJob(
                                                        homeScreenController
                                                                    .searchjob[
                                                                index]
                                                            ['escalations'])
                                                    .toString() ==
                                                'false') {
                                              homeScreenController.jobStatus(
                                                homeScreenController
                                                    .searchjob[index]['id'],
                                              );
                                            } else {
                                              if (kDebugMode) {
                                                print(
                                                    "----------job id on home screen1---${homeScreenController.sourcejob[index]['id']}");
                                              }
                                              Get.delete<VideoController>();
                                              Get.to(
                                                () => const PlayerScreen(),
                                                arguments: {
                                                  "id": homeScreenController
                                                          .searchjob.isEmpty
                                                      ? homeScreenController
                                                              .sourcejob[index]
                                                          ['id']
                                                      : homeScreenController
                                                              .searchjob[index]
                                                          ['id'],
                                                  "receiverName": " "
                                                },
                                              );
                                            }
                                          }
                                        },
                                        id: homeScreenController.id,
                                        publisher: homeScreenController
                                                .searchjob.isEmpty
                                            ? homeScreenController
                                                .sourcejob[index]['publisher']
                                            : homeScreenController
                                                .searchjob[index]['publisher'],
                                        isClipped: false,
                                        isAudio: false,
                                        isRead: homeScreenController
                                                .searchjob.isEmpty
                                            ? homeScreenController
                                                        .escalationsJob(
                                                            homeScreenController
                                                                        .sourcejob[
                                                                    index]
                                                                ['escalations'])
                                                        .toString() ==
                                                    'false'
                                                ? false
                                                : true
                                            : homeScreenController
                                                        .escalationsJob(
                                                            homeScreenController
                                                                        .searchjob[
                                                                    index]
                                                                ['escalations'])
                                                        .toString() ==
                                                    'false'
                                                ? false
                                                : true,
                                        imgUrl: homeScreenController
                                                .searchjob.isEmpty
                                            ? "${homeScreenController.baseUrlService.baseUrl}/uploads/${homeScreenController.sourcejob[index]['thumbnailPath']}"
                                            : "${homeScreenController.baseUrlService.baseUrl}/uploads/${homeScreenController.sourcejob[index]['thumbnailPath']}",
                                        title: homeScreenController
                                            .sourcejob[index]['programName'],
                                        des: homeScreenController
                                            .sourcejob[index]['programName'],
                                        anchor: homeScreenController
                                                .searchjob.isEmpty
                                            ? homeScreenController
                                                .sourcejob[index]['anchor']
                                            : homeScreenController
                                                .searchjob[index]['anchor'],
                                        segments: homeScreenController
                                                .searchjob.isEmpty
                                            ? homeScreenController
                                                .getTopicString(
                                                    homeScreenController
                                                            .sourcejob[index][
                                                        'segments'])
                                            : homeScreenController
                                                .getTopicString(
                                                    homeScreenController
                                                            .searchjob[index]
                                                        ['segments']),
                                        guests: homeScreenController
                                                .searchjob.isEmpty
                                            ? homeScreenController
                                                .getGuestsString(
                                                    homeScreenController
                                                            .sourcejob[index]
                                                        ['guests'])
                                            : homeScreenController
                                                .getGuestsString(
                                                    homeScreenController
                                                            .searchjob[index]
                                                        ['guests']),
                                        source: homeScreenController
                                                .searchjob.isEmpty
                                            ? homeScreenController
                                                .sourcejob[index]['platform']
                                            : homeScreenController
                                                .searchjob[index]['platform'],
                                        channelName: homeScreenController
                                                .searchjob.isEmpty
                                            ? homeScreenController
                                                .sourcejob[index]['channel']
                                            : homeScreenController
                                                .searchjob[index]['channel'],
                                        channelLogo: homeScreenController
                                                .searchjob.isEmpty
                                            ? homeScreenController.storage
                                                    .hasData("Url")
                                                ? homeScreenController
                                                        .sourcejob[index]
                                                            ['channelLogoPath']
                                                        .toString()
                                                        .contains('http')
                                                    ? homeScreenController.sourcejob[index]
                                                        ['channelLogoPath']
                                                    : "${homeScreenController.storage.read("Url").toString()}/uploads//${homeScreenController.sourcejob[index]['channelLogoPath']}"
                                                : homeScreenController
                                                        .sourcejob[index]
                                                            ['channelLogoPath']
                                                        .toString()
                                                        .contains('http')
                                                    ? homeScreenController
                                                            .sourcejob[index]
                                                        ['channelLogoPath']
                                                    : "${homeScreenController.baseUrlService.baseUrl}/uploads/${homeScreenController.sourcejob[index]['channelLogoPath']}"
                                            : homeScreenController.searchjob[index]
                                                        ['channelLogoPath']
                                                    .toString()
                                                    .contains('http')
                                                ? homeScreenController.searchjob[index]
                                                    ['channelLogoPath']
                                                : "${homeScreenController.baseUrlService.baseUrl}/uploads/${homeScreenController.sourcejob[index]['channelLogoPath']}",
                                        date: homeScreenController
                                                .searchjob.isEmpty
                                            ? homeScreenController
                                                .convertDateUtc(
                                                    homeScreenController
                                                        .sourcejob[index][
                                                            'programDate']
                                                        .toString())
                                            : homeScreenController
                                                .convertDateUtc(
                                                    homeScreenController
                                                        .searchjob[index]
                                                            ['programDate']
                                                        .toString()),
                                        time: homeScreenController
                                                .searchjob.isEmpty
                                            ? homeScreenController
                                                .convertTimeIntoUtc(
                                                    homeScreenController
                                                            .sourcejob[index]
                                                        ['broadcastDate'])
                                            : homeScreenController
                                                .convertTimeIntoUtc(
                                                    homeScreenController
                                                            .searchjob[index]
                                                        ['broadcastDate']),
                                      ),
                                      homeScreenController.isSMore.value
                                          ? Container(
                                              color: NewCommonColours
                                                  .paginationBackgroundColor,
                                              child: Center(
                                                child: Image.asset(
                                                  "assets/images/gif.gif",
                                                  height: 80.0,
                                                  width: 120.0,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            )
                                          : const SizedBox()
                                    ],
                                  ),
                                );
                              }),
                    ),
                  ),
                );
              });

      case "Blog":
        return homeScreenController.isLoadingWeb.value
            ? Center(
                child: Image.asset(
                  "assets/images/gif.gif",
                  height: 300.0,
                  width: 300.0,
                ),
              ).marginOnly(bottom: 50.0, top: 100)
            : Obx(() {
                return Expanded(
                  child: RefreshIndicator(
                    onRefresh: () =>
                        homeScreenController.getWebJob('["Blog"]', 1),
                    child: homeScreenController.webjob.isEmpty
                        ? NoDataFound(
                            onPressed: () {
                              homeScreenController.getWebJob('["Blog"]', 1);
                            },
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            itemCount: homeScreenController.webjob.length,
                            separatorBuilder: (c, e) {
                              return const SizedBox(
                                height: 5.0,
                              );
                            },
                            itemBuilder: (ctx, index) {
                              if (homeScreenController.webjob.isNotEmpty) {
                                if (homeScreenController.webjob.length == index + 1)
                                {
                                  if (homeScreenController.webtotalPages == 1) {
                                    homeScreenController.isWebMore.value = false;
                                  }
                                  else {
                                    homeScreenController.isWebMore.value = true;
                                  }
                                  homeScreenController.webpageno.value = homeScreenController.webpageno.value + 1;
                                  homeScreenController.getWebJob('["Blog"]', homeScreenController.webpageno.value);
                                }
                                else {
                                  homeScreenController.isWebMore.value = false;
                                }
                              } else if (homeScreenController
                                  .webjob.isNotEmpty) {
                                if (homeScreenController.webjob.length ==
                                    index + 1) {
                                  // if(homeScreenController.webtotalPages==1){
                                  //   homeScreenController.isWebMore.value = false;
                                  //
                                  // }
                                  // else{
                                  //   homeScreenController.isWebMore.value = true;
                                  //
                                  // }
                                  homeScreenController.webpageno.value =
                                      homeScreenController.webpageno.value + 1;
                                  homeScreenController.getWebJob('["Blog"]',
                                      homeScreenController.webpageno.value);
                                } else {
                                  homeScreenController.isWebMore.value = false;
                                }
                              }
                              return SwipeActionCell(
                                key: ObjectKey(
                                    homeScreenController.webjob[index]),
                                trailingActions: <SwipeAction>[
                                  SwipeAction(
                                    title: "Delete",
                                    onTap: (CompletionHandler handler) async {
                                      await homeScreenController
                                          .deleteEscalationJobs(
                                              homeScreenController.webjob[index]
                                                  ['id']);
                                      if (homeScreenController.statusCode ==
                                          200) {
                                        homeScreenController.webjob
                                            .removeAt(index);
                                      } else {
                                        CustomSnackBar.showSnackBar(
                                            title:
                                                AppStrings.somethingWentWrong,
                                            message: "",
                                            isWarning: true,
                                            backgroundColor:
                                                CommonColor.snackbarColour);
                                      }
                                    },
                                    color: Colors.red,
                                  ),
                                ],
                                child: Column(
                                  children: [
                                    CommonContainer(
                                      onPressed: () {
                                        homeScreenController.isWebMore.value =
                                            false;
                                        if (homeScreenController
                                                .escalationsJob(
                                                    homeScreenController
                                                            .webjob[index]
                                                        ['escalations'])
                                                .toString() ==
                                            'false') {
                                          homeScreenController.jobStatus(
                                            homeScreenController.webjob[index]
                                                ['id'],
                                          );
                                        } else {
                                          Get.delete<VideoController>();
                                          if (kDebugMode) {
                                            print(
                                                "----------job id on home screen---${homeScreenController.webjob[index]['id']}");
                                          }
                                          Get.to(
                                            () => const PlayerScreen(),
                                            arguments: {
                                              "id": homeScreenController
                                                      .searchjob.isEmpty
                                                  ? homeScreenController
                                                      .webjob[index]['id']
                                                  : homeScreenController
                                                      .searchjob[index]['id'],
                                              "receiverName": " "
                                            },
                                          );
                                        }
                                      },
                                      id: homeScreenController.id,
                                      publisher: homeScreenController
                                          .webjob[index]['publisher'],
                                      isClipped: false,
                                      isAudio: false,
                                      isRead: homeScreenController
                                              .searchjob.isEmpty
                                          ? homeScreenController
                                                      .escalationsJob(
                                                          homeScreenController
                                                                  .webjob[index]
                                                              ['escalations'])
                                                      .toString() ==
                                                  'false'
                                              ? false
                                              : true
                                          : homeScreenController
                                                      .escalationsJob(
                                                          homeScreenController
                                                                  .webjob[index]
                                                              ['escalations'])
                                                      .toString() ==
                                                  'false'
                                              ? false
                                              : true,
                                      imgUrl: homeScreenController
                                              .webjob.isEmpty
                                          ? "${homeScreenController.baseUrlService.baseUrl}/uploads/${homeScreenController.webjob[index]['thumbnailPath']}"
                                          : "${homeScreenController.baseUrlService.baseUrl}/uploads/${homeScreenController.webjob[index]['thumbnailPath']}",
                                      title: homeScreenController.webjob[index]
                                          ['programName'],
                                      des: homeScreenController.webjob[index]
                                          ['programName'],
                                      anchor: homeScreenController
                                              .searchjob.isEmpty
                                          ? homeScreenController.webjob[index]
                                              ['anchor']
                                          : homeScreenController
                                              .searchjob[index]['anchor'],
                                      segments: homeScreenController
                                              .searchjob.isEmpty
                                          ? homeScreenController.getTopicString(
                                              homeScreenController.webjob[index]
                                                  ['segments'])
                                          : homeScreenController.getTopicString(
                                              homeScreenController
                                                      .searchjob[index]
                                                  ['segments']),
                                      guests: homeScreenController
                                              .searchjob.isEmpty
                                          ? homeScreenController
                                              .getGuestsString(
                                                  homeScreenController
                                                      .webjob[index]['guests'])
                                          : homeScreenController
                                              .getGuestsString(
                                                  homeScreenController
                                                          .searchjob[index]
                                                      ['guests']),
                                      source: homeScreenController
                                              .searchjob.isEmpty
                                          ? homeScreenController.webjob[index]
                                              ['platform']
                                          : homeScreenController
                                              .searchjob[index]['platform'],
                                      channelName: homeScreenController
                                              .searchjob.isEmpty
                                          ? homeScreenController.webjob[index]
                                              ['channel']
                                          : homeScreenController
                                              .searchjob[index]['channel'],
                                      channelLogo: homeScreenController
                                              .searchjob.isEmpty
                                          ? homeScreenController.storage
                                                  .hasData("Url")
                                              ? homeScreenController.webjob[index]
                                                          ['channelLogoPath']
                                                      .toString()
                                                      .contains('http')
                                                  ? homeScreenController
                                                          .webjob[index]
                                                      ['channelLogoPath']
                                                  : "${homeScreenController.storage.read("Url").toString()}/uploads//${homeScreenController.webjob[index]['channelLogoPath']}"
                                              : homeScreenController.webjob[index]
                                                          ['channelLogoPath']
                                                      .toString()
                                                      .contains('http')
                                                  ? homeScreenController
                                                          .webjob[index]
                                                      ['channelLogoPath']
                                                  : "${homeScreenController.baseUrlService.baseUrl}/uploads/${homeScreenController.webjob[index]['channelLogoPath']}"
                                          : homeScreenController.searchjob[index]
                                                      ['channelLogoPath']
                                                  .toString()
                                                  .contains('http')
                                              ? homeScreenController.searchjob[index]
                                                  ['channelLogoPath']
                                              : "${homeScreenController.baseUrlService.baseUrl}/uploads/${homeScreenController.webjob[index]['channelLogoPath']}",
                                      date: homeScreenController
                                              .searchjob.isEmpty
                                          ? homeScreenController.convertDateUtc(
                                              homeScreenController.webjob[index]
                                                      ['programDate']
                                                  .toString())
                                          : homeScreenController.convertDateUtc(
                                              homeScreenController
                                                  .searchjob[index]
                                                      ['programDate']
                                                  .toString()),
                                      time: homeScreenController
                                              .searchjob.isEmpty
                                          ? homeScreenController
                                              .convertTimeIntoUtc(
                                                  homeScreenController.webjob[
                                                      index]['broadcastDate'])
                                          : homeScreenController
                                              .convertTimeIntoUtc(
                                                  homeScreenController
                                                          .searchjob[index]
                                                      ['broadcastDate']),
                                    ),
                                    homeScreenController.isWebMore.value
                                        ? Container(
                                            color: NewCommonColours
                                                .paginationBackgroundColor,
                                            child: Center(
                                              child: Image.asset(
                                                "assets/images/gif.gif",
                                                height: 80.0,
                                                width: 120.0,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          )
                                        : const SizedBox()
                                  ],
                                ),
                              );
                            }),
                  ),
                );
              });

      case "Print":
        return homeScreenController.isLoadingPrint.value
            ? Center(
                child: Image.asset(
                  "assets/images/gif.gif",
                  height: 300.0,
                  width: 300.0,
                ),
              ).marginOnly(bottom: 50.0, top: 100)
            : Obx(() {
                return Expanded(
                  child: RefreshIndicator(
                    onRefresh: () =>
                        homeScreenController.getPrintJob('["Print"]', 1),
                    child: homeScreenController.printjob.isEmpty
                        ? NoDataFound(
                            onPressed: () {
                              homeScreenController.getPrintJob('["Print"]', 1);
                            },
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            itemCount: homeScreenController.printjob.length,
                            separatorBuilder: (c, e) {
                              return const SizedBox(
                                height: 5.0,
                              );
                            },
                            itemBuilder: (ctx, index) {
                              if (homeScreenController.printjob.isNotEmpty) {
                                if (homeScreenController.printjob.length ==
                                    index + 1) {
                                  if (homeScreenController.printtotalPages ==
                                      1) {
                                    homeScreenController.isPrintMore.value =
                                        false;
                                  } else {
                                    homeScreenController.isPrintMore.value =
                                        true;
                                  }

                                  homeScreenController.printpageno.value =
                                      homeScreenController.printpageno.value +
                                          1;
                                  homeScreenController.getPrintJob('["Print"]',
                                      homeScreenController.printpageno.value);
                                } else {
                                  homeScreenController.isPrintMore.value =
                                      false;
                                }
                              } else if (homeScreenController
                                  .printjob.isNotEmpty) {
                                if (homeScreenController.printjob.length ==
                                    index + 1) {
                                  if (homeScreenController.printtotalPages ==
                                      1) {
                                    homeScreenController.isPrintMore.value =
                                        false;
                                  } else {
                                    homeScreenController.isPrintMore.value =
                                        true;
                                  }
                                  homeScreenController.printpageno.value =
                                      homeScreenController.printpageno.value +
                                          1;
                                  homeScreenController.getPrintJob('["Print"]',
                                      homeScreenController.printpageno.value);
                                } else {
                                  homeScreenController.isPrintMore.value =
                                      false;
                                }
                              }
                              return SwipeActionCell(
                                key: ObjectKey(
                                    homeScreenController.printjob[index]),
                                trailingActions: <SwipeAction>[
                                  SwipeAction(
                                    title: "Delete",
                                    onTap: (CompletionHandler handler) async {
                                      await homeScreenController
                                          .deleteEscalationJobs(
                                              homeScreenController
                                                  .printjob[index]['id']);
                                      if (homeScreenController.statusCode ==
                                          200) {
                                        homeScreenController.printjob
                                            .removeAt(index);
                                      } else {
                                        CustomSnackBar.showSnackBar(
                                            title:
                                                AppStrings.somethingWentWrong,
                                            message: "",
                                            isWarning: true,
                                            backgroundColor:
                                                CommonColor.snackbarColour);
                                      }
                                    },
                                    color: Colors.red,
                                  ),
                                ],
                                child: Column(
                                  children: [
                                    CommonContainer(
                                      onPressed: () {
                                        homeScreenController.isPrintMore.value =
                                            false;
                                        if (homeScreenController
                                                .escalationsJob(
                                                    homeScreenController
                                                            .printjob[index]
                                                        ['escalations'])
                                                .toString() ==
                                            'false') {
                                          homeScreenController.jobStatus(
                                            homeScreenController.printjob[index]
                                                ['id'],
                                          );
                                        } else {
                                          Get.delete<VideoController>();
                                          Get.to(
                                            () => const PlayerScreen(),
                                            arguments: {
                                              "id": homeScreenController
                                                      .searchjob.isEmpty
                                                  ? homeScreenController
                                                      .printjob[index]['id']
                                                  : homeScreenController
                                                      .searchjob[index]['id'],
                                              "receiverName": ""
                                            },
                                          );
                                        }
                                      },
                                      id: homeScreenController.id,
                                      publisher: homeScreenController
                                          .printjob[index]['publisher'],
                                      isClipped: false,
                                      isAudio: false,
                                      isRead: homeScreenController
                                              .searchjob.isEmpty
                                          ? homeScreenController
                                                      .escalationsJob(
                                                          homeScreenController
                                                                      .printjob[
                                                                  index]
                                                              ['escalations'])
                                                      .toString() ==
                                                  'false'
                                              ? false
                                              : true
                                          : homeScreenController
                                                      .escalationsJob(
                                                          homeScreenController
                                                                      .printjob[
                                                                  index]
                                                              ['escalations'])
                                                      .toString() ==
                                                  'false'
                                              ? false
                                              : true,
                                      imgUrl: homeScreenController
                                              .printjob.isEmpty
                                          ? "${homeScreenController.baseUrlService.baseUrl}/uploads/${homeScreenController.printjob[index]['thumbnailPath']}"
                                          : "${homeScreenController.baseUrlService.baseUrl}/uploads/${homeScreenController.printjob[index]['thumbnailPath']}",
                                      title: homeScreenController
                                          .printjob[index]['programName'],
                                      des: homeScreenController.printjob[index]
                                          ['programName'],
                                      anchor: homeScreenController
                                              .searchjob.isEmpty
                                          ? homeScreenController.printjob[index]
                                              ['anchor']
                                          : homeScreenController
                                              .searchjob[index]['anchor'],
                                      segments: homeScreenController
                                              .searchjob.isEmpty
                                          ? homeScreenController.getTopicString(
                                              homeScreenController
                                                  .printjob[index]['segments'])
                                          : homeScreenController.getTopicString(
                                              homeScreenController
                                                      .searchjob[index]
                                                  ['segments']),
                                      guests: homeScreenController
                                              .searchjob.isEmpty
                                          ? homeScreenController
                                              .getGuestsString(
                                                  homeScreenController
                                                          .printjob[index]
                                                      ['guests'])
                                          : homeScreenController
                                              .getGuestsString(
                                                  homeScreenController
                                                          .searchjob[index]
                                                      ['guests']),
                                      source: homeScreenController
                                              .searchjob.isEmpty
                                          ? homeScreenController.printjob[index]
                                              ['platform']
                                          : homeScreenController
                                              .searchjob[index]['platform'],
                                      channelName: homeScreenController
                                              .searchjob.isEmpty
                                          ? homeScreenController.printjob[index]
                                              ['channel']
                                          : homeScreenController
                                              .searchjob[index]['channel'],
                                      channelLogo: homeScreenController
                                              .searchjob.isEmpty
                                          ? homeScreenController.storage
                                                  .hasData("Url")
                                              ? homeScreenController.printjob[index]
                                                          ['channelLogoPath']
                                                      .toString()
                                                      .contains('http')
                                                  ? homeScreenController.printjob[index]
                                                      ['channelLogoPath']
                                                  : "${homeScreenController.storage.read("Url").toString()}/uploads//${homeScreenController.printjob[index]['channelLogoPath']}"
                                              : homeScreenController
                                                      .printjob[index]
                                                          ['channelLogoPath']
                                                      .toString()
                                                      .contains('http')
                                                  ? homeScreenController
                                                          .printjob[index]
                                                      ['channelLogoPath']
                                                  : "${homeScreenController.baseUrlService.baseUrl}/uploads/${homeScreenController.printjob[index]['channelLogoPath']}"
                                          : homeScreenController.searchjob[index]
                                                      ['channelLogoPath']
                                                  .toString()
                                                  .contains('http')
                                              ? homeScreenController.searchjob[index]
                                                  ['channelLogoPath']
                                              : "${homeScreenController.baseUrlService.baseUrl}/uploads/${homeScreenController.printjob[index]['channelLogoPath']}",
                                      date: homeScreenController
                                              .searchjob.isEmpty
                                          ? homeScreenController.convertDateUtc(
                                              homeScreenController
                                                  .printjob[index]
                                                      ['programDate']
                                                  .toString())
                                          : homeScreenController.convertDateUtc(
                                              homeScreenController
                                                  .searchjob[index]
                                                      ['programDate']
                                                  .toString()),
                                      time: homeScreenController
                                              .searchjob.isEmpty
                                          ? homeScreenController
                                              .convertTimeIntoUtc(
                                                  homeScreenController.printjob[
                                                      index]['broadcastDate'])
                                          : homeScreenController
                                              .convertTimeIntoUtc(
                                                  homeScreenController
                                                          .searchjob[index]
                                                      ['broadcastDate']),
                                    ),
                                    homeScreenController.isPrintMore.value
                                        ? Container(
                                            color: NewCommonColours
                                                .paginationBackgroundColor,
                                            child: Center(
                                              child: Image.asset(
                                                "assets/images/gif.gif",
                                                height: 80.0,
                                                width: 120.0,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          )
                                        : const SizedBox()
                                  ],
                                ),
                              );
                            }),
                  ),
                );
              });
      case "Online":
        return homeScreenController.isLoadingOnline.value
            ? Center(
                child: Image.asset(
                  "assets/images/gif.gif",
                  height: 300.0,
                  width: 300.0,
                ),
              ).marginOnly(bottom: 50.0, top: 100)
            : Obx(() {
                return Expanded(
                  child: RefreshIndicator(
                    onRefresh: () =>
                        homeScreenController.getOnlineJob('["Online"]', 1),
                    child: homeScreenController.onlinejob.isEmpty
                        ? NoDataFound(
                            onPressed: () {
                              homeScreenController.getOnlineJob(
                                  '["Online"]', 1);
                            },
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            itemCount: homeScreenController.onlinejob.length,
                            separatorBuilder: (c, e) {
                              return const SizedBox(
                                height: 5.0,
                              );
                            },
                            itemBuilder: (ctx, index) {
                              if (homeScreenController.onlinejob.isNotEmpty) {
                                if (homeScreenController.onlinejob.length ==
                                    index + 1) {
                                  if (homeScreenController.onlinetotalPages ==
                                      1) {
                                    homeScreenController.isOnlineMore.value =
                                        false;
                                  } else {
                                    homeScreenController.isOnlineMore.value =
                                        true;
                                  }

                                  homeScreenController.onlinepageno.value =
                                      homeScreenController.onlinepageno.value +
                                          1;
                                  homeScreenController.getOnlineJob(
                                      '["Online"]',
                                      homeScreenController.onlinepageno.value);
                                } else {
                                  homeScreenController.isOnlineMore.value =
                                      false;
                                }
                              } else if (homeScreenController
                                  .onlinejob.isNotEmpty) {
                                if (homeScreenController.onlinejob.length ==
                                    index + 1) {
                                  if (homeScreenController.onlinetotalPages ==
                                      1) {
                                    homeScreenController.isOnlineMore.value =
                                        false;
                                  } else {
                                    homeScreenController.isOnlineMore.value =
                                        true;
                                  }

                                  homeScreenController.onlinepageno.value =
                                      homeScreenController.onlinepageno.value +
                                          1;
                                  homeScreenController.getOnlineJob(
                                      '["Online"]',
                                      homeScreenController.onlinepageno.value);
                                } else {
                                  homeScreenController.isOnlineMore.value =
                                      false;
                                }
                              }
                              return SwipeActionCell(
                                key: ObjectKey(
                                    homeScreenController.onlinejob[index]),
                                trailingActions: <SwipeAction>[
                                  SwipeAction(
                                    title: "Delete",
                                    onTap: (CompletionHandler handler) async {
                                      await homeScreenController
                                          .deleteEscalationJobs(
                                              homeScreenController
                                                  .onlinejob[index]['id']);
                                      if (homeScreenController.statusCode ==
                                          200) {
                                        homeScreenController.onlinejob
                                            .removeAt(index);
                                      } else {
                                        CustomSnackBar.showSnackBar(
                                            title:
                                                AppStrings.somethingWentWrong,
                                            message: "",
                                            isWarning: true,
                                            backgroundColor:
                                                CommonColor.snackbarColour);
                                      }
                                    },
                                    color: Colors.red,
                                  ),
                                ],
                                child: Column(
                                  children: [
                                    CommonContainer(
                                      onPressed: () {
                                        homeScreenController
                                            .isOnlineMore.value = false;
                                        if (homeScreenController
                                                .escalationsJob(
                                                    homeScreenController
                                                            .onlinejob[index]
                                                        ['escalations'])
                                                .toString() ==
                                            'false') {
                                          homeScreenController.jobStatus(
                                            homeScreenController
                                                .onlinejob[index]['id'],
                                          );
                                        } else {
                                          Get.delete<VideoController>();
                                          Get.to(
                                            () => const PlayerScreen(),
                                            arguments: {
                                              "id": homeScreenController
                                                      .searchjob.isEmpty
                                                  ? homeScreenController
                                                      .onlinejob[index]['id']
                                                  : homeScreenController
                                                      .searchjob[index]['id'],
                                              "receiverName": " "
                                            },
                                          );
                                        }
                                      },
                                      id: homeScreenController.id,
                                      publisher: homeScreenController
                                          .onlinejob[index]['publisher'],
                                      isClipped: false,
                                      isAudio: false,
                                      isRead: homeScreenController
                                              .searchjob.isEmpty
                                          ? homeScreenController
                                                      .escalationsJob(
                                                          homeScreenController
                                                                      .onlinejob[
                                                                  index]
                                                              ['escalations'])
                                                      .toString() ==
                                                  'false'
                                              ? false
                                              : true
                                          : homeScreenController
                                                      .escalationsJob(
                                                          homeScreenController
                                                                      .onlinejob[
                                                                  index]
                                                              ['escalations'])
                                                      .toString() ==
                                                  'false'
                                              ? false
                                              : true,
                                      imgUrl: homeScreenController
                                              .onlinejob.isEmpty
                                          ? "${homeScreenController.baseUrlService.baseUrl}/uploads/${homeScreenController.onlinejob[index]['thumbnailPath']}"
                                          : "${homeScreenController.baseUrlService.baseUrl}/uploads/${homeScreenController.onlinejob[index]['thumbnailPath']}",
                                      title: homeScreenController
                                          .onlinejob[index]['programName'],
                                      des: homeScreenController.onlinejob[index]
                                          ['programName'],
                                      anchor:
                                          homeScreenController.searchjob.isEmpty
                                              ? homeScreenController
                                                  .onlinejob[index]['anchor']
                                              : homeScreenController
                                                  .searchjob[index]['anchor'],
                                      segments: homeScreenController
                                              .searchjob.isEmpty
                                          ? homeScreenController.getTopicString(
                                              homeScreenController
                                                  .onlinejob[index]['segments'])
                                          : homeScreenController.getTopicString(
                                              homeScreenController
                                                      .searchjob[index]
                                                  ['segments']),
                                      guests:
                                          homeScreenController.searchjob.isEmpty
                                              ? homeScreenController
                                                  .getGuestsString(
                                                      homeScreenController
                                                              .onlinejob[index]
                                                          ['guests'])
                                              : homeScreenController
                                                  .getGuestsString(
                                                      homeScreenController
                                                              .searchjob[index]
                                                          ['guests']),
                                      source:
                                          homeScreenController.searchjob.isEmpty
                                              ? homeScreenController
                                                  .onlinejob[index]['platform']
                                              : homeScreenController
                                                  .searchjob[index]['platform'],
                                      channelName:
                                          homeScreenController.searchjob.isEmpty
                                              ? homeScreenController
                                                  .onlinejob[index]['channel']
                                              : homeScreenController
                                                  .searchjob[index]['channel'],
                                      channelLogo: homeScreenController
                                              .searchjob.isEmpty
                                          ? homeScreenController.storage
                                                  .hasData("Url")
                                              ? homeScreenController.onlinejob[index]
                                                          ['channelLogoPath']
                                                      .toString()
                                                      .contains('http')
                                                  ? homeScreenController.onlinejob[index]
                                                      ['channelLogoPath']
                                                  : "${homeScreenController.storage.read("Url").toString()}/uploads//${homeScreenController.onlinejob[index]['channelLogoPath']}"
                                              : homeScreenController
                                                      .onlinejob[index]
                                                          ['channelLogoPath']
                                                      .toString()
                                                      .contains('http')
                                                  ? homeScreenController
                                                          .onlinejob[index]
                                                      ['channelLogoPath']
                                                  : "${homeScreenController.baseUrlService.baseUrl}/uploads/${homeScreenController.onlinejob[index]['channelLogoPath']}"
                                          : homeScreenController.searchjob[index]
                                                      ['channelLogoPath']
                                                  .toString()
                                                  .contains('http')
                                              ? homeScreenController.searchjob[index]
                                                  ['channelLogoPath']
                                              : "${homeScreenController.baseUrlService.baseUrl}/uploads/${homeScreenController.onlinejob[index]['channelLogoPath']}",
                                      date: homeScreenController
                                              .searchjob.isEmpty
                                          ? homeScreenController.convertDateUtc(
                                              homeScreenController
                                                  .onlinejob[index]
                                                      ['programDate']
                                                  .toString())
                                          : homeScreenController.convertDateUtc(
                                              homeScreenController
                                                  .searchjob[index]
                                                      ['programDate']
                                                  .toString()),
                                      time:
                                          homeScreenController.searchjob.isEmpty
                                              ? homeScreenController
                                                  .convertTimeIntoUtc(
                                                      homeScreenController
                                                              .onlinejob[index]
                                                          ['broadcastDate'])
                                              : homeScreenController
                                                  .convertTimeIntoUtc(
                                                      homeScreenController
                                                              .searchjob[index]
                                                          ['broadcastDate']),
                                    ),
                                    homeScreenController.isOnlineMore.value
                                        ? Container(
                                            color: NewCommonColours
                                                .paginationBackgroundColor,
                                            child: Center(
                                              child: Image.asset(
                                                "assets/images/gif.gif",
                                                height: 80.0,
                                                width: 120.0,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          )
                                        : const SizedBox()
                                  ],
                                ),
                              );
                            }),
                  ),
                );
              });
      case "Twitter":
        return homeScreenController.isLoadingTwitter.value
            ? Center(
                child: Image.asset(
                  "assets/images/gif.gif",
                  height: 300.0,
                  width: 300.0,
                ),
              ).marginOnly(bottom: 50.0, top: 100)
            : Obx(() {
                return Expanded(
                  child: RefreshIndicator(
                    onRefresh: () =>
                        homeScreenController.getTwitterJob('["Social"]', 1),
                    child: homeScreenController.twitterjob.isEmpty
                        ? NoDataFound(
                            onPressed: () {
                              homeScreenController.getTwitterJob(
                                  '["Social"]', 1);
                            },
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            itemCount: homeScreenController.twitterjob.length,
                            separatorBuilder: (c, e) {
                              return const SizedBox(
                                height: 5.0,
                              );
                            },
                            itemBuilder: (ctx, index) {
                              if (homeScreenController.twitterjob.isNotEmpty) {
                                if (homeScreenController.twitterjob.length ==
                                    index + 1) {
                                  if (homeScreenController.twittertotalPages ==
                                      1) {
                                    homeScreenController.isTwitterMore.value =
                                        false;
                                  } else {
                                    homeScreenController.isTwitterMore.value =
                                        true;
                                  }

                                  homeScreenController.twitterpageno.value =
                                      homeScreenController.twitterpageno.value +
                                          1;
                                  homeScreenController.getTwitterJob(
                                      '["Social"]',
                                      homeScreenController.twitterpageno.value);
                                } else {
                                  homeScreenController.isTwitterMore.value =
                                      false;
                                }
                              } else if (homeScreenController
                                  .searchjob.isNotEmpty) {
                                if (homeScreenController.searchjob.length ==
                                    index + 1) {
                                  if (homeScreenController.twittertotalPages ==
                                      1) {
                                    homeScreenController.isTwitterMore.value =
                                        false;
                                  } else {
                                    homeScreenController.isTwitterMore.value =
                                        true;
                                  }
                                  homeScreenController.twitterpageno.value =
                                      homeScreenController.twitterpageno.value +
                                          1;
                                  homeScreenController.getTwitterJob(
                                      '["Social"]',
                                      homeScreenController.twitterpageno.value);
                                } else {
                                  homeScreenController.isTwitterMore.value =
                                      false;
                                }
                              }
                              return SwipeActionCell(
                                key: ObjectKey(
                                    homeScreenController.twitterjob[index]),
                                trailingActions: <SwipeAction>[
                                  SwipeAction(
                                    title: "Delete",
                                    onTap: (CompletionHandler handler) async {
                                      await homeScreenController
                                          .deleteEscalationJobs(
                                              homeScreenController
                                                  .twitterjob[index]['id']);
                                      if (homeScreenController.statusCode ==
                                          200) {
                                        homeScreenController.twitterjob
                                            .removeAt(index);
                                      } else {
                                        CustomSnackBar.showSnackBar(
                                            title:
                                                AppStrings.somethingWentWrong,
                                            message: "",
                                            isWarning: true,
                                            backgroundColor:
                                                CommonColor.snackbarColour);
                                      }
                                    },
                                    color: Colors.red,
                                  ),
                                ],
                                child: Column(
                                  children: [
                                    TwitterContainer(
                                      onContainerTap: () {
                                        Fluttertoast.showToast(
                                          msg: AppStrings.toastmessage,
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                        );
                                      },
                                      thumbnail:
                                          "${homeScreenController.baseUrlService.baseUrl}/uploads/${homeScreenController.twitterjob[index]['thumbnailPath']}",
                                      username:
                                          "${homeScreenController.twitterjob[index]['channel']}",
                                      content: homeScreenController
                                                  .twitterjob[index]
                                                      ['transcription']
                                                  .runtimeType
                                                  .toString() ==
                                              'String'
                                          ? homeScreenController.content(
                                              json.decode(homeScreenController
                                                      .twitterjob[index]
                                                  ['transcription']))
                                          : homeScreenController.content(
                                              homeScreenController
                                                      .twitterjob[index]
                                                  ['transcription']),
                                      topic: homeScreenController
                                          .getTopicString(homeScreenController
                                              .twitterjob[index]['segments']),
                                      source: homeScreenController
                                          .twitterjob[index]['platform'],
                                      date: homeScreenController.convertDateUtc(
                                          homeScreenController.twitterjob[index]
                                                  ['programDate']
                                              .toString()),
                                      time: homeScreenController
                                          .convertTimeIntoUtc(
                                              homeScreenController
                                                      .twitterjob[index]
                                                  ['broadcastDate']),
                                      isUrdu:
                                          homeScreenController.twitterjob[index]
                                                      ['language'] ==
                                                  "ENGLISH"
                                              ? false
                                              : true,
                                      programUser: homeScreenController
                                          .twitterjob[index]['programUser'],
                                      isShare: true,
                                      onTap: () {
                                        if (homeScreenController
                                                .twitterjob[index]
                                                    ['transcription']
                                                .runtimeType
                                                .toString() ==
                                            'String') {
                                          homeScreenController.transcription =
                                              homeScreenController.content(json
                                                  .decode(homeScreenController
                                                          .twitterjob[index]
                                                      ['transcription']));
                                        } else {
                                          homeScreenController.transcription =
                                              homeScreenController.content(
                                                  homeScreenController
                                                          .twitterjob[index]
                                                      ['transcription']);
                                        }
                                        homeScreenController.source =
                                            homeScreenController
                                                .twitterjob[index]["source"];
                                        homeScreenController.channelName =
                                            homeScreenController
                                                .twitterjob[index]["channel"];
                                        _showMyDialog(
                                          context,
                                          homeScreenController,
                                          homeScreenController.twitterjob[index]
                                              ["id"],
                                          "${homeScreenController.baseUrlService.baseUrl}/uploads/${homeScreenController.twitterjob[index]['thumbnailPath']}",
                                        );
                                      },
                                    ),
                                    homeScreenController.isTwitterMore.value
                                        ? Container(
                                            color: NewCommonColours
                                                .paginationBackgroundColor,
                                            child: Center(
                                              child: Image.asset(
                                                "assets/images/gif.gif",
                                                height: 80.0,
                                                width: 120.0,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          )
                                        : const SizedBox()
                                  ],
                                ),
                              );
                            }),
                  ),
                );
              });

      case "Ticker":
        return homeScreenController.isLoadingTicker.value
            ? Center(
                child: Image.asset(
                  "assets/images/gif.gif",
                  height: 300.0,
                  width: 300.0,
                ),
              ).marginOnly(bottom: 50.0, top: 100)
            : Obx(() {
                return Expanded(
                  child: RefreshIndicator(
                    onRefresh: () =>
                        homeScreenController.getTickerJob('["Ticker"]', 1),
                    child: homeScreenController.tickerjob.isEmpty
                        ? NoDataFound(
                            onPressed: () {
                              homeScreenController.getTickerJob(
                                  '["Ticker"]', 1);
                            },
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            itemCount: homeScreenController.tickerjob.length,
                            separatorBuilder: (c, e) {
                              return const SizedBox(
                                height: 5.0,
                              );
                            },
                            itemBuilder: (ctx, index) {
                              if (homeScreenController.tickerjob.isNotEmpty) {
                                if (homeScreenController.tickerjob.length ==
                                    index + 1) {
                                  if (homeScreenController.tickertotalPages ==
                                      1) {
                                    homeScreenController.isTickerMore.value =
                                        false;
                                  } else {
                                    homeScreenController.isTickerMore.value =
                                        true;
                                  }

                                  homeScreenController.tickerpageno.value =
                                      homeScreenController.tickerpageno.value +
                                          1;
                                  homeScreenController.getTickerJob(
                                      '["Ticker"]',
                                      homeScreenController.tickerpageno.value);
                                } else {
                                  homeScreenController.isTickerMore.value =
                                      false;
                                }
                              } else if (homeScreenController
                                  .searchjob.isNotEmpty) {
                                if (homeScreenController.searchjob.length ==
                                    index + 1) {
                                  if (homeScreenController.tickertotalPages ==
                                      1) {
                                    homeScreenController.isTickerMore.value =
                                        false;
                                  } else {
                                    homeScreenController.isTickerMore.value =
                                        true;
                                  }

                                  homeScreenController.tickerpageno.value =
                                      homeScreenController.tickerpageno.value +
                                          1;
                                  homeScreenController.getTickerJob(
                                      '["Ticker"]',
                                      homeScreenController.tickerpageno.value);
                                } else {
                                  homeScreenController.isTickerMore.value =
                                      false;
                                }
                              }
                              return SwipeActionCell(
                                key: ObjectKey(
                                    homeScreenController.tickerjob[index]),
                                trailingActions: <SwipeAction>[
                                  SwipeAction(
                                    title: "Delete",
                                    onTap: (CompletionHandler handler) async {
                                      await homeScreenController
                                          .deleteEscalationJobs(
                                              homeScreenController
                                                  .tickerjob[index]['id']);
                                      if (homeScreenController.statusCode ==
                                          200) {
                                        homeScreenController.tickerjob
                                            .removeAt(index);
                                      } else {
                                        CustomSnackBar.showSnackBar(
                                            title:
                                                AppStrings.somethingWentWrong,
                                            message: "",
                                            isWarning: true,
                                            backgroundColor:
                                                CommonColor.snackbarColour);
                                      }
                                    },
                                    color: Colors.red,
                                  ),
                                ],
                                child: Column(
                                  children: [
                                    TickerContainer(
                                      onContainerTap: () {
                                        TickerDialog.showDialog(
                                          channelPath:
                                              '${homeScreenController.baseUrlService.baseUrl}/uploads/${homeScreenController.tickerjob[index]['channelLogoPath']}',
                                          thumbnailPath:
                                              '${homeScreenController.baseUrlService.baseUrl}/uploads/${homeScreenController.tickerjob[index]['thumbnailPath']}',
                                          programDate: homeScreenController
                                              .convertDateUtc(
                                                  homeScreenController
                                                      .tickerjob[index]
                                                          ['programDate']
                                                      .toString()),
                                          programTime:
                                              '${homeScreenController.convertTimeIntoUtc(homeScreenController.tickerjob[index]['broadcastDate'])}',
                                        );
                                      },
                                      thumbnail:
                                          "${homeScreenController.baseUrlService.baseUrl}/uploads/${homeScreenController.tickerjob[index]['channelLogoPath']}",
                                      username:
                                          "${homeScreenController.tickerjob[index]['channel']}",
                                      content: homeScreenController
                                                  .tickerjob[index]
                                                      ['transcription']
                                                  .runtimeType
                                                  .toString() ==
                                              'String'
                                          ? homeScreenController.content(
                                              json.decode(homeScreenController
                                                      .tickerjob[index]
                                                  ['transcription']))
                                          : homeScreenController.content(
                                              homeScreenController
                                                      .tickerjob[index]
                                                  ['transcription']),
                                      topic: homeScreenController
                                          .getTopicString(homeScreenController
                                              .tickerjob[index]['segments']),
                                      source: homeScreenController
                                          .tickerjob[index]['platform'],
                                      date: homeScreenController.convertDateUtc(
                                          homeScreenController.tickerjob[index]
                                                  ['programDate']
                                              .toString()),
                                      time: homeScreenController
                                          .convertTimeIntoUtc(
                                              homeScreenController
                                                      .tickerjob[index]
                                                  ['broadcastDate']),
                                      isUrdu:
                                          homeScreenController.tickerjob[index]
                                                      ['language'] ==
                                                  "ENGLISH"
                                              ? false
                                              : true,
                                      isShare: true,
                                      onTap: () {
                                        if (homeScreenController
                                                .tickerjob[index]
                                                    ['transcription']
                                                .runtimeType
                                                .toString() ==
                                            'String') {
                                          homeScreenController.transcription =
                                              homeScreenController.content(json
                                                  .decode(homeScreenController
                                                          .tickerjob[index]
                                                      ['transcription']));
                                        } else {
                                          homeScreenController.transcription =
                                              homeScreenController.content(
                                                  homeScreenController
                                                          .tickerjob[index]
                                                      ['transcription']);
                                        }
                                        homeScreenController.source =
                                            homeScreenController
                                                .tickerjob[index]["source"];
                                        homeScreenController.channelName =
                                            homeScreenController
                                                .tickerjob[index]["channel"];
                                        _showMyDialog(
                                          context,
                                          homeScreenController,
                                          homeScreenController.tickerjob[index]
                                              ["id"],
                                          "${homeScreenController.baseUrlService.baseUrl}/uploads/${homeScreenController.tickerjob[index]['thumbnailPath']}",
                                        );
                                      },
                                    ),
                                    homeScreenController.isTickerMore.value
                                        ? Container(
                                            color: NewCommonColours
                                                .paginationBackgroundColor,
                                            child: Center(
                                              child: Image.asset(
                                                "assets/images/gif.gif",
                                                height: 80.0,
                                                width: 120.0,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          )
                                        : const SizedBox()
                                  ],
                                ),
                              );
                            }),
                  ),
                );
              });

      default:
        return Container();
    }
  }

  onShare(BuildContext context, HomeScreenController _) async {
    List<String> thumbnailPath = [];
    thumbnailPath.insert(0, _.localPath);

    List<String> myList = [];
    myList.insert(0, _.source);
    myList.insert(1, _.channelName);
    myList.insert(2, _.transcription);
    // myList.insert(4,_.topic);
    // myList.insert(5,_.videoTranscription);
    String myString = myList.toString();
    myString = myString.substring(1, myString.length - 1);
    //
    // if (kDebugMode) {
    //   print("web transcription--------------$myString");
    // }

    await Share.shareFiles(thumbnailPath, text: myString);
  }

  Future<void> _showMyDialog(context, HomeScreenController _, String jobId,
      String thumbnailPath) async {
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
                                  'Youâ€™ll share the clip with the people you selected',
                              onPressed: () async {
                                Get.back();
                                await _.sharing(jobId);
                              },
                            );
                          });
                        },
                        minWidth: Get.width / 3.2,
                        height: 38,
                        child: const Text(
                          "Lytics",
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
}
