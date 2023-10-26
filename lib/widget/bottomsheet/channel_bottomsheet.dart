import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lytics_lens/Constants/common_color.dart';
import 'package:lytics_lens/Models/channelmodel.dart';

class ChannelBottomSheet {
  static void showBottomheet({
    required List<ChannelModel> channellist,
    required RxList<dynamic> filterlist,
    required RxList<dynamic> filterChannelList,
  }) {
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
              itemCount: channellist.length,
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
                    channellist[i].check.value = !channellist[i].check.value;
                    if (channellist[i].check.value == true) {
                      if (channellist[i].name == 'All Channels') {
                        filterlist.add(channellist[i].name);
                        filterChannelList.clear();
                        for (var e in channellist) {
                          if (e.name != 'All Channels') {
                            filterlist.remove(e.name);
                            e.check.value = false;
                            filterChannelList.add(e.name);
                          }
                        }
                      } else {
                        for (var q in channellist) {
                          if (q.name == 'All Channels') {
                            if (q.check.value == true) {
                              filterChannelList.clear();
                              q.check.value = false;
                              filterlist.remove(q.name);
                            }
                          }
                        }
                        filterChannelList.add(channellist[i].name);
                        filterlist.add(channellist[i].name);
                      }
                    } else {
                      if (channellist[i].name != 'All Channels') {
                        filterlist.remove(channellist[i].name);
                        filterChannelList.remove(channellist[i].name);
                        for (var e in channellist) {
                          if (e.name == 'All Channels') {
                            e.check.value = false;
                          }
                        }
                        if (filterChannelList.isEmpty) {
                          for (var e in channellist) {
                            if (e.name != 'All Channels') {
                              filterChannelList.add(e.name);
                            } else {
                              filterlist.add(e.name);
                              e.check.value = true;
                            }
                          }
                        }
                      } else {
                        filterChannelList.clear();
                        for (var e in channellist) {
                          if (e.name != 'All Channels') {
                            filterChannelList.add(e.name);
                            e.check.value = false;
                          }
                        }
                        filterlist.remove('All Channels');
                        for (var q in channellist) {
                          if (q.name == 'All Channels') {
                            filterlist.add(q.name);
                            q.check.value = true;
                          }
                        }
                      }
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
                            value: channellist[i].check.value,
                            onChanged: (val) {
                              channellist[i].check.value =
                              !channellist[i].check.value;
                              if (channellist[i].check.value == true) {
                                if (channellist[i].name == 'All Channels') {
                                  filterlist.add(channellist[i].name);
                                  filterChannelList.clear();
                                  for (var e in channellist) {
                                    if (e.name != 'All Channels') {
                                      filterlist.remove(e.name);
                                      e.check.value = false;
                                      filterChannelList.add(e.name);
                                    }
                                  }
                                } else {
                                  for (var q in channellist) {
                                    if (q.name == 'All Channels') {
                                      if (q.check.value == true) {
                                        filterChannelList.clear();
                                        q.check.value = false;
                                        filterlist.remove(q.name);
                                      }
                                    }
                                  }
                                  filterChannelList.add(channellist[i].name);
                                  filterlist.add(channellist[i].name);
                                }
                              } else {
                                if (channellist[i].name != 'All Channels') {
                                  filterlist.remove(channellist[i].name);
                                  filterChannelList
                                      .remove(channellist[i].name);
                                  for (var e in channellist) {
                                    if (e.name == 'All Channels') {
                                      e.check.value = false;
                                    }
                                  }
                                  if (filterChannelList.isEmpty) {
                                    for (var e in channellist) {
                                      if (e.name != 'All Channels') {
                                        filterChannelList.add(e.name);
                                      } else {
                                        filterlist.add(e.name);
                                        e.check.value = true;
                                      }
                                    }
                                  }
                                } else {
                                  filterChannelList.clear();
                                  for (var e in channellist) {
                                    if (e.name != 'All Channels') {
                                      filterChannelList.add(e.name);
                                      e.check.value = false;
                                    }
                                  }
                                  filterlist.remove('All Channels');
                                  for (var q in channellist) {
                                    if (q.name == 'All Channels') {
                                      filterlist.add(q.name);
                                      q.check.value = true;
                                    }
                                  }
                                }
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
                          channellist[i].source != ''
                              ? "${channellist[i].name} (${channellist[i].source})"
                              : "${channellist[i].name}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: GoogleFonts.roboto(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.4,
                            color: CommonColor.filterColor,
                          ),
                        ),
                      ),
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
