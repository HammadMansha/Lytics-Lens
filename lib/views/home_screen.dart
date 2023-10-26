// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lytics_lens/Constants/app_strrings.dart';
import 'package:lytics_lens/Constants/common_color.dart';
import 'package:lytics_lens/Controllers/home_controller.dart';
import 'package:lytics_lens/views/player_Screen.dart';
import 'package:lytics_lens/widget/bottomsheet/user_bottomsheet.dart';
import 'package:lytics_lens/widget/common_containers/commonTabBar.dart';
import 'package:lytics_lens/widget/common_textstyle/common_text_style.dart';
import 'package:lytics_lens/widget/dialog_box/share_dialogbox.dart';
import 'package:lytics_lens/widget/dialog_box/ticker_dialogbox.dart';
import 'package:lytics_lens/widget/tabs/home_tab.dart';
import 'package:share/share.dart';
import '../widget/common_button/common_button.dart';
import '../widget/common_containers/common_container.dart';
import '../widget/common_containers/taptoLoad.dart';
import '../widget/common_containers/ticker_container.dart';
import '../widget/common_containers/twitter_container.dart';
import '../widget/internet_connectivity/internetconnectivity_screen.dart';
import '../widget/snackbar/common_snackbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeScreenController>(
      init: HomeScreenController(),
      builder: (_) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            // backgroundColor: Color(0xFF2D2F3A),
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(50.0),
              child: AppBar(
                bottom: const TabBar(
                  isScrollable: false,
                  physics: NeverScrollableScrollPhysics(),
                  indicatorColor: Color(0xff22B161),
                  tabs: [
                    Tab(
                      text: "Alerts",
                    ),
                    Tab(
                      text: "Shared",
                    ),
                  ],
                ),
                elevation: 0.0,
                backgroundColor: const Color(0xff000425),
                titleSpacing: 0.0,
              ),
            ),
            // bottomNavigationBar: GlobalBottomNav(),
            // drawer: Drawer(),
            body: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [bodyData(context, _), bodyData1(context, _)],
            ),
          ),
        );
      },
    );
  }

  Widget bodyData(context, HomeScreenController _) {
    // final index = DefaultTabController.of(context)!.index;
    // print("tab index" + DefaultTabController.of(context)!.index.toString());
    return Container(
      height: Get.height,
      width: Get.width,
      color: const Color(0xff000425),
      child: Obx(
        () {
          return _.isLoading.value
              ? Center(
                  child: Image.asset(
                    "assets/images/gif.gif",
                    height: 300.0,
                    width: 300.0,
                  ),
                ).marginOnly(bottom: 50.0)
              : _.isSocketError.value
                  ? InterConnectivity(
                      onPressed: () async {
                        await _.getJobs(1);
                        await _.getReceiveJob();
                      },
                    )
                  : _.isDataFailed.value
                      ? TapToLoad(
                          onPressed: () {
                            _.getJobs(1);
                          },
                        )
                      : _.isSearchData.value
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // SizedBox(
                                //   height: 200.0,
                                // ),
                                Container(
                                  width: Get.width / 4.0,
                                  height: Get.height / 4.0,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                          "assets/images/searchjob.png",
                                        ),
                                        fit: BoxFit.contain),
                                  ),
                                ),
                                const Text(
                                  'No Result Found',
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontFamily: 'Roboto',
                                      letterSpacing: 0.4,
                                      color: Colors.white),
                                )
                              ],
                            )
                          : Column(
                              children: [
                                SizedBox(
                                  height: 50,
                                  //width: Get.width,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          separatorBuilder: (context, index) =>
                                              const Divider(
                                            color: Colors.transparent,
                                          ),
                                          itemCount: 1,
                                          itemBuilder: (context, index) {
                                            //----All tabbar Container-----

                                            return Row(
                                              children: [
                                                //----All tabbar Container-----
                                                CommonTabBar(
                                                  onPressed: () {
                                                    _.selectedTab.text = 'All';
                                                    _.update();
                                                  },
                                                  title: "All",
                                                  containerFillColor:
                                                      _.selectedTab.text ==
                                                              'All'
                                                          ? Colors.white
                                                          : Colors.transparent,
                                                  textColor:
                                                      _.selectedTab.text ==
                                                              'All'
                                                          ? Colors.white
                                                          : Colors.white24,
                                                ),

                                                //------Tv tabbar Container----
                                                CommonTabBar(
                                                  onPressed: () async {
                                                    _.selectedTab.text = 'Tv';
                                                    _.update();
                                                  },
                                                  title: "TV",
                                                  containerFillColor:
                                                      _.selectedTab.text == 'Tv'
                                                          ? const Color(
                                                              0xffff00ffd9)
                                                          : Colors.transparent,
                                                  textColor:
                                                      _.selectedTab.text == 'Tv'
                                                          ? const Color(
                                                              0xffff00ffd9)
                                                          : Colors.white24,
                                                ),
                                                //------Web tababr container---
                                                CommonTabBar(
                                                  onPressed: () async {
                                                    _.selectedTab.text = 'Blog';
                                                    _.update();
                                                  },
                                                  title: "Web",
                                                  containerFillColor: _
                                                              .selectedTab
                                                              .text ==
                                                          'Blog'
                                                      ? const Color(0xffffd76f)
                                                      : Colors.transparent,
                                                  textColor: _.selectedTab
                                                              .text ==
                                                          'Blog'
                                                      ? const Color(0xffffd76f)
                                                      : Colors.white24,
                                                ),
                                                //--------Print Tabbar Container----
                                                CommonTabBar(
                                                  onPressed: () async {
                                                    _.selectedTab.text =
                                                        'Print';
                                                    _.update();
                                                  },
                                                  title: "Print",
                                                  containerFillColor: _
                                                              .selectedTab
                                                              .text ==
                                                          'Print'
                                                      ? const Color(0xffc696ff)
                                                      : Colors.transparent,
                                                  textColor: _.selectedTab
                                                              .text ==
                                                          'Print'
                                                      ? const Color(0xffc696ff)
                                                      : Colors.white24,
                                                ),
                                                //--------Online Tabbar Container----
                                                CommonTabBar(
                                                  onPressed: () async {
                                                    _.selectedTab.text =
                                                        'Online';
                                                    _.update();
                                                  },
                                                  title: "Online",
                                                  containerFillColor:
                                                      _.selectedTab.text ==
                                                              'Online'
                                                          ? Color(0xfffd8894)
                                                          : Colors.transparent,
                                                  textColor:
                                                      _.selectedTab.text ==
                                                              'Online'
                                                          ? Color(0xfffd8894)
                                                          : Colors.white24,
                                                ),
                                                //--------Twitter Tabbar Container----
                                                CommonTabBar(
                                                  onPressed: () async {
                                                    _.selectedTab.text =
                                                        'Twitter';
                                                    _.update();
                                                  },
                                                  title: "Twitter",
                                                  containerFillColor: _
                                                              .selectedTab
                                                              .text ==
                                                          'Twitter'
                                                      ? const Color(0xfff26a32)
                                                      : Colors.transparent,
                                                  textColor: _.selectedTab
                                                              .text ==
                                                          'Twitter'
                                                      ? const Color(0xfff26a32)
                                                      : Colors.white24,
                                                ),
                                                //--------Ticker Tabbar Container----
                                                CommonTabBar(
                                                  onPressed: () {
                                                    _.selectedTab.text =
                                                        'Ticker';
                                                    _.update();
                                                  },
                                                  title: "Ticker",
                                                  containerFillColor: _
                                                              .selectedTab
                                                              .text ==
                                                          'Ticker'
                                                      ? const Color(0xffff1717)
                                                      : Colors.transparent,
                                                  textColor: _.selectedTab
                                                              .text ==
                                                          'Ticker'
                                                      ? const Color(0xffff1717)
                                                      : Colors.white24,
                                                ),
                                              ],
                                            ).marginAll(10);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                HomeTabs(
                                  selectedTab: _.selectedTab.text,
                                  homeScreenController: _,
                                ),
                              ],
                            );
        },
      ),
    );
  }

  Widget bodyData1(context, HomeScreenController _) {
    return SizedBox(
      height: Get.height,
      width: Get.width,
      // color: Color(0xff000425),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: const Color(0xff000425),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50.0),
            child: AppBar(
              bottom: const TabBar(
                isScrollable: false,
                physics: NeverScrollableScrollPhysics(),
                indicatorColor: Colors.transparent,
                labelColor: CommonColor.greenBorderColor,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(
                    text: "Received",
                  ),
                  Tab(
                    text: "Sent",
                  ),
                ],
              ),
              elevation: 0.0,
              backgroundColor: const Color(0xff000425),
              titleSpacing: 0.0,
            ),
          ),
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: [receivedList(_, context), sentList(_, context)],
          ),
        ),
      ),
    );
  }

  Widget sentList(HomeScreenController _, BuildContext context) {
    return Obx(
      () {
        return _.isSendLoading.value
            ? Center(
                child: Image.asset(
                  "assets/images/gif.gif",
                  height: 300.0,
                  width: 300.0,
                ),
              ).marginOnly(bottom: 50.0)
            : _.isSocketError.value
                ? InterConnectivity(
                    onPressed: () {
                      _.getSentJobs();
                    },
                  )
                : _.isDataFailed.value
                    ? TapToLoad(onPressed: () {
                        _.getSentJobs();
                      })
                    : DefaultTabController(
                        length: 5,
                        child: Column(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                child: RefreshIndicator(
                                    onRefresh: () => _.getSentJobs(),
                                    child: _.sentjob.isEmpty
                                        ? const Center(
                                            child: Text(
                                              "No Job Shared",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 20,
                                                  letterSpacing: 1.0),
                                            ),
                                          )
                                        : ListView.separated(
                                            shrinkWrap: true,
                                            itemCount: _.sentjob.length,
                                            separatorBuilder: (c, e) {
                                              return const SizedBox(
                                                height: 5.0,
                                              );
                                            },
                                            itemBuilder: (ctx, index) {
                                              return SwipeActionCell(
                                                key:
                                                    ObjectKey(_.sentjob[index]),
                                                trailingActions: <SwipeAction>[
                                                  SwipeAction(
                                                    title: "Delete",
                                                    onTap: (CompletionHandler
                                                        handler) async {
                                                      // _.getSingleJob(_.receivedJobsList[index]['id']);
                                                      _.checkDeleteIsLibrary =
                                                          _.sentjob[index]
                                                              ["isJobLibrary"];

                                                      if (kDebugMode) {
                                                        print(
                                                            "Check delete library value-----------${_.checkDeleteIsLibrary}");
                                                      }
                                                      _.update();
                                                      await _
                                                          .deleteSentSharedJob(
                                                              _.sentjob[index]
                                                                  ['shareId']);
                                                      if (_.statusCode == 200) {
                                                        _.sentjob
                                                            .removeAt(index);
                                                      } else {
                                                        CustomSnackBar.showSnackBar(
                                                            title: AppStrings
                                                                .somethingWentWrong,
                                                            message: "",
                                                            isWarning: true,
                                                            backgroundColor:
                                                                CommonColor
                                                                    .snackbarColour);
                                                      }
                                                    },
                                                    color: Colors.red,
                                                  ),
                                                ],
                                                child: Column(
                                                  children: [
                                                    _.sentjob[index]
                                                                ['source'] ==
                                                            'Social'
                                                        ? TwitterContainer(
                                                            onContainerTap: () {
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
                                                            thumbnail:
                                                                "${_.baseUrlService.baseUrl}/uploads/${_.sentjob[index]['thumbnailPath']}",
                                                            username:
                                                                "${_.sentjob[index]['channel']}",
                                                            programUser: _
                                                                        .sentjob[
                                                                    index]
                                                                ['programUser'],
                                                            content: _
                                                                        .sentjob[index]
                                                                            [
                                                                            'transcription']
                                                                        .runtimeType
                                                                        .toString() ==
                                                                    'String'
                                                                ? _.content(json.decode(
                                                                    _.sentjob[index]
                                                                        [
                                                                        'transcription']))
                                                                : _.content(_
                                                                        .sentjob[index]
                                                                    ['transcription']),
                                                            topic: _.getTopicString(
                                                                _.sentjob[index]
                                                                    [
                                                                    'segments']),
                                                            source: _.sentjob[
                                                                    index]
                                                                ['platform'],
                                                            date: _.convertDateUtc(_
                                                                .sentjob[index][
                                                                    'programDate']
                                                                .toString()),
                                                            time: _.convertTimeIntoUtc(_
                                                                        .sentjob[
                                                                    index][
                                                                'broadcastDate']),
                                                            isUrdu: _.sentjob[
                                                                            index]
                                                                        [
                                                                        'language'] ==
                                                                    "ENGLISH"
                                                                ? false
                                                                : true,
                                                            isShare: true,
                                                            onTap: () {
                                                              if( _.sentjob[index]['transcription'].runtimeType.toString() == 'String'){
                                                                _.transcription=_.content(json.decode(_.sentjob[index]['transcription']));

                                                              }
                                                              else{
                                                                _.transcription=_.content(_.sentjob[index]['transcription']);

                                                              }
                                                              _.source=_.sentjob[index]["source"];
                                                              _.channelName=_.sentjob[index]["channel"];

                                                              _showMyDialog(context, _, _.sentjob[index]["id"],"${_.baseUrlService.baseUrl}/uploads/${_.sentjob[index]['thumbnailPath']}",);

                                                            },
                                                          )
                                                        : _.sentjob[index][
                                                                    'source'] ==
                                                                'Ticker'
                                                            ? TickerContainer(
                                                                onContainerTap:
                                                                    () {
                                                                  TickerDialog
                                                                      .showDialog(
                                                                    channelPath:
                                                                        '${_.baseUrlService.baseUrl}/uploads/${_.sentjob[index]['channelLogoPath']}',
                                                                    thumbnailPath: '${_.baseUrlService.baseUrl}/uploads/${_.sentjob[index]['thumbnailPath']}',
                                                                    programDate: _.convertDateUtc(_
                                                                        .sentjob[
                                                                            index]
                                                                            [
                                                                            'programDate']
                                                                        .toString()),
                                                                    programTime:
                                                                        '${_.convertTimeIntoUtc(_.sentjob[index]['broadcastDate'])}',
                                                                  );
                                                                },
                                                                thumbnail:
                                                                    "${_.baseUrlService.baseUrl}/uploads/${_.sentjob[index]['channelLogoPath']}",
                                                                username:
                                                                    "${_.sentjob[index]['channel']}",
                                                                content: _.sentjob[index]['transcription'].runtimeType.toString() == 'String'
                                                                    ? _.content(json.decode(
                                                                        _.sentjob[index]
                                                                            [
                                                                            'transcription']))
                                                                    : _.content(
                                                                        _.sentjob[index]
                                                                            ['transcription']),
                                                                topic: _.getTopicString(_
                                                                            .sentjob[
                                                                        index][
                                                                    'segments']),
                                                                source: _.sentjob[
                                                                        index][
                                                                    'platform'],
                                                                date: _.convertDateUtc(_
                                                                    .sentjob[
                                                                        index][
                                                                        'programDate']
                                                                    .toString()),
                                                                time: _.convertTimeIntoUtc(_
                                                                            .sentjob[
                                                                        index][
                                                                    'broadcastDate']),
                                                                isUrdu: _.sentjob[index]
                                                                            [
                                                                            'language'] ==
                                                                        "ENGLISH"
                                                                    ? false
                                                                    : true,
                                                                isShare: true,
                                                                onTap: () {
                                                                  if( _.sentjob[index]['transcription'].runtimeType.toString() == 'String'){
                                                                    _.transcription=_.content(json.decode(_.sentjob[index]['transcription']));

                                                                  }
                                                                  else{
                                                                    _.transcription=_.content(_.sentjob[index]['transcription']);

                                                                  }
                                                                  _.source=_.sentjob[index]["source"];
                                                                  _.channelName=_.sentjob[index]["channel"];


                                                                  _showMyDialog(context, _, _.sentjob[index]["id"],  "${_.baseUrlService.baseUrl}/uploads/${_.sentjob[index]['thumbnailPath']}",);

                                                                },
                                                              )
                                                            : CommonContainer(
                                                                isClipped:
                                                                    _.sentjob[index]['sharedData'] !=
                                                                            null
                                                                        ? true
                                                                        : false,
                                                                isAudio: _.sentjob[index]['files'] == null ||
                                                                        _.sentjob[index]['files'] ==
                                                                            'null' ||
                                                                        _.sentjob[index]['files'] ==
                                                                            ''
                                                                    ? false
                                                                    : true,
                                                                isShare:
                                                                    _.sentjob[index]['sharedBy'] !=
                                                                            null
                                                                        ? true
                                                                        : false,
                                                                isSend: false,
                                                                receiverName:
                                                                    _.sentjob[index]['sharedBy'] !=
                                                                            null
                                                                        ?_.sentjob[index]['sharing'].toString()=="[]"?"": "${_.sentjob[index]['sharing'][0]['name']}"
                                                                        : '',
                                                                des: _.sentjob[index]
                                                                            [
                                                                            'sharedData'] !=
                                                                        null
                                                                    ? _.sentjob[index]
                                                                            [
                                                                            'sharedData']
                                                                        [
                                                                        'title']
                                                                    : _.sentjob[
                                                                            index]
                                                                        [
                                                                        'programName'],
                                                                publisher: _.sentjob[
                                                                            index]
                                                                        [
                                                                        'publisher'] ??
                                                                    "",
                                                                onPressed: () {
                                                                  Get.to(
                                                                    () =>
                                                                        const PlayerScreen(),
                                                                    arguments: {
                                                                      "id": _.sentjob[
                                                                              index]
                                                                          [
                                                                          'id'],
                                                                      "shareId":
                                                                          _.sentjob[index]
                                                                              [
                                                                              'shareId'],
                                                                      "sentPage":
                                                                          "true",
                                                                      "sharedJob":
                                                                          "true",
                                                                      "sentJob":
                                                                          "true",
                                                                      "receiverName":
                                                                          " ",
                                                                      "isJobLibrary":
                                                                          _.sentjob[index]
                                                                              [
                                                                              'isJobLibrary'],
                                                                    },
                                                                  );
                                                                },
                                                                isRead: true,
                                                                imgUrl:
                                                                    "${_.baseUrlService.baseUrl}/uploads/${_.sentjob[index]['thumbnailPath']}",
                                                                title: _.sentjob[index]
                                                                            [
                                                                            'sharedData'] !=
                                                                        null
                                                                    ? _.sentjob[index]
                                                                            [
                                                                            'sharedData']
                                                                        [
                                                                        'title']
                                                                    : _.sentjob[
                                                                            index]
                                                                        [
                                                                        'programName'],
                                                                anchor: _.sentjob[
                                                                        index]
                                                                    ['anchor'],
                                                                segments: _.getTopicString(_
                                                                            .sentjob[
                                                                        index][
                                                                    'segments']),
                                                                guests: _.getGuestsString(
                                                                    _.sentjob[
                                                                            index]
                                                                        [
                                                                        'guests']),
                                                                source: _.sentjob[
                                                                        index][
                                                                    'platform'],
                                                                channelName: _
                                                                            .sentjob[
                                                                        index]
                                                                    ['channel'],
                                                                channelLogo: _
                                                                        .storage
                                                                        .hasData(
                                                                            "Url")
                                                                    ? _.sentjob[index]['channelLogoPath']
                                                                            .toString()
                                                                            .contains(
                                                                                'http')
                                                                        ? _.sentjob[index]
                                                                            [
                                                                            'channelLogoPath']
                                                                        : "${_.storage.read("Url").toString()}/uploads//${_.sentjob[index]['channelLogoPath']}"
                                                                    : _.sentjob[index]['channelLogoPath']
                                                                            .toString()
                                                                            .contains(
                                                                                'http')
                                                                        ? _.sentjob[index]
                                                                            [
                                                                            'channelLogoPath']
                                                                        : "${_.baseUrlService.baseUrl}/uploads/${_.sentjob[index]['channelLogoPath']}",
                                                                date: _.convertDateUtc(_
                                                                    .sentjob[
                                                                        index][
                                                                        'programDate']
                                                                    .toString()),
                                                                time: _.convertTimeIntoUtc(_
                                                                            .sentjob[
                                                                        index][
                                                                    'broadcastDate']),
                                                              ),
                                                    _.isMore.value
                                                        ? Center(
                                                            child:
                                                                const CircularProgressIndicator()
                                                                    .marginOnly(
                                                              top: 10.0,
                                                              bottom: 10.0,
                                                            ),
                                                          )
                                                        : const SizedBox()
                                                  ],
                                                ),
                                              );
                                            })),
                              ),
                            )
                          ],
                        ),
                      );
      },
    );
  }

  Future<void> _showMyDialog(context, HomeScreenController _,String jobId,String thumbnailPath) async {
    return showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Obx(() {
          return AlertDialog(
            backgroundColor: const Color(0xff131C3A),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
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
                          UserBottomSheet
                              .showBottomSheet(
                              onPressed:
                                  () async {
                                ShareDialogbox
                                    .showDialogbox(
                                  title:
                                  'Are you sure?',
                                  subtitle:
                                  'You’ll share the clip with the people you selected',
                                  onPressed:
                                      () async {
                                    Get.back();
                                    await _.sharing(jobId);
                                  },
                                );
                              });                      },
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
                      _.downloadLoader.value==false?
                      MaterialButton(
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
                      ):
                      SizedBox(width: Get.width/3.7,child: Center(child: CircularProgressIndicator(color: NewCommonColours.shareBtnColor,),),),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
        );
      },
    );
  }



  onShare(BuildContext context, HomeScreenController _) async {
    List<String> thumbnailPath = [];
    thumbnailPath.insert(0,_.localPath);

    List<String> myList = [];
    myList.insert(0,_.source);
     myList.insert(1,_.channelName);
     myList.insert(2,_.transcription);
    // myList.insert(4,_.topic);
    // myList.insert(5,_.videoTranscription);
    String myString = myList.toString();
    myString = myString.substring(1, myString.length - 1);
    //
    // if (kDebugMode) {
    //   print("web transcription--------------$myString");
    // }


    await Share.shareFiles(thumbnailPath,text: myString);


  }




  Widget receivedList(HomeScreenController _, BuildContext context) {
    return Obx(
      () {
        return _.isLoading1.value
            ? Center(
                child: Image.asset(
                  "assets/images/gif.gif",
                  height: 300.0,
                  width: 300.0,
                ),
              ).marginOnly(bottom: 50.0)
            : _.isSocketError1.value
                ? InterConnectivity(
                    onPressed: () {
                      _.getReceiveJob();
                    },
                  )
                : _.isDataFailed.value
                    ? TapToLoad(
                        onPressed: () {
                          _.getReceiveJob();
                        },
                      )
                    : _.isSearchData.value
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // SizedBox(
                              //   height: 20.0,
                              // ),
                              Container(
                                width: Get.width / 4.0,
                                height: Get.height / 4.0,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                        "assets/images/searchjob.png",
                                      ),
                                      fit: BoxFit.contain),
                                ),
                              ),

                              const Text(
                                'No Result Found',
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontFamily: 'Roboto',
                                    letterSpacing: 0.4,
                                    color: Colors.white),
                              )
                            ],
                          )
                        : DefaultTabController(
                            length: 5,
                            child: Column(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    child: RefreshIndicator(
                                      onRefresh: () => _.getReceiveJob(),
                                      child: _.receivedJobsList.isEmpty
                                          ? const Center(
                                              child: Text(
                                                "No Job Received",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 20,
                                                    letterSpacing: 1.0),
                                              ),
                                            )
                                          : ListView.separated(
                                              shrinkWrap: true,
                                              itemCount:
                                                  _.receivedJobsList.length,
                                              separatorBuilder: (c, e) {
                                                return const SizedBox(
                                                  height: 5.0,
                                                );
                                              },
                                              itemBuilder: (ctx, index) {
                                                return SwipeActionCell(
                                                  key: ObjectKey(_
                                                      .receivedJobsList[index]),
                                                  trailingActions: <
                                                      SwipeAction>[
                                                    SwipeAction(
                                                      title: "Delete",
                                                      onTap: (CompletionHandler
                                                          handler) async {
                                                        // _.getSingleJob(_.receivedJobsList[index]['id']);
                                                        _.checkDeleteIsLibrary =
                                                            _.receivedJobsList[
                                                                    index][
                                                                "isJobLibrary"];

                                                        if (kDebugMode) {
                                                          print(
                                                              "Check delete library value-----------${_.checkDeleteIsLibrary}");
                                                        }
                                                        _.update();
                                                        await _.deleteReceivedSharedJob(
                                                            _.receivedJobsList[
                                                                    index]
                                                                ['shareId']);
                                                        if (_.statusCode ==
                                                            200) {
                                                          _.receivedJobsList
                                                              .removeAt(index);
                                                        } else {
                                                          CustomSnackBar.showSnackBar(
                                                              title: AppStrings
                                                                  .somethingWentWrong,
                                                              message: "",
                                                              isWarning: true,
                                                              backgroundColor:
                                                                  CommonColor
                                                                      .snackbarColour);
                                                        }
                                                      },
                                                      color: Colors.red,
                                                    ),
                                                  ],
                                                  child: Column(
                                                    children: [
                                                      _.receivedJobsList[index]
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
                                                              programUser: _.receivedJobsList[index]['programUser'],
                                                              thumbnail:
                                                                  "${_.baseUrlService.baseUrl}/uploads/${_.receivedJobsList[index]['thumbnailPath']}",
                                                              username:
                                                                  "${_.receivedJobsList[index]['channel']}",
                                                              content: _.receivedJobsList[index]['transcription'].runtimeType.toString() == 'String'
                                                                  ? _.content(json.decode(
                                                                      _.receivedJobsList[index]
                                                                          [
                                                                          'transcription']))
                                                                  : _.content(_
                                                                          .receivedJobsList[index]
                                                                      ['transcription']),
                                                              topic: _.getTopicString(
                                                                  _.receivedJobsList[
                                                                          index]
                                                                      [
                                                                      'segments']),
                                                              source:
                                                                  _.receivedJobsList[
                                                                          index]
                                                                      [
                                                                      'platform'],
                                                              date: _.convertDateUtc(_
                                                                  .receivedJobsList[
                                                                      index][
                                                                      'programDate']
                                                                  .toString()),
                                                              time: _.convertTimeIntoUtc(
                                                                  _.receivedJobsList[
                                                                          index]
                                                                      [
                                                                      'broadcastDate']),
                                                              isUrdu: _.receivedJobsList[
                                                                              index]
                                                                          [
                                                                          'language'] ==
                                                                      "ENGLISH"
                                                                  ? false
                                                                  : true,
                                                              isShare: true,
                                                              onTap: () {
                                                                if( _.receivedJobsList[index]['transcription'].runtimeType.toString() == 'String'){
                                                                  _.transcription=_.content(json.decode(_.receivedJobsList[index]['transcription']));

                                                                }
                                                                else{
                                                                  _.transcription=_.content(_.receivedJobsList[index]['transcription']);

                                                                }
                                                                _.source=_.receivedJobsList[index]["source"];
                                                                _.channelName=_.receivedJobsList[index]["channel"];

                                                                _showMyDialog(context, _, _.receivedJobsList[index]["id"],  "${_.baseUrlService.baseUrl}/uploads/${_.receivedJobsList[index]['thumbnailPath']}",);

                                                              },
                                                            )
                                                          : _.receivedJobsList[index]
                                                                      ['source'] == 'Ticker'
                                                              ? TickerContainer(
                                                                  onContainerTap: () {
                                                                    TickerDialog.showDialog(
                                                                      channelPath:
                                                                          '${_.baseUrlService.baseUrl}/uploads/${_.receivedJobsList[index]['channelLogoPath']}',
                                                                      thumbnailPath:
                                                                          '${_.baseUrlService.baseUrl}/uploads/${_.receivedJobsList[index]['thumbnailPath']}',
                                                                      programDate: _.convertDateUtc(_
                                                                          .receivedJobsList[
                                                                              index]
                                                                              [
                                                                              'programDate']
                                                                          .toString()),
                                                                      programTime:
                                                                          '${_.convertTimeIntoUtc(_.receivedJobsList[index]['broadcastDate'])}',
                                                                    );
                                                                  },
                                                                  thumbnail:
                                                                      "${_.baseUrlService.baseUrl}/uploads/${_.receivedJobsList[index]['channelLogoPath']}",
                                                                  username:
                                                                      "${_.receivedJobsList[index]['channel']}",
                                                                  content: _.receivedJobsList[index]['transcription'].runtimeType
                                                                              .toString() ==
                                                                          'String'
                                                                      ? _.content(
                                                                          json.decode(_.receivedJobsList[index]
                                                                              [
                                                                              'transcription']))
                                                                      : _.content(
                                                                          _.receivedJobsList[index]
                                                                              [
                                                                              'transcription']),
                                                                  topic: _.getTopicString(
                                                                      _.receivedJobsList[
                                                                              index]
                                                                          [
                                                                          'segments']),
                                                                  source: _.receivedJobsList[
                                                                          index]
                                                                      [
                                                                      'platform'],
                                                                  date: _.convertDateUtc(_
                                                                      .receivedJobsList[
                                                                          index]
                                                                          [
                                                                          'programDate']
                                                                      .toString()),
                                                                  time: _.convertTimeIntoUtc(
                                                                      _.receivedJobsList[
                                                                              index]
                                                                          [
                                                                          'broadcastDate']),
                                                                  isUrdu: _.receivedJobsList[index]
                                                                              [
                                                                              'language'] ==
                                                                          "ENGLISH"
                                                                      ? false
                                                                      : true,
                                                                  isShare: true,
                                                                  onTap: () {
                                                                    if( _.receivedJobsList[index]['transcription'].runtimeType.toString() == 'String'){
                                                                      _.transcription=_.content(json.decode(_.receivedJobsList[index]['transcription']));

                                                                    }
                                                                    else{
                                                                      _.transcription=_.content(_.receivedJobsList[index]['transcription']);

                                                                    }
                                                                    _.source=_.receivedJobsList[index]["source"];
                                                                    _.channelName=_.receivedJobsList[index]["channel"];

                                                                    _showMyDialog(context, _, _.receivedJobsList[index]["id"],"${_.baseUrlService.baseUrl}/uploads/${_.receivedJobsList[index]['thumbnailPath']}",);
                                                                  },
                                                                )
                                                              : CommonContainer(
                                                                  des: _.receivedJobsList[index]['sharedData'] != null
                                                                      ? _.receivedJobsList[index]['sharedData']['title']
                                                                      : _.receivedJobsList[index]['programName'],
                                                                  // ignore: prefer_if_null_operators
                                                                  publisher: _.receivedJobsList[index]
                                                                              [
                                                                              'publisher'] ==
                                                                          null
                                                                      ? ""
                                                                      : _.receivedJobsList[index]['publisher'],
                                                                  onPressed:
                                                                      () {
                                                                    if (kDebugMode) {
                                                                      print(
                                                                          "-----player screen is library ${_.receivedJobsList[index]['isJobLibrary']}");

                                                                      print(
                                                                          "-----share id on home screen ${_.receivedJobsList[index]['shareId']}");

                                                                    }
                                                                    Get.to(
                                                                      () =>
                                                                          const PlayerScreen(),
                                                                      arguments: {
                                                                        "id": _.receivedJobsList[index]
                                                                            [
                                                                            'id'],
                                                                        "shareId":
                                                                            _.receivedJobsList[index]['shareId'],
                                                                        "sentPage": "true",
                                                                        "sharedJob": "true",
                                                                        "receiverName": _.receivedJobsList[index]['sharedBy'] != null
                                                                            ? "${_.receivedJobsList[index]['sharedBy']['name']}"
                                                                            : '',
                                                                        "isJobLibrary":
                                                                            _.receivedJobsList[index]['isJobLibrary'],
                                                                      },
                                                                    );
                                                                  },
                                                                  isRead: true,
                                                                  imgUrl: _.receivedJobsList[index]
                                                                              ['thumbnailPath'] == null
                                                                      ? ''
                                                                      : "${_.baseUrlService.baseUrl}/uploads/${_.receivedJobsList[index]['thumbnailPath']}",
                                                                  isShare: _.receivedJobsList[index]['sharedBy'] != null
                                                                      ? true
                                                                      : false,
                                                                  isSend: _.receivedJobsList[index]
                                                                              [
                                                                              'sharedBy'] !=
                                                                          null
                                                                      ? true
                                                                      : false,
                                                                  receiverName:
                                                                      _.receivedJobsList[index]['sharedBy'] !=
                                                                              null
                                                                          ? "${_.receivedJobsList[index]['sharedBy']['name']}"
                                                                          : '',
                                                                  title: _.receivedJobsList[index]
                                                                              ['sharedData'] !=
                                                                          null
                                                                      ? _.receivedJobsList[index]
                                                                              [
                                                                              'sharedData']
                                                                          [
                                                                          'title']
                                                                      : _.receivedJobsList[
                                                                              index]
                                                                          [
                                                                          'programName'],
                                                                  anchor: _.receivedJobsList[
                                                                          index]
                                                                      [
                                                                      'anchor'],
                                                                  segments: _.receivedJobsList[index]
                                                                              [
                                                                              'segments'] ==
                                                                          null
                                                                      ? ''
                                                                      : _.getTopicString(
                                                                          _.receivedJobsList[index]
                                                                              [
                                                                              'segments']),
                                                                  isClipped:
                                                                      _.receivedJobsList[index]['sharedData'] !=
                                                                              null
                                                                          ? true
                                                                          : false,
                                                                  isAudio: _.receivedJobsList[index]['files'] == null ||
                                                                          _.receivedJobsList[index]['files'] ==
                                                                              'null' ||
                                                                          _.receivedJobsList[index]['files'] ==
                                                                              ''
                                                                      ? false
                                                                      : true,
                                                                  guests: _.receivedJobsList[index]
                                                                              [
                                                                              'guests'] ==
                                                                          null
                                                                      ? ''
                                                                      : _.getGuestsString(
                                                                          _.receivedJobsList[index]
                                                                              [
                                                                              'guests']),
                                                                  source: _.receivedJobsList[
                                                                          index]
                                                                      [
                                                                      'platform'],
                                                                  channelName: _
                                                                              .receivedJobsList[
                                                                          index]
                                                                      [
                                                                      'channel'],
                                                                  channelLogo: _.storage
                                                                          .hasData(
                                                                              "Url")
                                                                      ? _.receivedJobsList[index]['channelLogoPath'].toString().contains(
                                                                              'http')
                                                                          ? _.receivedJobsList[index]
                                                                              [
                                                                              'channelLogoPath']
                                                                          : "${_.storage.read("Url").toString()}/uploads//${_.receivedJobsList[index]['channelLogoPath']}"
                                                                      : _.receivedJobsList[index]['channelLogoPath'].toString().contains(
                                                                              'http')
                                                                          ? _.receivedJobsList[index]
                                                                              [
                                                                              'channelLogoPath']
                                                                          : "${_.baseUrlService.baseUrl}/uploads/${_.receivedJobsList[index]['channelLogoPath']}",
                                                                  date: _.convertDateUtc(_
                                                                      .receivedJobsList[
                                                                          index]
                                                                          [
                                                                          'programDate']
                                                                      .toString()),
                                                                  time: _.convertTimeIntoUtc(
                                                                      _.receivedJobsList[
                                                                              index]
                                                                          [
                                                                          'broadcastDate']),
                                                                ),
                                                      _.isMore.value
                                                          ? Center(
                                                              child:
                                                                  const CircularProgressIndicator()
                                                                      .marginOnly(
                                                                top: 10.0,
                                                                bottom: 10.0,
                                                              ),
                                                            )
                                                          : const SizedBox()
                                                    ],
                                                  ),
                                                );
                                              }),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
      },
    );
  }

  Widget getGuestList(HomeScreenController _, List guestlist) {
    return SizedBox(
      width: Get.width / 2.8,
      height: 17.0,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: guestlist.length,
        separatorBuilder: (c, v) {
          return const SizedBox(
            width: 10.0,
          );
        },
        itemBuilder: (c, i) {
          return Text(
            '${guestlist[i]['name']}',
            style: const TextStyle(
                fontSize: 12.0, fontFamily: 'Roboto', color: Colors.white60),
          );
        },
      ),
    );
  }

  Widget showSubTopic(List subtopic) {
    List c = [];
    c.add(subtopic[0]['topics']['topic2']);
    List<Widget> g = [];
    if (c.isEmpty) {
      g.add(const Text(''));
    } else {
      for (var i = 0; i < 1; i++) {
        g.add(Text(
          '${c[i]} ',
          style: const TextStyle(
              fontSize: 14, fontFamily: 'Roboto', color: Colors.white),
        ));
      }
    }
    return Expanded(
      child: Wrap(
        children: g,
      ),
    );
  }

  Future<void> showMyDialog(context) async {
    return showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xff131C3A),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          title: const Text(
            'Log Out?',
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
                  'Are you sure you want to log out?',
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
                      },
                      minWidth: Get.width / 3.5,
                      height: 38,
                      child: const Text(
                        "Cancel",
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
                    MaterialButton(
                      color: NewCommonColours.greenButton,
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: NewCommonColours.greenButton,
                          ),
                          borderRadius: BorderRadius.circular(9.0)),
                      onPressed: () async {
                        //  await _.logout();
                        // _.launchInBrowser(_.url);
                      },
                      minWidth: Get.width / 3.5,
                      height: 38,
                      child: const Text(
                        "Logout",
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            color: NewCommonColours.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
