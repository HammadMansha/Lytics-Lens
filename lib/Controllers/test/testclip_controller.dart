// ignore_for_file: avoid_init_to_null, prefer_final_fields, empty_catches, depend_on_referenced_packages, unused_catch_clause, unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lytics_lens/Constants/common_color.dart';
import 'package:lytics_lens/Controllers/company_user/companyUser_controller.dart';
import 'package:lytics_lens/Controllers/home_controller.dart';
import 'package:lytics_lens/Services/baseurl_service.dart';
import 'package:lytics_lens/abstract/getstorage_abstract.dart';
import 'package:lytics_lens/utils/api.dart';
import 'package:http/http.dart' as http;
import 'package:lytics_lens/widget/snackbar/common_snackbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class TestClipController extends GetxController with GetxStorage {
  bool isLoading = true;
  RxBool isPlaying = false.obs;
  var isScreenLoading = true.obs;
  var nodata = false.obs;


  TextEditingController title = TextEditingController();
  TextEditingController des = TextEditingController();
  TextEditingController searchContact = TextEditingController();
  HomeScreenController homeScreenController = Get.find<HomeScreenController>();
  BaseUrlService baseUrlService = Get.find<BaseUrlService>();

  CompanyUserController companyUserController =
      Get.find<CompanyUserController>();

  late BetterPlayerController betterPlayerController;

  String jobId = '';

  String senderId = '';
  String senderFirstName = '';
  String senderLastName = '';

  double startDuration = 0.0;
  double endDuration = 0.0;
  double totalDuration = 0.0;
  double videoDuration = 0.0;

  double tstartDuration = 0.0;
  double tendDuration = 0.0;

  double fstartDuration = 0.0;
  double fendDuration = 0.0;

  RxInt playerTime = 0.obs;

  var audioFile = null;
  Codec _codec = Codec.aacMP4;
  FlutterSoundPlayer? mPlayer = FlutterSoundPlayer();
  bool mPlayerIsInited = false;
  RxBool isPlay = false.obs;
  final recorder = FlutterSoundRecorder();
  String mPath = '${DateTime.now().millisecondsSinceEpoch.toString()}.mp4';
  List customThumbnail = [];
  bool showPlaceHolder = false;
  String videoUrl='';
  String channelName='';
  String programName='';
  String topic1='';
  String transcription='';
  String source='';



  String isJobLibrary="";
  late String localPath;
  RxBool donwloadLoader=false.obs;

  @override
  void onInit() async {
    senderId = await storage.read('id');
    senderFirstName = await storage.read('firstName');
    senderLastName = await storage.read('lastName');
    mPlayer!.openPlayer().then((value) {
      mPlayerIsInited = true;
      update();
    });
    super.onInit();
  }

  @override
  void onReady() async {
    Get.log("-----------Get argumemt ${Get.arguments}");
    companyUserController.searchcompanyUser.clear();
    companyUserController.sharingUser.clear();
    if (Get.arguments != null) {
      videoUrl=Get.arguments["url"]??"";

        betterPlayerController = BetterPlayerController(
          BetterPlayerConfiguration(
            aspectRatio: 16 / 13,
            looping: true,
            autoPlay: false,
            autoDispose: true,
            fit: BoxFit.cover,
            eventListener: (BetterPlayerEvent e) => eveB(e),
            controlsConfiguration:  BetterPlayerControlsConfiguration(
              enableAudioTracks: false,
              enablePip: false,
              enableMute: false,
              enableSkips: false,
              enableProgressText: false,
              enableOverflowMenu: false,
              enablePlayPause: false,
              enableProgressBar: false,
              enableFullscreen: false,
              forwardSkipTimeInMilliseconds: 10000,
              backwardSkipTimeInMilliseconds: 10000,
              progressBarPlayedColor: Colors.orange,
              progressBarBufferedColor: Color(0xff676767),
              progressBarBackgroundColor: Color(0xff676767),
            ),
          ),
          betterPlayerDataSource: BetterPlayerDataSource(
            BetterPlayerDataSourceType.network,
            Get.arguments['url'],
          ),
        );
        if (kDebugMode) {
          print("------test clipping joblibrary value ${Get.arguments.toString()}");

        }

        isJobLibrary=Get.arguments["isJobLibrary"].toString();

        if(Get.arguments["jobPortal"].toString()=="portal"){
          title.text=Get.arguments["title"];
          des.text=Get.arguments["description"];
          //audioFile=Get.arguments["voiceNote"];
        }
        else{
          title.text='';
          des.text;
          //audioFile==null;
        }

      endDuration = Get.arguments['endDuration'] == 0.0
          ? Get.arguments['video_duration']
          : Get.arguments['endDuration'];

      videoDuration = Get.arguments['video_duration'];

      startDuration = Get.arguments['startDuration'] == 0.0
          ? 0.0
          : Get.arguments['startDuration'];
      totalDuration = Get.arguments['totalDuration'] == 0.0
          ? 0.0
          : Get.arguments['totalDuration'];
      tendDuration = Get.arguments['totalDuration'] == 0.0
          ? Get.arguments['video_duration']
          : Get.arguments['totalDuration'];

      fendDuration = Get.arguments['totalDuration'] == 0.0
          ? 0.0
          : Get.arguments['endDuration'];

      fstartDuration = Get.arguments['startDuration'] == 0.0
          ? 0.0
          : Get.arguments['startDuration'];

      jobId = Get.arguments['id'];
      customThumbnail = Get.arguments['customThumbails'];
      source = Get.arguments['source'];
      channelName=Get.arguments["channelName"];
      programName=Get.arguments["programName"];
      topic1=Get.arguments["topic"];
      transcription=Get.arguments["transcription"];

      if (kDebugMode) {
        print("Source is ${source}");
      }
      if (customThumbnail.isEmpty) {
        showPlaceHolder = true;
        update();
      }
      if(Platform.isAndroid){
        initRecorder();
      }

      
        isLoading = false;
        update();
    }


    super.onReady();
  }

  @override
  void onClose() {
    betterPlayerController.pause();
    recorder.closeRecorder();
    mPlayer!.closePlayer();
    mPlayer = null;
    super.onClose();
  }

  Future<void> downloadImage() async {
      donwloadLoader.value = true;
      update();
      if (kDebugMode) {
        print( Uri.parse("${baseUrlService.baseUrl}/uploads/thumbnails${customThumbnail[0]}"));
      }
    try {
      final http.Response response = await http.get(Uri.parse("${baseUrlService.baseUrl}/uploads/thumbnails${customThumbnail[0]}"));
      final Directory directory = await getApplicationDocumentsDirectory();


      localPath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
      final File imageFile = File(localPath);
      await imageFile.writeAsBytes(response.bodyBytes);
      donwloadLoader.value = false;
        update();
      if (kDebugMode) {
        print('Image downloaded successfully.');
      }

    } catch (e) {

      donwloadLoader.value = false;
        update();
      if (kDebugMode) {
        print('Error while downloading the image: $e');
      }
    }
  }


  void audioplay(String p) {
    try {
      isPlay.value = true;
      mPlayer!
          .startPlayer(
            fromURI: p,
            whenFinished: () {
              isPlay.value = false;
            },
          )
          .then((value) {});
    } catch (e) {}
  }

  void stopPlayer() {
    isPlay.value = false;
    try {
      mPlayer!.stopPlayer().then((value) {});
    } catch (e) {}
  }

  void pausePlayer() {
    isPlay.value = false;
    try {
      mPlayer!.pausePlayer().then((value) {});
    } catch (e) {}
  }

  Future<void> record() async {
    await recorder.startRecorder(
        toFile: mPath, codec: _codec, audioSource: AudioSource.microphone);
  }

  Future<void> stop() async {
    final path = await recorder.stopRecorder();
    audioFile = File(path!);

    update();
  }

  Future<void> initRecorder() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }

    await recorder.openRecorder();
  }

  Future<void> eveB(e) async {
    if (e.betterPlayerEventType == BetterPlayerEventType.play) {
      await betterPlayerController.videoPlayerController!
          .seekTo(Duration(milliseconds: startDuration.round().toInt()));
      betterPlayerController.videoPlayerController!.addListener(() {
        if (betterPlayerController
                .videoPlayerController!.value.position.inMilliseconds
                .round()
                .toInt() >=
            endDuration.round().toInt()) {
          checkVideo();
        }
      });
    } else if (e.betterPlayerEventType == BetterPlayerEventType.pause) {
      await betterPlayerController.videoPlayerController!
          .seekTo(Duration(milliseconds: startDuration.round().toInt()));
      betterPlayerController.videoPlayerController!.addListener(() {
        if (betterPlayerController
                .videoPlayerController!.value.position.inMilliseconds
                .round()
                .toInt() >=
            endDuration.round().toInt()) {
          checkVideo();
        }
      });
    }
  }

  void checkVideo() {
    if (betterPlayerController.isPlaying() == true) {
      betterPlayerController.pause();
    }
  }

  Future<void> sharing(String id) async {
    if (kDebugMode) {
      print("i am in full share clip job api");
      print("job id in sharing ${id}");

    }

    Get.back();
    Map sharedBy = {
      "id": senderId,
      "name": "${senderFirstName} ${senderLastName}",
    };
    if (kDebugMode) {
      print("i am in full share clip job api");
      print("job id in sharing ${id}");

    }
    DateTime now = DateTime.now();
    String formatDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    Map bodyData = {
      "jobId": id,
      "sharedTime": formatDateTime,
      "shareType": "Full",
      "sharedBy": sharedBy,
      "sharedTo": companyUserController.sharingUser,
    };
    if (kDebugMode) {
      print("Check Sharing data $bodyData");

    }

    companyUserController.isBottomLoading.value = true;
    try {
      String token = await storage.read("AccessToken");

      var query=Uri.parse('${baseUrlService.baseUrl}${isJobLibrary=="true"?ApiData.libraryShareJobs:ApiData.shareJobs}');
      if(kDebugMode){
        print("-------------${isJobLibrary}");
        print("-------------2${query}");
      }

      var res =
          await http.post(query,
              headers: {
                'Authorization': "Bearer $token",
                "Content-type": "application/json",
                "Accept": "application/json"
              },
              body: json.encode(bodyData));
      if (kDebugMode) {
        print("i am in full share clip  job api----------");

      }

      var data = json.decode(res.body);
      Get.log('Shared Job Result is $data');
      if (res.statusCode == 201) {
        companyUserController.sharingUser.clear();
        homeScreenController.isLoading.value = true;
        await homeScreenController.getSentJobs();
        homeScreenController.isLoading.value = false;
        companyUserController.isBottomLoading.value = false;
        Get.back(closeOverlays: true);
        CustomSnackBar.showSnackBar(
          title: "Job shared successfully",
          message: "",
          isWarning: false,
          backgroundColor: CommonColor.greenColor,
        );
      } else {
        companyUserController.isBottomLoading.value = false;
      }
    } on SocketException catch (e) {
      companyUserController.isBottomLoading.value = false;
      update();
    } catch (e) {
      companyUserController.isBottomLoading.value = false;
      update();
    }
  }

  Future<void> sendData(String id) async {
    try {
      if (kDebugMode) {
        print("i am in share clip job api");
        print("Job file path  ${audioFile.path}");

      }
      Get.back();
      companyUserController.isBottomLoading.value = true;
      Map sharedBy = {
        "id": senderId,
        "name": "${senderFirstName} ${senderLastName}",
      };
      Map jobInfo = {
        "title": title.text,
        "comments": des.text,
        "startDuration": startDuration.toString(),
        "endDuration": endDuration.toString(),
      };
      String token = await storage.read("AccessToken");
      Map<String, String> h = {'Authorization': 'Bearer $token'};
      var uri = Uri.parse('${baseUrlService.baseUrl}${isJobLibrary=="true"?ApiData.libraryShareJobs: ApiData.shareClippedJob}');
      var res = http.MultipartRequest('POST', uri)
        ..headers.addAll(h)
        ..fields['jobId'] = id
        ..fields['sharedTime'] = DateTime.now().toString()
        ..fields['shareType'] = "Clipped"
        ..fields['sharedBy'] = json.encode(sharedBy)
        ..fields['sharedTo'] = json.encode(companyUserController.sharingUser)
        ..fields['sharedData'] = json.encode(jobInfo)
        ..files.add(await http.MultipartFile.fromPath('files', audioFile.path));
      var response = await res.send();
      var result = await response.stream.bytesToString();
      Get.log('------ audio/video ${result}');
      if (response.statusCode == 200) {
        companyUserController.sharingUser.clear();
        homeScreenController.isLoading.value = true;
        await homeScreenController.getSentJobs();
        homeScreenController.isLoading.value = false;
        companyUserController.isBottomLoading.value = false;
        Get.back(closeOverlays: true);
        CustomSnackBar.showSnackBar(
          title: "Job shared successfully",
          message: "",
          isWarning: false,
          backgroundColor: CommonColor.greenColor,
        );
      } else {
        companyUserController.isBottomLoading.value = false;
      }
    } catch (e) {
      companyUserController.isBottomLoading.value = false;
    }
  }

  Future<void> sendDataWithoutAudio(String id) async {
    try {
      if (kDebugMode) {
        print("i am in share clip audio job api");
      }
      Get.back();
      companyUserController.isBottomLoading.value = true;
      Map sharedBy = {
        "id": senderId,
        "name": "${senderFirstName} ${senderLastName}",
      };
      Map jobInfo = {
        "title": title.text,
        "comments": des.text,
        "startDuration": startDuration.toString(),
        "endDuration": endDuration.toString(),
      };
      String token = await storage.read("AccessToken");
      Map<String, String> h = {'Authorization': 'Bearer $token'};
      var uri = Uri.parse('${baseUrlService.baseUrl}${isJobLibrary=="true"?ApiData.libraryShareJobs: ApiData.shareClippedJob}');
      var res = http.MultipartRequest('POST', uri)
        ..headers.addAll(h)
        ..fields['jobId'] = id
        ..fields['sharedTime'] = DateTime.now().toString()
        ..fields['shareType'] = "Clipped"
        ..fields['sharedBy'] = json.encode(sharedBy)
        ..fields['sharedTo'] = json.encode(companyUserController.sharingUser)
        ..fields['sharedData'] = json.encode(jobInfo);
      var response = await res.send();
      var result = await response.stream.bytesToString();
      Get.log('------Check Response audio/video ${result}');
      if (response.statusCode == 200) {
        companyUserController.sharingUser.clear();
        homeScreenController.isLoading.value = true;
        await homeScreenController.getSentJobs();
        homeScreenController.isLoading.value = false;
        companyUserController.isBottomLoading.value = false;
        Get.back(closeOverlays: true);
        CustomSnackBar.showSnackBar(
          title: "Job shared successfully",
          message: "",
          isWarning: false,
          backgroundColor: CommonColor.greenColor,
        );
      } else {
        companyUserController.isBottomLoading.value = false;
      }
    } catch (e) {
      companyUserController.isBottomLoading.value = false;
    }
  }

}
