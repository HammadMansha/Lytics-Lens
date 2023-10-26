import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../Constants/common_color.dart';

class HeadlineContainer extends StatelessWidget {
  final int? colorCode;
  final bool isHeadline;
  final String? channelName;
  final String? headlinetype;
  final String? title;

  const HeadlineContainer(
      {Key? key,
      this.colorCode,
      this.isHeadline = false,
      this.channelName,
      this.headlinetype,
      this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      height: 20.0,
      constraints: const BoxConstraints(
        maxHeight: double.infinity,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: colorCode.toString() == ''
              ? const Color(0xff48beeb)
              : Color(colorCode!),
        ),
        color: isHeadline ? Colors.transparent : const Color(0xff24252D),
      ),
      child: isHeadline
          ? Lottie.asset("assets/images/imgload.json",
              height: 90, width: Get.width / 2.5, fit: BoxFit.fill)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$channelName News",
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.4,
                        color: colorCode.toString() == ''
                            ? const Color(0xff48beeb)
                            : Color(colorCode!),
                      ),
                    ).marginOnly(left: 5, top: 5),
                    const Spacer(),
                    Container(
                      width: 56,
                      height: 15,
                      decoration: BoxDecoration(
                        color: colorCode.toString() == ''
                            ? const Color(0xff48beeb)
                            : Color(colorCode!),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(2.0),
                            bottomLeft: Radius.circular(2.0)),
                      ),
                      child: Center(
                        child: Text(
                          "$headlinetype",
                          style: const TextStyle(
                              fontSize: 8,
                              letterSpacing: 0.4,
                              color: Color(0xff1D1F2A)),
                        ),
                      ),
                    )
                  ],
                ),
                ExpandableText(
                  "$title",
                  expandText: 'Show More',
                  collapseText: 'Show Less',
                  maxLines: 3,
                  animation: true,
                  onLinkTap: () {
                    showMyDialog(context, title!, channelName!, colorCode);
                  },
                  animationDuration: const Duration(seconds: 3),
                  linkStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.4,
                      fontFamily: 'Roboto',
                      fontSize: 13,
                      color: Colors.blue),
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.4,
                      fontFamily: 'Roboto',
                      fontSize: 13,
                      color: Colors.white),
                ).marginOnly(top: 13, left: 8),
                const SizedBox(
                  height: 2.0,
                ),
              ],
            ).marginOnly(bottom: 5.0),
    ).marginOnly(left: 3);
  }

  Future<void> showMyDialog(
      context, String news, String channel, int? colorCode) async {
    return showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xff131C3A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: BorderSide(
              color: colorCode.toString() == ''
                  ? const Color(0xff48beeb)
                  : Color(colorCode!),
            ),
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
          title: Text(
            '$channel News',
            textScaleFactor: 1.0,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              letterSpacing: 0.4,
              fontFamily: 'Roboto',
            ),
          ),
          content: Text(
            news,
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
