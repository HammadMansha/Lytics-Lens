// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lytics_lens/Constants/common_color.dart';

class NoDataFound extends StatelessWidget {
  final Function() onPressed;

  const NoDataFound({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Center(
          //   child: Container(
          //     width: Get.width / 2.0,
          //     height: Get.height / 8,
          //     decoration: const BoxDecoration(
          //       image: DecorationImage(
          //         image: AssetImage(
          //           'assets/images/no_server.png',
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'No data available',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          // const Text(
          //   'Tap to check for new jobs',
          //   style: TextStyle(
          //     fontFamily: 'Roboto',
          //     fontSize: 11.0,
          //     color: Colors.white,
          //     fontWeight: FontWeight.w400,
          //   ),
          // ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: Get.width/2.3,
            height: 48,
            decoration: BoxDecoration(
                border: Border.all(color:NewCommonColours.greenButton),
                color: NewCommonColours.greenButton,
                borderRadius: BorderRadius.circular(5.0)),
            child: const Center(
              child: Text(
                'Tap to check for new jobs',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 10.0,
                  color: Colors.white,
                  letterSpacing: 0.4,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          )
        ],
      ).marginOnly(left: 20.0, right: 20.0),
    );
  }
}
