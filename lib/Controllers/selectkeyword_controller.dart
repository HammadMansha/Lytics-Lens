// ignore_for_file: unused_catch_clause

import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lytics_lens/Services/internetcheck.dart';
import 'package:lytics_lens/abstract/getstorage_abstract.dart';
import 'package:lytics_lens/utils/api.dart';
import 'package:flutter/material.dart';

import '../Models/topicmodel.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';

import '../Services/baseurl_service.dart';

class SelectKeyWordController extends GetxController with GetxStorage {
  RxInt counter = 10.obs;
  var currentindex = 0;
  late NetworkController networkController;
  BaseUrlService baseUrlService = Get.find<BaseUrlService>();

  bool isSocket = false;
  bool isLoading = true;

  List allDataList = [];

  RxInt keywordsCounter = 10.obs;
  var keywordsCurrentIndex = 0;
  TextEditingController keyWord = TextEditingController();
  TextEditingController addKeyWord = TextEditingController();
  final TreeController treeController = TreeController(allNodesExpanded: false);

  List<Map<String, dynamic>> selectedtopicList = [];

  Pattern pattern = r'^(?=.*[a-zA-Z])(?=.*[*".!@#\$%^&(){}:;<>,.\'
      r"'?/~_+-=])(?=.*[0-9]).{8,30}\$";

  RxList topicsList = [].obs;

  var keyWordsList = []; //List for add All data at once from api

  List<String> listOfQueryWords = []; //List for add query data
  List<String> urduQueryWords =
      []; // List for add urdu querrywords from api function

  var showListOfWords = [].obs; //List for show keywords in ui
  var showListOfUrduWords = [].obs; //List for show Urdu Keywords in ui

  List allKeyword = [];

  var urduKeyPressed = false.obs;
  var englishKeyPressed = true.obs;

  RxBool isContainerShown = false.obs;

  List<TopicModel> topicList = [];

  AnimationController? controller;
  Animation? animation;

  FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    controller!.dispose();
    focusNode.dispose();

    super.dispose();
  }

  @override
  void onInit() async {
    if (Get.isRegistered<NetworkController>()) {
      networkController = Get.find<NetworkController>();
    } else {
      networkController = Get.put(NetworkController());
    }
    await getKeyWords();

    // controller = AnimationController(vsync: this, duration: Duration(milliseconds:300));
    // animation = Tween(begin: 300.0, end: 50.0).animate(controller!)
    // ..addListener(() {

    // });

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        controller!.forward();
      } else {
        controller!.reverse();
      }
    });

    super.onInit();
  }

  @override
  void onReady() async {
    await gettopic();
    await getKeyWords();
    isLoading = false;

    update();
    super.onReady();
  }

  Future<void> getKeyWords() async {
    String token = await storage.read("AccessToken");
    var res = await http
        .get(Uri.parse(baseUrlService.baseUrl + ApiData.getKeyWords), headers: {
      'Authorization': "Bearer $token",
    });
    var data = json.decode(res.body);
    // print("All Data $data");
    //Get.log("All Data $data");

    keyWordsList.addAll(data['results']);
    for (var element in keyWordsList) {
      if (element["language"].toString() == 'Urdu') {
        urduQueryWords.add(element["queryWord"]);
      } else {
        listOfQueryWords.add(element["queryWord"]);
      }
    }
    update();
  }

  Future<void> gettopic() async {
    try {
      isSocket = false;
      topicList.clear();
      update();
      String token = await storage.read("AccessToken");
      var res = await http
          .get(Uri.parse(baseUrlService.baseUrl + ApiData.topic), headers: {
        'Authorization': "Bearer $token",
      });
      var data = json.decode(res.body);
      // Get.log('Data is $data');
      // print('Data is $data');
      data['results'].forEach((e) {
        topicList.add(TopicModel.fromJson(e));
      });

      update();
      for (int i = 0; i < topicList.length; i++) {}
    } on SocketException catch (e) {
      isLoading = false;
      isSocket = true;
      update();
      // CustomSnackBar.showSnackBar(
      //     title: AppStrings.unable,
      //     message: "",
      //     backgroundColor: Color(0xff48beeb),isWarning: true);
    } catch (e) {
      isLoading = false;
      update();
    }
  }

  void addDataToList(String topic1, List topic2, List topic3) {
    selectedtopicList.add({
      "topic1": topic1,
      "topic2": topic2,
      "topic3": topic3,
    });
    update();
  }

  void show() {
    // selectedtopicList.forEach((element) {

    // });
  }

  void show1() {
    // selectedtopicList.forEach((element) {

    // });
  }

  Future<void> updateTopic() async {
    String token = await storage.read("AccessToken");
    // var d = json.encode(allData);
    String id = storage.read("id");
    await http.patch(
      Uri.parse(baseUrlService.baseUrl + ApiData.getUserInformation + id),
      body: json.encode({'topics': selectedtopicList, 'device': 'mobile'}),
      headers: {
        'Authorization': "Bearer $token",
      },
    );
  }

  Future<void> updatekeyword() async {
    String token = await storage.read("AccessToken");
    // var d = json.encode(allData);
    String id = storage.read("id");
    await http.patch(
      Uri.parse(baseUrlService.baseUrl + ApiData.getUserInformation + id),
      body: json.encode({'keyWords': allKeyword, 'device': 'mobile'}),
      headers: {
        'Authorization': "Bearer $token",
      },
    );
  }
}
