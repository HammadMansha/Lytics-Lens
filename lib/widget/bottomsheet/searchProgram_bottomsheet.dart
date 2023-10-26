import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lytics_lens/Constants/common_color.dart';
import 'package:lytics_lens/widget/common_textstyle/common_text_style.dart';

import '../../Controllers/searchbar_controller.dart';

class ShowProgramSheet{
  static void showBottomSheet({required SearchBarController cntrl,}){
    Get.bottomSheet(
      Column(
        children: [
          const SizedBox(
            height: 10.0,
          ),
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              height: 5.0,
              width: 60.0,
              decoration: BoxDecoration(
                  color: CommonColor.filterColor,
                  borderRadius: BorderRadius.circular(10.0)),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Expanded(
            child: ListView.separated(
              itemCount: cntrl.programType.length,
              shrinkWrap: true,
              separatorBuilder: (c, e) {
                return const SizedBox(
                  width: 20.0,
                );
              },
              itemBuilder: (c, i) {
                return InkWell(
                  splashColor: const Color(0xff22B161),
                  hoverColor: const Color(0xff22B161),
                  focusColor: const Color(0xff22B161),
                  onTap: () {
                    if (cntrl.programType[i].check.value == false) {
                      cntrl.programType[i].check.value = true;
                      cntrl.filterlist.add(cntrl.programType[i].name);
                      cntrl.filterProgramType.add(cntrl.programType[i].name);
                    } else {
                      cntrl.programType[i].check.value = false;
                      cntrl.filterProgramType.removeWhere(
                              (item) => item == cntrl.programType[i].name);
                      cntrl.filterlist.removeWhere(
                              (item) => item == cntrl.programType[i].name);
                      cntrl.update();
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Theme(
                        data: ThemeData(unselectedWidgetColor: Colors.white),
                        child: Obx(
                              () => Checkbox(
                            visualDensity: const VisualDensity(
                                horizontal: -3.5, vertical: -2.5),
                            materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                            side: const BorderSide(
                                width: 1.0, color: CommonColor.filterColor),
                            activeColor: CommonColor.greenColor,
                            focusColor: CommonColor.filterColor,
                            hoverColor: CommonColor.filterColor,
                            value: cntrl.programType[i].check.value,
                            onChanged: (val) {
                              if (cntrl.programType[i].check.value == false) {
                                cntrl.programType[i].check.value = true;
                                cntrl.filterlist.add(cntrl.programType[i].name);
                                cntrl.filterProgramType.add(cntrl.programType[i].name);
                              } else {
                                cntrl.programType[i].check.value = false;
                                cntrl.filterProgramType.removeWhere(
                                        (item) => item == cntrl.programType[i].name);
                                cntrl.filterlist.removeWhere(
                                        (item) => item == cntrl.programType[i].name);
                                cntrl.update();
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Flexible(
                          child: Text(
                            "${cntrl.programType[i].name}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:GoogleFonts.roboto(
                                color: Colors.white,
                                letterSpacing: 0.4,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w300),
                          )),
                    ],
                  ),
                );
              },
            ).marginOnly(left: 20.0, right: 20.0),
          ),
        ],
      ),
      backgroundColor: CommonColor.backgroundColour,
    );
  
  }
}