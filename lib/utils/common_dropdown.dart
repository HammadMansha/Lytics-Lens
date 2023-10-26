// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_typing_uninitialized_variables, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lytics_lens/widget/textFields/Global_TextField.dart';

class CommonDropDownField extends StatefulWidget {
  final TextEditingController controller;
  final String placeholder;
  final String? hinttext;
  final Color? fillcolor;
  final Color? bordercolor;
  final List values;
  final checkedvalue;
  final String listMapName;
  final String listMapId;
  final dynamic screenController;
  final flex;
  final readOnly;
  final doCallback;

  CommonDropDownField({
    required this.controller,
    this.placeholder = "",
    required this.values,
    this.bordercolor,
    this.fillcolor,
    this.hinttext,
    this.checkedvalue,
    this.listMapName = 'name',
    this.listMapId = 'id',
    @required this.screenController,
    this.flex = 1,
    this.readOnly = false,
    this.doCallback,
  });

  @override
  State<CommonDropDownField> createState() => _CommonDropDownFieldState();
}

class _CommonDropDownFieldState extends State<CommonDropDownField> {
  @override
  Widget build(context) {
    TextEditingController terminalName = TextEditingController();
    if (widget.readOnly) {
      for (var list in widget.values) {
        if (widget.checkedvalue.text == list[widget.listMapId]) {
          terminalName.text = list[widget.listMapName];
        }
      }
    }

    return widget.readOnly == false
        ? SizedBox(
            width: Get.width,
            height: 30,
            child: InputDecorator(
              baseStyle: const TextStyle(fontSize: 10),
              decoration: InputDecoration(
                hintText: widget.placeholder,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
                focusColor: Colors.black,
                hoverColor: Colors.black,
                // labelText: placeholder,
                // hintText: hinttext,
                filled: true,
                fillColor: widget.fillcolor ?? Colors.transparent,
                hintStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Roboto',
                    letterSpacing: 0.0),
                // border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: widget.bordercolor ?? Colors.white, width: 1.0),
                ),
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(2.0),
                    ),
                    borderSide: BorderSide(width: 1.0)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(2.0),
                  ),
                  borderSide: BorderSide(
                      color: widget.bordercolor ?? Colors.white, width: 3.0),
                ),
                labelStyle:
                    const TextStyle(color: Colors.white, fontSize: 12.0),
                // fillColor: Colors.white,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  dropdownColor: const Color(0xff6f707e),
                  icon: const Icon(Icons.keyboard_arrow_down,
                      color: Color(0xffabb4bd)),
                  style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Roboto'),
                  value: widget.checkedvalue.text != ''
                      ? widget.checkedvalue.text
                      : widget.values[0][widget.listMapId].toString(),
                  isDense: true,
                  isExpanded: true,
                  items: widget.values.map((list) {
                    return DropdownMenuItem(
                      value: list[widget.listMapId].toString(),
                      child: list[widget.listMapName] != ''
                          ? Text(
                              '${list[widget.listMapName]}',
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              maxLines: 1,
                              style: const TextStyle(
                                  fontSize: 13.0,
                                  letterSpacing: 0.4,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'Roboto'),
                            )
                          : const Text('notfound'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      widget.controller.text = value.toString();
                    });

                    widget.doCallback != null
                        ? widget.doCallback()
                        : print('no callback');
                  },
                ),
              ),
            ),
          )
        : GlobalTextField(
            widget.controller,
            (value) {},
            "",
            TextInputAction.next,
            false,
          );
  }
}
