import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lytics_lens/Constants/common_color.dart';
import 'package:lytics_lens/widget/common_button/common_button.dart';
import 'package:lytics_lens/widget/common_textstyle/common_text_style.dart';

class InterConnectivity extends StatelessWidget {
  final Function() onPressed;

  const InterConnectivity({
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
            width: 200,
            height: 200,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/no_wifi.png',
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 27,
        ),
        const Text(
          'No internet connection.',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 11.0,
            color: Colors.white,
            letterSpacing: 0.4,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 2.0,
        ),
        const Text(
          'Please connect to the internet and try again.',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 11.0,
            color: Colors.white,
            letterSpacing: 0.4,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 27,
        ),
        CommonButton(text: 'Try Again', textStyle: NewTextStyle.font15Weight500, onPressed: onPressed, fillColor: NewCommonColours.greenButton),
      ],
    );
  }
}
