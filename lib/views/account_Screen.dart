// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lytics_lens/Constants/app_strrings.dart';
import 'package:lytics_lens/Constants/common_color.dart';
import 'package:lytics_lens/Controllers/account_controller.dart';
import 'package:lytics_lens/views/changepassword_screen.dart';
import 'package:lytics_lens/views/home_screen.dart';

// import 'package:lytics_lens/views/select_subsccription_screen.dart';
// import 'package:lytics_lens/views/select_keyword_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColor.appBarColor,
      appBar: AppBar(
        backgroundColor: CommonColor.appBarColor,
        title: const Text(
          "Settings",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              fontFamily: 'Roboto',
              letterSpacing: 0.7),
        ).marginOnly(left: 20.0, top: 10),
        elevation: 0.0,
        automaticallyImplyLeading: false,
      ),
      // bottomNavigationBar: GlobalBottomNav(),
      body: bodyData(context),
    );
  }

  void moveToAlertScreen(BuildContext context) {
    Get.offAll(const HomeScreen());
  }

  Widget bodyData(BuildContext context) {
    return GetBuilder<AccountController>(
        init: AccountController(),
        builder: (_) {
          return Container(
              width: Get.width,
              height: Get.height,
              color: CommonColor.appBarColor,
              child: Column(
                children: [
                  const SizedBox(
                    height: 40.0,
                  ),
                  Expanded(
                    child: ScrollConfiguration(
                      behavior:
                          const ScrollBehavior().copyWith(overscroll: false),
                      child: GlowingOverscrollIndicator(
                        axisDirection: AxisDirection.right,
                        color: Colors.black,
                        child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: 1,
                            itemBuilder: (BuildContext context, int index) {
                              return ListView(shrinkWrap: true, children: [
                                options(
                                  text: 'Change Password',
                                  subTitle: '',
                                  // subTitle: 'You can change your password',
                                  imagename: 'assets/images/password.png',
                                  onTap: () {
                                    Get.to(() => const ChangePasswordScreen());
                                  },
                                ),
                                // options(
                                //   text: 'Manage Notifications',
                                //   subTitle:
                                //       'You can see which notifications to receive',
                                //   imagename: 'assets/images/notification.png',
                                //   onTap: () {
                                //     Get.to(() => NotificationViewScreen());
                                //   },
                                // ),

                                // options(
                                //   text: 'Select Preferences by Topic',
                                //   subTitle:
                                //       'You can add new Topics to your list',
                                //   imagename: 'assets/images/pref.png',
                                //   onTap: () {
                                //     Get.to(() => SelectKeyWords());
                                //   },
                                // ),

                                // options(
                                //   text: 'Select Preferences by Keywords',
                                //   subTitle:
                                //       'You can add new Keywords to your list',
                                //   imagename: 'assets/images/setting.png',
                                //   onTap: () {
                                //     Get.to(() => SelectKeyWords());
                                //   },
                                // ),

                                // options(
                                //   text: 'Select Subscription',
                                //   subTitle:
                                //       'You can add new Keywords to your list',
                                //   imagename: 'assets/images/setting.png',
                                //   onTap: () {
                                //     Get.to(() => SelectSubscriptionScreen());
                                //   },
                                // ),

                                // options(
                                //   text: 'Change Subscription',
                                //   subTitle:
                                //       // options(
                                //       //   text: 'Change Subscription',
                                //       //   subTitle:
                                //       'Request a change in your subscriptions and choose a new one',
                                //   imagename: 'assets/images/email_setting.png',
                                //   onTap: () {
                                //     Get.to(() => SelectSubscriptionScreen());
                                //   },
                                // ),
                                options(
                                  text: 'Logout',
                                  //subTitle: '',
                                   subTitle: '${_.useremail}',
                                  imagename: 'assets/images/logout.png',
                                  onTap: () {
                                    _showMyDialog(context, _);
                                  },
                                ),
                              ]);
                            }),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_.isShow == true) {
                        versionBox(context, _);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          AppStrings.version,
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              fontSize: 11.0,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w300,
                              color: Colors.white),
                        ).marginOnly(bottom: 5.0),
                        // Icon(
                        //   Icons.info_outline_rounded,
                        //   color: Colors.white,
                        //   size: 15,
                        // ).marginOnly(bottom: 8, left: 3),
                      ],
                    ),
                  )
                ],
              ));
        });
  }

  Widget options(
      {String? text, String? subTitle, String? imagename, Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      splashColor: const Color(0xff48beeb),
      hoverColor: const Color(0xff48beeb),
      focusColor: const Color(0xff48beeb),
      child: SizedBox(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 60.0,
                width: 60.0,
                child: Image.asset(
                  imagename!,
                  height: 24,
                  width: 24,
                ),
              ).marginOnly(left: 20.0),
              const SizedBox(
                width: 5.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: Get.width / 1.4,
                    child: Text(
                      text!,
                      textScaleFactor: 1.0,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    ),
                  ),
                  subTitle == ''
                      ? const SizedBox()
                      : const SizedBox(
                          height: 5.0,
                        ),
                  subTitle == ''
                      ? const SizedBox()
                      : SizedBox(
                          width: Get.width / 1.4,
                          child: Text(
                            subTitle!,
                            textScaleFactor: 1.0,
                            maxLines: 2,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        )
                ],
              )
            ],
          )),
    ).marginOnly(bottom: 30.0);
  }

  void versionBox(context, AccountController _) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xff131C3A),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          title: const Text(
            'UPDATE',
            textScaleFactor: 1.0,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              letterSpacing: 0.4,
              fontFamily: 'Roboto',
            ),
          ),
          content: SizedBox(
            height: Get.height / 3.0,
            width: Get.width,
            child: ListView.separated(
              itemCount: _.updateList.length,
              shrinkWrap: true,
              itemBuilder: (c, i) {
                return getRow(des: _.updateList[i]['point']);
              },
              separatorBuilder: (c, q) {
                return const SizedBox(
                  height: 5.0,
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget getRow({String? des}) {
    return Row(
      children: [
        Container(
          height: 5.0,
          width: 5.0,
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
        ),
        const SizedBox(
          width: 5.0,
        ),
        Flexible(
          child: Text(
            des!,
            textScaleFactor: 1.0,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w300,
                color: Colors.white,
                letterSpacing: 0.4,
                fontFamily: 'Roboto'),
          ),
        ),
      ],
    );
  }

  Future<void> _showMyDialog(context, AccountController _) async {
    return showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xff131C3A),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          title: const Text(
            'Log Out?',
            textScaleFactor: 1.0,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              letterSpacing: 0.4,
              fontFamily: 'Roboto',
            ),
          ),
          content: SizedBox(
            height: 100.0,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Are you sure you want to log out?',
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                      letterSpacing: 0.4,
                      fontFamily: 'Roboto'),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MaterialButton(
                      onPressed: () async {
                        Get.back();
                      },
                      minWidth: Get.width / 3.5,
                      height: 38,
                      child: const Text(
                        "Cancel",
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            color: CommonColor.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    MaterialButton(
                      color: NewCommonColours.greenButton,
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: NewCommonColours.greenButton,
                          ),
                          borderRadius: BorderRadius.circular(9.0)),
                      onPressed: () async {
                        await _.logout();
                       // _.launchInBrowser(_.url);
                      },
                      minWidth: Get.width / 3.5,
                      height: 38,
                      child: const Text(
                        "Logout",
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            color: NewCommonColours.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
