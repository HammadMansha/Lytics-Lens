import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lytics_lens/Constants/common_color.dart';
import 'package:lytics_lens/views/Search_Screen.dart';
import '../Controllers/searchScreen_controller.dart';
import '../Controllers/searchbar_controller.dart';
import '../widget/bottomsheet/filter_bottimsheet.dart';
import '../widget/internet_connectivity/internetconnectivity_screen.dart';

class SearchBarView extends StatelessWidget {
  const SearchBarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xff000425),

      // bottomNavigationBar: GlobalBottomNav(),
      body: SafeArea(child: bodyData(context)),
    );
  }

  Widget bodyData(context) {
    final mqData = MediaQuery.of(context);
    final mqDataNew = mqData.copyWith(
        textScaleFactor:
            mqData.textScaleFactor > 1.0 ? 1.0 : mqData.textScaleFactor);

    return GetBuilder<SearchBarController>(
      init: SearchBarController(),
      builder: (_) {
        return MediaQuery(
          data: mqDataNew,
          child: Container(
            // decoration: BoxDecoration(
            //   gradient: RadialGradient(
            //     colors: [
            //       Color(0xff1b1d28).withOpacity(.95),
            //       Color(0xff1b1d28),
            //     ],
            //   ),
            //color: const Color(0xff000425),

            // color: Color.fromRGBO(27, 29, 40, 1),
            height: Get.height,
            width: Get.width,
            child: GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                    _.isShowList = false;
                    _.update();
                  }
                },
                onVerticalDragCancel: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                    _.isShowList = false;
                    _.update();
                  }
                },
                child: _.isSocket
                    ? InterConnectivity(
                        onPressed: () async {
                          await _.gettopic();
                          // _.getHeadlines();
                        },
                      )
                    : Obx(
                        () => SingleChildScrollView(
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _.isLoading.value
                                  ? Center(
                                      child: Image.asset(
                                        "assets/images/gif.gif",
                                        height: 300.0,
                                        width: 300.0,
                                      ),
                                    ).marginOnly(top: 140)
                                  : SingleChildScrollView(
                                      child: GestureDetector(
                                        onTap: () {
                                          _.isShowList = false;
                                          _.update();
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            _.isShowList == false
                                                ? Container(
                                                    height: 90,
                                                    width: Get.width,
                                                    decoration:
                                                        const BoxDecoration(
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                            "assets/images/new_logo.png"),
                                                      ),
                                                    ),
                                                  ).marginOnly(
                                                    left: 88,
                                                    right: 88,
                                                    top: 200)
                                                : const SizedBox(),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: 330,
                                                  width: _.isShowList == false
                                                      ? Get.width / 1.2
                                                      : Get.width / 1.06,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(20.0),
                                                      topLeft:
                                                          Radius.circular(20.0),
                                                    ),
                                                    color: _.isShowList
                                                        ? NewCommonColours
                                                            .searchSuggestionBoxColor
                                                        : Colors.transparent,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        height: 42,
                                                        width: Get.width,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .only(
                                                            topRight:
                                                                Radius.circular(
                                                                    20.0),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    20.0),
                                                            topLeft:
                                                                Radius.circular(
                                                                    20.0),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    20.0),
                                                          ),
                                                          color: NewCommonColours
                                                              .searchTextFieldColor,
                                                        ),
                                                        child: Row(
                                                          children: <Widget>[
                                                            GestureDetector(
                                                                    onTap:
                                                                        () async {
                                                                      if (_
                                                                              .searchText
                                                                              .value
                                                                              .text
                                                                              .isEmpty &&
                                                                          _.searchText.value.text ==
                                                                              '') {
                                                                      } else {
                                                                        _.isShowList =
                                                                            false;
                                                                        _.update();
                                                                        // Get.delete<
                                                                        //     SearchController>();
                                                                        Get.to(() =>
                                                                            const SearchScreen());
                                                                        await _.getFilterJobs(
                                                                            _.searchText.value.text,
                                                                            1);
                                                                        if (kDebugMode) {
                                                                          print(
                                                                              "Check Data ${Get.currentRoute}");
                                                                        }
                                                                      }
                                                                    },
                                                                    child: Image
                                                                        .asset(
                                                                      "assets/images/search-green.png",
                                                                      height:
                                                                          15,
                                                                      width: 15,
                                                                      fit: BoxFit
                                                                          .fill,
                                                                    ))
                                                                .marginOnly(
                                                                    left: 20.0,
                                                                    top: 9,
                                                                    bottom: 10,
                                                                    right: 3.0),
                                                            Expanded(
                                                              child:
                                                                  TextFormField(
                                                                cursorColor:
                                                                    CommonColor
                                                                        .greenColor,
                                                                textAlignVertical:
                                                                    TextAlignVertical
                                                                        .center,
                                                                style: GoogleFonts.roboto(
                                                                    color: Colors
                                                                        .white),
                                                                controller: _
                                                                    .searchText
                                                                    .value,
                                                                onFieldSubmitted:
                                                                    (String
                                                                        c) async {
                                                                  if (_
                                                                      .searchText
                                                                      .value
                                                                      .text
                                                                      .isEmpty) {
                                                                  } else {
                                                                    _.isShowList =
                                                                        false;
                                                                    _.update();
                                                                    // Get.delete<
                                                                    //     SearchController>();
                                                                    // Get.to(
                                                                    //     () =>
                                                                    //         const SearchScreen(),
                                                                    //     arguments: _
                                                                    //         .searchText
                                                                    //         .text);
                                                                    Get.to(() =>
                                                                        const SearchScreen());
                                                                    await _.getFilterJobs(
                                                                        _
                                                                            .searchText
                                                                            .value
                                                                            .text,
                                                                        1);
                                                                  }
                                                                },
                                                                keyboardType:
                                                                    TextInputType
                                                                        .text,
                                                                onTap: () {
                                                                  _.isShowList =
                                                                      true;
                                                                  _.update();
                                                                },
                                                                decoration:
                                                                    InputDecoration(
                                                                  // prefixIcon: Icon(Icons.search),
                                                                  // prefixIcon: Image.asset(
                                                                  // "assets/images/search-green.png",
                                                                  //
                                                                  // //fit: BoxFit.none,
                                                                  // ).marginOnly(),

                                                                  // ).marginOnly(left: 20,top: 9,bottom: 9,right: 11),
                                                                  hintText:
                                                                      "Search",
                                                                  fillColor:
                                                                      NewCommonColours
                                                                          .searchTextFieldColor,
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  hintStyle:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Color(
                                                                        0xff9b9b9b),
                                                                  ),
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: NewCommonColours
                                                                          .searchTextFieldColor,
                                                                    ),
                                                                    borderRadius:
                                                                        const BorderRadius
                                                                            .all(
                                                                      Radius.circular(
                                                                          20),
                                                                    ),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: NewCommonColours
                                                                          .searchTextFieldColor,
                                                                    ),
                                                                    borderRadius:
                                                                        const BorderRadius
                                                                            .all(
                                                                      Radius.circular(
                                                                          20),
                                                                    ),
                                                                  ),
                                                                  filled: true,
                                                                ),
                                                                onChanged: (v) {
                                                                  _.searchFunction(
                                                                      v);
                                                                },
                                                              ).marginOnly(
                                                                      left:
                                                                          10.0),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                _.searchText
                                                                    .value
                                                                    .clear();
                                                                _.isShowList =
                                                                    true;
                                                                _.searchtopiclist
                                                                    .clear();
                                                                _.update();
                                                              },
                                                              child: _
                                                                      .searchText
                                                                      .value
                                                                      .text
                                                                      .isEmpty
                                                                  ? const SizedBox()
                                                                  : Row(
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                          "assets/images/cross-green.png",
                                                                          height:
                                                                              12,
                                                                          width:
                                                                              12,
                                                                          fit: BoxFit
                                                                              .fill,
                                                                        ),
                                                                        VerticalDivider(
                                                                          width:
                                                                              3,
                                                                          color:
                                                                              Colors.grey,
                                                                        ).marginSymmetric(
                                                                            horizontal:
                                                                                5),
                                                                      ],
                                                                    ),
                                                            ).marginOnly(
                                                                left: 20.0,
                                                                top: 9,
                                                                bottom: 10,
                                                                right: 0.0),
                                                            GestureDetector(
                                                              onTap: () {
                                                                FilterBottomSheet
                                                                    .showBottomSheet(
                                                                        cntrl:
                                                                            _);
                                                              },
                                                              child:
                                                                  Image.asset(
                                                                "assets/images/search_filter.png",
                                                                height: 12,
                                                                width: 16,
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                            ).marginOnly(
                                                                right: 10,
                                                                left: 5)
                                                          ],
                                                        ),
                                                      ),
                                                      _.isShowList
                                                          ? Expanded(
                                                              child: Container(
                                                                color: NewCommonColours
                                                                    .searchSuggestionBoxColor,
                                                                width:
                                                                    Get.width,
                                                                child: ListView
                                                                    .builder(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  itemCount: _
                                                                          .searchtopiclist
                                                                          .isEmpty
                                                                      ? _.topiclist
                                                                          .length
                                                                      : _.searchtopiclist
                                                                          .length,
                                                                  itemBuilder:
                                                                      (BuildContext
                                                                              context,
                                                                          int index) {
                                                                    return GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        _.searchtopiclist.isEmpty
                                                                            ? _.searchText.value.text =
                                                                                _.topiclist[index]['name']
                                                                            : _.searchText.value.text = _.searchtopiclist[index]['name'];
                                                                        _.isShowList =
                                                                            false;
                                                                        _.update();
                                                                        Get.to(() =>
                                                                            const SearchScreen());
                                                                        await _.getFilterJobs(
                                                                            _.searchText.value.text,
                                                                            1);
                                                                        // Get.delete<
                                                                        //     SearchController>();
                                                                        // Get.to(
                                                                        //     () =>
                                                                        //         const SearchScreen(),
                                                                        //     arguments:
                                                                        //         _.searchText.text);
                                                                        // _.searchText
                                                                        //     .clear();
                                                                        // _.searchtopiclist
                                                                        //     .clear();
                                                                        // _.update();
                                                                      },
                                                                      child:
                                                                          SizedBox(
                                                                        height:
                                                                            40.0,
                                                                        child: _
                                                                                .searchtopiclist.isEmpty
                                                                            ? Text(
                                                                                "${_.topiclist[index]['name']}",
                                                                                textScaleFactor: 1.0,
                                                                                style: GoogleFonts.roboto(
                                                                                  fontSize: 15.0,
                                                                                  fontWeight: FontWeight.w400,
                                                                                  letterSpacing: 0.4,
                                                                                  color: const Color(0xffFFFFFF),
                                                                                ),
                                                                              ).marginOnly(
                                                                                left: 20,
                                                                                top: 10.0)
                                                                            : Text("${_.searchtopiclist[index]['name']}",
                                                                                textScaleFactor: 1.0,
                                                                                style: GoogleFonts.roboto(
                                                                                  fontSize: 15.0,
                                                                                  fontWeight: FontWeight.w400,
                                                                                  letterSpacing: 0.4,
                                                                                  color: const Color(0xffFFFFFF),
                                                                                )).marginOnly(left: 20, top: 10.0),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            )
                                                          : const SizedBox(),
                                                    ],
                                                  ),
                                                ).marginOnly(
                                                    left: _.isShowList == false
                                                        ? 30
                                                        : 11,
                                                    right: _.isShowList == false
                                                        ? 10
                                                        : 5,
                                                    top: _.isShowList == false
                                                        ? 22
                                                        : 10),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      )),
          ),
        );
      },
    );
  }
}
