// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:lytics_lens/Constants/common_color.dart';
import 'package:lytics_lens/Controllers/test/testclip_controller.dart';
import 'package:lytics_lens/widget/bottomsheet/user_bottomsheet.dart';
import 'package:lytics_lens/widget/common_textstyle/common_text_style.dart';
import 'package:lytics_lens/widget/dialog_box/share_dialogbox.dart';
import 'package:lytics_lens/widget/snackbar/common_snackbar.dart';
import 'package:lytics_lens/widget/textFields/common_textfield.dart';
import 'package:another_xlider/another_xlider.dart';
import 'package:share/share.dart';


class TestClipScreen extends StatelessWidget {
  final double videoDuration;
  final double startDuration;
  final double endDuration;
  final double totalDuration;

   TestClipScreen({
    Key? key,
    required this.videoDuration,
    required this.startDuration,
    required this.endDuration,
    required this.totalDuration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back(closeOverlays: true);
        Get.delete<TestClipController>();
        return false;
      },
      child: GetBuilder<TestClipController>(
        init: TestClipController(),
        builder: (_) {
          return Scaffold(
            extendBodyBehindAppBar: true,

            backgroundColor: NewCommonColours.playerDetailScreenColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              leading: GestureDetector(
                onTap: () {
                  // _.betterPlayerController.dispose();
                  Get.back();
                  // Get.off(() => Dashboard());
                  Get.delete<TestClipController>();
                },
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 15,
                ),
              ),
            ),
            body: _.isLoading
                ? Center(
                    child: Image.asset(
                      "assets/images/gif.gif",
                      height: 300.0,
                      width: 300.0,
                    ),
                  )
                : SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          _.source.toLowerCase()=='tv'|| _.source.toLowerCase()=='online'|| _.source.toLowerCase()=='youtube'?

                          Container(
                            color: CommonColor.backgroundColour,
                            height: 245,
                            width: Get.width,
                            child: BetterPlayer(
                              controller: _.betterPlayerController,
                            ),
                          ):const SizedBox(),

                        ],
                      ),
                      Center(
                        child: Container(
                          height: 5.0,
                          width: Get.width / 6,
                          decoration: BoxDecoration(
                            color: CommonColor.textFieldBorderColor,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ).marginOnly(top: 13,bottom: 13),



                      const Divider(
                        height: 2,
                        color: Colors.white,
                      ).marginOnly(left: 14.0, right: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:  [
                          Text(
                            "Clip Video",
                            style: NewTextStyle.font16Weight500,
                          ),
                          const Spacer(),
                          const Icon(Icons.info_outline,size: 14,color: Colors.white,)
                        ],

                      ).marginOnly(left: 35.0, right: 20.0,top: 30),

                      const SizedBox(
                        height: 20.0,
                      ),

                      CommonTextField(
                        fillcolor: Colors.transparent,
                        controller: _.title,
                        hintText: 'Add Title(required) ',
                        maxLength: 60,
                        isInlineBorder: true,
                        hintTextColor: Colors.white,
                        textInputAction: TextInputAction.next,
                      ).marginOnly(left: 32.0, right: 31.0),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: Get.width / 1.45,

                            child: CommonTextField(
                              fillcolor: Colors.transparent,
                              controller: _.des,
                              hintText: 'Add Description',
                              maxLine: 3,
                              hintTextColor: Colors.white,
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                          const Spacer(),
                          Platform.isIOS==true?const SizedBox():
                          Column(
                            children: [
                              _.audioFile == null
                                  ? const SizedBox(
                                      height: 25,
                                      width: 25,
                                    )
                                  : GestureDetector(
                                      onTap: () async {
                                        // stopPlayer();
                                        

                                        if (Platform.isIOS) {
                                    await File(_.audioFile.path)
                                        .delete()
                                        .then((value) {
                                        _.audioFile = null;
                                        _.update();
                                    });
                                  } else {
                                    await _.recorder
                                        .deleteRecord(
                                            fileName: _.audioFile.path)
                                        .then((value) {
                                      if (kDebugMode) {
                                        print("check aud ${_.audioFile.path}");
                                      }
                                    });
                                      _.audioFile = null;
                                      _.update();
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
                                          color:
                                              CommonColor.greenBorderColor,
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
                                                _.audioplay(
                                                    _.audioFile.path);
                                              },
                                              child: Container(
                                                height: 33,
                                                width: 33,
                                                decoration:
                                                    const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  gradient: LinearGradient(
                                                    begin:
                                                        Alignment.topRight,
                                                    end: Alignment
                                                        .bottomLeft,
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
                                                        left: 3.0,
                                                        right: 3.0),
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
                                        _.update();
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 33,
                                        width: 33,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                                  const Color(0xff23b662)),
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
                        height: 75,
                        width: Get.width,
                        child: Stack(
                          children: [
                            Container(
                              height: 75,
                              width: Get.width,
                              color: Colors.transparent,
                              child: _.showPlaceHolder == true
                                  ? Container(
                                height: 75,
                                    width: Get.width,
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,

                                        border: Border.all(color: NewCommonColours.clippingBorderColor)
                                    ),
                                    child: const Center(
                                        child: Text(
                                          "No thumbnail available",
                                          style:
                                              TextStyle(color: Colors.white),
                                        ),
                                      ),
                                  )
                                  : Row(
                                      children: [
                                        Flexible(
                                          child: SizedBox(
                                            height: 75,
                                            width: Get.width,
                                            child: ListView.builder(
                                              itemCount:
                                                  _.customThumbnail.length,
                                              shrinkWrap: true,
                                              scrollDirection:
                                                  Axis.horizontal,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemBuilder: (c, i) {
                                                return Container(
                                                  height: 75,
                                                  width: Get.width / 6.8,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          "${_.baseUrlService.baseUrl}/uploads/thumbnails${_.customThumbnail[i]}"),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            ).marginOnly(left: 35.0, right: 30.0),
                            FlutterSlider(

                              handler: FlutterSliderHandler(
                                decoration: const BoxDecoration(),
                                child:  Material(
                                  type: MaterialType.transparency,
                                  color: Colors.orange,
                                  elevation: 3,
                                  child: Container(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: const Icon(Icons.arrow_left, size: 30,color: Colors.white,),
                                  ),
                                ),
                              ),
                              rightHandler: FlutterSliderHandler(
                                decoration: const BoxDecoration(),
                                child: Material(
                                  type: MaterialType.transparency,
                                 // color: Colors.orange,
                                  elevation: 3,
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 5),
                                      child: const Icon(Icons.arrow_right, size: 30,color: Colors.white,),
                                  ),
                                ),
                              ),

                              values: totalDuration == 0.0
                                  ? [_.startDuration, _.endDuration]
                                  : [_.tstartDuration, _.tendDuration],
                              rangeSlider: true,
                              tooltip: FlutterSliderTooltip(
                                alwaysShowTooltip: false,
                                disabled: true,
                              ),
                              selectByTap: false,
                              trackBar: FlutterSliderTrackBar(
                                inactiveTrackBarHeight: 75.0,
                                activeTrackBarHeight: 75.0,
                                activeTrackBar: BoxDecoration(
                                  color: Colors.white38,
                                  border: Border.all(
                                    color: Colors.green,
                                    width: 3.0,
                                  ),
                                ),
                                inactiveTrackBar: const BoxDecoration(
                                  color: Colors.transparent,
                                ),
                              ),
                              max: totalDuration == 0.0
                                  ? videoDuration
                                  : totalDuration,
                              min: 0,
                              step: const FlutterSliderStep(step: 20),
                              jump: false,
                              onDragging: (handlerIndex, lowerValue,
                                  upperValue) async {
                                if (totalDuration == 0.0) {
                                  _.startDuration = lowerValue;
                                  _.endDuration = upperValue;
                                  _.betterPlayerController.pause();
                                  _.update();
                                } else {
                                  _.tstartDuration = lowerValue;
                                  _.tendDuration = upperValue;
                                  _.betterPlayerController.pause();
                                  _.update();
                                  _.startDuration =
                                      _.fstartDuration + lowerValue;
                                  var dif = totalDuration - upperValue;
                                  _.endDuration = dif == 0.0
                                      ? _.fendDuration
                                      : _.fendDuration - dif;
                                  _.update();
                                }
                              },
                            ).marginOnly(left: 15.0, right: 10.0),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 26.0,
                      ),
                      totalDuration == 0.0
                          ? Text(
                              "${_.startDuration / 1000}s / ${_.endDuration / 1000}s",
                              style:
                                  GoogleFonts.roboto(color: Colors.white),
                            )
                          : Text(
                              "${_.tstartDuration / 1000}s / ${_.tendDuration / 1000}s",
                              style:
                                  GoogleFonts.roboto(color: Colors.white),
                            ),
                      const SizedBox(
                        height: 46.0,
                      ),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9.0),
                          side: const BorderSide(
                            color: Color(0xff23B662),
                          ),
                        ),
                        onPressed: () async {
                          if (_.recorder.isRecording) {
                            await _.stop();
                          }
                          UserBottomSheet.showBottomSheet(
                              onPressed: () async {
                                ShareDialogbox.showDialogbox(
                                  title: 'Are you sure?',
                                  subtitle:
                                  'You’ll share the clip with the people you selected',
                                  onPressed: () async {
                                    if (kDebugMode) {
                                      print("Box Tap Work");
                                    }
                                    if (totalDuration != 0.0) {
                                      if (_.title.text.isEmpty) {
                                        CustomSnackBar.showSnackBar(
                                          title: "Job title is required",
                                          message: "",
                                          isWarning: true,
                                          backgroundColor:
                                          CommonColor.greenColor,
                                        );
                                      } else {
                                        if (_.audioFile == null) {
                                          await _.sendDataWithoutAudio(_.jobId);
                                        } else {
                                          await _.sendData(_.jobId);
                                        }
                                      }
                                    } else {
                                      if (_.title.text.isEmpty &&
                                          _.des.text.isEmpty &&
                                          _.audioFile == null) {
                                        if (totalDuration == 0.0) {
                                          if (_.startDuration == 0.0 && _.endDuration == videoDuration) {
                                            await _.sharing(_.jobId);
                                          } else {
                                            CustomSnackBar.showSnackBar(
                                              title: "Job title is required",
                                              message: "",
                                              isWarning: true,
                                              backgroundColor:
                                              CommonColor.greenColor,
                                            );
                                          }
                                        } else {
                                          if (_.tstartDuration ==
                                              _.fstartDuration &&
                                              _.tendDuration == totalDuration) {
                                            await _.sharing(_.jobId);
                                          }
                                        }
                                      } else {
                                        if (_.title.text.isEmpty) {
                                          CustomSnackBar.showSnackBar(
                                            title: "Job title is required",
                                            message: "",
                                            isWarning: true,
                                            backgroundColor:
                                            CommonColor.greenColor,
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
                        minWidth: Get.width / 3,
                        height: 40,
                        // color: Color.fromRGBO(72, 190, 235, 1),
                        color: NewCommonColours.greenButton,
                        child: const Text(
                          "Share Clip",
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 0.4,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500),
                          maxLines: 2,
                        ),
                      ).marginOnly(bottom: 40),
                    ],
                  ),
                ),
          );
        },
      ),
    );
  }
  // Future<void> _showMyDialog(context, TestClipController _) async {
  //   return showDialog(
  //     context: context,
  //     barrierDismissible: true, // user must tap button!
  //     builder: (BuildContext context) {
  //       return Obx(() {
  //           return AlertDialog(
  //             backgroundColor: const Color(0xff131C3A),
  //             shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
  //             title: const Text(
  //               'Share?',
  //               textScaleFactor: 1.0,
  //               style: TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.w400,
  //                 color: Colors.white,
  //                 letterSpacing: 0.4,
  //                 fontFamily: 'Roboto',
  //               ),
  //             ),
  //             content: SizedBox(
  //               height: 100.0,
  //               child: Column(
  //                 // mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   const Text(
  //                     'Are you sure you want to share with in app or other?',
  //                     textScaleFactor: 1.0,
  //                     style: TextStyle(
  //                         fontSize: 13,
  //                         fontWeight: FontWeight.w300,
  //                         color: Colors.white,
  //                         letterSpacing: 0.4,
  //                         fontFamily: 'Roboto'),
  //                   ),
  //                   const Spacer(),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     children: [
  //                       MaterialButton(
  //                         onPressed: () async {
  //                           Get.back();
  //                           UserBottomSheet.showBottomSheet(
  //                               onPressed: () async {
  //                                 ShareDialogbox.showDialogbox(
  //                                   title: 'Are you sure?',
  //                                   subtitle:
  //                                   'You’ll share the clip with the people you selected',
  //                                   onPressed: () async {
  //                                     if (kDebugMode) {
  //                                       print("Box Tap Work");
  //                                     }
  //                                     if (totalDuration != 0.0) {
  //                                       if (_.title.text.isEmpty) {
  //                                         CustomSnackBar.showSnackBar(
  //                                           title: "Job title is required",
  //                                           message: "",
  //                                           isWarning: true,
  //                                           backgroundColor:
  //                                           CommonColor.greenColor,
  //                                         );
  //                                       } else {
  //                                         if (_.audioFile == null) {
  //                                           await _.sendDataWithoutAudio(_.jobId);
  //                                         } else {
  //                                           await _.sendData(_.jobId);
  //                                         }
  //                                       }
  //                                     } else {
  //                                       if (_.title.text.isEmpty &&
  //                                           _.des.text.isEmpty &&
  //                                           _.audioFile == null) {
  //                                         if (totalDuration == 0.0) {
  //                                           if (_.startDuration == 0.0 && _.endDuration == videoDuration) {
  //                                             await _.sharing(_.jobId);
  //                                           } else {
  //                                             CustomSnackBar.showSnackBar(
  //                                               title: "Job title is required",
  //                                               message: "",
  //                                               isWarning: true,
  //                                               backgroundColor:
  //                                               CommonColor.greenColor,
  //                                             );
  //                                           }
  //                                         } else {
  //                                           if (_.tstartDuration ==
  //                                               _.fstartDuration &&
  //                                               _.tendDuration == totalDuration) {
  //                                             await _.sharing(_.jobId);
  //                                           }
  //                                         }
  //                                       } else {
  //                                         if (_.title.text.isEmpty) {
  //                                           CustomSnackBar.showSnackBar(
  //                                             title: "Job title is required",
  //                                             message: "",
  //                                             isWarning: true,
  //                                             backgroundColor:
  //                                             CommonColor.greenColor,
  //                                           );
  //                                         } else {
  //                                           if (_.audioFile == null) {
  //                                             await _.sendDataWithoutAudio(_.jobId);
  //                                           } else {
  //                                             await _.sendData(_.jobId);
  //                                           }
  //                                         }
  //                                       }
  //                                     }
  //                                   },
  //                                 );
  //                               });
  //                         },
  //                         minWidth: Get.width / 3.2,
  //                         height: 38,
  //                         child: const Text(
  //                           "In App Share",
  //                           textScaleFactor: 1.0,
  //                           style: TextStyle(
  //                               color: CommonColor.whiteColor,
  //                               fontSize: 16,
  //                               fontWeight: FontWeight.w700),
  //                         ),
  //                       ),
  //
  //
  //                       const SizedBox(
  //                         width: 8.0,
  //                       ),
  //                       _.donwloadLoader.value==true?CircularProgressIndicator(color: NewCommonColours.shareBtnColor,).marginOnly(left: 40,right: 20):
  //                       MaterialButton(
  //                         color: NewCommonColours.greenButton,
  //                         shape: RoundedRectangleBorder(
  //                             side: const BorderSide(
  //                               color: NewCommonColours.greenButton,
  //                             ),
  //                             borderRadius: BorderRadius.circular(9.0)),
  //                         onPressed: () async {
  //                           await _.downloadImage();
  //                           // _.launchInBrowser(_.url);
  //                           Get.back();
  //                           onShareWithEmptyFields(context,_);
  //                         },
  //                         minWidth: Get.width / 3.7,
  //                         height: 38,
  //                         child: const Text(
  //                           "Other",
  //                           textScaleFactor: 1.0,
  //                           style: TextStyle(
  //                               color: NewCommonColours.whiteColor,
  //                               fontSize: 16,
  //                               fontWeight: FontWeight.w700),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         }
  //       );
  //     },
  //   );
  // }
  //
  // onShareWithEmptyFields(BuildContext context,TestClipController _) async {
  //
  //   List<String> thumbnailPath = [];
  //   thumbnailPath.insert(0,_.localPath);
  //
  //
  //   List<String> myList = [];
  //   myList.insert(0,_.videoUrl);
  //   myList.insert(1,_.source);
  //   myList.insert(2,_.channelName);
  //   myList.insert(3,_.programName);
  //   myList.insert(4,_.topic1);
  //   myList.insert(5,_.transcription);
  //
  //   String myString = myList.toString();
  //   myString = myString.substring(1, myString.length - 1);
  //
  //   await Share.shareFiles(thumbnailPath,text:myString);
  // }

}
