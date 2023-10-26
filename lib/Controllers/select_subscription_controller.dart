// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lytics_lens/Services/internetcheck.dart';
import 'package:lytics_lens/abstract/getstorage_abstract.dart';

import '../Models/subscriptionmodel.dart';
import '../Services/baseurl_service.dart';
import '../utils/api.dart';

class SelectSubscriptionController extends GetxController with GetxStorage {
  List intelligence = [];

  RxBool isShownContaine = false.obs;
  List<String> child = [];
  List alltopic = [];
  var filterlist = [];
  List reportTiming = [];
  List subValues = [];
  List filterlist1 = [].obs;

  Map ch = {};
  Map selectintelligence = {};
  Map allData = {};

  final TreeController treeController = TreeController(allNodesExpanded: false);
  BaseUrlService baseUrlService = Get.find<BaseUrlService>();

  List<Map<String, dynamic>> check = [];
  List<Map<String, dynamic>> check1 = [];
  List<Map<String, dynamic>> subscriptionSelectList = [];

  var result;
  List filter = [];

  List<Subscription> subscriptionList = [];
  List<SourceValue> sourceList = [];

  List<String> parentList = [];
  List<String> childList = [];

  String key = '';

  var temp = [];
  TextEditingController controller = TextEditingController();
  TextEditingController reportTimeController =
      TextEditingController(text: '60');
  late NetworkController networkController;

  @override
  void onInit() async {
    if (Get.isRegistered<NetworkController>()) {
      networkController = Get.find<NetworkController>();
    } else {
      networkController = Get.put(NetworkController());
    }
    intelligence = [
      {'name': 'Transcription', 'check': false},
      {'name': 'Translation', 'check': false},
      {'name': 'Sentiment', 'check': false},
      {'name': 'Speaker Recognition', 'check': false},
    ];
    reportTiming = [
      {'timming': '24 Hours', 'check': false, 'min': '1440'},
      {'timming': '12 Hours', 'check': false, 'min': '720'},
      {'timming': '6 Hours', 'check': false, 'min': '360'},
      {'timming': '3 Hours', 'check': false, 'min': '180'},
      {'timming': '1 Hour', 'check': false, 'min': '60'},
    ];

    await getUserInformation();
    update();

    super.onInit();
  }

  Future<void> getUserInformation() async {
    temp.clear();
    filter.clear();
    String token = await storage.read("AccessToken");
    String id = await storage.read("id");

    var res = await http.get(
        Uri.parse(baseUrlService.baseUrl + ApiData.getUserInformation + id),
        headers: {
          'Authorization': "Bearer $token",
        });
    var data = json.decode(res.body);

   // Get.log("All Data $data");
    Map response = data["subscription"];

    checkMap(response);

    update();
  }

  void checkMap(Map a) {
    subValues.clear();
    update();
    for (var element in a.entries) {
      if (element.value.toString().length != 2) {
        element.value.forEach((e) {
          subValues.add({
            "sValues": e,
            // "sCheck": false,
          });
        });
      } else {
        subValues = [];
      }

      check.add({
        'source': element.key,
        'source_value': subValues,
      });
    }

    for (int i = 0; i < check.length; i++) {
      filter.add({
        'source': check[i]['source'],
        'source_value':
            check[i]['source'] == 'socialMedia' ? [] : check[i]['source_value']
      });
    }

    for (int i = 0; i < filter.length; i++) {
      subscriptionList.add(Subscription.fromJson(filter[i]));
    }
    update();
  }

  void addDataInList(String c, List b) {
    ch.addAll({c: b});
    subscriptionSelectList.add({c: b});
    update();
  }

  void show() {
    allData.addAll({
      "subscription": ch,
      "intelligence": selectintelligence,
      "reportTiming": reportTimeController.text
    });
    update();
  }

  Future<void> sendData() async {
    String token = await storage.read("AccessToken");
    // var d = json.encode(allData);
    String id = storage.read("id");
    await http.patch(
      Uri.parse(baseUrlService.baseUrl + ApiData.getUserInformation + id),
      body: json.encode({'escalations': allData, 'device': 'mobile'}),
      headers: {
        'Authorization': "Bearer $token",
      },
    );
  }
}
