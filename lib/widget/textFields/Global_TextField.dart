// ignore_for_file: file_names, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';

class GlobalTextField extends StatelessWidget {
  final control;
  final validation;
  final String? hint;
  final TextInputAction? textInputAction;
  final bool secure;

  GlobalTextField(
    this.control,
    this.validation,
    this.hint,
    this.textInputAction,
    this.secure,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      width: Get.width,
      child: TextFormField(
        obscureText: secure,
        controller: control,
        validator: validation,
        textInputAction: textInputAction,
        style: const TextStyle(color: Colors.white, fontSize: 11),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color.fromRGBO(45, 47, 58, 1),
          contentPadding: const EdgeInsets.all(10.0),
          isDense: true,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
        ),
      ),
    );
  }
}
