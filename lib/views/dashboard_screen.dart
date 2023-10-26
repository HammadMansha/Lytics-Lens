import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lytics_lens/Constants/common_color.dart';
import 'package:lytics_lens/Controllers/dashboard.dart';
import 'package:lytics_lens/views/account_Screen.dart';
import 'package:lytics_lens/views/home_screen.dart';
import 'package:lytics_lens/views/reports_Screen.dart';
import 'package:lytics_lens/views/search.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      init: DashboardController(),
      builder: (_) {
        return WillPopScope(
          onWillPop: () async {
            if (_.navigationQueue.isEmpty) {
              return showWillPopMessage(context);
            }
            _.navigationQueue.removeLast();
            int position =
                _.navigationQueue.isEmpty ? 0 : _.navigationQueue.last;
            _.currentindex = position;
            _.update();
            return false;
          },
          child: Scaffold(
            body: getBody(_),
            bottomNavigationBar: bottomnavbar(_),
          ),
        );
      },
    );
  }

  showWillPopMessage(context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: CommonColor.bottomSheetBackgroundColour,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          title: const Text(
            'Exit App?',
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
                  'Are you sure you want to exit App?',
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9.0)),
                      onPressed: () async {
                        Get.back();
                      },
                      minWidth: Get.width / 3.5,
                      height: 48,
                      child: const Text(
                        "Cancel",
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            color: CommonColor.whiteColor, fontSize: 16),
                      ),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9.0),
                        side: const BorderSide(
                          color: NewCommonColours.greenButton,
                        ),
                      ),
                      onPressed: () async {
                        if (Platform.isAndroid) {
                          exit(0);
                        } else {
                          exit(0);
                        }
                      },
                      minWidth: Get.width / 3.4,
                      height: 40,
                      color: NewCommonColours.greenButton,
                      child: const Text(
                        "Exit",
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            color: NewCommonColours.whiteColor, fontSize: 16),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget bottomnavbar(DashboardController _) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage("assets/images/alerts.png"),
            size: 25.0,
          ),
          label: 'Alerts',
          backgroundColor: Color.fromRGBO(27, 29, 40, 1),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.search,
            size: 25.0,
          ),
          label: 'Search',
          backgroundColor: Color.fromRGBO(27, 29, 40, 1),
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.content_paste),
        //   label: 'Analysis',
        //   backgroundColor: Color.fromRGBO(27, 29, 40, 1),
        // ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
          backgroundColor: Color.fromRGBO(27, 29, 40, 1),
        ),
      ],
      currentIndex: _.currentindex,
      selectedItemColor: const Color(0xff22B161),
      selectedFontSize: 12.0,
      backgroundColor: const Color(0xff031347),
      unselectedItemColor: const Color(0xffD3D3D3),
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      onTap: _.changeTabIndex,
    );
  }

  Widget getBody(DashboardController _) {
    List<Widget> pages = [
      const HomeScreen(),
      const SearchBarView(),
      //const ReportsScreen(),
      const AccountScreen(),
    ];
    return IndexedStack(
      index: _.currentindex,
      children: pages,
    );
  }
}
