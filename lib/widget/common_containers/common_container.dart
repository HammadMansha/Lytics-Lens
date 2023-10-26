import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lytics_lens/Constants/common_color.dart';
import 'package:lottie/lottie.dart';
import 'package:lytics_lens/widget/common_textstyle/common_text_style.dart';

class CommonContainer extends StatelessWidget {
  final Function() onPressed;
  final double height;
  final String? imgUrl;
  final String? errorImage;
  final String? id;
  final String? title;
  final String? des;
  final List? anchor;
  final String? segments;
  final String? publisher;
  final String? guests;
  final String? source;
  final String? channelName;
  final String? channelLogo;
  final String? programType;
  final String? date;
  final String? time;
  final String? receiverName;
  final bool isProgress;
  final bool isRead;
  final bool isShare;
  final bool isSend;
  final bool isReceived;
  final int progressValue;
  final bool isAudio;
  final bool isClipped;

  static bool validate(String value) {
    return RegExp(r"^[a-zA-Z0-9_\-=@,\.;' ']+$").hasMatch(value) ? true : false;
  }

   CommonContainer({
    Key? key,
    required this.onPressed,
    this.height = 120,
    // this.width,
    this.imgUrl,
    this.id,
    this.title,
    this.des,
    this.anchor,
    this.segments,
    this.publisher,
    this.guests,
    this.source,
    this.channelName,
    this.channelLogo,
    this.programType,
    this.date,
    this.time,
    this.receiverName,
    this.isShare = false,
    this.isSend = false,

    this.isProgress = false,
    this.isRead = true,
    this.isClipped = false,
    this.isReceived = false,
    this.isAudio = false,
    this.progressValue = 1,
    this.errorImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 95,
        // color: Color(0xff0A0D29),
        decoration: BoxDecoration(
          color: isRead ? const Color(0xff0A0D29) : const Color(0xff131C3A),
        ),
        // decoration: BoxDecoration(
        //   color: isRead ? Color(0xFF363842) : Color(0xff575968),
        // ),
        child: Row(
          children: [
            // First Column Start here
            SizedBox(
              width: 100,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  SizedBox(
                    width: 130,
                    height: MediaQuery.of(context).size.height,
                    //color: Colors.white,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(0),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: imgUrl!,

                        placeholder: (c, e) => Lottie.asset(
                            "assets/images/circular_loader_image.json",
                            fit: BoxFit.cover),
                        errorWidget: (c, e, r) => Container(
                          width: 130,
                          height: MediaQuery.of(context).size.height,
                          color: Colors.white,
                          child:
                              Image.network("$channelLogo", fit: BoxFit.contain)
                                  .marginOnly(left: 5.0, right: 5.0),
                        ),
                        fit: BoxFit.contain,
                      ),
                    ).marginOnly(left: 7.0, top: 7, bottom: 7, right: 9),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     ],
                  // ).marginOnly(top: 7, right: 9),
                ],
              ),
            ),
            const SizedBox(height: 7),
            // Second Column Start here
            SizedBox(
              width: Get.width / 2.6,
              height: Get.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: source!.toLowerCase() == 'youtube' ||
                            source!.toLowerCase() == 'tv'
                        ? RegExp(r'^[a-zA-Z 0-9 _@./#;&+-]*$')
                                    .hasMatch(title!.trim().split(' ').first) ==
                                true
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.end
                        : RegExp(r'^[a-zA-Z 0-9 _@./#;&+-]*$')
                                    .hasMatch(title!.trim().split(' ').first) ==
                                true
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          //textDirection: validate(des![0])==true?TextDirection.ltr:TextDirection.rtl,

                          textDirection: source!.toLowerCase() == 'youtube' ||
                              source!.toLowerCase() == 'tv'||source!.toLowerCase() == 'online'
                              ? validate(title![0])==true?  TextDirection.ltr : TextDirection.rtl
                              : validate(des![0])==true
                              ? TextDirection.ltr
                              : TextDirection.rtl,




                          //textAlign: validate(des![0])==true?TextAlign.start:TextAlign.right,


                          textAlign: source!.toLowerCase() == 'youtube' ||
                              source!.toLowerCase() == 'tv'|| source!.toLowerCase() == 'online'
                              ? validate(title![0])==true?
                   TextAlign.start
                              : TextAlign.right
                              : validate(des![0])==true
                          ? TextAlign.start
                              : TextAlign.right,



                          text: TextSpan(
                            text: source!.toLowerCase() == 'youtube' ||
                                source!.toLowerCase() == 'tv'
                                ? '$title'
                                : '$des',
                              style: validate(des![0])==true
                                  ? CommonTextStyle.font11Weight500
                                  : CommonTextStyle.urduStyle,

                          ),
                        ).marginOnly(
                            top: validate(des![0])== true
                                ? 8
                                : 3),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      SizedBox(
                        width: Get.width / 2.8,
                        child: Text(
                          "$segments",
                          textScaleFactor: 1.0,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textDirection: RegExp(r'^[a-zA-Z _@./#;&+-]*$')
                                      .hasMatch(segments!.trim().split(' ').first) == true
                              ? TextDirection.ltr
                              : TextDirection.rtl,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            letterSpacing: 0.4,
                            color: source!.toLowerCase() == 'online'
                                ? NewCommonColours.onlineContainerColor
                                : source!.toLowerCase() == 'tv'
                                    ? NewCommonColours.tvContainerColor
                                    : source!.toLowerCase() == 'website' ||
                                            source!.toLowerCase() == 'blog'
                                        ? NewCommonColours.webContainerColor
                                        : source!.toLowerCase() == 'print'
                                            ? NewCommonColours.printContainerColor
                                            : source!.toLowerCase() == 'Youtube'
                                                ? const Color(0xffFD8894)
                                                : const Color(0xffFD8894),
                            fontSize: 9.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  source!.toLowerCase() == 'website' ||
                          source!.toLowerCase() == 'blog' ||
                          source!.toLowerCase() == 'print'
                      ? SizedBox()
                  // SizedBox(
                  //         width: Get.width / 2.8,
                  //         child: Text(
                  //           "$publisher",
                  //           textScaleFactor: 1.0,
                  //           overflow: TextOverflow.ellipsis,
                  //           maxLines: 1,
                  //           textDirection: RegExp(r'^[a-zA-Z _@./#;&+-]*$')
                  //                       .hasMatch(publisher!
                  //                           .trim()
                  //                           .split(' ')
                  //                           .first) ==
                  //                   true
                  //               ? TextDirection.ltr
                  //               : TextDirection.rtl,
                  //           style: GoogleFonts.notoNastaliqUrdu(
                  //               letterSpacing: 0.4,
                  //               color: const Color(0xffa3a3a4),
                  //               fontSize: 8.0,
                  //               fontWeight: FontWeight.w400),
                  //         ).marginOnly(bottom: 5.0),
                  //       )
                      : SizedBox(
                          width: Get.width / 2.8,
                          child: anchor.toString() == '[]'
                              ? const Text(
                                  "",
                                  textScaleFactor: 1.0,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      letterSpacing: 0.4,
                                      color: Color(0xffa3a3a4),
                                      fontSize: 9.0,
                                      fontWeight: FontWeight.w400),
                                ).marginOnly(bottom: 5.0)
                              : Text(
                                  "${anchor![0]}",
                                  textScaleFactor: 1.0,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textDirection:
                                      RegExp(r'^[a-zA-Z _@./#;&+-]*$').hasMatch(
                                                  anchor![0]
                                                      .toString()
                                                      .trim()
                                                      .split(' ')
                                                      .first) ==
                                              true
                                          ? TextDirection.ltr
                                          : TextDirection.rtl,
                                  style: const TextStyle(
                                      fontFamily: 'Roboto',
                                      letterSpacing: 0.4,
                                      color: Color(0xffa3a3a4),
                                      fontSize: 9.0,
                                      fontWeight: FontWeight.w400),
                                ).marginOnly(bottom: 5.0),
                        ),
                ],
              ),
            ).marginOnly(left: 0.0),
            const Spacer(),
            //Third Column start from here.
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(
                    height: 2.0,
                  ),
                  isShare
                      ? Row(
                          children: [
                            isAudio
                                ? Container(
                              height: 15,
                              width: 15,
                              color: Colors.transparent,
                              child: const Center(
                                child: Icon(
                                  Icons.mic,
                                  size: 13,
                                  color: Colors.green,
                                ),
                              ),
                            )
                                : const SizedBox(),
                            isClipped
                                ? Container(
                              height: 15,
                              width: 15,
                              color: Colors.transparent,
                              child: const Center(
                                child: Icon(
                                  Icons.cut,
                                  size: 12,
                                  color: Colors.green,
                                ),
                              ),
                            )
                                : const SizedBox(),

                            isSend
                                ? Column(
                                    children: [
                                      SizedBox(
                                        height: 11,
                                        width: 11,
                                        child: Image.asset(
                                          'assets/images/share.png',
                                          width: 15.0,
                                        ),
                                      ),
                                    ],
                                  )
                                :  SizedBox(
                              height: 11,
                              width: 11,
                              child: Image.asset(
                                'assets/images/receive.png',
                                width: 15.0,
                              ),
                            ),




                            const SizedBox(
                              width: 5.0,
                            ),

                            SizedBox(
                              width: receiverName == '' ? 0 : Get.width / 12.0,
                              child: Text(
                                '$receiverName',
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                style: const TextStyle(
                                  fontSize: 10.0,
                                  color: CommonColor.whiteColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ).marginOnly(right: 1),
                            Container(
                              height: 17,
                              width:44,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(2.0),
                                ),
                                border: Border.all(
                                    color: source!.toLowerCase() == 'online'
                                        ? NewCommonColours.onlineContainerColor
                                        : source!.toLowerCase() == 'tv'
                                        ? NewCommonColours.tvContainerColor
                                        : source!.toLowerCase() == 'website' ||
                                        source!.toLowerCase() == 'blog'
                                        ? NewCommonColours.webContainerColor
                                        : source!.toLowerCase() == 'print'
                                        ? NewCommonColours.printContainerColor
                                        : source!.toLowerCase() ==
                                        'Youtube'
                                        ? NewCommonColours.onlineContainerColor
                                        :NewCommonColours.onlineContainerColor
                                ),
                                // colors[widget.index],
                              ),
                              child: Center(
                                child: Text(
                                  source!.toLowerCase() == 'online'
                                      ? " Online"
                                      : source!.toLowerCase() == 'website' ||
                                      source!.toLowerCase() == 'blog'
                                      ? "Web"
                                      : source!.toLowerCase() == 'print'?
                                  "Print"
                                      :source!.toLowerCase() == 'tv'?"TV":
                                  source!.toLowerCase()=='youtube'?'Video': source!.toUpperCase(),
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    letterSpacing: 0.4,
                                    color: source!.toLowerCase() == 'online'
                                        ? NewCommonColours.onlineContainerColor
                                        : source!.toLowerCase() == 'tv'
                                        ? NewCommonColours.tvContainerColor
                                        : source!.toLowerCase() == 'website' ||
                                        source!.toLowerCase() == 'blog'
                                        ? NewCommonColours.webContainerColor
                                        : source!.toLowerCase() == 'print'
                                        ? NewCommonColours.printContainerColor
                                        : source!.toLowerCase() ==
                                        'Online'
                                        ? NewCommonColours.onlineContainerColor
                                        : const Color(0xffFD8894),
                                    fontSize: 9.0,
                                  ),
                                ).marginOnly(left: 5.0, right: 5.0),
                              ),
                            ),
                          ],
                        )
                  //----------------------------------Job Source Container--------------
                      : Container(
                          height: 17,
                          width:44,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(2.0),
                            ),
                            border: Border.all(
                              color: source!.toLowerCase() == 'online'
                                  ? NewCommonColours.onlineContainerColor
                                  : source!.toLowerCase() == 'tv'
                                      ? NewCommonColours.tvContainerColor
                                      : source!.toLowerCase() == 'website' ||
                                              source!.toLowerCase() == 'blog'
                                          ? NewCommonColours.webContainerColor
                                          : source!.toLowerCase() == 'print'
                                              ? NewCommonColours.printContainerColor
                                              : source!.toLowerCase() ==
                                                      'Youtube'
                                                  ? NewCommonColours.onlineContainerColor
                                                  :NewCommonColours.onlineContainerColor
                            ),
                            // colors[widget.index],
                          ),
                          child: Center(
                            child: Text(
                              source!.toLowerCase() == 'online'
                                  ? " Video"
                                  : source!.toLowerCase() == 'website' ||
                                          source!.toLowerCase() == 'blog'
                                      ? "Web"
                                      : source!.toLowerCase() == 'print'?
                                  "Print"
                              :source!.toLowerCase() == 'tv'?"TV":
                              source!.toLowerCase() == 'youtube'
                                  ? " Video"     : source!.toUpperCase(),
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                letterSpacing: 0.4,
                                color: source!.toLowerCase() == 'online'
                                    ? NewCommonColours.onlineContainerColor
                                    : source!.toLowerCase() == 'tv'
                                        ? NewCommonColours.tvContainerColor
                                        : source!.toLowerCase() == 'website' ||
                                                source!.toLowerCase() == 'blog'
                                            ? NewCommonColours.webContainerColor
                                            : source!.toLowerCase() == 'print'
                                                ? NewCommonColours.printContainerColor
                                                : source!.toLowerCase() ==
                                                        'Online'
                                                    ? NewCommonColours.onlineContainerColor
                                                    : const Color(0xffFD8894),
                                fontSize: 9.0,
                              ),
                            ).marginOnly(left: 5.0, right: 5.0),
                          ),
                        ),
                  const SizedBox(
                    height: 7.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "$channelName",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9.0,
                                letterSpacing: 0.4,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      // CachedNetworkImage(
                      //   imageUrl: channelLogo!,
                      //   placeholder: (c, e) => Lottie.asset(
                      //       "assets/images/imgload.json",
                      //       fit: BoxFit.cover),
                      //   errorWidget: (c, e, r) => Lottie.asset(
                      //       "assets/images/imgload.json",
                      //       fit: BoxFit.cover),
                      //   width: 15,
                      //   height: 15,
                      //   fit: BoxFit.cover,
                      // ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 10.0,
                        color: Colors.white,
                      ).marginOnly(bottom: 7),
                      const SizedBox(
                        width: 3.0,
                      ),
                      Text(
                        "$date",
                        textScaleFactor: 1.0,
                        // showDate[widget.index],
                        style: const TextStyle(
                            color: Colors.white,
                            letterSpacing: 0.4,
                            fontFamily: 'Roboto',
                            fontSize: 9),
                      ).marginOnly(bottom: 5),
                      Container(
                        height: 3.0,
                        width: 3.0,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                      ).marginOnly(bottom: 5, left: 4, right: 4),
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Text(
                          "$time",
                          textScaleFactor: 1.0,
                          // showTime[widget.index],
                          style: const TextStyle(
                            color: Colors.white,
                            letterSpacing: 0.4,
                            fontSize: 9.0,
                          ),
                        ).marginOnly(bottom: 5),
                      ),
                    ],
                  ),
                ],
              ),
              //color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
