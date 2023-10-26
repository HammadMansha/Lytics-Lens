// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lytics_lens/Constants/common_color.dart';
import 'package:lytics_lens/widget/common_button/common_button.dart';
import 'package:lytics_lens/widget/common_textstyle/common_text_style.dart';

class TapToLoad extends StatelessWidget {
  final Function() onPressed;

  const TapToLoad({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Container(
            width: Get.width / 2.0,
            height: Get.height / 4,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/no_server.png',
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Could not connect to the server.',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 11.0,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        const Text(
          'Please try again.',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 11.0,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(
          height: 39,
        ),
        CommonButton(text: "Try Again", textStyle: NewTextStyle.font15Weight500, onPressed: onPressed, fillColor: NewCommonColours.greenButton)
        

      ],
    ).marginOnly(left: 20.0, right: 20.0);
  }
}
