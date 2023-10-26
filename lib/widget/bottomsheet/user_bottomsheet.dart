import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lytics_lens/Constants/common_color.dart';
import 'package:lytics_lens/Controllers/company_user/companyUser_controller.dart';

class UserBottomSheet {
  static void showBottomSheet({required void Function()? onPressed}) {
    CompanyUserController _ = Get.find<CompanyUserController>();
    if (
        _.sharingUser.length ==
            _.companyUser
                .length) {
      _.isEveryonePress.value =
      true;
    } else {
      _.isEveryonePress.value =
      false;
    }
    Get.bottomSheet(
      isScrollControlled: true,
      elevation: 0,
      StatefulBuilder(
        builder: (context, setState) {
          return Container(
            height: Get.height - 260,
            width: Get.width,
            color: const Color(0xff131C3A),
            child: Obx(
              () => _.isBottomLoading.value
                  ? Center(
                      child: Image.asset(
                        "assets/images/gif.gif",
                        height: 300.0,
                        width: 300.0,
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Center(
                            child: Container(
                              height: 5.0,
                              width: Get.width / 3,
                              decoration: BoxDecoration(
                                color: CommonColor.textFieldBorderColor,
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Container(
                              height: 34,
                              width: Get.width / 1.6,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(6.0),
                                  bottomLeft: Radius.circular(6.0),
                                  topLeft: Radius.circular(6.0),
                                  bottomRight: Radius.circular(6.0),
                                ),
                                color: Color(0xff455177),
                              ),
                              child: TextFormField(
                                controller: _.searchContact,
                                cursorColor: CommonColor.greenColor,
                                onChanged: (c) {
                                  _.searchUserFunction(c);
                                },
                                textAlignVertical: TextAlignVertical.center,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Colors.green,
                                  ),
                                  hintText: "Search",
                                  fillColor: Color(0xff455177),
                                  contentPadding: EdgeInsets.zero,
                                  hintStyle: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xffD3D3D3),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xff455177),
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(6),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xff455177),
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(6),
                                    ),
                                  ),
                                  filled: true,
                                ),
                              ),
                            ),
                            MaterialButton(
                              color: NewCommonColours.greenButton,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: _.sharingUser.isEmpty
                                        ? Colors.grey
                                        :NewCommonColours.greenButton,
                                  ),
                                  borderRadius: BorderRadius.circular(9.0)),
                              onPressed:
                                  _.sharingUser.isEmpty ? null : onPressed,
                              minWidth: Get.width / 3.9,
                              height: 33,
                              child: Text(
                                "Share",
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    color: _.sharingUser.isEmpty
                                        ? Colors.grey
                                        : CommonColor.whiteColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700),
                              ),
                            ).marginOnly(left: 13),
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Expanded(
                          child: _.nodata.value
                              ? const Center(
                                  child: Text(
                                    "No data found",
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              : SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _.isEveryonePress.value =
                                              !_.isEveryonePress.value;
                                          if (_.isEveryonePress.value) {
                                            _.sharingUser.clear();
                                            if (_.searchcompanyUser.isEmpty) {
                                              for (int i = 0;
                                                  i < _.companyUser.length;
                                                  i++) {
                                                _.sharingUser.add({
                                                  "id": _.companyUser[i]['id'],
                                                  "name":
                                                      "${_.companyUser[i]['firstName']} ${_.companyUser[i]['lastName']}",
                                                  "read": "false",
                                                  "time": DateFormat(
                                                          'yyyy-MM-dd HH:mm:ss')
                                                      .format(DateTime.now()),
                                                });
                                              }
                                              Get.log(
                                                  "sharing user data if ${_.sharingUser}");
                                              Get.log(
                                                  "sharing user data List lenght if ${_.sharingUser.length.toString()}");
                                            } else {
                                              for (int i = 0;
                                                  i <
                                                      _.searchcompanyUser
                                                          .length;
                                                  i++) {
                                                _.sharingUser.add({
                                                  "id": _.searchcompanyUser[i]
                                                      ['id'],
                                                  "name":
                                                      "${_.searchcompanyUser[i]['firstName']} ${_.companyUser[i]['lastName']}",
                                                  "read": "false",
                                                  "time": DateFormat(
                                                          'yyyy-MM-dd HH:mm:ss')
                                                      .format(DateTime.now()),
                                                });
                                              }
                                              Get.log(
                                                  "sharing user data else ${_.sharingUser}");
                                            }
                                          } else {
                                            _.sharingUser.clear();
                                            Get.log(
                                                "sharing user data main else${_.sharingUser}");
                                            Get.log(
                                                "sharing user data main else lenght${_.sharingUser.length.toString()}");
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color:
                                                  NewCommonColours.greenButton,
                                                ),
                                                color: _.isEveryonePress.value
                                                    ? NewCommonColours.greenButton
                                                    : Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                                // image: const DecorationImage(
                                                //     image: AssetImage(
                                                //         'assets/images/app_icon.png'),
                                                //     fit: BoxFit.fill),
                                              ),
                                              child: _.isEveryonePress.value
                                                  ? const Icon(
                                                      Icons.check,
                                                      color: CommonColor
                                                          .whiteColor,
                                                      size: 40,
                                                    )
                                                  : Image.asset(
                                                  'assets/images/app_icon.png',fit: BoxFit.fill),
                                            ),
                                            const SizedBox(
                                              width: 20.0,
                                            ),
                                            const Text(
                                              "Everyone",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15.0),
                                            ),
                                            const Spacer(),
                                            Image.asset(
                                              'assets/images/logo (2).png',
                                              height: 30,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      ListView.separated(
                                        itemCount: _.searchcompanyUser.isEmpty
                                            ? _.companyUser.length
                                            : _.searchcompanyUser.length,
                                        shrinkWrap: true,
                                        separatorBuilder: (c, i) {
                                          return const SizedBox(
                                            height: 10,
                                          );
                                        },
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (c, i) {
                                          //----------Share to Everyone Container-----

                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (_.searchcompanyUser
                                                    .isEmpty) {
                                                  if (_.addDataList(
                                                          _.companyUser[i]
                                                              ['id']) ==
                                                      '${_.companyUser[i]['id']}') {
                                                    _.deletedata(
                                                        _.companyUser[i]['id']);
                                                    _.isEveryonePress.value =
                                                        false;
                                                    Get.log(
                                                        "sharing user data lenght ${_.sharingUser.length.toString()}");
                                                  } else {
                                                    _.sharingUser.add({
                                                      "id": _.companyUser[i]
                                                          ['id'],
                                                      "name":
                                                          "${_.companyUser[i]['firstName']} ${_.companyUser[i]['lastName']}",
                                                      "read": "false",
                                                      "time": DateFormat(
                                                              'yyyy-MM-dd HH:mm:ss')
                                                          .format(
                                                              DateTime.now()),
                                                    });

                                                    _.isEveryonePress.value =
                                                        false;

                                                    if (_.sharingUser.length ==
                                                            _.searchcompanyUser
                                                                .length ||
                                                        _.sharingUser.length ==
                                                            _.companyUser
                                                                .length) {
                                                      _.isEveryonePress.value =
                                                          true;
                                                    } else {
                                                      _.isEveryonePress.value =
                                                          false;
                                                    }
                                                    Get.log(
                                                        "sharing user data if ${_.sharingUser}");
                                                    Get.log(
                                                        "sharing user data if lenght ${_.sharingUser.length.toString()}");
                                                  }
                                                } else {
                                                  if (_.addDataList(
                                                          _.searchcompanyUser[i]
                                                              ['id']) ==
                                                      '${_.searchcompanyUser[i]['id']}') {
                                                    _.deletedata(
                                                        _.searchcompanyUser[i]
                                                            ['id']);
                                                    _.isEveryonePress.value =
                                                        false;
                                                    Get.log(
                                                        "sharing user data lenght ${_.sharingUser.length.toString()}");
                                                  } else {
                                                    _.sharingUser.add({
                                                      "id":
                                                          _.searchcompanyUser[i]
                                                              ['id'],
                                                      "name":
                                                          "${_.searchcompanyUser[i]['firstName']} ${_.searchcompanyUser[i]['lastName']}",
                                                      "read": "false",
                                                      "time": DateFormat(
                                                              'yyyy-MM-dd HH:mm:ss')
                                                          .format(
                                                              DateTime.now()),
                                                    });
                                                    _.isEveryonePress.value =
                                                        false;
                                                    if (_.sharingUser.length ==
                                                            _.searchcompanyUser
                                                                .length ||
                                                        _.sharingUser.length ==
                                                            _.companyUser
                                                                .length) {
                                                      _.isEveryonePress.value =
                                                          true;
                                                    } else {
                                                      _.isEveryonePress.value =
                                                          false;
                                                    }
                                                    Get.log(
                                                        "sharing user data else ${_.sharingUser}");
                                                    Get.log(
                                                        "sharing user data else lenght ${_.sharingUser.length.toString()}");
                                                  }
                                                }
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 50,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: NewCommonColours.greenButton,
                                                      ),
                                                      color: _.searchcompanyUser
                                                              .isEmpty
                                                          ? _.addDataList(_.companyUser[
                                                                          i]
                                                                      ['id']) ==
                                                                  '${_.companyUser[i]['id']}'
                                                              ? NewCommonColours.greenButton
                                                              : Colors
                                                                  .transparent
                                                          : _.addDataList(_
                                                                          .searchcompanyUser[i]
                                                                      ['id']) ==
                                                                  '${_.searchcompanyUser[i]['id']}'
                                                              ? NewCommonColours.greenButton
                                                              : Colors
                                                                  .transparent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0)),
                                                  child: Center(
                                                    child: _.searchcompanyUser
                                                            .isEmpty
                                                        ? _.addDataList(_.companyUser[
                                                                    i]['id']) ==
                                                                '${_.companyUser[i]['id']}'
                                                            ? const Icon(
                                                                Icons.check,
                                                                color: CommonColor
                                                                    .whiteColor,
                                                                size: 40,
                                                              )
                                                            : _.companyUser[i][
                                                                        'firstName'] ==
                                                                    "Everyone"
                                                                ? Image.asset(
                                                                    "assets/images/app_icon.png",
                                                                    fit: BoxFit
                                                                        .contain,
                                                                  )
                                                                : Text(
                                                                    _
                                                                        .namesSplit(
                                                                            '${_.companyUser[i]['firstName']} ${_.companyUser[i]['lastName']}')
                                                                        .toUpperCase(),
                                                                    style: const TextStyle(
                                                                        color: Color(
                                                                            0xff34f68a),
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        fontFamily:
                                                                            'Roboto'),
                                                                  ).marginOnly(
                                                                    top: 12.0,
                                                                    bottom:
                                                                        12.0,
                                                                    //left: 5,
                                                                    //right: 5
                                                                  )
                                                        : _.addDataList(
                                                                    _.searchcompanyUser[
                                                                            i]
                                                                        ['id']) ==
                                                                '${_.searchcompanyUser[i]['id']}'
                                                            ? const Icon(
                                                                Icons.check,
                                                                color: CommonColor
                                                                    .whiteColor,
                                                                size: 40,
                                                              )
                                                            : Text(
                                                                _
                                                                    .namesSplit(
                                                                        '${_.searchcompanyUser[i]['firstName']} ${_.searchcompanyUser[i]['lastName']}')
                                                                    .toUpperCase(),
                                                                style: const TextStyle(
                                                                    color: Color(
                                                                        0xff34f68a),
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontFamily:
                                                                        'Roboto'),
                                                              ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 20.0,
                                                ),
                                                SizedBox(
                                                  width: Get.width / 2.5,
                                                  child: Text(
                                                    _.searchcompanyUser.isEmpty
                                                        ? '${_.companyUser[i]['firstName']} ${_.companyUser[i]['lastName']}'
                                                        : '${_.searchcompanyUser[i]['firstName']} ${_.searchcompanyUser[i]['lastName']}',
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15.0),
                                                  ),
                                                ),
                                                const Spacer(),
                                                Image.asset(
                                                  'assets/images/logo (2).png',
                                                  height: 30,
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ],
                    ).marginOnly(left: 20, top: 20),
            ),
          );
        },
      ),
    );
  }
}

class webShareBottomSheet{
  static void showBottomSheet({required void Function()? onPressed}) {
    CompanyUserController _ = Get.find<CompanyUserController>();
    if (
    _.sharingUser.length == _.companyUser.length) {
      _.isEveryonePress.value =
      true;
    } else {
      _.isEveryonePress.value =
      false;
    }
    Get.bottomSheet(
      isScrollControlled: true,
      elevation: 0,
      StatefulBuilder(
        builder: (context, setState) {
          return Container(
            height: Get.height - 260,
            width: Get.width,
            color: const Color(0xff131C3A),
            child: Obx(
                  () => _.isBottomLoading.value
                  ? Center(
                child: Image.asset(
                  "assets/images/gif.gif",
                  height: 300.0,
                  width: 300.0,
                ),
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Center(
                      child: Container(
                        height: 5.0,
                        width: Get.width / 3,
                        decoration: BoxDecoration(
                          color: CommonColor.textFieldBorderColor,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 34,
                        width: Get.width / 1.6,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(6.0),
                            bottomLeft: Radius.circular(6.0),
                            topLeft: Radius.circular(6.0),
                            bottomRight: Radius.circular(6.0),
                          ),
                          color: Color(0xff455177),
                        ),
                        child: TextFormField(
                          controller: _.searchContact,
                          cursorColor: CommonColor.greenColor,
                          onChanged: (c) {
                            _.searchUserFunction(c);
                          },
                          textAlignVertical: TextAlignVertical.center,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.green,
                            ),
                            hintText: "Search",
                            fillColor: Color(0xff455177),
                            contentPadding: EdgeInsets.zero,
                            hintStyle: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Color(0xffD3D3D3),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xff455177),
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(6),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xff455177),
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(6),
                              ),
                            ),
                            filled: true,
                          ),
                        ),
                      ),
                      MaterialButton(
                        color: CommonColor.greenColorWithOpacity,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: _.sharingUser.isEmpty
                                  ? Colors.grey
                                  : const Color(0xff23B662),
                            ),
                            borderRadius: BorderRadius.circular(9.0)),
                        onPressed:
                        _.sharingUser.isEmpty ? null : onPressed,
                        minWidth: Get.width / 3.9,
                        height: 33,
                        child: Text(
                          "SHARE",
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              color: _.sharingUser.isEmpty
                                  ? Colors.grey
                                  : CommonColor.greenButtonTextColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w700),
                        ),
                      ).marginOnly(left: 13),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Expanded(
                    child: _.nodata.value
                        ? const Center(
                      child: Text(
                        "No data found",
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                        : SingleChildScrollView(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _.isEveryonePress.value =
                              !_.isEveryonePress.value;
                              if (_.isEveryonePress.value) {
                                _.sharingUser.clear();
                                if (_.searchcompanyUser.isEmpty) {
                                  for (int i = 0;
                                  i < _.companyUser.length;
                                  i++) {
                                    _.sharingUser.add({
                                      "id": _.companyUser[i]['id'],
                                      "name":
                                      "${_.companyUser[i]['firstName']} ${_.companyUser[i]['lastName']}",
                                      "read": "false",
                                      "time": DateFormat(
                                          'yyyy-MM-dd HH:mm:ss')
                                          .format(DateTime.now()),
                                    });
                                  }
                                  Get.log(
                                      "sharing user data if ${_.sharingUser}");
                                  Get.log(
                                      "sharing user data List lenght if ${_.sharingUser.length.toString()}");
                                } else {
                                  for (int i = 0;
                                  i <
                                      _.searchcompanyUser
                                          .length;
                                  i++) {
                                    _.sharingUser.add({
                                      "id": _.searchcompanyUser[i]
                                      ['id'],
                                      "name":
                                      "${_.searchcompanyUser[i]['firstName']} ${_.companyUser[i]['lastName']}",
                                      "read": "false",
                                      "time": DateFormat(
                                          'yyyy-MM-dd HH:mm:ss')
                                          .format(DateTime.now()),
                                    });
                                  }
                                  Get.log(
                                      "sharing user data else ${_.sharingUser}");
                                }
                              } else {
                                _.sharingUser.clear();
                                Get.log(
                                    "sharing user data main else${_.sharingUser}");
                                Get.log(
                                    "sharing user data main else lenght${_.sharingUser.length.toString()}");
                              }
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                      const Color(0xff34f68a),
                                    ),
                                    color: _.isEveryonePress.value
                                        ? const Color(0xff34f68a)
                                        : Colors.transparent,
                                    borderRadius:
                                    BorderRadius.circular(5.0),
                                    // image: const DecorationImage(
                                    //     image: AssetImage(
                                    //         'assets/images/app_icon.png'),
                                    //     fit: BoxFit.fill),
                                  ),
                                  child: _.isEveryonePress.value
                                      ? const Icon(
                                    Icons.check,
                                    color: CommonColor
                                        .whiteColor,
                                    size: 40,
                                  )
                                      : Image.asset(
                                      'assets/images/app_icon.png',fit: BoxFit.fill),
                                ),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                const Text(
                                  "Everyone",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0),
                                ),
                                const Spacer(),
                                Image.asset(
                                  'assets/images/logo (2).png',
                                  height: 30,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          ListView.separated(
                            itemCount: _.searchcompanyUser.isEmpty
                                ? _.companyUser.length
                                : _.searchcompanyUser.length,
                            shrinkWrap: true,
                            separatorBuilder: (c, i) {
                              return const SizedBox(
                                height: 10,
                              );
                            },
                            physics:
                            const NeverScrollableScrollPhysics(),
                            itemBuilder: (c, i) {
                              //----------Share to Everyone Container-----

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (_.searchcompanyUser
                                        .isEmpty) {
                                      if (_.addDataList(
                                          _.companyUser[i]
                                          ['id']) ==
                                          '${_.companyUser[i]['id']}') {
                                        _.deletedata(
                                            _.companyUser[i]['id']);
                                        _.isEveryonePress.value =
                                        false;
                                        Get.log(
                                            "sharing user data lenght ${_.sharingUser.length.toString()}");
                                      } else {
                                        _.sharingUser.add({
                                          "id": _.companyUser[i]
                                          ['id'],
                                          "name":
                                          "${_.companyUser[i]['firstName']} ${_.companyUser[i]['lastName']}",
                                          "read": "false",
                                          "time": DateFormat(
                                              'yyyy-MM-dd HH:mm:ss')
                                              .format(
                                              DateTime.now()),
                                        });

                                        _.isEveryonePress.value =
                                        false;

                                        if (_.sharingUser.length ==
                                            _.searchcompanyUser
                                                .length ||
                                            _.sharingUser.length ==
                                                _.companyUser
                                                    .length) {
                                          _.isEveryonePress.value =
                                          true;
                                        } else {
                                          _.isEveryonePress.value =
                                          false;
                                        }
                                        Get.log(
                                            "sharing user data if ${_.sharingUser}");
                                        Get.log(
                                            "sharing user data if lenght ${_.sharingUser.length.toString()}");
                                      }
                                    } else {
                                      if (_.addDataList(
                                          _.searchcompanyUser[i]
                                          ['id']) ==
                                          '${_.searchcompanyUser[i]['id']}') {
                                        _.deletedata(
                                            _.searchcompanyUser[i]
                                            ['id']);
                                        _.isEveryonePress.value =
                                        false;
                                        Get.log(
                                            "sharing user data lenght ${_.sharingUser.length.toString()}");
                                      } else {
                                        _.sharingUser.add({
                                          "id":
                                          _.searchcompanyUser[i]
                                          ['id'],
                                          "name":
                                          "${_.searchcompanyUser[i]['firstName']} ${_.searchcompanyUser[i]['lastName']}",
                                          "read": "false",
                                          "time": DateFormat(
                                              'yyyy-MM-dd HH:mm:ss')
                                              .format(
                                              DateTime.now()),
                                        });
                                        _.isEveryonePress.value =
                                        false;
                                        if (_.sharingUser.length ==
                                            _.searchcompanyUser
                                                .length ||
                                            _.sharingUser.length ==
                                                _.companyUser
                                                    .length) {
                                          _.isEveryonePress.value =
                                          true;
                                        } else {
                                          _.isEveryonePress.value =
                                          false;
                                        }
                                        Get.log(
                                            "sharing user data else ${_.sharingUser}");
                                        Get.log(
                                            "sharing user data else lenght ${_.sharingUser.length.toString()}");
                                      }
                                    }
                                  });
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color(
                                                0xff34f68a),
                                          ),
                                          color: _.searchcompanyUser
                                              .isEmpty
                                              ? _.addDataList(_.companyUser[
                                          i]
                                          ['id']) ==
                                              '${_.companyUser[i]['id']}'
                                              ? const Color(
                                              0xff34f68a)
                                              : Colors
                                              .transparent
                                              : _.addDataList(_
                                              .searchcompanyUser[i]
                                          ['id']) ==
                                              '${_.searchcompanyUser[i]['id']}'
                                              ? const Color(
                                              0xff34f68a)
                                              : Colors
                                              .transparent,
                                          borderRadius:
                                          BorderRadius.circular(
                                              5.0)),
                                      child: Center(
                                        child: _.searchcompanyUser
                                            .isEmpty
                                            ? _.addDataList(_.companyUser[
                                        i]['id']) ==
                                            '${_.companyUser[i]['id']}'
                                            ? const Icon(
                                          Icons.check,
                                          color: CommonColor
                                              .whiteColor,
                                          size: 40,
                                        )
                                            : _.companyUser[i][
                                        'firstName'] ==
                                            "Everyone"
                                            ? Image.asset(
                                          "assets/images/app_icon.png",
                                          fit: BoxFit
                                              .contain,
                                        )
                                            : Text(
                                          _
                                              .namesSplit(
                                              '${_.companyUser[i]['firstName']} ${_.companyUser[i]['lastName']}')
                                              .toUpperCase(),
                                          style: const TextStyle(
                                              color: Color(
                                                  0xff34f68a),
                                              fontSize:
                                              16,
                                              fontWeight:
                                              FontWeight
                                                  .w700,
                                              fontFamily:
                                              'Roboto'),
                                        ).marginOnly(
                                          top: 12.0,
                                          bottom:
                                          12.0,
                                          //left: 5,
                                          //right: 5
                                        )
                                            : _.addDataList(
                                            _.searchcompanyUser[
                                            i]
                                            ['id']) ==
                                            '${_.searchcompanyUser[i]['id']}'
                                            ? const Icon(
                                          Icons.check,
                                          color: CommonColor
                                              .whiteColor,
                                          size: 40,
                                        )
                                            : Text(
                                          _
                                              .namesSplit(
                                              '${_.searchcompanyUser[i]['firstName']} ${_.searchcompanyUser[i]['lastName']}')
                                              .toUpperCase(),
                                          style: const TextStyle(
                                              color: Color(
                                                  0xff34f68a),
                                              fontSize:
                                              16,
                                              fontWeight:
                                              FontWeight
                                                  .w700,
                                              fontFamily:
                                              'Roboto'),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20.0,
                                    ),
                                    SizedBox(
                                      width: Get.width / 2.5,
                                      child: Text(
                                        _.searchcompanyUser.isEmpty
                                            ? '${_.companyUser[i]['firstName']} ${_.companyUser[i]['lastName']}'
                                            : '${_.searchcompanyUser[i]['firstName']} ${_.searchcompanyUser[i]['lastName']}',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.0),
                                      ),
                                    ),
                                    const Spacer(),
                                    Image.asset(
                                      'assets/images/logo (2).png',
                                      height: 30,
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ).marginOnly(left: 20, top: 20),
            ),
          );
        },
      ),
    );
  }
}
