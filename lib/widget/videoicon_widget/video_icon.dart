import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lytics_lens/Constants/common_color.dart';

class VideoIcon extends StatelessWidget {
  const VideoIcon({Key? key, required this.onTap, required this.title})
      : super(key: key);

  final void Function() onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 107.0,
        height: 30,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: 25,
                width: 90,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0)),
                  color: CommonColor.whiteColor,
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    // 'Full Video',
                    title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0,
                    ),
                  ),
                ).marginOnly(
                  right: 5.0,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
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
            ),
          ],
        ),
      ),
    );
  }
}
