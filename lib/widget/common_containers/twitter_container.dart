import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:lytics_lens/widget/common_textstyle/common_text_style.dart';

class TwitterContainer extends StatelessWidget {
  final String? thumbnail;
  final String? username;
  final String? programUser;
  final String? content;
  final String? topic;
  final String? time;
  final String? date;
  final bool isUrdu;
  final bool isShare;
  final String? source;
  final void Function()? onTap;
  final void Function()? onContainerTap;

  const TwitterContainer(
      {Key? key,
      this.thumbnail,
      this.username,
      this.programUser,
      this.content,
      this.topic,
      this.time,
      this.isUrdu = false,
      this.isShare = false,
      this.source,
      this.onTap,
      this.onContainerTap,
      this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onContainerTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Color(0xff0A0D29),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: thumbnail!,
                    placeholder: (c, e) => Lottie.asset(
                        "assets/images/circular_loader_image.json",
                        fit: BoxFit.cover),
                    errorWidget: (c, e, r) => Lottie.asset(
                        "assets/images/circular_loader_image.json",
                        fit: BoxFit.cover),
                    fit: BoxFit.cover,
                    height: 15.0,
                    width: 15.0,
                  ),
                ).marginOnly(top: 6.0),
                const SizedBox(
                  width: 7,
                ),
                programUser!.contains('@')
                    ? SizedBox(
                  width: Get.width / 1.4,
                      child: Text(
                          "$username - $programUser",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            letterSpacing: 0.4,
                            fontSize: 12.0,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                          ),
                        ).marginOnly(top: 6.0),
                    )
                    : SizedBox(
                  width: Get.width / 1.4,
                      child: Text(
                          "$username - @$programUser",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            letterSpacing: 0.4,
                            fontSize: 12.0,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                          ),
                        ).marginOnly(top: 6.0),
                    ),
                const Spacer(),
                Container(
                  height: 17,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.0),
                    border: Border.all(
                      color: const Color(0xffF26A32),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      source!.toUpperCase(),
                      textScaleFactor: 1.0,
                      style: const TextStyle(
                          color: Color(0xffF26A32),
                          fontWeight: FontWeight.w500,
                          fontSize: 9.0),
                    ).marginOnly(left: 5.0, right: 5.0),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5.0,
            ),
            Align(
              alignment: isUrdu ? Alignment.topRight : Alignment.topLeft,
              child: ExpandableText(
                "$content",
                style: isUrdu
                    ? CommonTextStyle.urduStyle
                    : CommonTextStyle.englishStyle,
                expandText: 'Read more',
                textAlign: isUrdu ? TextAlign.start : null,
                textDirection: isUrdu ? TextDirection.rtl : null,
                collapseText: "Read less",
                maxLines: 4,
                linkColor: const Color(0xffF26A32),
                animation: true,
                animationDuration: const Duration(seconds: 3),
              ).marginOnly(right: 6.0),
            ),
            const SizedBox(
              height: 6.0,
            ),
            Row(
              children: [
                SizedBox(
                  width: Get.width / 2,
                  child: Text(
                    "$topic",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xffF26A32),
                      fontSize: 12,
                      fontFamily: 'Roboto',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
                const Spacer(),
                isShare
                    ? GestureDetector(
                        onTap: onTap,
                        child: SizedBox(
                          height: 20,
                          width: 28,
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/video-share.png',
                                width: 10.0,
                              ),
                              const Spacer(),
                              const Text(
                                "Share",
                                style: TextStyle(
                                    color: Color(0xff22B161),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 8.0,
                                    letterSpacing: 0.4),
                              )
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(
                  width: 3.0,
                ),
                SizedBox(
                  child: Row(
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
                          fontSize: 9,
                        ),
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
                )
              ],
            ),
            const SizedBox(
              height: 2.0,
            )
          ],
        ).marginOnly(left: 12.0),
      ),
    );
  }
}
