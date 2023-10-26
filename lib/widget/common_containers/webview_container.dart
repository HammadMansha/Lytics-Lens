import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../Constants/common_color.dart';
import '../common_textstyle/common_text_style.dart';

class WebViewContainer extends StatelessWidget {
  final List? imageurl;
  final String? channelLogo;
  final String? thumbnailPath;
  final String? programDes;
  final String? programDate;
  final String? source;
  final String? anchorName;
  final String? channelName;
  final String? programTime;
  final VoidCallback? onTap;
  final void Function()? onGestureTap;
  final String? userLength;
  final bool isSend;

  const WebViewContainer({
    Key? key,
    this.imageurl,
    this.channelLogo,
    this.thumbnailPath,
    this.programDes,
    this.programDate,
    this.source,
    this.anchorName,
    this.channelName,
    this.programTime,
    this.onTap,
    this.onGestureTap,
    this.userLength,
    this.isSend = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: Get.width,
          height: 250,
          child: imageurl!.isEmpty
              ? CachedNetworkImage(
            height: 250,
                  width: Get.width,
                  imageUrl: thumbnailPath!,
                  placeholder: (c, e) => Lottie.asset(
                      "assets/images/circular_loader_image.json",
                      fit: BoxFit.contain),
                  errorWidget: (c, e, r) {
                   return Container(
                      height: 225,
                      width: Get.width,
                      color: Colors.white,
                      child: Image.network(
                          "$channelLogo", fit: BoxFit.scaleDown)
                          .marginOnly(left: 7.0, right: 7.0),
                    );

                  },
                  fit: BoxFit.scaleDown,
                )
              : CarouselSlider.builder(
                  itemCount: imageurl!.length,
                  options: CarouselOptions(
                    autoPlay: true,
                    aspectRatio: 1.0,
                    enlargeCenterPage: false,
                  ),
                  itemBuilder: (context, index, realIdx) {
                    return CachedNetworkImage(

                      imageUrl: imageurl![index],
                      fit: BoxFit.fill,


                      placeholder: (c, e) => Lottie.asset(
                          "assets/images/default.jpeg",
                          fit: BoxFit.fill),
                      errorWidget: (c, e, r) => Lottie.asset(
                          "assets/images/default.jpeg",
                          fit: BoxFit.fill),
                    );
                  },
                ),
        ),
        // const SizedBox(
        //   height: 10.0,
        // ),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
        //   child: Divider(
        //     thickness: 2.0,
        //     height: 1.0,
        //     color: source!.toLowerCase() == 'website' ||
        //             source!.toLowerCase() == 'blog'
        //         ? const Color(0xffFFD76F)
        //         : source!.toLowerCase() == 'print'
        //             ? const Color(0xffB48AE8)
        //             : Colors.white,
        //   ),
        // ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Column(
        //       mainAxisAlignment: MainAxisAlignment.end,
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         // SizedBox(
        //         //   width: Get.width / 1.3,
        //         //   // child: Text(
        //         //   //   "$programDes",
        //         //   //   textScaleFactor: 1.0,
        //         //   //   maxLines: 2,
        //         //   //   overflow: TextOverflow.ellipsis,
        //         //   //   style: TextStyle(
        //         //   //     color: Colors.white,
        //         //   //     fontSize: 16.0,
        //         //   //     letterSpacing: 0.4,
        //         //   //     fontWeight: FontWeight.w500,
        //         //   //   ),
        //         //   // ),
        //         //   child: ExpandableText("$programDes",
        //         //       expandText: 'Show More',
        //         //       collapseText: 'Show Less',
        //         //       maxLines: 3,
        //         //       textDirection: RegExp(r'^[a-zA-Z _@./#;&+-]*$').hasMatch(
        //         //                   programDes!.trim().split(' ').first) ==
        //         //               true
        //         //           ? TextDirection.ltr
        //         //           : TextDirection.rtl,
        //         //       animation: true, onLinkTap: () {
        //         //     showMyDialog(context, programDes!, source!);
        //         //   },
        //         //       animationDuration: const Duration(seconds: 3),
        //         //       linkStyle: TextStyle(
        //         //           fontWeight: FontWeight.w500,
        //         //           letterSpacing: 0.4,
        //         //           fontFamily: 'Roboto',
        //         //           fontSize: 13,
        //         //           color: source!.toLowerCase() == 'website' ||
        //         //                   source!.toLowerCase() == 'blog'
        //         //               ? const Color(0xffFFD76F)
        //         //               : source!.toLowerCase() == 'print'
        //         //                   ? const Color(0xffB48AE8)
        //         //                   : Colors.white),
        //         //       style: RegExp(r'^[a-zA-Z _@./#;&+-]*$').hasMatch(
        //         //                   programDes!.trim().split(' ').first) ==
        //         //               true
        //         //           ? CommonTextStyle.englishPlayerScreenHeading
        //         //           : CommonTextStyle.urduPlayerScreenHeading),
        //         // ),
        //       ],
        //     ).marginOnly(top: 10.0),
        //     Container(
        //       decoration: BoxDecoration(
        //         borderRadius: const BorderRadius.only(
        //           bottomLeft: Radius.circular(2.0),
        //           bottomRight: Radius.circular(2.0),
        //         ),
        //         color: source!.toLowerCase() == 'website' ||
        //                 source!.toLowerCase() == 'blog'
        //             ? const Color(0xffFFD76F)
        //             : source!.toLowerCase() == 'print'
        //                 ? const Color(0xffB48AE8)
        //                 : Colors.white,
        //       ),
        //       child: Text(
        //         source!.toLowerCase() == 'website' ||
        //                 source!.toLowerCase() == 'blog'
        //             ? 'WEB  '
        //             : '${source!.toUpperCase()}  ',
        //         style: TextStyle(
        //           color: source!.toLowerCase() == 'website' ||
        //                   source!.toLowerCase() == 'blog'
        //               ? Colors.black
        //               : Colors.white,
        //           fontSize: 10.0,
        //           letterSpacing: 0.4,
        //           fontWeight: FontWeight.w400,
        //           fontFamily: 'Roboto',
        //         ),
        //       ).paddingOnly(left: 10.0, right: 2.0, top: 5.0, bottom: 5.0),
        //     )
        //   ],
        // ).marginOnly(left: 15.0, right: 15.0),
        // const SizedBox(
        //   height: 10.0,
        // ),
        // Row(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     mainAxisAlignment: MainAxisAlignment.start,
        //     children: [
        //       const Icon(
        //         Icons.access_time,
        //         size: 10.0,
        //         color: Colors.white,
        //       ).marginOnly(bottom: 0),
        //       const SizedBox(
        //         width: 5.0,
        //       ),
        //       Text(
        //         "$programDate",
        //         textScaleFactor: 1.0,
        //         style: const TextStyle(
        //           color: Color(0xffd3d3d3),
        //           fontSize: 9.5,
        //           fontWeight: FontWeight.w400,
        //           letterSpacing: 0.4,
        //         ),
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.only(left: 3, right: 3, top: 4),
        //         child: Image.asset(
        //           "assets/images/dot2.png",
        //           height: 3,
        //           width: 3,
        //         ),
        //       ),
        //       const SizedBox(
        //         width: 2.0,
        //       ),
        //       Text(
        //         "$programTime",
        //         style: const TextStyle(
        //           color: Colors.white,
        //           letterSpacing: 0.4,
        //           fontSize: 10,
        //         ),
        //       ),
        //       Container(
        //         height: 10,
        //         width: 1,
        //         color: const Color(0xffC4C4C4),
        //       ).marginSymmetric(horizontal: 8),
        //       Text(
        //         "$channelName",
        //         textScaleFactor: 1.0,
        //         style: const TextStyle(
        //           color: Color(0xffd3d3d3),
        //           fontSize: 9.5,
        //           fontWeight: FontWeight.w400,
        //           letterSpacing: 0.4,
        //         ),
        //       ),
        //       const Spacer(),
        //       isSend
        //           ? Row(
        //               children: [
        //                 GestureDetector(
        //                   onTap: onGestureTap,
        //                   child: Text(
        //                     '$userLength',
        //                     style: const TextStyle(
        //                       fontSize: 12.0,
        //                       color: CommonColor.whiteColor,
        //                       fontWeight: FontWeight.bold,
        //                       fontFamily: 'Roboto',
        //                     ),
        //                   ),
        //                 ),
        //                 const SizedBox(
        //                   width: 3.0,
        //                 ),
        //                 GestureDetector(
        //                   onTap: onGestureTap,
        //                   child: const Icon(
        //                     Icons.remove_red_eye_outlined,
        //                     color: CommonColor.whiteColor,
        //                     size: 18,
        //                   ),
        //                 ),
        //               ],
        //             )
        //           : const SizedBox(),
        //       SizedBox(
        //         width: isSend ? 15.0 : 0.0,
        //       ),
        //       InkWell(
        //         onTap: onTap,
        //         child: Column(children: [
        //           SizedBox(
        //               height: 15,
        //               width: 15,
        //               child: Image.asset(
        //                 "assets/images/shareicon.png",
        //               )),
        //           const SizedBox(
        //             height: 5,
        //           ),
        //           const Text(
        //             "Share",
        //             style: TextStyle(
        //               color: Color(0xff22B161),
        //               fontSize: 9,
        //               fontWeight: FontWeight.w400,
        //             ),
        //           )
        //         ]),
        //       ),
        //     ]).marginOnly(left: 15.0, right: 15.0),
      ],
    );
  }

  Future<void> showMyDialog(context, String description, String source) async {
    return showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xff131C3A),
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: source.toLowerCase() == 'website' ||
                        source.toLowerCase() == 'blog'
                    ? const Color(0xffFFD76F)
                    : source.toLowerCase() == 'print'
                        ? const Color(0xffB48AE8)
                        : Colors.white),
          ),
          actions: [
            MaterialButton(
              onPressed: () async {
                Get.back();
              },
              minWidth: Get.width / 3.5,
              height: 38,
              child: const Text(
                "CLOSE",
                textScaleFactor: 1.0,
                style: TextStyle(
                    color: CommonColor.cancelButtonColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ],
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
            description,
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
}
