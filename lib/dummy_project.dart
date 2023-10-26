import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lytics_lens/Constants/common_color.dart';

class TabbarOptmization extends StatelessWidget {
   TabbarOptmization({Key? key}) : super(key: key);

  String selectedTab="BTC";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: Get.height,
          width: Get.width,
          color: CommonColor.appBarColor,
          child: Column(
            children: [



              SizedBox(
                height: 50,
                //width: Get.width,
                child: Row(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (context, index) =>
                        const Divider(
                          color: Colors.transparent,
                        ),
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          //----All tabbar Container-----

                          return Row(children: [
                            GestureDetector(
                              onTap:(){
                                selectedTab="All";

                          },
                              child: Container(
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border(
                                    top: const BorderSide(
                                      color: Colors.transparent,
                                    ),
                                    left: const BorderSide(color: Colors.transparent),
                                    right: const BorderSide(color: Colors.transparent),
                                    bottom: BorderSide(
                                        color: selectedTab == 'BTC'
                                            ? Colors.white
                                            : Colors.transparent,
                                        width: 2),
                                  ),
                                ),
                                child: Text(
                                  "All",
                                  style:TextStyle(fontSize: 14,color: Colors.grey),
                                ),
                              ),
                            ),

                            Container(
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border(
                                  top: const BorderSide(
                                    color: Colors.transparent,
                                  ),
                                  left: const BorderSide(color: Colors.transparent),
                                  right: const BorderSide(color: Colors.transparent),
                                  bottom: BorderSide(
                                      color: selectedTab == 'BTC'
                                          ? Colors.white
                                          : Colors.transparent,
                                      width: 2),
                                ),
                              ),
                              child: Text(
                                "Tv",
                                style:TextStyle(fontSize: 14,color: Colors.grey),
                              ),
                            ),
                            Container(
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border(
                                  top: const BorderSide(
                                    color: Colors.transparent,
                                  ),
                                  left: const BorderSide(color: Colors.transparent),
                                  right: const BorderSide(color: Colors.transparent),
                                  bottom: BorderSide(
                                      color: selectedTab == 'BTC'
                                          ? Colors.white
                                          : Colors.transparent,
                                      width: 2),
                                ),
                              ),
                              child: Text(
                                "Web",
                                style:TextStyle(fontSize: 14,color: Colors.grey),
                              ),
                            ),
                            Container(
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border(
                                  top: const BorderSide(
                                    color: Colors.transparent,
                                  ),
                                  left: const BorderSide(color: Colors.transparent),
                                  right: const BorderSide(color: Colors.transparent),
                                  bottom: BorderSide(
                                      color: selectedTab == 'BTC'
                                          ? Colors.white
                                          : Colors.transparent,
                                      width: 2),
                                ),
                              ),
                              child: Text(
                                "Print",
                                style:TextStyle(fontSize: 14,color: Colors.grey),
                              ),
                            ),
                            Container(
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border(
                                  top: const BorderSide(
                                    color: Colors.transparent,
                                  ),
                                  left: const BorderSide(color: Colors.transparent),
                                  right: const BorderSide(color: Colors.transparent),
                                  bottom: BorderSide(
                                      color: selectedTab == 'BTC'
                                          ? Colors.white
                                          : Colors.transparent,
                                      width: 2),
                                ),
                              ),
                              child: Text(
                                "Online",
                                style:TextStyle(fontSize: 14,color: Colors.grey),
                              ),
                            ),
                            Container(
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border(
                                  top: const BorderSide(
                                    color: Colors.transparent,
                                  ),
                                  left: const BorderSide(color: Colors.transparent),
                                  right: const BorderSide(color: Colors.transparent),
                                  bottom: BorderSide(
                                      color: selectedTab == 'BTC'
                                          ? Colors.white
                                          : Colors.transparent,
                                      width: 2),
                                ),
                              ),
                              child: Text(
                                "Ticker",
                                style:TextStyle(fontSize: 14,color: Colors.grey),
                              ),
                            ),

                            Container(
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border(
                                  top: const BorderSide(
                                    color: Colors.transparent,
                                  ),
                                  left: const BorderSide(color: Colors.transparent),
                                  right: const BorderSide(color: Colors.transparent),
                                  bottom: BorderSide(
                                      color: selectedTab == 'BTC'
                                          ? Colors.white
                                          : Colors.transparent,
                                      width: 2),
                                ),
                              ),
                              child: Text(
                                "Twitter",
                                style:TextStyle(fontSize: 14,color: Colors.grey),
                              ),
                            ),




                          ],).marginAll(10);
                        },
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),



        ),
      ),
    );
  }


}
