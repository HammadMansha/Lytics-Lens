// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Constants/common_color.dart';
import '../../utils/commoncolor.dart';

var searchText;

// ignore: must_be_immutable
class SearchField extends StatelessWidget {
  // final control;
  // final List <dynamic> textForSearch=[];
  TextEditingController serController = TextEditingController();
  final void Function(String)? onChanged;
  final String text;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onTap;
  final void Function()? onIconTap;
  final void Function()? onSearchIconTap;

  SearchField(this.serController, this.onChanged, this.text,
      this.onFieldSubmitted, this.onTap, this.onIconTap, this.onSearchIconTap,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 38,
      decoration:  BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
          color:NewCommonColours.searchTextFieldColor
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 0.0, bottom: 0.0, right: 0.0, left: 0.0),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            // GestureDetector(
            //   onTap: onTap,
            //   child: Container(
            //     height: 20.0,
            //     width: 20.0,
            //     decoration: BoxDecoration(
            //         image: DecorationImage(
            //             image: AssetImage("assets/images/search.png"),
            //             fit: BoxFit.contain)),
            //   ),
            // ),

            TextFormField(
              controller: serController,
              textAlignVertical: TextAlignVertical.center,
              style: const TextStyle(color: Colors.white, fontSize: 15.0),
              cursorColor: Colors.green,
              cursorHeight: 20,
              onChanged: onChanged,
              onFieldSubmitted: onFieldSubmitted,
              inputFormatters: [LengthLimitingTextInputFormatter(64)],
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(right: 110),
                hintText: "Search",
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(
                      top: 8, left: 0, right: 0, bottom: 10),
                  child: GestureDetector(
                    onTap: onSearchIconTap,
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: Image.asset("assets/images/search-green.png"),
                    ),
                  ),
                ),
                isDense: true,
                hintStyle: const TextStyle(color: Color(0xFFD3D3D3)),
                border: InputBorder.none,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                        color: Color(0xFFD3D3D3),
                        fontSize: 10.0,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.4),
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  GestureDetector(
                    onTap: onIconTap,
                    child: const Icon(
                      Icons.clear,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildCustomPrefixIcon() {
    return Container(
      width: 0,
    );
  }
}
