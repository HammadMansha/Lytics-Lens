// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lytics_lens/Services/internetcheck.dart';
import 'package:lytics_lens/abstract/getstorage_abstract.dart';
import 'package:lytics_lens/utils/api.dart';

import '../Services/baseurl_service.dart';

class SelectVideoController extends GetxController with GetxStorage {
  bool isLoading = true;

  late NetworkController networkController;
  BaseUrlService baseUrlService = Get.find<BaseUrlService>();

  var arrg;
  String videoPath = '';
  String jobId = '';
  String event = '';
  String topic = '';
  List subTopic = [];
  List anchor = [];
  List guest = [];
  String source = '';
  String speaker = '';
  String statment = '';
  String thumbnailpath = '';
  String channelLogo = '';
  String description = '';
  String transcription = '';
  String translation = '';

  @override
  void onInit() async {
    if (Get.isRegistered<NetworkController>()) {
      networkController = Get.find<NetworkController>();
    } else {
      networkController = Get.put(NetworkController());
    }
    if (Get.arguments != null) {
      arrg = Get.arguments;
      jobId = arrg["id"];

      update();
    }

    super.onInit();
  }

  @override
  void onReady() async {
    await getSingleJob();
    isLoading = false;
    update();
    super.onReady();
  }

  Future<void> getSingleJob() async {
    String token = await storage.read("AccessToken");
    var res = await http.get(
        Uri.parse(baseUrlService.baseUrl + ApiData.singleJob + jobId),
        headers: {
          'Authorization': "Bearer $token",
        });
    var data = json.decode(res.body);
    videoPath = data["videoPath"];
    event = data['programName'];
    topic = data['segments'][0]['topics']['topic1'];
    // subTopic = data['segments'][0]['topics']['topic2'][0];
    subTopic = data['segments'][0]['topics']['topic2'];
    source = data["source"];
    guest = data["guests"];
    anchor = data['anchor'];
    speaker = data['anchor'][0];
    statment = data['programName'];
    channelLogo = data['channelLogoPath'];
    thumbnailpath = data['thumbnailPath'];
    description = data['programName'];
    update();
  }
}
