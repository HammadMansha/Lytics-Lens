import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lytics_lens/Constants/app_strrings.dart';
import 'package:lytics_lens/Controllers/perefrences_page_controller.dart';

class PreferencesPage extends StatelessWidget {
  const PreferencesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodyData(context),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(27, 29, 40, 1),
        title: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Change Preferences",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            )),
        elevation: 0.0,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.keyboard_backspace_rounded,
          ).marginOnly(left: 34),
        ),
      ),
    );
  }

  Widget bodyData(context) {
    return GetBuilder<PreferencesPageController>(
        init: PreferencesPageController(),
        builder: (_) {
          return Container(
            height: Get.height,
            width: Get.width,
            decoration: BoxDecoration(
                gradient: RadialGradient(colors: [
              const Color(0xff1b1d28).withOpacity(.95),
              const Color(0xff1b1d28),
            ])),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    height: 22,
                    width: 22,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/add.png')),
                        color: Color(0xff48BEEB),
                        shape: BoxShape.circle),
                  ),
                ).marginOnly(right: 25, top: 20),
                Center(
                  child: const Text(
                    AppStrings.chooseText,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.7,
                      color: Colors.white,
                    ),
                  ).marginOnly(bottom: 27, left: 40),
                ),
                Expanded(
                  child: RawScrollbar(
                    radius: const Radius.circular(5),
                    thickness: 4,
                    thumbColor: const Color(0xff48BEEB),
                    child: ListView.separated(
                        separatorBuilder: (context, index) => const Padding(
                              padding: EdgeInsets.only(bottom: 9),
                            ),
                        itemCount: _.topic.length,
                        itemBuilder: (c, i) {
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  _.currentindex = i;
                                  _.update();
                                },
                                child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: _.currentindex == i
                                            ? const Color(0xff48BEEB)
                                            : const Color(0xff1b1d28),
                                        border: Border.all(
                                            color: _.currentindex == i
                                                ? const Color(0xff48BEEB)
                                                : const Color(0xffBDBDBD),
                                            width: 1),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(4))),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('${_.topic[i]['name']}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white,
                                              )),
                                          const Spacer(),
                                          IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.expand_more,
                                                size: 18,
                                                color: _.currentindex == i
                                                    ? Colors.white
                                                    : const Color(0xffCCCCCC),
                                              ))
                                        ],
                                      ).marginOnly(
                                        left: 60,
                                      ),
                                    )).marginSymmetric(horizontal: 20),
                              ),
                              const SizedBox(
                                height: 1,
                              ),
                              _.currentindex == i
                                  ? Container(
                                      height: 160,
                                      decoration: const BoxDecoration(
                                          color: Color(0xff6F707E)),
                                      child: RawScrollbar(
                                        radius: const Radius.circular(5),
                                        thickness: 4,
                                        thumbColor: const Color(0xff48BEEB),
                                        child: ListView.separated(
                                            separatorBuilder: (context,
                                                    index) =>
                                                const Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 0)),
                                            itemCount: _.topic.length,
                                            itemBuilder: (context, index) =>
                                                InkWell(
                                                    onTap: () {
                                                      _.index = index;
                                                      _.update();
                                                    },
                                                    child: Container(
                                                      height: 23,
                                                      decoration: BoxDecoration(
                                                          color: _.index ==
                                                                  index
                                                              ? const Color(
                                                                  0xff48BEEB)
                                                              : const Color(
                                                                  0xff6F707E)),
                                                      child: Text(
                                                              '${_.topic[index]['name']}',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .white,
                                                              ))
                                                          .marginOnly(
                                                              left: 60,
                                                              top: 3.5),
                                                    )).marginOnly(top: 5)),
                                      ),
                                    ).marginOnly(
                                      left: 20, right: 20, bottom: 20)
                                  : Container(),
                            ],
                          );
                        }),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
