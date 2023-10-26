// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CommonTabBar extends StatelessWidget {
  final Function() onPressed;
  final double height;
  final String? title;
  final Color containerFillColor;
  final Color textColor;

  const CommonTabBar({
    Key? key,
    required this.onPressed,
    required this.title,
    this.height = 40,
    this.containerFillColor = Colors.transparent,
    this.textColor = Colors.white24,
    // this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 80,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          border: Border.all(color: containerFillColor),
          //color: containerFillColor,
        ),
        child: Center(
          child: Text(
            "$title",
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}
