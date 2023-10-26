// ignore_for_file: file_names, unused_local_variable

import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:lottie/lottie.dart';
import 'package:lytics_lens/Constants/common_color.dart';
import 'package:lytics_lens/Controllers/playerController.dart';
import 'package:lytics_lens/Controllers/test/testclip_controller.dart';
import 'package:lytics_lens/widget/bottomsheet/user_bottomsheet.dart';
import 'package:lytics_lens/widget/common_button/common_button.dart';
import 'package:lytics_lens/widget/common_containers/webview_container.dart';
import 'package:lytics_lens/widget/textFields/common_textfield.dart';
import 'package:lytics_lens/widget/text_highlight/text_highlight.dart';
import 'package:lytics_lens/widget/videoicon_widget/video_icon.dart';
import 'package:share/share.dart';
import '../widget/common_containers/transcription_container.dart';
import '../widget/common_textstyle/common_text_style.dart';
import '../widget/dialog_box/share_dialogbox.dart';
import '../widget/snackbar/common_snackbar.dart';
import 'testclip/testclip_screen.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final mqDataNew = mqData.copyWith(
        textScaleFactor:
            mqData.textScaleFactor > 1.0 ? 1.0 : mqData.textScaleFactor);
    return MediaQuery(
      data: mqDataNew,
      child: GetBuilder<VideoController>(
        init: VideoController(),
        builder: (_) {
          if (kDebugMode) {
            print("check123 ${_.sharedData}");
          }
          return WillPopScope(
            onWillPop: () async {
              Get.back(closeOverlays: true);
              Get.delete<VideoController>();
              return false;
            },
            child: Scaffold(
              extendBodyBehindAppBar: true,
              resizeToAvoidBottomInset: true,
              backgroundColor: Theme.of(context).primaryColor,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                leading: GestureDetector(
                  onTap: () {
                    // _.betterPlayerController.dispose();
                    Get.back();
                    // Get.off(() => Dashboard());
                    Get.delete<VideoController>();
                  },
                  child:  Platform.isIOS? Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(360),
                      border: Border.all(
                        color: Colors.blue, // set the border color here
                        width: 2, // set the border width here
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 25  ,
                      color: Colors.blue,
                    ),
                  ):Icon(Icons.arrow_back_ios).marginOnly(top: 10, left: 10),
                ),
                actions: [
                  _.source.toLowerCase() == 'blog' ||
                          _.source.toLowerCase() == 'print'
                      ? const SizedBox()
                      : _.jobPortal == "portal"
                          ? const SizedBox()
                          : _.sharedData.toString() != '{}' || _.isPervious
                              ? VideoIcon(
                                  onTap: () async {
                                    // _.betterPlayerController.dispose();
                                    if (_.perviousjobId == '') {
                                      _.perviousjobId = _.jobId;
                                      _.isPervious = true;
                                      _.update();
                                      _.isSentJob.value = false;
                                      _.isLoading.value = true;
                                      await _.getSingleJobById(_.parentjobId);
                                      _.isLoading.value = false;
                                    } else {
                                      _.isLoading.value = true;
                                      await _.getSingleJob(_.perviousjobId);
                                      _.isLoading.value = false;
                                      _.perviousjobId = '';
                                      _.isPervious = false;
                                      _.update();
                                      _.isSentJob.value = true;
                                    }
                                  },
                                  title: _.perviousjobId == ''
                                      ? 'Full Video'
                                      : 'Clip Video',
                                ).marginOnly(right: 5.0)
                              : const SizedBox(),
                ],
              ),
              // bottomNavigationBar: GlobalBottomNav(),
              body: bodyData(context, _),
            ),
          );
        },
      ),
    );
  }

  Widget bodyData(context, VideoController _) {
    return LayoutBuilder(builder: (context, constraints) {
      // if (orientation == Orientation.portrait) {
      //   // _.betterPlayerController.enterFullScreen();
      //   SystemChrome.setPreferredOrientations(
      //       [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
      // }
      // else {
      //   _.betterPlayerController.enterFullScreen();
      // }
      return Container(
          color: CommonColor.backgroundColour,
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Obx(
            () => _.internalServer.value
                ? const Center(
                    child: Text(
                      "Internal Server Error",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  )
                : _.isLoading.value
                    ? Center(
                        child: Image.asset(
                          "assets/images/gif.gif",
                          height: 300.0,
                          width: 300.0,
                        ),
                      )
                    : _.isSocket
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 225,
                                width: Get.width,
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      height: 225,
                                      width: Get.width,
                                      child: CachedNetworkImage(
                                        imageUrl: _.imagePathLast,
                                        placeholder: (c, e) => Lottie.asset(
                                            "assets/images/imgload.json",
                                            height: 225,
                                            width: Get.width,
                                            fit: BoxFit.cover),
                                        errorWidget: (c, e, r) => Lottie.asset(
                                            "assets/images/imgload.json",
                                            fit: BoxFit.cover),
                                        height: 225,
                                        width: Get.width,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      height: 225,
                                      width: Get.width,
                                      color: const Color.fromARGB(189, 0, 0, 0),
                                    ),
                                    const Center(
                                      child: CircularProgressIndicator(
                                          color: Colors.white),
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                        : Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              // Player Container
                              _.source.toLowerCase() == 'tv' ||
                                      _.source.toLowerCase() == 'online'
                                  ? AspectRatio(
                                      aspectRatio: 4 / 3,
                                      child: BetterPlayer(
                                        controller: _.betterPlayerController,
                                      ),
                                    )
                                  : WebViewContainer(
                                      imageurl: _.thumbnail,
                                      channelLogo: _.channelLogo,
                                      thumbnailPath: _.imagePathLast,
                                      programDes: _.title,
                                      programDate: _.programDate == ''
                                          ? ''
                                          : _.convertDateUtc(_.programDate),
                                      source: _.source,
                                      anchorName: _.anchor.toString() == '[]'
                                          ? ''
                                          : _.anchor[0].toString(),
                                      channelName: _.channel,
                                      programTime: _.programTime == ''
                                          ? ''
                                          : _.convertTime(_.programTime),
                                      onTap: () {
                                        // UserBottomSheet.showBottomSheet(
                                        //     onPressed: () async {
                                        //   ShareDialogbox.showDialogbox(
                                        //     title: 'Are you sure?',
                                        //     subtitle:
                                        //         'You’ll share the clip with the people you selected',
                                        //     onPressed: () async {
                                        //       Get.back();
                                        //       await _.sharing();
                                        //     },
                                        //   );
                                        // });
                                        webShareBottomSheet(context, _);
                                      },
                                      onGestureTap: _.isSentJob.value
                                          ? () {
                                              if (_.sharedTo.isNotEmpty) {
                                                sharedUser(context, _.sharedTo);
                                              }
                                            }
                                          : null,
                                      userLength: "${_.sharedTo.length}",
                                      isSend: _.isSentJob.value ? true : false,
                                    ),
                              //SizedBox(height: 1.0,),
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(
                              //       horizontal: 15.0),
                              //   child: Divider(
                              //     color:
                              //         const Color(0xffd3d3d3).withOpacity(0.16),
                              //     thickness: 1.0,
                              //   ),
                              // ),
                              // const SizedBox(
                              //   height: 15.0,
                              // ),
                              //------------------------Three tabs---------
                              Positioned(
                                //<-- SEE HERE
                                right: 0,
                                top: Get.height / 3,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        _.selectedTab.text = 'Transcription';
                                        _.update();
                                      },
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(0),
                                          topRight: Radius.circular(0),
                                        ),
                                        child: Container(
                                          height: 42,
                                          width: Get.width / 2,
                                          decoration: BoxDecoration(
                                            color: NewCommonColours
                                                .playerScreenButtons,
                                            border: Border(
                                              top: BorderSide(
                                                  color: NewCommonColours
                                                      .playerScreenBorderColor),
                                              left: BorderSide(
                                                  color: NewCommonColours
                                                      .playerScreenBorderColor),
                                              right: BorderSide(
                                                  color: NewCommonColours
                                                      .playerScreenBorderColor),
                                              bottom: BorderSide(
                                                  color: _.selectedTab
                                                              .text ==
                                                          'Transcription'
                                                      ? NewCommonColours
                                                          .playerScreenSelectedTab
                                                      : NewCommonColours
                                                          .playerScreenBorderColor,
                                                  width: 2),
                                              // color: _.selectedTab.text ==
                                              //         'Transcription'
                                              //     ? const Color(0xff1cb0c2)
                                              //     : const Color.fromRGBO(
                                              //         72, 190, 235, 0.19),
                                              // border:  Border(
                                              //   top: BorderSide(
                                              //     width: 2,
                                              //     color: Color(0xff000000).withOpacity(0.25),
                                              //   ),
                                              //   left: BorderSide(
                                              //     width: 3,
                                              //     color: Color(0xff1cb0c2),
                                              //   ),
                                              //   right: BorderSide(
                                              //     width: 3,
                                              //     color: Color(0xff1cb0c2),
                                              //   ),
                                              //   bottom: BorderSide.none,
                                              // ),
                                              // borderRadius: BorderRadius.only(
                                              //   topLeft: Radius.circular(5.0),
                                              //   topRight: Radius.circular(5.0),
                                              // ),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Transcription',
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                letterSpacing: 0.4,
                                                color: NewCommonColours
                                                    .playerScreenTabTextColor,

                                                // color: _.selectedTab.text ==
                                                //         'Transcription'
                                                //     ? Colors.white
                                                //     : const Color(0xff1cb0c2),
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
//------------------------- Todo uncomment the below code for translation container--------
                                    // GestureDetector(
                                    //   onTap: () {
                                    //     _.selectedTab.text = 'Translation';
                                    //     _.update();
                                    //   },
                                    //   child: Container(
                                    //     height: 42,
                                    //     // height:
                                    //     //     _.selectedTab.text == 'Translation'
                                    //     //         ? 44
                                    //     //         : 38,
                                    //     width: Get.width / 3,
                                    //     decoration: BoxDecoration(
                                    //         color: NewCommonColours.playerScreenButtons,
                                    //       border: Border(
                                    //         top: BorderSide(color: NewCommonColours.playerScreenBorderColor),
                                    //         left: BorderSide(color: NewCommonColours.playerScreenBorderColor),
                                    //         right: BorderSide(color: NewCommonColours.playerScreenBorderColor),
                                    //
                                    //
                                    //         bottom: BorderSide(
                                    //             color:_.selectedTab.text == 'Translation' ?NewCommonColours.playerScreenSelectedTab:  NewCommonColours.playerScreenBorderColor,
                                    //             width: 2),
                                    //       ),                                        // color: _.selectedTab.text ==
                                    //       //         'Translation'
                                    //       //     ? CommonColor.gradientColor
                                    //       //     : CommonColor.gradientColor2,
                                    //       // border: const Border(
                                    //       //   top: BorderSide(
                                    //       //     width: 2,
                                    //       //     color: CommonColor.gradientColor,
                                    //       //   ),
                                    //       //   left: BorderSide(
                                    //       //     width: 3,
                                    //       //     color: CommonColor.gradientColor,
                                    //       //   ),
                                    //       //   right: BorderSide(
                                    //       //     width: 3,
                                    //       //     color: CommonColor.gradientColor,
                                    //       //   ),
                                    //       //   bottom: BorderSide.none,
                                    //       // ),
                                    //       // borderRadius: BorderRadius.only(
                                    //       //   topLeft: Radius.circular(5.0),
                                    //       //   topRight: Radius.circular(5.0),
                                    //       // ),
                                    //     ),
                                    //     child: Center(
                                    //       child: Text(
                                    //         'Translation',
                                    //         style: TextStyle(
                                    //           fontSize: 12.0,
                                    //           letterSpacing: 0.4,
                                    //           color: NewCommonColours.playerScreenTabTextColor,
                                    //
                                    //           // color: _.selectedTab.text ==
                                    //           //         'Translation'
                                    //           //     ? Colors.white
                                    //           //     : CommonColor.greenTextColor,
                                    //           fontWeight: FontWeight.w700,
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),

                                    GestureDetector(
                                      onTap: () {
                                        _.selectedTab.text = 'Details';
                                        _.update();
                                      },
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(0),
                                          topRight: Radius.circular(0),
                                        ),
                                        child: Container(
                                          // height: _.selectedTab.text == 'Details'
                                          //     ? 44
                                          //     : 38,
                                          height: 42,
                                          width: Get.width / 2,
                                          decoration: BoxDecoration(
                                            color: NewCommonColours
                                                .playerScreenButtons,
                                            // border: Border.all(color: NewCommonColours.playerScreenBorderColor)
                                            // color: _.selectedTab.text == 'Details'
                                            //     ? const Color(0xff48beeb)
                                            //     : const Color.fromRGBO(
                                            //         72, 190, 235, 0.19),
                                            // border: const Border(
                                            //   top: BorderSide(
                                            //     width: 2,
                                            //     color: Color(0xff48beeb),
                                            //   ),
                                            //   left: BorderSide(
                                            //     width: 3,
                                            //     color: Color(0xff48beeb),
                                            //   ),
                                            //   right: BorderSide(
                                            //     width: 3,
                                            //     color: Color(0xff48beeb),
                                            //   ),
                                            // ),
                                            border: Border(
                                              top: BorderSide(
                                                  color: NewCommonColours
                                                      .playerScreenBorderColor),
                                              left: BorderSide(
                                                  color: NewCommonColours
                                                      .playerScreenBorderColor),
                                              right: BorderSide(
                                                  color: NewCommonColours
                                                      .playerScreenBorderColor),
                                              bottom: BorderSide(
                                                  color: _.selectedTab.text ==
                                                          'Details'
                                                      ? NewCommonColours
                                                          .playerScreenSelectedTab
                                                      : NewCommonColours
                                                          .playerScreenBorderColor,
                                                  width: 2),
                                            ),
                                            // borderRadius: BorderRadius.only(
                                            //   topLeft: Radius.circular(5.0),
                                            //   topRight: Radius.circular(5.0),
                                            // ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Details',
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                letterSpacing: 0.4,
                                                color: NewCommonColours
                                                    .playerScreenTabTextColor,
                                                // color: _.selectedTab.text ==
                                                //         'Details'
                                                //     ? Colors.white
                                                //     : const Color(0xff48beeb),
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                //--------------Detail container----------
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(0.0),
                                child: Container(
                                  width: Get.width,
                                  // height: MediaQuery.of(context).size.height / 2.5,
                                  decoration: BoxDecoration(
                                      // border: Border(
                                      //   top: BorderSide(
                                      //       color: _.selectedTab.text ==
                                      //               'Transcription'
                                      //           ? const Color(0xff1cb0c2)
                                      //           : _.selectedTab.text ==
                                      //                   'Translation'
                                      //               ? CommonColor
                                      //                   .greenBorderColor
                                      //               : const Color(0xff48beeb),
                                      //       width: 2),
                                      // ),
                                      color: _.selectedTab.text == 'Details'
                                          ? NewCommonColours
                                              .playerDetailScreenColor
                                          : NewCommonColours
                                              .playerScreenBackgroundColor),
                                  child: _.selectedTab.text == 'Transcription'
                                      ? Column(
                                          children: [
                                            Expanded(
                                              child: _.transcriptionlistdir
                                                      .isNotEmpty
                                                  ? Container(
                                                      width: Get.width,
                                                      decoration: BoxDecoration(
                                                        color: NewCommonColours
                                                            .playerDetailScreenColor,
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                          Radius.circular(0.0),
                                                        ),
                                                      ),
                                                      child: RawScrollbar(
                                                        thumbColor: NewCommonColours
                                                            .playerDetailScreenColor,
                                                        radius: const Radius
                                                            .circular(20),
                                                        mainAxisMargin: 5.0,
                                                        thickness: 5,
                                                        child:
                                                            SingleChildScrollView(
                                                          child: Column(
                                                            children: [
                                                              _.lang == "URDU"
                                                                  ? TranscriptionUrduContainer(
                                                                      source: _
                                                                          .source,
                                                                      transcriptionlistdir:
                                                                          _.transcriptionlistdir,
                                                                      videoController:
                                                                          _,
                                                                      searchText:
                                                                          _.urdusearchtext,
                                                                    )
                                                                  : TranscriptionEnglishContainer(
                                                                      source: _
                                                                          .source,
                                                                      transcriptionlistdir:
                                                                          _.transcriptionlistdir,
                                                                      videoController:
                                                                          _,
                                                                      searchText:
                                                                          _.englishsearchtext,
                                                                    ),
                                                            ],
                                                          ),
                                                        ).marginAll(9.0),
                                                      ),
                                                    )
                                                  : Container(
                                                      width: Get.width,
                                                      height: Get.height,
                                                      color: NewCommonColours
                                                          .playerDetailScreenColor,
                                                      child: const Center(
                                                          child: Text(
                                                        'Not Available',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            letterSpacing: 0.4,
                                                            fontFamily:
                                                                'Roboto',
                                                            color:
                                                                Colors.white),
                                                      )),
                                                    ),
                                            ),
                                          ],
                                        ).marginSymmetric(horizontal: 9)
                                      : _.selectedTab.text == 'Translation'
                                          ? Column(
                                              children: [
                                                Expanded(
                                                  child: _.translationlist
                                                          .isNotEmpty
                                                      ? Container(
                                                          width: Get.width,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: NewCommonColours
                                                                .playerDetailScreenColor,
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  0.0),
                                                            ),
                                                          ),
                                                          child: RawScrollbar(
                                                            thumbColor:
                                                                const Color(
                                                                    0xff22B161),
                                                            radius: const Radius
                                                                .circular(20),
                                                            mainAxisMargin: 5.0,
                                                            thickness: 5,
                                                            child:
                                                                SingleChildScrollView(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  CommonTextField3(
                                                                    inputFormatters: [
                                                                      FilteringTextInputFormatter
                                                                          .deny(
                                                                              RegExp(r"\s\b|\b\s"))
                                                                    ],
                                                                    hintText:
                                                                        'Search Translation',
                                                                    prefixIcon:
                                                                        Icons
                                                                            .search,
                                                                    controller:
                                                                        _.englishsearchtext,
                                                                    fillcolor:
                                                                        NewCommonColours
                                                                            .transcriptionTextFieldColor,
                                                                  ).marginOnly(
                                                                      left: 5,
                                                                      right: 5,
                                                                      bottom:
                                                                          14),
                                                                  InteractiveViewer(
                                                                    child:
                                                                        Directionality(
                                                                      textDirection:
                                                                          TextDirection
                                                                              .ltr,
                                                                      child:
                                                                          Wrap(
                                                                        alignment:
                                                                            WrapAlignment.start,
                                                                        clipBehavior:
                                                                            Clip.none,
                                                                        children: [
                                                                          for (int i = 0;
                                                                              i < _.translationlist.length;
                                                                              i++)
                                                                            GestureDetector(
                                                                              onDoubleTap: () {
                                                                                String splittext = _.translationlist[i]['duration'].split('-').first;
                                                                                String splittext2 = _.translationlist[i]['duration'].split('-').last;
                                                                                double starttime = double.parse(splittext);
                                                                                double endtime = double.parse(splittext2);
                                                                                _.betterPlayerController.videoPlayerController!.seekTo(Duration(seconds: starttime.toInt()));
                                                                                _.update();
                                                                              },
                                                                              child: Container(
                                                                                color: _.source.toLowerCase() == 'website' || _.source.toLowerCase() == 'print' || _.source.toLowerCase() == 'blog' ? Colors.white : _.check1(_.translationlist[i]['duration'], _.playerTime!),
                                                                                child: TextHighlighting(
                                                                                  caseSensitive: false,
                                                                                  text: '${_.translationlist[i]['line']}',
                                                                                  highlights: [
                                                                                    _.englishsearchtext.text.isEmpty ? "ssadsauadnasjjwjeiweuywdsjandsakjdsad" : _.englishsearchtext.text
                                                                                  ],
                                                                                  style: const TextStyle(
                                                                                    fontSize: 13.0,
                                                                                    letterSpacing: 0.4,
                                                                                    fontWeight: FontWeight.w400,
                                                                                  ),
                                                                                  textAlign: TextAlign.start,
                                                                                ),
                                                                              ),
                                                                            )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ).marginAll(10.0),
                                                          ),
                                                        )
                                                      : Container(
                                                          width: Get.width,
                                                          height: Get.height,
                                                          color: NewCommonColours
                                                              .playerDetailScreenColor,
                                                          child: const Center(
                                                              child: Text(
                                                            'Not Available',
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                letterSpacing:
                                                                    0.4,
                                                                fontFamily:
                                                                    'Roboto',
                                                                color: Colors
                                                                    .white),
                                                          )),
                                                        ),
                                                ),
                                              ],
                                            ).marginSymmetric(horizontal: 9)
                                          //---------------------Job detail tab-----------
                                          : Column(
                                              children: [
                                                Expanded(
                                                  child: RawScrollbar(
                                                    thumbColor:
                                                        const Color(0xff48beeb),
                                                    radius:
                                                        const Radius.circular(
                                                            20),
                                                    mainAxisMargin: 5.0,
                                                    thickness: 5,
                                                    child:
                                                        SingleChildScrollView(
                                                      //----------------------Todo from here--------
                                                      child: Column(
                                                        children: [
                                                          _.isAudio == true ||
                                                                  _.isComment ==
                                                                      true
                                                              ? Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment: _.isAudio ==
                                                                              true ||
                                                                          _.isComment ==
                                                                              false
                                                                      ? MainAxisAlignment
                                                                          .end
                                                                      : MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    // _.source.toLowerCase() == 'website' ||
                                                                    //         _.source.toLowerCase() ==
                                                                    //             'print' ||
                                                                    //         _.source.toLowerCase() ==
                                                                    //             'blog'
                                                                    //     ? const SizedBox()
                                                                    //     : Container(
                                                                    //         width:
                                                                    //             110,
                                                                    //         height:
                                                                    //             25,
                                                                    //         decoration: const BoxDecoration(
                                                                    //             color:
                                                                    //                 Color(0xff3C3D5C),
                                                                    //             borderRadius: BorderRadius.all(Radius.circular(20))),
                                                                    //         child:
                                                                    //             Center(
                                                                    //           child:
                                                                    //               Text(
                                                                    //             _.programType,
                                                                    //             style: const TextStyle(
                                                                    //                 color: Colors.white,
                                                                    //                 fontWeight: FontWeight.w400,
                                                                    //                 fontSize: 12),
                                                                    //           ),
                                                                    //         ),
                                                                    //       ),
                                                                    // const Spacer(),
                                                                    // _.source.toLowerCase() == 'website' ||
                                                                    //         _.source.toLowerCase() ==
                                                                    //             'print' ||
                                                                    //         _.source.toLowerCase() ==
                                                                    //             'blog'
                                                                    //     ? const SizedBox()
                                                                    //     :
                                                                    // _.source.toLowerCase() == 'website' ||
                                                                    //         _.source.toLowerCase() ==
                                                                    //             'print' ||
                                                                    //         _.source.toLowerCase() ==
                                                                    //             'blog'
                                                                    //     ? const SizedBox()
                                                                    //     :
                                                                    //-------------Comments section code......
                                                                    _.isComment
                                                                        ? Container(
                                                                            width:
                                                                                Get.width / 1.3,
                                                                            height:
                                                                                79,
                                                                            decoration:
                                                                                BoxDecoration(borderRadius: BorderRadius.circular(7), border: Border.all(color: NewCommonColours.commentsBorderFiled)),
                                                                            child:
                                                                                SingleChildScrollView(
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  //-----------------Heading Text-----------
                                                                                  Row(
                                                                                    children: [
                                                                                      Text(
                                                                                        "MUST WATCH THIS",
                                                                                        style: NewTextStyle.font12Weight700,
                                                                                      ),
                                                                                      _.isSentJob.value == true
                                                                                          ? Text(
                                                                                              " - ${_.senderFirstName}",
                                                                                              style: NewTextStyle.font10Weight300,
                                                                                            )
                                                                                          : Text(
                                                                                              " - ${_.receiverName}",
                                                                                              style: NewTextStyle.font10Weight300,
                                                                                            ),
                                                                                    ],
                                                                                  ).marginOnly(top: 10, bottom: 7),
                                                                                  Text(
                                                                                    "${_.comment}",
                                                                                    style: NewTextStyle.font10Weight300,
                                                                                    textAlign: TextAlign.start,
                                                                                  ),
                                                                                ],
                                                                              ).marginOnly(left: 14, right: 5),
                                                                            ),
                                                                          )
                                                                        : const SizedBox(),
                                                                    _.isAudio
                                                                        ? Obx(
                                                                            () => _.isPlay.value == false
                                                                                ? GestureDetector(
                                                                                    onTap: () {
                                                                                      _.betterPlayerController.pause();
                                                                                      _.audioplay(_.audioPath);
                                                                                    },
                                                                                    child: Container(
                                                                                      height: 34,
                                                                                      width: 34,
                                                                                      decoration: const BoxDecoration(
                                                                                        shape: BoxShape.circle,
                                                                                        gradient: LinearGradient(
                                                                                          begin: Alignment.topRight,
                                                                                          end: Alignment.bottomLeft,
                                                                                          colors: [
                                                                                            Color(0xff22B161),
                                                                                            Color(0xff35B7A5),
                                                                                            Color(0xff48BEEB),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      child: const Center(
                                                                                        child: Icon(
                                                                                          Icons.play_arrow_sharp,
                                                                                          color: Colors.white,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                : GestureDetector(
                                                                                    onTap: () {
                                                                                      _.stopPlayer();
                                                                                    },
                                                                                    child: Container(
                                                                                      height: 34,
                                                                                      width: 34,
                                                                                      decoration: BoxDecoration(
                                                                                        shape: BoxShape.circle,
                                                                                        border: Border.all(color: CommonColor.greenBorderColor),
                                                                                      ),
                                                                                      child: Center(
                                                                                        child: Lottie.asset('assets/images/waves.json').marginOnly(left: 3.0, right: 3.0),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                          ).marginOnly(
                                                                            left:
                                                                                8,
                                                                            right: _.isAudio == true && _.isComment == false
                                                                                ? 5
                                                                                : 0)
                                                                        : const SizedBox(),
                                                                  ],
                                                                ).marginOnly(
                                                                  bottom: _.isAudio ==
                                                                              true &&
                                                                          _.isComment ==
                                                                              false
                                                                      ? 5
                                                                      : 16)
                                                              : const SizedBox(),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                height:
                                                                    Get.height /
                                                                        1.2,
                                                                width:
                                                                    Get.width /
                                                                        1.3,
                                                                // color: Colors.red,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    //--------------start here----------------

                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.end,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            _.sharedData.isEmpty
                                                                                ? SizedBox(
                                                                                    width: Get.width / 1.4,
                                                                                    child: Text(
                                                                                      _.programName,
                                                                                      textScaleFactor: 1.0,
                                                                                      maxLines: 3,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      textDirection: _.validate(_.programName[0]) == true ? TextDirection.ltr : TextDirection.rtl,
                                                                                      style: _.validate(_.programName[0]) == true ? CommonTextStyle.englishPlayerScreenHeading : CommonTextStyle.urduPlayerScreenHeading,

                                                                                      //     TextStyle(
                                                                                      //   color: Colors.white,
                                                                                      //   // color: _.platform!.toLowerCase() == 'online'
                                                                                      //   //     ? NewCommonColours.onlineContainerColor
                                                                                      //   //     : _.platform!.toLowerCase() == 'tv'
                                                                                      //   //     ? NewCommonColours.tvContainerColor
                                                                                      //   //     : _.platform!.toLowerCase() == 'website' ||
                                                                                      //   //     _.platform!.toLowerCase() == 'blog'
                                                                                      //   //     ? NewCommonColours.webContainerColor
                                                                                      //   //     : _.platform!.toLowerCase() == 'print'
                                                                                      //   //     ? NewCommonColours.printContainerColor
                                                                                      //   //     : _.platform!.toLowerCase() ==
                                                                                      //   //     'youtube'
                                                                                      //   //     ? NewCommonColours.onlineContainerColor
                                                                                      //   //     : const Color(0xffFD8894),
                                                                                      //   fontSize: 16.0,
                                                                                      //   letterSpacing: 0.4,
                                                                                      //   fontWeight: FontWeight.w500,
                                                                                      // ),
                                                                                    ),
                                                                                  )
                                                                                : SizedBox(
                                                                                    width: Get.width / 1.4,
                                                                                    child: Text(
                                                                                      "${_.sharedData['title']}",
                                                                                      textScaleFactor: 1.0,
                                                                                      maxLines: 3,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      textDirection: RegExp(r'^[a-zA-Z0-9 _@./#;&+-]*$').hasMatch('${_.sharedData['title'].trim().split(' ').first}') == true ? TextDirection.ltr : TextDirection.rtl,
                                                                                      style: const TextStyle(
                                                                                        color: Colors.white,
                                                                                        // color: _.platform
                                                                                        //     .toLowerCase() ==
                                                                                        //     'online'
                                                                                        //     ? const Color(
                                                                                        //     0xff76d14b)
                                                                                        //     : _.platform.toLowerCase() ==
                                                                                        //     'tv'
                                                                                        //     ? const Color(
                                                                                        //     0xff00ffd9)
                                                                                        //     : _.platform.toLowerCase() ==
                                                                                        //     'website' ||
                                                                                        //     _.platform.toLowerCase() ==
                                                                                        //         'blog'
                                                                                        //     ? const Color(
                                                                                        //     0xffffd76f)
                                                                                        //     : _.platform.toLowerCase() ==
                                                                                        //     'print'
                                                                                        //     ? const Color(0xffB48AE8)
                                                                                        //     : _.platform == 'youtube'
                                                                                        //     ? const Color(0xffFD8894)
                                                                                        //     : const Color(0xffFD8894),
                                                                                        fontSize: 16.0,
                                                                                        letterSpacing: 0.4,
                                                                                        fontWeight: FontWeight.w500,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          5.0,
                                                                    ),
                                                                    Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        // crossAxisAlignment:
                                                                        //     CrossAxisAlignment.center,
                                                                        children: [
                                                                          const Icon(
                                                                            Icons.calendar_month,
                                                                            size:
                                                                                10,
                                                                            color:
                                                                                Color(0xffd3d3d3),
                                                                          ),
                                                                          // Padding(
                                                                          //   padding:
                                                                          //   const EdgeInsets.all(1.0),
                                                                          //   child: Image.asset(
                                                                          //     "assets/images/calendar.png",
                                                                          //     height: 10,
                                                                          //     width:10,
                                                                          //   ),
                                                                          // ),
                                                                          const SizedBox(
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                          Text(
                                                                            _.programDate == ''
                                                                                ? ''
                                                                                : _.convertDateUtc(_.programDate),
                                                                            textScaleFactor:
                                                                                1.0,
                                                                            style:
                                                                                const TextStyle(
                                                                              color: Color(0xffd3d3d3),
                                                                              fontSize: 10,
                                                                              letterSpacing: 0.4,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(3.0),
                                                                            child:
                                                                                Image.asset(
                                                                              "assets/images/dot2.png",
                                                                              height: 3,
                                                                              width: 3,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                          Text(
                                                                            _.convertTimeIntoUtc(_.programTime),
                                                                            style:
                                                                                const TextStyle(
                                                                              color: Colors.white,
                                                                              letterSpacing: 0.4,
                                                                              fontSize: 10,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                5.0,
                                                                          ),

                                                                          Container(
                                                                            height:
                                                                                12,
                                                                            width:
                                                                                1,
                                                                            color:
                                                                                const Color(0xffffffff),
                                                                          ).marginOnly(
                                                                              left: 1,
                                                                              right: 9),

                                                                          Text(
                                                                            _.channel,
                                                                            style:
                                                                                const TextStyle(
                                                                              color: Colors.white,
                                                                              letterSpacing: 0.4,
                                                                              fontSize: 10,
                                                                            ),
                                                                          ),

                                                                          const Spacer(),
                                                                          _.isSentJob.value
                                                                              // ignore: unrelated_type_equality_checks
                                                                              ? _.sharedTo != 0
                                                                                  ? GestureDetector(
                                                                                      onTap: () {
                                                                                        sharedUser(context, _.sharedTo);
                                                                                      },
                                                                                      child: Text(
                                                                                        '${_.sharedTo.length}',
                                                                                        style: const TextStyle(
                                                                                          fontSize: 12.0,
                                                                                          color: CommonColor.whiteColor,
                                                                                          fontWeight: FontWeight.bold,
                                                                                          fontFamily: 'Roboto',
                                                                                        ),
                                                                                      ),
                                                                                    )
                                                                                  : const SizedBox()
                                                                              : const SizedBox(),
                                                                          SizedBox(
                                                                            width: _.isSentJob.value == false
                                                                                ? 0.0
                                                                                : 3.0,
                                                                          ),
                                                                          _.isSentJob.value
                                                                              ? GestureDetector(
                                                                                  onTap: () {
                                                                                    sharedUser(context, _.sharedTo);
                                                                                  },
                                                                                  child: const Icon(
                                                                                    Icons.remove_red_eye_outlined,
                                                                                    color: CommonColor.whiteColor,
                                                                                    size: 18,
                                                                                  ),
                                                                                )
                                                                              : const SizedBox(),
                                                                          SizedBox(
                                                                            width: _.isSentJob.value == false
                                                                                ? 0.0
                                                                                : 15.0,
                                                                          ),
                                                                        ]),

                                                                    //-----------------------------Details tabbar container--------------

                                                                    Text("Topics",
                                                                            style: NewTextStyle
                                                                                .font12)
                                                                        .marginOnly(
                                                                            top:
                                                                                15),
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                          _.topic,
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                13,
                                                                            fontWeight:
                                                                                FontWeight.w300,
                                                                            color: _.platform!.toLowerCase() == 'online'
                                                                                ? NewCommonColours.onlineContainerColor
                                                                                : _.platform!.toLowerCase() == 'tv'
                                                                                    ? NewCommonColours.tvContainerColor
                                                                                    : _.platform!.toLowerCase() == 'website' || _.platform!.toLowerCase() == 'blog'
                                                                                        ? NewCommonColours.webContainerColor
                                                                                        : _.platform!.toLowerCase() == 'print'
                                                                                            ? NewCommonColours.printContainerColor
                                                                                            : _.platform!.toLowerCase() == 'youtube'
                                                                                                ? NewCommonColours.onlineContainerColor
                                                                                                : const Color(0xffFD8894),
                                                                          ),
                                                                        ).marginOnly(
                                                                            bottom:
                                                                                11,
                                                                            top:
                                                                                8),
                                                                        _.subTopic
                                                                                .isEmpty
                                                                            ? const SizedBox()
                                                                            : Container(
                                                                                height: 10,
                                                                                width: 1,
                                                                                color: _.platform!.toLowerCase() == 'online'
                                                                                    ? NewCommonColours.onlineContainerColor
                                                                                    : _.platform!.toLowerCase() == 'tv'
                                                                                        ? NewCommonColours.tvContainerColor
                                                                                        : _.platform!.toLowerCase() == 'website' || _.platform!.toLowerCase() == 'blog'
                                                                                            ? NewCommonColours.webContainerColor
                                                                                            : _.platform!.toLowerCase() == 'print'
                                                                                                ? NewCommonColours.printContainerColor
                                                                                                : _.platform!.toLowerCase() == 'youtube'
                                                                                                    ? NewCommonColours.onlineContainerColor
                                                                                                    : const Color(0xffFD8894),
                                                                              ).marginOnly(
                                                                                bottom: 11,
                                                                                top: 8,
                                                                                right: 8,
                                                                                left: 8),
                                                                        Flexible(
                                                                          child:
                                                                              Text(
                                                                            _.subTopic.isEmpty
                                                                                ? ''
                                                                                : _.subTopicString(_.subTopic),
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 13,
                                                                              fontWeight: FontWeight.w700,
                                                                              color: _.platform!.toLowerCase() == 'online'
                                                                                  ? NewCommonColours.onlineContainerColor
                                                                                  : _.platform!.toLowerCase() == 'tv'
                                                                                      ? NewCommonColours.tvContainerColor
                                                                                      : _.platform!.toLowerCase() == 'website' || _.platform!.toLowerCase() == 'blog'
                                                                                          ? NewCommonColours.webContainerColor
                                                                                          : _.platform!.toLowerCase() == 'print'
                                                                                              ? NewCommonColours.printContainerColor
                                                                                              : _.platform!.toLowerCase() == 'youtube'
                                                                                                  ? NewCommonColours.onlineContainerColor
                                                                                                  : const Color(0xffFD8894),
                                                                            ),
                                                                          ).marginOnly(bottom: 11, top: 8),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        _.source.toLowerCase() == 'website' ||
                                                                                _.source.toLowerCase() == 'print' ||
                                                                                _.source.toLowerCase() == 'blog'
                                                                            ? Text(
                                                                                "Writer ",
                                                                                style: NewTextStyle.font12,
                                                                              )
                                                                            : Text(
                                                                                "Speaker  ",
                                                                                style: NewTextStyle.font12,
                                                                              ),
                                                                        // Container(
                                                                        //   height: 10,
                                                                        //   width: 1,
                                                                        //   color: const Color(
                                                                        //       0xffC4C4C4),
                                                                        // ).marginSymmetric(
                                                                        //     horizontal:
                                                                        //         8),
                                                                      ],
                                                                    ).marginOnly(
                                                                        top: 22,
                                                                        bottom:
                                                                            9),
                                                                    //--------------Row of speakers name--------
                                                                    Row(
                                                                      children: [
                                                                        _.source.toLowerCase() == 'website' ||
                                                                                _.source.toLowerCase() == 'blog' ||
                                                                                _.source.toLowerCase() == 'print'
                                                                            ? Flexible(
                                                                                child: Text(
                                                                                  _.publisher,
                                                                                  style: NewTextStyle.font13Weight400,
                                                                                ).marginOnly(bottom: _.lang == "URDU" ? 5.0 : 0.0),
                                                                              )
                                                                            : Flexible(
                                                                                child: Text(
                                                                                  _.anchor.isEmpty ? '' : _.anchorString(_.anchor),
                                                                                  style: NewTextStyle.font13Weight400,
                                                                                ).marginOnly(bottom: _.lang == "URDU" ? 5.0 : 0.0),
                                                                              ),
                                                                      ],
                                                                    ),

                                                                    // _.description == ''
                                                                    //     ? const SizedBox()
                                                                    //     : const SizedBox(
                                                                    //         height: 10,
                                                                    //       ),
                                                                    // const SizedBox(
                                                                    //   height: 25,
                                                                    // ),
                                                                    //-------------------Guests Tag-----------------
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                            "Guests ",
                                                                            style:
                                                                                NewTextStyle.font13),
                                                                      ],
                                                                    ).marginOnly(
                                                                        top: 32,
                                                                        bottom:
                                                                            9),

                                                                    //---------------Guest name row-------------
                                                                    Row(
                                                                      children: [
                                                                        Flexible(
                                                                          child:
                                                                              Text(
                                                                            _.guest.isEmpty
                                                                                ? ''
                                                                                : _.guestString(_.guest),
                                                                            style:
                                                                                NewTextStyle.font13Weight400,
                                                                          ).marginOnly(bottom: _.lang == "URDU" ? 5.0 : 0.0),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    //---------------Keywords row---------------

                                                                    Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        SizedBox(
                                                                          width:
                                                                              Get.width / 3.5,
                                                                          child: Text("Keywords", style: NewTextStyle.font12).marginOnly(
                                                                              top: 32.0,
                                                                              bottom: 12),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    //-----------------Keywords name row---------

                                                                    Row(
                                                                      children: [
                                                                        SizedBox(
                                                                          width:
                                                                              Get.width / 1.3,
                                                                          child: showQueryWords(
                                                                              _,
                                                                              _.source),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    //--------------------------  Hashtags rows---------

                                                                    Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          "Hashtags",
                                                                          style:
                                                                              NewTextStyle.font12,
                                                                        ).marginOnly(
                                                                            top:
                                                                                34.0,
                                                                            bottom:
                                                                                12),
                                                                      ],
                                                                    ),
                                                                    //---------------Hashtags row names------------
                                                                    Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        SizedBox(
                                                                          width:
                                                                              Get.width / 2.2,
                                                                          child: showHashTags(
                                                                              _,
                                                                              _.source),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          50.0,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),

                                                              //-----------------Add share icon--------
                                                              Column(
                                                                children: [
                                                                  Container(
                                                                    height: 20,
                                                                    width: 44,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          const BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            2.0),
                                                                      ),
                                                                      border: Border.all(
                                                                          color: _.platform!.toLowerCase() == 'online'
                                                                              ? NewCommonColours.onlineContainerColor
                                                                              : _.platform!.toLowerCase() == 'tv'
                                                                                  ? NewCommonColours.tvContainerColor
                                                                                  : _.platform!.toLowerCase() == 'website' || _.platform!.toLowerCase() == 'blog'
                                                                                      ? NewCommonColours.webContainerColor
                                                                                      : _.platform!.toLowerCase() == 'print'
                                                                                          ? NewCommonColours.printContainerColor
                                                                                          : _.platform!.toLowerCase() == 'Youtube'
                                                                                              ? NewCommonColours.onlineContainerColor
                                                                                              : NewCommonColours.onlineContainerColor),
                                                                      // colors[widget.index],
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        _.platform!.toLowerCase() ==
                                                                                'online'
                                                                            ? " Online"
                                                                            : _.platform!.toLowerCase() == 'website' || _.platform!.toLowerCase() == 'blog'
                                                                                ? "Web"
                                                                                : _.platform!.toLowerCase() == 'print'
                                                                                    ? "Print"
                                                                                    : _.platform!.toLowerCase() == 'tv'
                                                                                        ? "TV"
                                                                                        : _.platform!.toLowerCase() == 'youtube'
                                                                                            ? "Video"
                                                                                            : _.platform!.toUpperCase(),
                                                                        textScaleFactor:
                                                                            1.0,
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          letterSpacing:
                                                                              0.4,
                                                                          color: _.platform!.toLowerCase() == 'online'
                                                                              ? NewCommonColours.onlineContainerColor
                                                                              : _.platform!.toLowerCase() == 'tv'
                                                                                  ? NewCommonColours.tvContainerColor
                                                                                  : _.platform!.toLowerCase() == 'website' || _.platform!.toLowerCase() == 'blog'
                                                                                      ? NewCommonColours.webContainerColor
                                                                                      : _.platform!.toLowerCase() == 'print'
                                                                                          ? NewCommonColours.printContainerColor
                                                                                          : _.platform!.toLowerCase() == 'youtube'
                                                                                              ? NewCommonColours.onlineContainerColor
                                                                                              : const Color(0xffFD8894),
                                                                          fontSize:
                                                                              9.0,
                                                                        ),
                                                                      ).marginOnly(
                                                                              left: 5.0,
                                                                              right: 5.0),
                                                                    ),
                                                                  ),
                                                                  //------------Add share icon---------------
                                                                  InkWell(
                                                                    onTap: _.betterPlayerController.videoPlayerController!.value.isBuffering ==
                                                                            true
                                                                        ? null
                                                                        : () async {
                                                                            if (_.source == "Tv" ||
                                                                                _.source == "Online") {
                                                                              _.betterPlayerController.pause();
                                                                            }

                                                                            // UserBottomSheet.showBottomSheet(
                                                                            //     onPressed: () async {
                                                                            //       ShareDialogbox.showDialogbox(
                                                                            //         title: 'Are you sure?',
                                                                            //         subtitle:
                                                                            //         'You’ll share the clip with the people you selected',
                                                                            //         onPressed: () async {
                                                                            //           Get.back();
                                                                            //           await _.sharing();
                                                                            //         },
                                                                            //       );
                                                                            //     })
                                                                            _showMyDialog(context,
                                                                                _);
                                                                          },
                                                                    child: Column(
                                                                        children: [
                                                                          _.betterPlayerController.videoPlayerController!.value.isBuffering
                                                                              ? Container(
                                                                                  height: 13,
                                                                                  child: Image.asset(
                                                                                    "assets/images/greyshare.png",
                                                                                  ),
                                                                                )
                                                                              : Container(
                                                                                  height: 13,
                                                                                  child: Image.asset("assets/images/shareicon.png"),
                                                                                ),
                                                                          const SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                          Text(
                                                                            "Share",
                                                                            style:
                                                                                TextStyle(
                                                                              color: _.betterPlayerController.videoPlayerController!.value.isBuffering ? Colors.grey : const Color(0xff22B161),
                                                                              fontSize: 9,
                                                                              fontWeight: FontWeight.w400,
                                                                            ),
                                                                          )
                                                                        ]),
                                                                  ).marginOnly(
                                                                      top: 10),
                                                                ],
                                                              ).marginOnly(
                                                                  top: 5),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ).marginOnly(
                                                            top: 14,
                                                            left: 30.0,
                                                            right: 9.0),
                                                  ),
                                                )
                                              ],
                                            ),
                                ),
                              ).marginOnly(top: (Get.height / 3) + 42),
                            ],
                          ),
          ));
    });
  }

  onShare(BuildContext context, VideoController _) async {
    List<String> thumbnailPath = [];
    thumbnailPath.insert(0, _.localPath);

    List<String> myList = [];
    if (_.source == "Tv" || _.source == "Online") {
      myList.insert(0, _.videoPath);
    } else {
      myList.insert(0, _.thumbnailpath);
    }
    myList.insert(1, _.source);
    myList.insert(2, _.channel);
    myList.insert(3, _.programName);
    myList.insert(4, _.topic);
    if (_.source == "Tv" || _.source == "Online") {
      myList.insert(5, _.speaker);
    } else {
      myList.insert(5, _.publisher);
    }

    myList.insert(6, _.videoTranscription);
    String myString = myList.toString();
    myString = myString.substring(1, myString.length - 1);
    if (kDebugMode) {
      print("local path--------------${_.localPath}");
    }

    if (kDebugMode) {
      print("web transcription--------------$myString");
    }

    await Share.shareFiles(
      thumbnailPath,
      text: myString,

    );
  }

  Future<void> _showMyDialog(context, VideoController _) async {
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
                          if (_.source == "Blog" || _.source == "Print") {
                            webShareBottomSheet(context, _);
                          } else if (_.source == "Online" || _.source == "Tv") {
                            Get.back();

                            Get.to(
                                () => TestClipScreen(
                                      videoDuration: _
                                          .betterPlayerController
                                          .videoPlayerController!
                                          .value
                                          .duration!
                                          .inMilliseconds
                                          .toDouble(),
                                      startDuration: _.sharedData.isEmpty ||
                                              _.sharedData == {}
                                          ? 0.0
                                          : double.parse(
                                              _.sharedData['startDuration']),
                                      endDuration: _.sharedData.isEmpty ||
                                              _.sharedData == {}
                                          ? 0.0
                                          : double.parse(
                                              _.sharedData['endDuration']),
                                      totalDuration: _.sharedData.isEmpty ||
                                              _.sharedData == {}
                                          ? 0.0
                                          : double.parse(
                                                  _.sharedData['endDuration']) -
                                              double.parse(_
                                                  .sharedData['startDuration']),
                                    ),
                                arguments: {
                                  "url": _.videoPath,
                                  "video_duration": _
                                      .betterPlayerController
                                      .videoPlayerController!
                                      .value
                                      .duration!
                                      .inMilliseconds
                                      .toDouble(),
                                  "id": _.jobId,
                                  "startDuration":
                                      _.sharedData.isEmpty || _.sharedData == {}
                                          ? 0.0
                                          : double.parse(
                                              _.sharedData['startDuration']),
                                  "endDuration":
                                      _.sharedData.isEmpty || _.sharedData == {}
                                          ? 0.0
                                          : double.parse(
                                              _.sharedData['endDuration']),
                                  "totalDuration": _.sharedData.isEmpty ||
                                          _.sharedData == {}
                                      ? 0.0
                                      : double.parse(
                                              _.sharedData['endDuration']) -
                                          double.parse(
                                              _.sharedData['startDuration']),
                                  "customThumbails": _.customThumbnail,
                                  "source": _.platform!,
                                  "isJobLibrary": _.apiIsJobLibrary,
                                  "jobPortal": _.jobPortal,
                                  "title": _.sharedData['title'],
                                  "description": _.comment,
                                  "channelName": _.channel ?? "",
                                  "programName": _.programName ?? "",
                                  "topic": _.topic ?? "",
                                  "transcription": _.videoTranscription,

                                  //"voiceNote":_.audioPath,
                                });
                          }
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
                      _.downloadLoader.value == true
                          ? SizedBox(
                              width: Get.width / 3.7,
                              child: Center(
                                  child: CircularProgressIndicator(
                                color: NewCommonColours.shareBtnColor,
                              )))
                          : MaterialButton(
                              color: NewCommonColours.greenButton,
                              shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    color: NewCommonColours.greenButton,
                                  ),
                                  borderRadius: BorderRadius.circular(9.0)),
                              onPressed: () async {
                                if (_.source == "Blog" || _.source == "Print") {
                                  await _.downloadImage(_.thumbnailpath);
                                } else if (_.source == "Online" || _.source == "Tv") {
                                  await _.downloadImage("${_.baseUrlService.baseUrl}/uploads/thumbnails${_.customThumbnail[0]}");
                                }
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

  Widget showHashTags(_, String source) {
    List<Widget> g = [];
    for (int i = 0; i < _.hashTags.length; i++) {
      g.add(FittedBox(
        fit: BoxFit.fill,
        child: Container(
          height: 30,
          decoration: BoxDecoration(
            color: const Color(0xff393D63),
            border: Border.all(color: const Color(0xff000000).withOpacity(0.1)),
            borderRadius: BorderRadius.circular(14.0),
          ),
          child: Center(
            child: Text(
              "${_.hashTags[i]}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: NewTextStyle.font11Weight400,
            ).marginOnly(left: 7.0, right: 7.0),
          ),
        ),
      ).marginAll(5.0));
    }

    return Wrap(
      children: g,
    );
  }

  //<--------------------------------- QueryWords --------------------------
  Widget showQueryWords(_, String source) {
    List<Widget> g = [];

    for (int i = 0; i < _.queryWords.length; i++) {
      g.add(FittedBox(
        fit: BoxFit.fill,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(1.0),
            topRight: Radius.circular(7),
            bottomLeft: Radius.circular(1.0),
            bottomRight: Radius.circular(7.0),
          ),
          child: Container(
            height: 30,
            decoration: BoxDecoration(
              color: NewCommonColours.playerScreenKeywordsTags,
              border: Border(
                left: BorderSide(
                    width: 2.0,
                    color: source!.toLowerCase() == 'online'
                        ? NewCommonColours.onlineContainerColor
                        : source!.toLowerCase() == 'tv'
                            ? NewCommonColours.tvContainerColor
                            : source!.toLowerCase() == 'website' ||
                                    source!.toLowerCase() == 'blog'
                                ? NewCommonColours.webContainerColor
                                : source!.toLowerCase() == 'print'
                                    ? NewCommonColours.printContainerColor
                                    : source!.toLowerCase() == 'Online'
                                        ? NewCommonColours.onlineContainerColor
                                        : const Color(0xffFD8894)),
                // bottom: BorderSide(width: 16.0, color: Colors.lightBlue.shade900),
              ),
              // borderRadius:  BorderRadius.only(
              //   // topLeft: Radius.circular(1.0),
              //   topRight: Radius.circular(7),
              //   // bottomLeft: Radius.circular(1.0),
              //   bottomRight: Radius.circular(7.0),
              // ),
            ),
            child: Center(
              child: Text(
                "${_.queryWords[i]['word']}",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: NewTextStyle.font9Weight400,
              ).marginOnly(left: 15.0, right: 15.0, top: 2, bottom: 2),
            ),
          ),
        ),
      ).marginAll(5.0));
    }
    return Wrap(
      // alignment: WrapAlignment.center,
      // crossAxisAlignment: WrapCrossAlignment.center,
      children: g,
    );
  }

  void sharedUser(BuildContext context, List user) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        elevation: 0,
        builder: (BuildContext bc) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              height: Get.height / 2.5,
              width: Get.width,
              color: const Color(0xff131C3A),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Center(
                        child: Container(
                          height: 5.0,
                          width: Get.width / 3,
                          decoration: BoxDecoration(
                            color: CommonColor.textFieldBorderColor,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Center(
                      child: Text(
                        'Shared with',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            color: CommonColor.whiteColor,
                            fontSize: 20.0),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: user.length,
                        shrinkWrap: true,
                        separatorBuilder: (c, i) {
                          return const SizedBox(
                            height: 10.0,
                          );
                        },
                        itemBuilder: (c, i) {
                          return Text(
                            '${user[i]['name']}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15.0),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                  ]).marginOnly(left: 20, top: 20),
            );
          });
        });
  }

  //---------------------------Comment Box---------------
  Future<void> showCommentDialouge(
    context,
    VideoController _,
  ) async {
    return showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xff131C3A),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          title: const Text(
            'Description',
            textScaleFactor: 1.0,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              letterSpacing: 0.4,
              fontFamily: 'Roboto',
            ),
          ),
          content: Text(
            _.comment,
            textScaleFactor: 1.0,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w300,
              color: Colors.white,
              letterSpacing: 0.4,
              fontFamily: 'Roboto',
            ),
          ),
        );
      },
    );
  }

//-----------------------------Web share bottom sheet----------
  void webShareBottomSheet(context, VideoController _) {
    Get.bottomSheet(
      backgroundColor: NewCommonColours.playerDetailScreenColor,
      isScrollControlled: true,
      elevation: 0,
      StatefulBuilder(
        builder: (context, setState) {
          return Container(
            height: Get.height / 1.8,
            width: Get.width,
            child: Column(
              children: [
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
                ).marginOnly(top: 19),
                const Divider(
                  height: 2,
                  color: Colors.white,
                ).marginOnly(left: 14.0, right: 16.0, top: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Share ",
                      style: NewTextStyle.font16Weight500,
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.info_outline,
                      size: 14,
                      color: Colors.white,
                    )
                  ],
                ).marginOnly(left: 35.0, right: 20.0, top: 30),
                const SizedBox(
                  height: 20.0,
                ),
                CommonTextField(
                  fillcolor: Colors.transparent,
                  controller: _.addTitle,
                  hintText: 'Add Title (required) ',
                  maxLength: 60,
                  isInlineBorder: true,
                  hintTextColor: Colors.white,
                  textInputAction: TextInputAction.next,
                ).marginOnly(left: 32.0, right: 31.0),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: Get.width / 1.45,
                      child: CommonTextField(
                        fillcolor: Colors.transparent,
                        controller: _.addDescription,
                        hintText: 'Add Description',
                        maxLine: 3,
                        hintTextColor: Colors.white,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    const Spacer(),
                    Platform.isIOS == true
                        ? const SizedBox()
                        : Column(
                            children: [
                              _.audioFile == null
                                  ? const SizedBox(
                                      height: 25,
                                      width: 25,
                                    )
                                  : GestureDetector(
                                      onTap: () async {
                                        // if (kDebugMode) {
                                        //   print("check aud ${_.audioFile.path}");
                                        // }
                                        if (Platform.isIOS) {
                                          await File(_.audioFile.path)
                                              .delete()
                                              .then((value) {
                                            setState(() {
                                              _.audioFile = null;
                                            });
                                          });
                                        } else {
                                          await _.recorder
                                              .deleteRecord(
                                                  fileName: _.audioFile.path)
                                              .then((value) {
                                            if (kDebugMode) {
                                              print(
                                                  "check aud ${_.audioFile.path}");
                                            }
                                          });
                                          setState(() {
                                            _.audioFile = null;
                                          });
                                        }
                                      },
                                      child: Container(
                                        height: 25,
                                        width: 25,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white),
                                        child: const Icon(
                                          Icons.delete,
                                          color: CommonColor.greenBorderColor,
                                          size: 15.0,
                                        ),
                                      ),
                                    ),
                              // const SizedBox(
                              //   height: 10.0,
                              // ),
                              _.audioFile != null
                                  ? Obx(
                                      () => _.isPlay.value == false
                                          ? GestureDetector(
                                              onTap: () {
                                                _.audioplay(_.audioFile.path);
                                              },
                                              child: Container(
                                                height: 33,
                                                width: 33,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topRight,
                                                    end: Alignment.bottomLeft,
                                                    colors: [
                                                      Color(0xff22B161),
                                                      Color(0xff35B7A5),
                                                      Color(0xff48BEEB),
                                                    ],
                                                  ),
                                                ),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.play_arrow_sharp,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container(
                                              height: 33,
                                              width: 33,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: CommonColor
                                                        .greenBorderColor),
                                              ),
                                              child: Center(
                                                child: Lottie.asset(
                                                        'assets/images/waves.json')
                                                    .marginOnly(
                                                        left: 3.0, right: 3.0),
                                              ),
                                            ),
                                    )
                                  : GestureDetector(
                                      onTap: () async {
                                        if (_.recorder.isRecording) {
                                          await _.stop();
                                        } else {
                                          await _.record();
                                        }
                                        setState(() {});
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 33,
                                        width: 33,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: const Color(0xff23b662)),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Icon(
                                            _.recorder.isRecording
                                                ? Icons.stop
                                                : Icons.mic,
                                            color: const Color(0xff23b662),
                                          ),
                                        ),
                                      ).marginOnly(bottom: 0),
                                    ),
                            ],
                          )
                  ],
                ).marginOnly(left: 35.0, right: 30.0),
                const SizedBox(
                  height: 40.0,
                ),
                SizedBox(
                  width: Get.width / 3.4,
                  child: CommonButton(
                      text: 'Share',
                      textStyle: NewTextStyle.font15Weight500,
                      onPressed: () async {
                        //------------company users------
                        if (_.recorder.isRecording) {
                          await _.stop();
                        }
                        Get.back();
                        UserBottomSheet.showBottomSheet(onPressed: () async {
                          ShareDialogbox.showDialogbox(
                            title: 'Are you sure?',
                            subtitle:
                                'You’ll share the clip with the people you selected',
                            onPressed: () async {
                              if (kDebugMode) {
                                print("Box Tap Work");
                              }
                              if (_.totalDuration != 0.0) {
                                if (_.addTitle.text.isEmpty) {
                                  CustomSnackBar.showSnackBar(
                                    title: "Job title is required",
                                    message: "",
                                    isWarning: true,
                                    backgroundColor: CommonColor.greenColor,
                                  );
                                } else {
                                  if (_.audioFile == null) {
                                    await _.sendDataWithoutAudio(_.jobId);
                                  } else {
                                    await _.sendData(_.jobId);
                                  }
                                }
                              } else {
                                if (_.addTitle.text.isEmpty &&
                                    _.addDescription.text.isEmpty &&
                                    _.audioFile == null) {
                                  if (_.totalDuration == 0.0) {
                                    if (_.startDuration == 0.0 &&
                                        _.endDuration == _.videoDuration) {
                                      await _.sharing(_.jobId);
                                    } else {
                                      CustomSnackBar.showSnackBar(
                                        title: "Job title is required",
                                        message: "",
                                        isWarning: true,
                                        backgroundColor: CommonColor.greenColor,
                                      );
                                    }
                                  } else {
                                    if (_.tstartDuration == _.fstartDuration &&
                                        _.tendDuration == _.totalDuration) {
                                      await _.sharing(_.jobId);
                                    }
                                  }
                                } else {
                                  if (_.addTitle.text.isEmpty) {
                                    CustomSnackBar.showSnackBar(
                                      title: "Job title is required",
                                      message: "",
                                      isWarning: true,
                                      backgroundColor: CommonColor.greenColor,
                                    );
                                  } else {
                                    if (_.audioFile == null) {
                                      await _.sendDataWithoutAudio(_.jobId);
                                    } else {
                                      await _.sendData(_.jobId);
                                    }
                                  }
                                }
                              }
                            },
                          );
                        });
                      },
                      fillColor: NewCommonColours.greenButton),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
