// ignore_for_file: unrelated_type_equality_checks

import 'dart:convert';
import 'dart:io';

import 'package:change_case/change_case.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lytics_lens/Models/alltopicmodel.dart';
import 'package:lytics_lens/Models/channelmodel2.dart';
import 'package:lytics_lens/Models/datesmodel.dart';
import 'package:lytics_lens/Models/datesmodel1.dart';
import 'package:lytics_lens/Models/programnamemodel.dart';
import 'package:lytics_lens/Models/programtypemodel.dart';
import 'package:lytics_lens/Models/programtypemodel1.dart';
import 'package:lytics_lens/Models/reprotHostModel.dart';
import 'package:lytics_lens/Services/internetcheck.dart';
import 'package:http/http.dart' as http;
import 'package:lytics_lens/abstract/getstorage_abstract.dart';
import 'package:lytics_lens/utils/api.dart';
import 'package:lytics_lens/views/graphs.dart';

import '../Services/baseurl_service.dart';
import '../widget/graph/guest_graph.dart';

class ReportsController extends GetxController with GetxStorage {
  bool isLoading = true;
  bool isPieChartData = true;

  bool isChartData = true;
  bool isSocket = false;
  bool isSocketFirstGraph1 = false;
  bool isSocketFirstGraph2 = false;
  bool isDefaultGraph = false;

  // List<PieChartSectionData> data = [];
  List<PieChartSectionData> chartdata = [];

  List<PieChartSectionData> chartdata1 = [];
  List<Widget> indicatorList = [];

  List<Widget> indicatorList1 = [];

  List piechartlist = [];

  List piechartlist1 = [];

  List graphData = [];
  List graphData1 = [];
  double total = 0.0;
  double? percentage;
  double total1 = 0.0;
  double? percentage1;

  late NetworkController networkController;

  // <------ For First time Graph Data ---------->

  List<String> allDropdownChannels = [];
  List allChanelsList = [];
  List allprogramList = [];

  List responseresult = [];
  List responseTopicresult = [];
  List responseTopic2result = [];
  List responseprogramtyperesult = [];
  List responsechannellist = [];
  List responseprogramlist = [];

  List<ReportHostModel> hostList = [];

  List programresult = [];
  List resprogramresult = [];
  List serachprogramresult = [];
  List allprogramresult = [];

  // List<GraphData> dataValues = [];
  List<GraphData> dataValues = [];
  List graphchartlist = [];

  List graphchartlist1 = [];

  TextEditingController searchController = TextEditingController();
  TextEditingController channelselect = TextEditingController();
  TextEditingController programselect = TextEditingController();
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();

  Rx<TextEditingController> hostselect = TextEditingController().obs;
  Rx<TextEditingController> hostselect1 = TextEditingController().obs;

  BaseUrlService baseUrlService = Get.find<BaseUrlService>();

  // List channels = [];
  List programTypesList = [];
  String channelSelected = "Geo News";
  List<dynamic> timeFrame = [];
  String timeFrameSelected = "Today";

  DateTime selectedDays = DateTime.now();

// <------------- Filer Data ------------------>

  var filterlist = [].obs;
  var filterlist1 = [].obs;

  List filterchannellist = [];

  List<ChannelModel3> channellist = [];
  List<ChannelModel2> channellist2 = [];

  List<ProgramNameModel> programslist = <ProgramNameModel>[].obs;

  // var programslist = [].obs;
  Rx<TextEditingController> programSelect = TextEditingController().obs;

  List channelsAll = [];

  List<ProgramTypeModel> programType = [];
  List<ProgramTypeModel1> programType1 = [];

  List programTypefilter = [];

  List programTypefilterdata = [];
  List selectprogramType = [];

  var filterHost = [].obs;
  List<String> anchorList = [];

  List anchorList1 = [];

  List allanchorList = [];
  List guestsList = [];

  List topiclist = [];
  List topic2list = [];
  List topic3list = [];
  List allData = [];
  List topic2allData = [];
  List<AllTopicModel> alltopic = [];

  List<String> selectedchannel = [];
  List<String> channellistonly = [];

  DateTime now = DateTime.now();
  DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
  DateTime week = DateTime.now().subtract(const Duration(days: 7));
  DateTime quarter = DateTime.now().subtract(const Duration(days: 15));

  List datelist = [];
  List<DatesModel> alldatelist = [];
  List<DatesModel1> alldatelist1 = [];

  // <---- Search data List ------------------->

  var channelsearchlist = [].obs;
  List programsearchlist = [];
  String trendingStartDate = '';
  String trendingEndDate = '';
  String pieChartStartDate = '';
  String pieChartEndDate = '';

  TextEditingController startSearchDate = TextEditingController();
  TextEditingController endSearchDate = TextEditingController();

  //<---------- PaiChart Filter ----------->

  RxList paichartchannel = [].obs;
  RxList paichartprogramtype = [].obs;
  RxList programtypegraph = [].obs;

  String topTopics = 'Top 10';

  List paicharthost = [];
  TextEditingController startpaichartSearchDate = TextEditingController();
  TextEditingController endpaichartSearchDate = TextEditingController();
//----------------------Trending graph field selected bool variables---------
  bool isTop10Select = true;
  bool trendingChannelSelect = false;
  bool trendingContentTypeSelect = false;
  bool trendingStartDateSelect = false;
  bool trendingEndDateSelect = false;

//----------------------Guest graph field selected bool variables---------
  bool guestChannelSelect = false;
  bool guestContentTypeSelect = false;
  bool guestStartDateSelect = false;
  bool guestEndDateSelect = false;
  bool guestHostSelect = false;

  //------------Trending Topics date variables---------
  DateTime? trendingEndData;
  DateTime? trendingStartData;

  DateTime? guestGraphEndDate;
  DateTime? guestGraphStartDate;
  int filter1DaysDifference = 0;
  int filter2DaysDifference = 0;

  @override
  void onInit() {
    if (Get.isRegistered<NetworkController>()) {
      networkController = Get.find<NetworkController>();
    } else {
      networkController = Get.put(NetworkController());
    }
    // datelist = [
    //   {
    //     'id': 'Today',
    //     'name': 'Today',
    //     'startDate': '${now.year}-${now.month}-${now.day}',
    //     'endDate': '${now.year}-${now.month}-${now.day}',
    //   },
    //   {
    //     'id': 'Yesterday',
    //     'name': 'Yesterday',
    //     'startDate': '${now.year}-${now.month}-${now.day}',
    //     'endDate': '${yesterday.year}-${yesterday.month}-${yesterday.day}',
    //   },
    //   {
    //     'id': 'Last 7 Days',
    //     'name': 'Last 7 Days',
    //     'startDate': '${now.year}-${now.month}-${now.day}',
    //     'endDate': '${week.year}-${week.month}-${week.day}',
    //   },
    //   {
    //     'id': 'This Month',
    //     'name': 'This Month',
    //     'startDate': '${now.year}-${now.month}-${now.day}',
    //     'endDate': now.month - 1 == 0
    //         ? '${now.year - 1}-12-${now.day}'
    //         : '${now.year}-${now.month - 1}-${now.day}',
    //   },
    //   // {
    //   //   'id': 'This Quarter',
    //   //   'name': 'This Quarter',
    //   //   'startDate': '${now.year}-${now.month}-${now.day}',
    //   //   'endDate': '${quarter.year}-${quarter.month}-${quarter.day}',
    //   // },
    // ];
    startSearchDate.text = DateTime(now.year, now.month - 1, now.day).toString().split(" ").first;
    endSearchDate.text = DateTime.now().toString().split(" ").first;

    startpaichartSearchDate.text = DateTime(now.year, now.month - 1, now.day).toString().split(" ").first;
    endpaichartSearchDate.text = DateTime.now().toString().split(" ").first;

    update();
    filterlist1.add('All Channels');
    filterlist.add('All Channels');
    super.onInit();
  }

  @override
  void onReady() async {
    await getAllHost();
    await getChannels();
    await getProgram();
    await getProgramType();
    await getTopic();
    await firstTimeGraphData('Top 10');
    await firstTimePieChartData();
    selectedchannel.add('All Channels');
    getdates();

    isLoading = false;
    update();
    super.onReady();
  }

  void getdates() {
    alldatelist.clear();
    alldatelist1.clear();
    update();
    for (var element in datelist) {
      alldatelist.add(DatesModel.fromJSON(element));
      alldatelist1.add(DatesModel1.fromJSON(element));
    }
    update();
  }

  void deleteData(String c) {
    if (c == 'All Channels') {
      // channelsearchlist.clear();
      // programsearchlist.clear();
      // programslist.clear();
      // filterlist1.removeWhere((element) => element == 'All Programs Name');
      // for (int i = 0; i < channellist2.length; i++) {
      //   if (channellist2[i].name == 'All Channels') {
      //     channellist2[i].check.value = false;
      //   }
      // }
      // filterlist1.removeWhere((element) => element == 'All Channels');
    } else if (c == 'All Programs Name') {
      programsearchlist.clear();
      for (int i = 0; i < programslist.length; i++) {
        if (programslist[i].name == 'All Programs Name') {
          programslist[i].check.value = false;
        }
      }
    } else {
      for (int i = 0; i < channellist2.length; i++) {
        channelsearchlist
            .removeWhere((element) => element == channellist2[i].name);
        if (channellist2[i].name.toString() == c) {
          channellist2[i].check.value = false;
          deleteSearchChannelProgram(channellist2[i].name!);
          // programslist.clear();
          programSelect.value.clear();
          update();
        }
      }
      for (int i = 0; i < programslist.length; i++) {
        if (programslist[i].name == c) {
          programsearchlist.removeWhere((element) => element == c);
          update();
          programslist[i].check.value = false;
        }
      }
      for (int i = 0; i < alldatelist1.length; i++) {
        if ('${alldatelist1[i].endDate.toString()} - ${alldatelist1[i].startDate.toString()}' ==
            c) {
          filterlist1.removeWhere((item) =>
              item ==
              '${alldatelist1[i].endDate.toString()} - ${alldatelist1[i].endDate.toString()}');
          alldatelist1[i].check.value = false;
          endSearchDate.clear();
          startSearchDate.clear();
          update();
        }
      }
    }
  }

  void deleteDataFilter(String c) {
    if (c == 'All Channels') {
      for (int i = 0; i < channellist.length; i++) {
        if (channellist[i].name == 'All Channels') {
          channellist[i].check.value = false;
        }
      }
      channelsearchlist.clear();
      programsearchlist.clear();
      programslist.clear();
      filterlist.removeWhere((element) => element == 'All Programs Name');
      filterlist.removeWhere((element) => element == 'All Channels');
    } else if (c == 'All Programs Name') {
      programsearchlist.clear();
    } else {
      for (int i = 0; i < channellist.length; i++) {
        if (channellist[i].name.toString() == c) {
          channellist[i].check.value = false;
          deleteSearchChannelProgram(channellist[i].name!);
          // programslist.clear();
          programSelect.value.clear();
          update();
        }
      }
      for (int i = 0; i < programslist.length; i++) {
        if (programslist[i].name == c) {
          programsearchlist.removeWhere((element) => element == c);
          update();
          programslist[i].check.value = false;
        }
      }
      for (int i = 0; i < alldatelist.length; i++) {
        if ('${alldatelist[i].endDate.toString()} - ${alldatelist[i].startDate.toString()}' ==
            c) {
          filterlist.removeWhere((item) =>
              item ==
              '${alldatelist[i].endDate.toString()} - ${alldatelist[i].endDate.toString()}');
          alldatelist[i].check.value = false;
          startpaichartSearchDate.clear();
          endpaichartSearchDate.clear();
          update();
        }
      }
    }
  }

  void addhostdata() {
    if (hostselect.value.text != "0") {
      bool isAvailable = false;
      for (var element in filterlist) {
        if (element == hostselect.value.text) {
          isAvailable = true;
          update();
        }
      }
      if (isAvailable == false) {
        filterlist.add(hostselect.value.text);
        paicharthost.add(hostselect.value.text);
        update();
      } else {
        isAvailable = false;
        update();
      }
      update();
    }
  }

  //< ------------ Get All Host -------------->

  Future<void> getAllHost() async {
    List allanchorList = [];
    anchorList.clear();
    List aList = [];
    List host = [];
    update();
    try {
      String token = await storage.read("AccessToken");
      var res = await http
          .get(Uri.parse(baseUrlService.baseUrl + ApiData.hosts), headers: {
        'Authorization': 'Bearer $token',
      });
      var response = json.decode(res.body);
      allanchorList.addAll(response['results']);

      for (var e in allanchorList) {
        aList.add(e['name']);
      }
      aList = Set.of(aList).toList();
      for (var e in aList) {
        anchorList.add(e);
      }
      anchorList.sort((a, b) => a.toString().compareTo(b.toString()));

      for (var e in anchorList) {
        host.add({
          "id": e,
          "name": e,
        });
      }

      for (var element in host) {
        hostList.add(ReportHostModel.fromJSON(element));
      }
      update();
    } on SocketException {
      isLoading = false;
      update();
      isSocket = true;
      update();
    }
  }

  // <------------- Get Program type ------------>

  Future<void> getProgramType() async {
    responseprogramtyperesult.clear();
    responseprogramlist.clear();
    programType.clear();
    programType1.clear();
    responseprogramtyperesult.clear();
    update();
    try {
      String token = await storage.read("AccessToken");
      var res = await http.get(
          Uri.parse(baseUrlService.baseUrl + ApiData.programTypes),
          headers: {
            'Authorization': 'Bearer $token',
          });
      var response = json.decode(res.body);
      responseprogramtyperesult.addAll(response['results']);
      for (var element in responseprogramtyperesult) {
        if (element['name'] == 'EE - Training' ||
            element['name'] == 'UU - Training') {
        } else {
          responseprogramlist
              .add({'id': element['name'], 'name': element['name']});
          programTypefilter.add(element['name']);
          programTypefilterdata
              .add({'id': element['name'], 'name': element['name']});
        }
        // programTypesList.add({"id": element['name'], "name": element['name']});
      }
      update();
      for (var element in responseprogramlist) {
        programType.add(ProgramTypeModel.fromJSON(element));
        programType1.add(ProgramTypeModel1.fromJSON(element));
      }
      update();
    } on SocketException {
      isLoading = false;
      update();
      isSocket = true;
      update();
    } catch (e) {
      isLoading = false;
      update();
    }
  }

  // <------------- Get Topic type ------------>

  Future<void> getTopic() async {
    responseTopicresult.clear();
    topiclist.clear();
    responseTopic2result.clear();
    topic2list.clear();
    update();
    try {
      String token = await storage.read("AccessToken");
      var res = await http
          .get(Uri.parse(baseUrlService.baseUrl + ApiData.topic), headers: {
        'Authorization': 'Bearer $token',
      });
      var response = json.decode(res.body);
      // log('Topic Response $response');
      responseTopicresult.addAll(response['results']);
      for (var element in responseTopicresult) {
        topiclist.add(element['name']);
        responseTopic2result.add(element['topic2']);
        // responseprogramlist.add(element['name']);
        // programTypesList.add({"id": element['name'], "name": element['name']});
      }
      for (var e in responseTopic2result) {
        topic2list.add({
          'id': e['name'],
          'name': e['name'],
        });
      }
      update();
    } on SocketException {
      isLoading = false;
      update();
      isSocket = true;
      update();
    } catch (e) {
      isLoading = false;
      update();
      // Get.snackbar("Catch Error", e.toString(), backgroundColor: Colors.red);
    }
  }

  //<-------------- Get Channels Name ---------->

  Future<void> getChannels() async {
    responsechannellist.clear();
    channellist.clear();
    channellist2.clear();
    channelsearchlist.clear();
    paichartchannel.clear();
    filterchannellist.clear();
    List reverse = [];
    // allChanelsList.clear();
    channelsAll.clear();
    update();
    try {
      String token = await storage.read("AccessToken");
      var res = await http
          .get(Uri.parse(baseUrlService.baseUrl + ApiData.channels), headers: {
        'Authorization': 'Bearer $token',
      });
      var response = json.decode(res.body);
      // log('Chanel Response $response');
      responseresult.addAll(response['results']);
      for (var element in responseresult) {
        if (element['name'].toString().isLowerCase == 'all') {
        } else {
          responsechannellist
              .add({"name": element['name'], "type": element['type']});
          filterchannellist.add(element['name']);
        }
      }
      reverse = responsechannellist.reversed.toList();
      channelsAll
          .add({'id': 'All Channels', 'name': 'All Channels', 'type': ''});
      channellistonly.add('All Channels');
      for (var e in reverse) {
        allChanelsList.add(e['name']);
        channelsearchlist.add(e['name']);
        paichartchannel.add(e['name']);
        allDropdownChannels.add(e['name']);
        channellistonly.add(e['name']);
        channelsAll
            .add({'id': e['name'], 'name': e['name'], 'type': e['type']});
      }

      for (var element in channelsAll) {
        channellist.add(ChannelModel3.fromJSON(element));
        channellist2.add(ChannelModel2.fromJSON(element));
      }
      for (var e in channellist2) {
        if (e.name == "All Channels") {
          e.check.value = true;
        }
      }
      for (var q in channellist) {
        if (q.name == "All Channels") {
          q.check.value = true;
        }
      }
      update();
    } on SocketException {
      isLoading = false;
      update();
      isSocket = true;
      update();
    } catch (e) {
      isLoading = false;
      update();
    }
  }

  // <------------ Get Program --------------->

  Future<void> getProgram() async {
    allprogramresult.clear();
    allprogramList.clear();
    programslist.clear();
    List programlist = [];
    update();
    try {
      String token = await storage.read("AccessToken");
      var res = await http.get(
          Uri.parse(baseUrlService.baseUrl + ApiData.programNames),
          headers: {
            'Authorization': 'Bearer $token',
          });
      var response = json.decode(res.body);
      // log("Program res $response");
      programresult.addAll(response['results']);
      for (var element in programresult) {
        allprogramresult.add(element['title']);
      }
      update();
      allprogramresult = Set.of(allprogramresult).toList();
      update();
      for (var element in allprogramresult) {
        allprogramList.add(element);
        programlist.add({
          'id': '$element',
          'name': '$element',
        });
      }
      update();
    } on SocketException {
      isLoading = false;
      update();
      isSocket = true;
      update();
    } catch (e) {
      isLoading = false;
      update();
      // Get.snackbar("Catch Error", e.toString(), backgroundColor: Colors.red);
    }
  }

  searchFunction(String channelname) {
    List plist = [];
    List sortplist = [];
    List allProgramName = [];
    // programslist.clear();
    if (channelname == 'All Channels') {
      programslist.clear();
      programsearchlist.clear();
      for (var e in programresult) {
        sortplist.add(e['title']);
      }
      update();
      sortplist = Set.of(sortplist).toList();
      update();
      for (var element in sortplist) {
        programsearchlist.add(element);
        plist.add({"id": element, "name": element});
      }
      update();
      allProgramName
          .add({"id": 'All Programs Name', "name": 'All Programs Name'});
      update();
      for (var element in allProgramName) {
        programslist.add(ProgramNameModel.fromJSON(element));
      }
      // plist.forEach((element) {
      //   programslist.add(ProgramNameModel.fromJSON(element));
      // });
      for (var element in programslist) {
        element.check.value = true;
      }
      update();
      filterlist1.add('All Programs Name');
    } else {
      for (var e in programresult) {
        if (e['channel'].toString().contains(channelname)) {
          sortplist.add(e['title']);
        }
        update();
      }
      update();
      sortplist = Set.of(sortplist).toList();
      update();
      for (var element in sortplist) {
        programsearchlist.add(element);
        plist.add({"id": element, "name": element});
      }
      update();
      for (var element in plist) {
        programslist.add(ProgramNameModel.fromJSON(element));
      }
    }
  }

  deleteSearchChannelProgram(String channelname) {
    // programslist.clear();
    update();
    for (var e in programresult) {
      if (e['channel'].toString().contains(channelname)) {
        programslist.removeWhere((item) => item.name == e['title']);
        filterlist1.removeWhere((item) => item == e['title']);
        // plist.add({"id": e['title'], "name": e['title']});
        // serachprogramresult.add(e["title"]);
      }
      update();
    }
  }

  // <------- Pai Chart Data ------------>

  Future<void> getPieChartData() async {
    isLoading = true;
    isSocketFirstGraph2 = false;
    chartdata.clear();
    piechartlist.clear();
    graphchartlist.clear();
    indicatorList.clear();
    total = 0.0;
    List selectedchannellist = [];
    List selectedprogramresult = [];
    selectedchannellist.add(channelselect.text);
    selectedprogramresult.add(programselect.text);
    update();
    try {
      String token = await storage.read("AccessToken");
      var res = await http.post(
          Uri.parse(baseUrlService.baseUrl + ApiData.guestsgraph),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-type': 'application/json',
            "Accept": "application/json",
          },
          body: json.encode({
            "startDate": startpaichartSearchDate.text,
            "endDate": endpaichartSearchDate.text,
            "channel": paichartchannel,
            "programType": paichartprogramtype,
            "programName": [],
            "anchor": filterHost,
          }));

      var data1 = json.decode(res.body);
      // Get.log('print All Map  for Graph is $data1');
      piechartlist.addAll(data1);
      update();
      if (piechartlist.length >= 5) {
        for (var i = 0; i < 5; i++) {
          total += piechartlist[i]['count'];
        }
        for (var i = 0; i < 5; i++) {
          percentage = (piechartlist[i]['count'] * 100 / total);
          update();
          chartdata.add(
            PieChartSectionData(
              color: colors[i],
              value: percentage!.roundToDouble(),
              title: '${percentage!.roundToDouble()}%',
              radius: 70,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              titlePositionPercentageOffset: 0.55,
            ),
          );
          indicatorList.add(Indicator(
              color: colors[i],
              text: piechartlist[i]['guest'],
              isSquare: false,
              textColor: colors[i]));
        }
      } else {
        chartdata.clear();
        update();
        for (var i = 0; i < piechartlist.length; i++) {
          total += piechartlist[i]['count'];
        }
        for (var i = 0; i < piechartlist.length; i++) {
          percentage = piechartlist[i]['count'] * 100 / total;
          update();
          chartdata.add(
            PieChartSectionData(
              color: colors[i],
              value: percentage!.roundToDouble(),
              title: '${percentage!.roundToDouble()}%',
              radius: 50,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              titlePositionPercentageOffset: 0.55,
            ),
          );
          indicatorList.add(Indicator(
              color: colors[i],
              text: piechartlist[i]['guest'],
              isSquare: false,
              textColor: colors[i]));
        }
      }

      isLoading = false;
      update();
    } on SocketException {
      isLoading = false;
      update();
      isSocket = true;
      update();
    }
  }

  Future<void> firstTimePieChartData() async {
    try {
      isLoading = true;
      chartdata.clear();
      piechartlist.clear();
      graphchartlist.clear();
      indicatorList.clear();
      total = 0;
      List selectedchannellist = [];
      List selectedprogramresult = [];
      selectedchannellist.add(channelselect.text);
      selectedprogramresult.add(programselect.text);
      update();
      String token = await storage.read("AccessToken");
      var res = await http.post(
          Uri.parse(baseUrlService.baseUrl + ApiData.guestsgraph),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-type': 'application/json',
            "Accept": "application/json",
          },
          body: json.encode({
            "endDate": '${now.year}/${now.month}/${now.day}',
            "startDate": now.month - 1 == 0
                ? '${now.year - 1}/12/${now.day}'
                : '${now.year}/${now.month - 1}/${now.day}',
            "channel": allChanelsList,
            "programType": programTypefilter,
            "programName": [],
            "anchor": anchorList,
          }));
      // Get.log("-------${json.encode({
      //   "endDate": '${now.year}/${now.month}/${now.day}',
      //   "startDate": now.month - 1 == 0
      //       ? '${now.year - 1}/12/${now.day}'
      //       : '${now.year}/${now.month - 1}/${now.day}',
      //   "channel": allChanelsList,
      //   "programType": programTypefilter,
      //   "programName": [],
      //   "anchor": anchorList,
      // })}");

      var data1 = json.decode(res.body);
      // Get.log('print All Map  for Graph is $data1');
      piechartlist.addAll(data1);
      update();
      if (piechartlist.length >= 5) {
        for (var i = 0; i < 5; i++) {
          // chartdata.add(
          //   ChartSampleData(
          //       x: piechartlist[i]['guest'], y: piechartlist[i]['count']),
          // );
          total += piechartlist[i]['count'];
          // Get.log("The total is $total");
          // data.add(
          //   PieChartSectionData(
          //       //title: piechartlist[i]['guest'],
          //       titleStyle: TextStyle(color: Colors.white),
          //       value: piechartlist[i]['count'].toDouble(),
          //       color: Color(0xff22B161)),
          // );
        }
        for (var i = 0; i < 5; i++) {
          percentage = (piechartlist[i]['count'] * 100 / total);
          // Get.log("The percentage is $percentage");
          update();
          chartdata.add(
            PieChartSectionData(
              color: colors[i],
              value: percentage!.roundToDouble(),
              title: '${percentage!.roundToDouble()}%',
              radius: 70,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              titlePositionPercentageOffset: 0.55,
            ),

            // ChartSampleData(
            //     x: piechartlist[i]['guest'], y: percentage!.roundToDouble()),
          );
          indicatorList.add(Indicator(
              color: colors[i],
              text: piechartlist[i]['guest'],
              isSquare: false,
              textColor: colors[i]));

          // chartdata.add(percentage);
          // update();
        }
      } else {
        chartdata.clear();
        update();
        for (var i = 0; i < piechartlist.length; i++) {
          // chartdata.add(
          //   ChartSampleData(
          //       x: piechartlist[i]['guest'], y: piechartlist[i]['count']),
          // );
          total += piechartlist[i]['count'];

          // data.add(
          //   PieChartSectionData(
          //       //title: piechartlist[i]['guest'],
          //       titleStyle: TextStyle(color: Colors.white),
          //       value: piechartlist[i]['count'].toDouble(),
          //       color: Color(0xff22B161)),
          // );
        }
        for (var i = 0; i < piechartlist.length; i++) {
          percentage = piechartlist[i]['count'] * 100 / total;
          update();
          chartdata.add(
            PieChartSectionData(
              color: colors[i],
              value: percentage!.roundToDouble(),
              title: '${percentage!.roundToDouble()}%',
              radius: 50,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              titlePositionPercentageOffset: 0.55,
            ),
            // ChartSampleData(
            //     x: piechartlist[i]['guest'], y: percentage!.roundToDouble()),
          );
          indicatorList.add(Indicator(
              color: colors[i],
              text: piechartlist[i]['guest'],
              isSquare: false,
              textColor: colors[i]));
          // chartdata.add(percentage);
        }
      }
      isLoading = false;
      update();
    } on SocketException {
      isLoading = false;
      update();
      isSocket = true;
      update();
    } catch (e) {
      isLoading = false;
      update();
    }
  }

  // <========== barChart =========>

  Future<void> firstTimeGraphData(String topicstop) async {
    dataValues.clear();
    graphData.clear();
    graphchartlist.clear();
    isLoading = true;
    isDefaultGraph = false;
    update();
    List selectedchannellist = [];
    List selectedprogramresult = [];
    selectedchannellist.add(channelselect.text);
    selectedprogramresult.add(programselect.text);
    update();
    try {
      isLoading = true;
      update();
      //Get.log('CHeck ProgramTypes Data ${json.encode(programTypefilter)}');
      String token = await storage.read("AccessToken");
      var res = await http.post(
        Uri.parse(baseUrlService.baseUrl + ApiData.media),
        headers: {
          'Content-type': 'application/json',
          "Accept": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: json.encode(
          {
            "endDate": '${now.year}-${now.month}-${now.day}',
            "startDate": now.month - 1 == 0
                ? '${now.year - 1}-12-${now.day}'
                : '${now.year}-${now.month - 1}-${now.day}',
            "channel": allChanelsList,
            "programType": programTypefilter,
            "topics": [topicstop]
          },
        ),
      );
      // Get.log('ALl Graph data first time is ${json.encode({
      //       "endDate": '${now.year}-${now.month}-${now.day}',
      //       "startDate": now.month - 1 == 0
      //           ? '${now.year - 1}-12-${now.day}'
      //           : '${now.year}-${now.month - 1}-${now.day}',
      //       // "endDate": endSearchDate.text,
      //       "channel": allChanelsList,
      //       "programType": programTypefilter,
      //       "topics": [topicstop]
      //     })}');
      var data1 = json.decode(res.body);
      //Get.log("1st time Graph data is Main Topics: $data1");
      graphchartlist.addAll(data1);
      graphData.clear();
      update();
      for (int i = 0; i < graphchartlist.length; i++) {
        // print('Graph Data is ${graphchartlist[i]}');
        search(graphchartlist[i]);
      }
      getAllData(topicstop);
      isLoading = false;
      update();
      // print(body.toString());
    } on SocketException {
      isLoading = false;
      update();
      isSocket = true;
      update();
    } catch (e) {
      isLoading = false;
      update();
    }
  }

  //search from map

  void search(Map a) {
    for (var element in a.entries) {
      if (element.key == 'topic1') {
      } else {
        if (element.key == 'topic21') {
          graphData.add(element.value);
        }
        // print('All Sub Topic Data is${element.value}');
      }
    }
    update();
  }

  void getAllData(String trendingTopic) {
    // List check = [];

    graphData.sort((a, b) => (b['Count']).compareTo(a['Count']));
    //<------------- Unique ------------------>
    final jsonList = graphData.map((item) => jsonEncode(item)).toList();
    final uniqueJsonList = jsonList.toSet().toList();
    final result = uniqueJsonList.map((item) => jsonDecode(item)).toList();

    for (int i = 0; i < result.length; i++) {}
    if (trendingTopic == 'Top 5') {
      if (result.length >= 5) {
        for (int i = 0; i < 5; i++) {
          dataValues.add(
            // ChartSampleData(
            //   x: '${result[i]['name']}',
            //   y: result[i]['Count'],
            //   pointColor: const Color(0xff22B161),
            // ),
            GraphData(
              result[i]['name'].toString().split(' ').first,
              result[i]['Count'],
              charts.ColorUtil.fromDartColor(const Color(0xff22B161)),
            ),
          );
        }
      } else {
        for (int i = 0; i < result.length; i++) {
          dataValues.add(
            // ChartSampleData(
            //   x: '${result[i]['name']}',
            //   y: result[i]['Count'],
            //   pointColor: const Color(0xff22B161),
            // ),
            GraphData(
              result[i]['name'].toString().split(' ').first,
              result[i]['Count'],
              charts.ColorUtil.fromDartColor(const Color(0xff22B161)),
            ),
          );
        }
      }
    } else {
      if (result.length >= 10) {
        for (int i = 0; i < 10; i++) {
          dataValues.add(
            // ChartSampleData(
            //   x: '${result[i]['name']}',
            //   y: result[i]['Count'],
            //   pointColor: const Color(0xff22B161),
            // ),
            GraphData(
              result[i]['name'].toString().split(' ').first,
              result[i]['Count'],
              charts.ColorUtil.fromDartColor(const Color(0xff22B161)),
            ),
          );
        }
      } else {
        for (int i = 0; i < result.length; i++) {
          dataValues.add(
            // ChartSampleData(
            //   x: '${result[i]['name']}',
            //   y: result[i]['Count'],
            //   pointColor: const Color(0xff22B161),
            // ),
            GraphData(
              result[i]['name'].toString().split(' ').first,
              result[i]['Count'],
              charts.ColorUtil.fromDartColor(const Color(0xff22B161)),
            ),
          );
        }
      }
    }
  }

  Future<void> getGraphData() async {
    dataValues.clear();
    graphchartlist.clear();
    graphData1.clear();
    isLoading = true;
    isSocketFirstGraph1 = false;
    update();
    update();
    List selectedchannellist = [];
    List selectedprogramresult = [];
    selectedchannellist.add(channelselect.text);
    selectedprogramresult.add(programselect.text);
    update();
    try {
      isLoading = true;
      update();
      String token = await storage.read("AccessToken");
      var res =
          await http.post(Uri.parse(baseUrlService.baseUrl + ApiData.media),
              headers: {
                'Content-type': 'application/json',
                "Accept": "application/json",
                'Authorization': 'Bearer $token',
              },
              body: json.encode({
                "endDate": endSearchDate.text,
                "startDate": startSearchDate.text,
                "channel": channelsearchlist,
                "programType": programtypegraph,
                "topics": ["Top 10"]
              }));

      // Get.log("++++++++++++++ ${json.encode({
      //   "endDate": endSearchDate.text,
      //   "startDate": startSearchDate.text,
      //   "channel": channelsearchlist,
      //   "programType": programtypegraph,
      //   "topics": ["Top 10"]
      // })}");
      var data1 = json.decode(res.body);
      graphchartlist.addAll(data1);
      update();
      for (int i = 0; i < graphchartlist.length; i++) {
        search1(graphchartlist[i]);
      }
      getAllData1();
      isLoading = false;
      update();
    } on SocketException {
      isLoading = false;
      update();
      isSocket = true;
      update();
    }
  }

  void search1(Map a) {
    for (var element in a.entries) {
      if (element.key == 'topic1') {
      } else {
        if (element.key == 'topic21') {
          graphData1.add(element.value);
        }
      }
    }
    update();
  }

  void getAllData1() {
    graphData1.sort((a, b) => (b['Count']).compareTo(a['Count']));
    final jsonList = graphData1.map((item) => jsonEncode(item)).toList();
    final uniqueJsonList = jsonList.toSet().toList();
    final result1 = uniqueJsonList.map((item) => jsonDecode(item)).toList();
    for (int i = 0; i < result1.length; i++) {}
    if (result1.length >= 10) {
      for (int i = 0; i < 10; i++) {
        dataValues.add(
          // ChartSampleData(
          //   x: '${result1[i]['name']}',
          //   y: result1[i]['Count'],
          //   pointColor: const Color(0xff22B161),
          // ),
          GraphData(
            result1[i]['name'].toString().split(' ').first,
            result1[i]['Count'],
            charts.ColorUtil.fromDartColor(const Color(0xff22B161)),
          ),
        );
      }
    } else {
      for (int i = 0; i < result1.length; i++) {
        dataValues.add(
          // ChartSampleData(
          //   x: '${result1[i]['name']}',
          //   y: result1[i]['Count'],
          //   pointColor: const Color(0xff22B161),
          // ),
          GraphData(
            result1[i]['name'].toString().split(' ').first,
            result1[i]['Count'],
            charts.ColorUtil.fromDartColor(const Color(0xff22B161)),
          ),
        );
      }
    }
  }

  String listToString(List c) {
    List g = [];
    for (int i = 0; i < c.length; i++) {
      g.add(c[i]);
    }
    // update();
    var channel = g.join(", ");
    // var guest = " ";
    return channel;
  }

  String checkList(String name) {
    var r = filterHost.firstWhere((e) => e == name, orElse: () => 'not found');
    return r;
  }

  void deleteDataFromFilterList(String f) {
    if (f == 'All Channels') {
    } else {
      for (var r in channellist2) {
        if (r.name == f) {
          r.check.value = false;
          channelsearchlist.remove(f);
          filterlist1.remove(f);
        }
      }
      if (channelsearchlist.isEmpty) {
        for (var w in channellist2) {
          if (w.name == 'All Channels') {
            filterlist1.add(w.name);
            w.check.value = true;
          } else {
            channelsearchlist.add(w.name);
          }
        }
      }
    }
  }

  void deleteDataFromFilterListPia(String f) {
    if (f == 'All Channels') {
    } else {
      for (var r in channellist) {
        if (r.name == f) {
          r.check.value = false;
          paichartchannel.remove(f);
          filterlist.remove(f);
        }
      }
      if (paichartchannel.isEmpty) {
        for (var w in channellist) {
          if (w.name == 'All Channels') {
            filterlist.add(w.name);
            w.check.value = true;
          } else {
            paichartchannel.add(w.name);
          }
        }
      }
    }
  }

  List colors = const [
    Color(0xff0293ee),
    Color(0xfff8b250),
    Color(0xff845bef),
    Color(0xff13d38e),
    Color(0xffffffff)
  ];

  //----------------Trending topics date picker function----------
  void showTrendingCalendar(BuildContext context) {
    return showCustomDateRangePicker(
      fontFamily: 'Roboto',
      primaryColor: Colors.transparent,
      backgroundColor: Colors.green,
      context,
      dismissible: true,
      minimumDate: DateTime(1947, 01, 01),
      maximumDate: DateTime.now(),
      endDate: trendingEndData,
      startDate: trendingStartData,
      onApplyClick: (start, end) {
        trendingEndData = end;
        trendingStartData = start;
        startSearchDate.text = trendingStartData.toString().split(" ").first;
        endSearchDate.text = trendingEndData.toString().split(" ").first;
        if (kDebugMode) {
          print("Start date ${startSearchDate.text}");
          print("End date ${endSearchDate.text}");
        }
        filter1DaysDifference =
            trendingEndData!.difference(trendingStartData!).inDays;
        Get.log("date differenceeeeeeeee ${filter1DaysDifference.toString()}");

        update();
      },
      onCancelClick: () {
        trendingEndData = null;
        trendingStartData = null;
        update();
      },
    );
  }

//----------------Guest Pie chart date picker function------------

  void showGuestGraphCalendar(BuildContext context) {
    return showCustomDateRangePicker(
      fontFamily: 'Roboto',
      primaryColor: Colors.transparent,
      backgroundColor: Colors.green,
      context,
      dismissible: true,
      minimumDate: DateTime(1947, 01, 01),
      maximumDate: DateTime.now(),
      endDate: guestGraphEndDate,
      startDate: guestGraphStartDate,
      onApplyClick: (start, end) {
        guestGraphEndDate = end;
        guestGraphStartDate = start;
        startpaichartSearchDate.text =
            guestGraphStartDate.toString().split(" ").first;
        endpaichartSearchDate.text =
            guestGraphEndDate.toString().split(" ").first;
        if (kDebugMode) {
          print("Start date ${startpaichartSearchDate.text}");
          print("End date ${endpaichartSearchDate.text}");
        }

        filter2DaysDifference =
            guestGraphEndDate!.difference(guestGraphStartDate!).inDays;
        Get.log("date differenceeeeeeeee ${filter2DaysDifference.toString()}");

        update();
      },
      onCancelClick: () {
        guestGraphEndDate = null;
        guestGraphStartDate = null;
        update();
      },
    );
  }
}
