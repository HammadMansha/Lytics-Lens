// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final void Function() onPressed;
  final Color fillColor;
   final double width;

  // ignore: use_key_in_widget_constructors
  const CommonButton({
    required this.text,
    required this.textStyle,
    required this.onPressed,
    required this.fillColor,
    this.width=125,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //color: CommonColor.loginAndSendCodeButtonColor,
      width: width,
      height: 45,
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
          side:  BorderSide(
            color: const Color(0xff0c473c).withOpacity(0.29),
          ),
        ),

        onPressed: onPressed,
        // minWidth: Get.width / 3,
        // height: 42,
        // color: Color.fromRGBO(72, 190, 235, 1),
        color: fillColor?? Colors.transparent,
        child: Text(
          text,
          textScaleFactor: 1.0,
          style: textStyle,
          maxLines: 2,
        ),
      ),
    );
  }
}



class CommonFilterButton extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final void Function() onPressed;
  final Color fillColor;

  // ignore: use_key_in_widget_constructors
  const CommonFilterButton({
    required this.text,
    required this.textStyle,
    required this.onPressed,
    required this.fillColor
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //color: CommonColor.loginAndSendCodeButtonColor,
      width: 125,
      height: 35,
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side:  const BorderSide(
            color: Colors.transparent,
          ),
        ),

        onPressed: onPressed,
        // minWidth: Get.width / 3,
        // height: 42,
        // color: Color.fromRGBO(72, 190, 235, 1),
        color: fillColor?? Colors.transparent,
        child: Text(
          text,

          textScaleFactor: 1.0,
          style: textStyle,
          maxLines: 2,
        ),
      ),
    );
  }
}
