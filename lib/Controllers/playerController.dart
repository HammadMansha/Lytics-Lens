import 'dart:convert';
import 'dart:io';
import 'package:better_player/better_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lytics_lens/Controllers/company_user/companyUser_controller.dart';
import 'package:lytics_lens/Controllers/home_controller.dart';
import 'package:lytics_lens/Controllers/test/testclip_controller.dart';
import 'package:lytics_lens/Services/internetcheck.dart';
import 'package:http/http.dart' as http;
import 'package:lytics_lens/abstract/getstorage_abstract.dart';
import 'package:lytics_lens/utils/api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wakelock/wakelock.dart';
import '../Constants/common_color.dart';
import '../Services/baseurl_service.dart';
import '../widget/snackbar/common_snackbar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';

class VideoController extends GetxController with GetxStorage {
  var isLoading = true.obs;

  var internalServer = false.obs;

  var isSharedData = false.obs;

  bool isSocket = false;

  bool isPervious = false;

  List recieveruser = [];

  String imagePathLast = '';
  var isVoicePressed = false.obs;

  var nodata = false.obs;

  var sentjob = [].obs;

  var filePath;

  File? videoFilePath;

  CompanyUserController companyUserController = Get.find<CompanyUserController>();
  HomeScreenController homeScreenController = Get.find<HomeScreenController>();

  // <------------- Recorder ---------------->

  bool isAudio = false;
  bool isComment = false;

  FlutterSoundPlayer? mPlayer = FlutterSoundPlayer();
  bool mPlayerIsInited = false;
  RxBool isPlay = false.obs;

//<-------------Variables for trim video---------------->

  var isPlaying = false;
  bool progressVisibility = false;
  var isVideoPlay = false.obs;

  TextEditingController searchContact = TextEditingController();

//--------------------------------------------------------
  var arrg;
  var videoURL;
  RxBool startTimer = false.obs;
  RxBool showBack = false.obs;
  late BetterPlayerController betterPlayerController;
  late NetworkController networkController;
  TextEditingController englishsearchtext = TextEditingController();
  TextEditingController urdusearchtext = TextEditingController();
  Duration? playerTime;
  final bool looping = false;
  String videolink = "";
  String urduText = "";
  String englishText = "";
  List transcriptionlist = [];
  List transcriptionlistdir = [];

  List speakerTranscription = [];

  List fullTranscriptionDir = [];
  List transcriptionSpeakers = [];
  List dir = [];
  List translationlist = [];
  List translationlist1 = [];
  List data = [];

  // <----------------- New Code ------------------>
  String audioPath = '';
  String channel = '';
  String videoPath = '';
  String sourcevideoPath = '';
  String jobId = '';
  String parentjobId = '';
  String perviousjobId = '';
  String event = '';
  String programName = '';
  String topic = '';
  List subTopic = [];
  List anchor = [];
  List guest = [];
  List sharedList = [];
  String analysis = '';
  List segments = [];
  List hashTags = [];
  String source = '';
  String platform = '';
  String publisher = '';
  String speaker = '';
  String statment = '';
  String thumbnailpath = '';
  String channelLogo = '';
  String description = '';
  String title = '';
  List queryWords = [];
  String programType = '';
  List transcription = [];
  List translation = [];
  String programTime = '';
  String programDate = '';
  var duration = 0.obs;
  List thumbnail = [];
  var loadingData = true.obs;
  String comment = ' ';
  String lang = ' ';
  Map sharedData = {};
  Map sharedBy = {};
  RxList sharedTo = [].obs;
  RxBool isSentJob = false.obs;
//List transcriptionSpeakers=[];
  // <---------  For WebSite Only ---------->
  String transcriptionText = '';
  String videoTranscription = '';
  List fullTranscription = [];

  Duration startAt = const Duration();

  TextEditingController selectedTab =
      TextEditingController(text: 'Transcription');

  String senderId = '';
  String senderFirstName = '';
  String senderLastName = '';

  //----------------CustomThumbnails----------
  List customThumbnail = [];

  //---------------------web Sharing module variables---------
  TextEditingController addDescription = TextEditingController();
  TextEditingController addTitle = TextEditingController();
  var audioFile = null;
  final recorder = FlutterSoundRecorder();
  String mPath = '${DateTime.now().millisecondsSinceEpoch.toString()}.mp4';
  Codec _codec = Codec.aacMP4;
  double startDuration = 0.0;
  double endDuration = 0.0;
  double totalDuration = 0.0;
  double videoDuration = 0.0;
  double tstartDuration = 0.0;
  double tendDuration = 0.0;

  double fstartDuration = 0.0;
  double fendDuration = 0.0;

  String receiverName = '';
  //--------Is job library data---------
  String isJobLibrary = '';
  String apiIsJobLibrary = '';
  String jobPortal = '';
  late String localPath = "";
  RxBool downloadLoader = false.obs;
  BaseUrlService baseUrlService = Get.find<BaseUrlService>();

  @override
  void onInit() async {
    internalServer.value = false;
    senderId = await storage.read('id');
    senderFirstName = await storage.read('firstName');
    senderLastName = await storage.read('lastName');
    update();
    mPlayer!.openPlayer().then((value) {
      mPlayerIsInited = true;
      update();
    });
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    if (Get.isRegistered<NetworkController>()) {
      networkController = Get.find<NetworkController>();
    } else {
      networkController = Get.put(NetworkController());
    }
    if (Get.arguments != null) {
      if (kDebugMode) {
        print("-----------job id on player screen ${Get.arguments['id']}");
      }

      if (Get.arguments['searchValue'] != null) {
        if (Get.arguments['searchValue'] != null ||
            Get.arguments['searchValue'] != "") {
          RegExp(r'^[a-zA-Z 0-9 _@./#;&+-]*$').hasMatch(
                      Get.arguments['searchValue']!.trim().split(' ').first) ==
                  true
              ? englishsearchtext.text = Get.arguments['searchValue']
              : urdusearchtext.text = Get.arguments['searchValue'];
        }
      }
      if (kDebugMode) {
        print("value of english controller ${englishsearchtext.text}");
        print("value of urdu controller ${urdusearchtext.text}");
      }

      if (Get.arguments['sentJob'] != null) {
        isSentJob.value = true;
      } else {
        isSentJob.value = false;
      }
      isSocket = false;
      jobId = Get.arguments['id'];
      receiverName = Get.arguments["receiverName"];
      isJobLibrary = Get.arguments["isJobLibrary"].toString();
      Get.log("------------------Job id is ${jobId}");
      if (kDebugMode) {
        print("-----player screen controller is library ${isJobLibrary}");
      }

      update();
      await getSingleJob(Get.arguments['id']);
      isLoading.value = false;
      // await urlToFile(videoPath);
    }
    urduText = data.join(" ");

    update();
    super.onInit();
  }

  @override
  void onReady() async {
    isLoading.value = false;
    if (Platform.isAndroid) {
      await initRecorder();
    }
    update();
    super.onReady();
  }

  @override
  void onClose() {
    betterPlayerController.dispose();
    mPlayer!.closePlayer();
    mPlayer = null;
    Wakelock.disable();
    Get.delete<VideoController>();
    super.onClose();
  }

  //-----------------convert UTC time into local------------
  String convertTimeIntoUtc(String time) {
    final dateTime = DateTime.parse(time).toUtc();
    final timeFormat = DateFormat('HH:mm');
    final utcTime = timeFormat.format(dateTime.add(Duration(hours: 0)));

    return formatTime(utcTime);
  }

  String formatTime(String time) {
    final parseTime = DateFormat('HH:mm').parse(time);
    return DateFormat('h:mma').format(parseTime);
  }

  //<----------------- Get Job By Id ------------------->
  Future<void> getSingleJob(String jId) async {
    try {
      var res;
      segments.clear();
      sharedList.clear();
      subTopic.clear();
      translation.clear();
      transcription.clear();
      fullTranscription.clear();
      hashTags.clear();
      guest.clear();
      queryWords.clear();
      anchor.clear();
      sharedData.clear();
      thumbnail.clear();
      fullTranscriptionDir.clear();
      transcriptionlistdir.clear();
      transcriptionlistdir.clear();
      dir.clear();
      translationlist.clear();
      sharedBy.clear();
      sharedTo.clear();
      update();
      internalServer.value = false;
      isSharedData.value = false;
      String token = await storage.read("AccessToken");
      thumbnail.clear();
      if (Get.arguments['sharedJob'] != null) {
        res = await http.get(
            Uri.parse(
                '${baseUrlService.baseUrl}${isJobLibrary == "true" ? ApiData.singleLibraryJob : ApiData.singleJob}$jId?device=mobile&sentPage=${Get.arguments['sentPage']}&shareId=${Get.arguments['shareId']}'),
            headers: {
              'Authorization': "Bearer $token",
            });
      } else {
        res = await http.get(
            Uri.parse(
                '${baseUrlService.baseUrl}${ApiData.singleJob}$jId?device=mobile'),
            headers: {
              'Authorization': "Bearer $token",
            });
      }

      if (res.statusCode == 200) {
        var data = json.decode(res.body);

        if (kDebugMode) {
          print("orignal job id is ${data["originalJobId"]}");
          print("orignal job id is is $jId");
          print("-----isLibrayrvalue ${data["isJobLibrary"]}");
          //print("--------------------single api response ${data}");

        }
        // Get.log("Sharing Job data is ${data['sharing']}");
        // Get.log("All Data $data");

        jobId = jId;
        parentjobId = data["originalJobId"] ?? '';
        apiIsJobLibrary = data["isJobLibrary"] ?? '';
        jobPortal = data["jobSource"] ?? '';
        source = data["source"] ?? '';
        platform = data["platform"] ?? '';
        channel = data['channel'] ?? '';

        if (data['sharedData'] == null ||
            data['sharedData'] == '' ||
            data['sharedData'].toString() == '{}') {
          comment = '';
        } else {
          comment = data['sharedData']["comments"];
        }
        customThumbnail = data["customThumbnails"] ?? [];
        if (data["source"].toLowerCase() == 'website' ||
            data["source"].toLowerCase() == 'blog' ||
            data["source"].toLowerCase() == 'print') {
          Get.log('Check code ');

          publisher = data["publisher"];
          Get.log('Check code 0');
        } else {
          publisher = '';
        }

        Get.log('Check code 1');

        // sourcevideoPath = source.toString() == 'websites'
        //     ? 'http://checkk'
        //     : data["videoPath"];
        // videoPath = sourcevideoPath.split('http://103.31.81.34/Videos/').last;
        videoPath = data["videoPath"] ?? '';

        if (kDebugMode) {
          print("video path-------------------------------${videoPath}");
        } // await urlToFile(videoPath);
        if (data['sharedData'] == null ||
            data['sharedData'] == '' ||
            data['sharedData'].toString() == '{}') {
          isComment = false;
          update();
        } else {
          if (data['sharedData']['comments'].toString() == '') {
            isComment = false;
            update();
          } else {
            isComment = true;
            update();
          }
        }
        if (data['files'] == null ||
            data['files'] == 'null' ||
            data['files'] == '') {
          audioPath = '';
          isAudio = false;
          update();
        } else {
          audioPath = '${baseUrlService.baseUrl}/uploads/${data["files"]}';
          isAudio = true;
          if (kDebugMode) {
            print("+++++++++++++++++++++++ ${audioPath}");
          }
          update();
        }

        event = data['programName'];
        programName = data['programName'];
        segments = data['segments'];

        if (data['sharing'].toString().length == 2 || data['sharing'] == null) {
          sharedList = [];
        } else {
          data['sharing'].forEach((e) {
            if (senderId == e['senderId']) {
              sharedList.add(e);
            }
          });
          update();
        }

        if (data['segments'].toString().length == 2) {
          topic = '';
        } else {
          topic = data['segments'][0]['topics']['topic1'];
        }
        if (data['segments'].toString().length == 2) {
          subTopic = [];
          analysis = '';
        } else {
          subTopic = data['segments'][0]['topics']['topic2'];
          analysis =
              data["segments"][0]['segmentAnalysis']["analysis"]["analyst"];
        }
        if (data['segments'].toString().length == 2) {
          hashTags = [];
        } else {
          hashTags = data['segments'][0]['hashtags'];
        }

        if (source.toLowerCase() == 'print' || source.toLowerCase() == 'blog') {
          title = data['programName'].toString() == 'null' ||
                  data['programName'].toString() == ''
              ? ''
              : data['programName'];
        } else if (source.toLowerCase() == 'website') {
          title = data['programName'].toString() == 'null' ||
                  data['programName'].toString() == ''
              ? ''
              : data['title'];
        }

        guest = data["guests"];
        lang = data["language"].toString();
        queryWords.addAll(data['queryWords']);
        anchor = data['anchor'];
        speaker = data['anchor'].toString() == '[]' ? '' : data['anchor'][0];
        statment = data['programName'];

        channelLogo = data['channelLogoPath'].toString().contains('http')
            ? data['channelLogoPath']
            : '${baseUrlService.baseUrl}/uploads/${data['channelLogoPath']}';
        thumbnailpath = storage.hasData("Url")
            ? "${storage.read("Url").toString()}/uploads/${data['thumbnailPath']}"
            : "${baseUrlService.baseUrl}/uploads/${data['thumbnailPath']}";
        if (kDebugMode) {
          print("Thumbnail path is--------------------${thumbnailpath}");
        }
        // if (source.toLowerCase() == 'blog' ||
        //     source.toLowerCase() == 'print') {
        //   if (data['gallary'].toString().length == 2) {
        //     thumbnail = [];
        //     Get.log("Check code 5");
        //
        //   } else {
        //     data['gallary'].forEach((e) {
        //       e.toString().contains('http')
        //           ? thumbnail.add(e)
        //           : thumbnail.add('${baseUrlService.baseUrl}/uploads/$e');
        //     });
        //     Get.log("Check code 7");
        //
        //     update();
        //   }
        // }
        description = data['programName'];

        programTime = data["broadcastDate"];
        programDate = data['programDate'];
        imagePathLast =
            "${baseUrlService.baseUrl}/uploads/${data['thumbnailPath']}";
        programType = data['programType'];

        if (data['transcription'].toString().toLowerCase() == 'null' ||
            data['transcription'].toString().toLowerCase() == '[]' ||
            data['transcription'].toString().toLowerCase() == "") {
          transcriptionlistdir = [];
        } else {
          if (data['transcription'].runtimeType.toString() == 'String') {
            addTrancriptionIntoList(json.decode(data['transcription']));
          } else {
            addTrancriptionIntoList(data['transcription']);
          }
        }

        if (data['fullTranscription'].toString().toLowerCase() == 'null' ||
            data['fullTranscription'].toString().toLowerCase() == '[]' ||
            data['fullTranscription'].toString().toLowerCase() == "") {
          fullTranscriptionDir = [];
        } else {
          if (data['fullTranscription'].runtimeType.toString() == 'String') {
            addFullTrancriptionIntoList(json.decode(data['fullTranscription']));
          } else {
            addFullTrancriptionIntoList(data['fullTranscription']);
          }
        }

        if (data['translation'].toString().toLowerCase() == 'null' ||
            data['translation'].toString().toLowerCase() == '[]' ||
            data['translation'].toString().toLowerCase() == "") {
          dir = [];
          translationlist = [];
        } else {
          if (data['translation'].runtimeType.toString() == 'String') {
            addTranslationIntoList(json.decode(data['translation']));
          } else {
            addTranslationIntoList(data['translation']);
          }
        }

        if (data['sharedData'] != null) {
          isSharedData.value = true;
          sharedData.addAll(data['sharedData']);
          if (source.toLowerCase() != 'website' ||
              source.toLowerCase() != 'print' ||
              source.toLowerCase() != 'blog') {
            await playerConfig(videoPath, data['sharedData']);
          }
        } else {
          isSharedData.value = false;
          sharedData = {};
          if (source.toLowerCase() != 'website' ||
              source.toLowerCase() != 'print' ||
              source.toLowerCase() != 'blog') {
            await playerConfig(videoPath, {});
          }
        }
        if (data['sharedBy'] != null) {
          sharedBy.addAll(data['sharedBy']);
        } else {
          sharedBy.clear();
        }
        if (data['sharedTo'] != null) {
          data['sharedTo'].forEach((e) {
            sharedTo.add(e);
          });
        } else {
          sharedTo.clear();
        }
        update();
      } else {
        internalServer.value = true;
      }
    } on SocketException catch (e) {
      isSocket = true;
      update();
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
    }
  }

  Future<void> getSingleJobById(String jId) async {
    try {
      var res;
      segments.clear();
      sharedList.clear();
      subTopic.clear();
      translation.clear();
      transcription.clear();
      fullTranscription.clear();

      hashTags.clear();
      guest.clear();
      queryWords.clear();
      anchor.clear();
      sharedData.clear();
      thumbnail.clear();
      transcriptionlistdir.clear();
      transcriptionlistdir.clear();
      dir.clear();
      translationlist.clear();
      sharedBy.clear();
      sharedTo.clear();
      update();
      internalServer.value = false;
      isSharedData.value = false;
      String token = await storage.read("AccessToken");
      thumbnail.clear();
      res = await http.get(
          Uri.parse(
              '${baseUrlService.baseUrl}${ApiData.singleJob}$jId?device=mobile'),
          headers: {
            'Authorization': "Bearer $token",
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);

        if (kDebugMode) {
          print("orignal job id is ${data["originalJobId"]}");
          print("orignal job id is is $jId");
        }
        Get.log("Sharing Job data is ${data['sharing']}");
        Get.log("All Data $data");

        jobId = jId;
        parentjobId = data["originalJobId"] ?? '';
        source = data["source"];
        platform = data["platform"];
        channel = data['channel'];
        if (data['sharedData'] == null ||
            data['sharedData'] == '' ||
            data['sharedData'].toString() == '{}') {
          comment = '';
        } else {
          comment = data['sharedData']["comments"];
        }
        customThumbnail = data["customThumbnails"];
        if (data["source"].toLowerCase() == 'website' ||
            data["source"].toLowerCase() == 'blog' ||
            data["source"].toLowerCase() == 'print') {
          publisher = data["publisher"];
        } else {
          publisher = '';
        }
        // sourcevideoPath = source.toString() == 'websites'
        //     ? 'http://checkk'
        //     : data["videoPath"];
        // videoPath = sourcevideoPath.split('http://103.31.81.34/Videos/').last;
        videoPath = data["videoPath"] ?? '';
        // await urlToFile(videoPath);
        if (data['sharedData'] == null ||
            data['sharedData'] == '' ||
            data['sharedData'].toString() == '{}') {
          isComment = false;
          update();
        } else {
          if (data['sharedData']['comments'].toString() == '') {
            isComment = false;
            update();
          } else {
            isComment = true;
            update();
          }
        }
        if (data['files'] == null ||
            data['files'] == 'null' ||
            data['files'] == '') {
          audioPath = '';
          isAudio = false;
          update();
        } else {
          audioPath = '${baseUrlService.baseUrl}/uploads/${data["files"]}';
          isAudio = true;
          if (kDebugMode) {
            print("+++++++++++++++++++++++ 1 ${audioPath}");
          }
          update();
        }
        event = data['programName'];
        programName = data['programName'];
        segments = data['segments'];
        if (data['sharing'].toString().length == 2 || data['sharing'] == null) {
          sharedList = [];
        } else {
          data['sharing'].forEach((e) {
            if (senderId == e['senderId']) {
              sharedList.add(e);
            }
          });
          update();
        }

        if (data['segments'].toString().length == 2) {
          topic = '';
        } else {
          topic = data['segments'][0]['topics']['topic1'];
        }
        if (data['segments'].toString().length == 2) {
          subTopic = [];
          analysis = '';
        } else {
          subTopic = data['segments'][0]['topics']['topic2'];
          analysis =
              data["segments"][0]['segmentAnalysis']["analysis"]["analyst"];
        }
        if (data['segments'].toString().length == 2) {
          hashTags = [];
        } else {
          hashTags = data['segments'][0]['hashtags'];
        }
        if (source.toLowerCase() == 'print' || source.toLowerCase() == 'blog') {
          title = data['programName'].toString() == 'null' ||
                  data['programName'].toString() == ''
              ? ''
              : data['programName'];
        } else if (source.toLowerCase() == 'website') {
          title = data['programName'].toString() == 'null' ||
                  data['programName'].toString() == ''
              ? ''
              : data['title'];
        }

        guest = data["guests"];
        lang = data["language"].toString();
        queryWords.addAll(data['queryWords']);
        anchor = data['anchor'];
        speaker = data['anchor'].toString() == '[]' ? '' : data['anchor'][0];
        statment = data['programName'];
        channelLogo = data['channelLogoPath'].toString().contains('http')
            ? data['channelLogoPath']
            : '${baseUrlService.baseUrl}/uploads/${data['channelLogoPath']}';
        thumbnailpath = storage.hasData("Url")
            ? "${storage.read("Url").toString()}/uploads/${data['thumbnailPath']}"
            : "${baseUrlService.baseUrl}/uploads/${data['thumbnailPath']}";
        if (source.toLowerCase() == 'website' ||
            source.toLowerCase() == 'print') {
          if (data['gallary'].toString().length == 2) {
            thumbnail = [];
          } else {
            data['gallary'].forEach((e) {
              e.toString().contains('http')
                  ? thumbnail.add(e)
                  : thumbnail.add('${baseUrlService.baseUrl}/uploads/$e');
            });
            update();
          }
        }
        description = data['programName'];

        programTime = data["broadcastDate"];
        programDate = data['programDate'];
        imagePathLast =
            "${baseUrlService.baseUrl}/uploads/${data['thumbnailPath']}";
        programType = data['programType'];
        if (data['transcription'].toString().toLowerCase() == 'null' ||
            data['transcription'].toString().toLowerCase() == '[]') {
          transcriptionlistdir = [];
        } else {
          if (data['transcription'].runtimeType.toString() == 'String') {
            addTrancriptionIntoList(json.decode(data['transcription']));
          } else {
            addTrancriptionIntoList(data['transcription']);
          }
        }

        if (data['fullTranscription'].toString().toLowerCase() == 'null' ||
            data['fullTranscription'].toString().toLowerCase() == '[]' ||
            data['fullTranscription'].toString().toLowerCase() == "") {
          fullTranscriptionDir = [];
        } else {
          if (data['fullTranscription'].runtimeType.toString() == 'String') {
            addFullTrancriptionIntoList(json.decode(data['fullTranscription']));
          } else {
            addFullTrancriptionIntoList(data['fullTranscription']);
          }
        }

        if (data['translation'].toString().toLowerCase() == 'null' ||
            data['translation'].toString().toLowerCase() == '[]') {
          dir = [];
          translationlist = [];
        } else {
          if (data['translation'].runtimeType.toString() == 'String') {
            addTranslationIntoList(json.decode(data['translation']));
          } else {
            addTranslationIntoList(data['translation']);
          }
        }
        if (data['sharedData'] != null) {
          isSharedData.value = true;
          sharedData.addAll(data['sharedData']);
          if (source.toLowerCase() != 'website' ||
              source.toLowerCase() != 'print' ||
              source.toLowerCase() != 'blog') {
            await playerConfig(videoPath, data['sharedData']);
          }
        } else {
          isSharedData.value = false;
          sharedData = {};
          if (source.toLowerCase() != 'website' ||
              source.toLowerCase() != 'print' ||
              source.toLowerCase() != 'blog') {
            await playerConfig(videoPath, {});
          }
        }
        if (data['sharedBy'] != null) {
          sharedBy.addAll(data['sharedBy']);
        } else {
          sharedBy.clear();
        }
        if (data['sharedTo'] != null) {
          data['sharedTo'].forEach((e) {
            sharedTo.add(e);
          });
        } else {
          sharedTo.clear();
        }
        update();
      } else {
        internalServer.value = true;
      }
    } on SocketException catch (e) {
      isSocket = true;
      update();
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
    }
  }

  Future<void> getSingleJobForNotification(
      String jobId, String sharedId, String sendPage) async {
    try {
      var res;
      segments.clear();
      sharedList.clear();
      subTopic.clear();
      hashTags.clear();
      guest.clear();
      queryWords.clear();
      anchor.clear();
      sharedData.clear();
      thumbnail.clear();
      transcriptionlistdir.clear();
      dir.clear();
      translationlist.clear();
      sharedBy.clear();
      sharedTo.clear();
      update();
      internalServer.value = false;
      isSharedData.value = false;
      String token = await storage.read("AccessToken");
      thumbnail.clear();
      res = await http.get(
          Uri.parse(
              '${baseUrlService.baseUrl}${ApiData.singleJob}$jobId?device=mobile&sentPage=$sendPage&shareId=$sharedId'),
          headers: {
            'Authorization': "Bearer $token",
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        Get.log("Sharing Job data is ${data['sharing']}");
        // print("All Data $data");
        Get.log("All Data $data");
        // print('Sub Topic ${data['segments'][0]['topics']['topic2']}');
        source = data["source"];
        platform = data["platform"];
        channel = data['channel'];
        if (data['sharedData'] == null ||
            data['sharedData'] == '' ||
            data['sharedData'].toString() == '{}') {
          comment = '';
        } else {
          comment = data['sharedData']["comments"];
        }
        customThumbnail = data["customThumbnails"];
        if (data["source"].toLowerCase() == 'website' ||
            data["source"].toLowerCase() == 'blog' ||
            data["source"].toLowerCase() == 'print') {
          publisher = data["publisher"];
        } else {
          publisher = '';
        }
        sourcevideoPath = source.toString() == 'websites'
            ? 'http://checkk'
            : data["videoPath"];
        videoPath = sourcevideoPath.split('http://103.31.81.34/Videos/').last;
        videoPath = sourcevideoPath;
        // await urlToFile(videoPath);
        if (data['sharedData'] == null ||
            data['sharedData'] == '' ||
            data['sharedData'].toString() == '{}') {
          isComment = false;
          update();
        } else {
          if (data['sharedData']['comments'].toString() == '') {
            isComment = false;
            update();
          } else {
            isComment = true;
            update();
          }
        }
        if (data['files'] == null ||
            data['files'] == 'null' ||
            data['files'] == '') {
          audioPath = '';
          isAudio = false;
          update();
        } else {
          audioPath = '${baseUrlService.baseUrl}/uploads/${data["files"]}';
          isAudio = true;
          if (kDebugMode) {
            print("+++++++++++++++++++++++ 2${audioPath}");
          }
          update();
        }
        event = data['programName'];
        programName = data['programName'];
        segments = data['segments'];
        if (data['sharing'].toString().length == 2 || data['sharing'] == null) {
          sharedList = [];
        } else {
          data['sharing'].forEach((e) {
            if (senderId == e['senderId']) {
              sharedList.add(e);
            }
          });
          update();
        }
        if (data['segments'].toString().length == 2) {
          topic = '';
        } else {
          topic = data['segments'][0]['topics']['topic1'];
        }
        if (data['segments'].toString().length == 2) {
          subTopic = [];
          analysis = '';
        } else {
          subTopic = data['segments'][0]['topics']['topic2'];
          analysis =
              data["segments"][0]['segmentAnalysis']["analysis"]["analyst"];
        }
        if (data['segments'].toString().length == 2) {
          hashTags = [];
        } else {
          hashTags = data['segments'][0]['hashtags'];
        }
        if (source.toLowerCase() == 'print' || source.toLowerCase() == 'blog') {
          title = data['programName'].toString() == 'null' ||
                  data['programName'].toString() == ''
              ? ''
              : data['programName'];
        } else if (source.toLowerCase() == 'website') {
          title = data['programName'].toString() == 'null' ||
                  data['programName'].toString() == ''
              ? ''
              : data['title'];
        }

        guest = data["guests"];
        lang = data["language"].toString();
        queryWords.addAll(data['queryWords']);
        anchor = data['anchor'];
        speaker = data['anchor'].toString() == '[]' ? '' : data['anchor'][0];
        statment = data['programName'];
        channelLogo = data['channelLogoPath'].toString().contains('http')
            ? data['channelLogoPath']
            : '${baseUrlService.baseUrl}/uploads/${data['channelLogoPath']}';
        thumbnailpath = storage.hasData("Url")
            ? "${storage.read("Url").toString()}/uploads/${data['thumbnailPath']}"
            : "${baseUrlService.baseUrl}/uploads/${data['thumbnailPath']}";
        if (source.toLowerCase() == 'website' ||
            source.toLowerCase() == 'print') {
          if (data['gallary'].toString().length == 2) {
            thumbnail = [];
          } else {
            data['gallary'].forEach((e) {
              e.toString().contains('http')
                  ? thumbnail.add(e)
                  : thumbnail.add('${baseUrlService.baseUrl}/uploads/$e');
            });
            update();
          }
        }
        description = data['programName'];

        programTime = data["broadcastDate"];
        programDate = data['programDate'];
        imagePathLast =
            "${baseUrlService.baseUrl}/uploads/${data['thumbnailPath']}";
        programType = data['programType'];
        if (data['transcription'].toString().toLowerCase() == 'null' ||
            data['transcription'].toString().toLowerCase() == '[]') {
          transcriptionlistdir = [];
        } else {
          if (data['transcription'].runtimeType.toString() == 'String') {
            addTrancriptionIntoList(json.decode(data['transcription']));
          } else {
            addTrancriptionIntoList(data['transcription']);
          }
        }

        if (data['fullTranscription'].toString().toLowerCase() == 'null' ||
            data['fullTranscription'].toString().toLowerCase() == '[]' ||
            data['fullTranscription'].toString().toLowerCase() == "") {
          fullTranscriptionDir = [];
        } else {
          if (data['fullTranscription'].runtimeType.toString() == 'String') {
            addFullTrancriptionIntoList(json.decode(data['fullTranscription']));
          } else {
            addFullTrancriptionIntoList(data['fullTranscription']);
          }
        }

        if (data['translation'].toString().toLowerCase() == 'null' ||
            data['translation'].toString().toLowerCase() == '[]') {
          dir = [];
          translationlist = [];
        } else {
          if (data['translation'].runtimeType.toString() == 'String') {
            addTranslationIntoList(json.decode(data['translation']));
          } else {
            addTranslationIntoList(data['translation']);
          }
        }
        if (data['sharedData'] != null) {
          isSharedData.value = true;
          sharedData.addAll(data['sharedData']);
          if (source.toLowerCase() != 'website' ||
              source.toLowerCase() != 'print' ||
              source.toLowerCase() != 'blog') {
            await playerConfig(videoPath, data['sharedData']);
          }
        } else {
          isSharedData.value = false;
          sharedData = {};
          if (source.toLowerCase() != 'website' ||
              source.toLowerCase() != 'print' ||
              source.toLowerCase() != 'blog') {
            await playerConfig(videoPath, {});
          }
        }
        if (data['sharedBy'] != null) {
          sharedBy.addAll(data['sharedBy']);
        } else {
          sharedBy.clear();
        }
        if (data['sharedTo'] != null) {
          data['sharedTo'].forEach((e) {
            sharedTo.add(e);
          });
        } else {
          sharedTo.clear();
        }

        update();
      } else {
        internalServer.value = true;
      }
    } on SocketException catch (e) {
      isSocket = true;
      update();
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
    }
  }

  Future<void> downloadImage(String thumbnailpath) async {
    downloadLoader.value = true;
    update();
    if (kDebugMode) {
      print(Uri.parse(thumbnailpath));
    }
    try {
      final http.Response response = await http.get(Uri.parse(thumbnailpath));
      if (kDebugMode) {
        print("download status -----${response.body}");
      }

      if (response.body == "") {
        final http.Response response = await http.get(Uri.parse(channelLogo));
        final Directory directory = await getApplicationDocumentsDirectory();
        localPath =
            '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
        final File imageFile = File(localPath);
        await imageFile.writeAsBytes(response.bodyBytes);
        downloadLoader.value = false;
        update();
        if (kDebugMode) {
          print("download status 1-----${imageFile.path.toString()}");
        }
      } else if (response.body.toString().contains("{")) {
        final http.Response response = await http.get(Uri.parse(channelLogo));
        final Directory directory = await getApplicationDocumentsDirectory();
        localPath =
            '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
        final File imageFile = File(localPath);
        await imageFile.writeAsBytes(response.bodyBytes);
        downloadLoader.value = false;
        update();
        if (kDebugMode) {
          print("download status 2-----${imageFile.path.toString()}");
        }
      } else {
        final Directory directory = await getApplicationDocumentsDirectory();
        localPath =
            '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
        final File imageFile = File(localPath);
        await imageFile.writeAsBytes(response.bodyBytes);
        downloadLoader.value = false;
        update();
        if (kDebugMode) {
          print("download status 3-----${imageFile.path.toString()}");
        }
      }
    } catch (e) {
      downloadLoader.value = false;
      update();
      if (kDebugMode) {
        print('Error while downloading the image: $e');
      }
    }
  }

  void addTrancriptionIntoList(List transcription) {
    String anchor = "";
    String text = "";
    // <--------- Transcription ----------->
    transcriptionlistdir.clear();
    update();

    // for(int i=0;i<transcription.length;i++){
    //   if(kDebugMode){
    //     print("speaker is-----------${transcription[i]["speaker"]}");
    //   }
    //
    //
    //   if(anchor.isEmpty){
    //     anchor=transcription[i]["speaker"];
    //   }
    //
    //   if(anchor!=transcription[i]["speaker"])
    //   {
    //     //speakerTranscription.insert(i, text);
    //     speakerTranscription.add({
    //       "speaker":anchor,
    //       "line":text,
    //     });
    //     text="";
    //     anchor="";
    //     anchor=transcription[i]["speaker"];
    //     text+=transcription[i]["line"];
    //     update();
    //
    //   }
    //   else
    //   {
    //     text+=transcription[i]["line"];
    //
    //   }
    //
    //
    // }
    //
    // if(kDebugMode){
    //
    //   print("speaker base transcription--------------${speakerTranscription}");
    // }
    //

    for (var element in transcription) {
      data.add(element['line']);
      transcriptionSpeakers.add(element['speaker']);
      transcriptionlistdir.add(element);
      // videoTranscription+=element["line"];
    }

    // var distinctIds = transcriptionSpeakers.toSet().toList();
    //
    // transcriptionSpeakers=distinctIds;
    // if(kDebugMode){
    //
    //   print("transcription speakers--------------------${transcriptionSpeakers.toString()}");
    //
    //
    // }
    update();
  }

  void addFullTrancriptionIntoList(List fullTranscription) {
    // <--------- Transcription ----------->
    fullTranscriptionDir.clear();
    update();

    for (var element in fullTranscription) {
      data.add(element['line']);
      transcriptionSpeakers.add(element['speaker']);
      fullTranscriptionDir.add(element);
      videoTranscription += element["line"];
    }

    // var distinctIds = transcriptionSpeakers.toSet().toList();
    //
    // transcriptionSpeakers=distinctIds;
    // if(kDebugMode){
    //
    //   print("transcription speakers--------------------${transcriptionSpeakers.toString()}");
    //
    //
    // }
    update();
  }

  void addTranslationIntoList(List translation) {
    // <--------- Transcription ----------->
    dir.clear();
    translationlist.clear();
    update();

    if (translation.toString() != "null") {
      dir.add(translation);
    }
    update();
    if (dir.isNotEmpty) {
      for (int i = 0; i < dir.length; i++) {
        if (dir[i] == "null") {
          translationlist = [];
        } else {
          dir[i].forEach((e) {
            translationlist.add(e);
          });
        }
      }
    }
    englishText = translationlist.join("");
    update();
  }

  void addsharedBy(Map c) {
    sharedBy.clear();
    update();
    sharedBy.addAll(c);
    update();
  }

  Future<void> playerConfig(String url, Map d) async {
    betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        expandToFill: true,
        //aspectRatio:4/3,
        looping: false,
        autoDispose: true,
        autoPlay: true,
        startAt: startAt,
        eventListener: (BetterPlayerEvent e) => eveB(e),
        // ignore: prefer_const_constructors
        controlsConfiguration: BetterPlayerControlsConfiguration(
          enableMute: false,
          enableAudioTracks: false,
          enablePip: false,
          enableOverflowMenu: false,
          enablePlayPause: true,
          // enableProgressText: d.isEmpty || d == {} ? true : false,
          // enableProgressBar: d.isEmpty || d == {} ? true : false,
          enableProgressText: true,
          enableProgressBar: true,
          enableFullscreen: Platform.isIOS ? false : true,
          forwardSkipTimeInMilliseconds: 10000,
          backwardSkipTimeInMilliseconds: 10000,
          progressBarPlayedColor: Colors.orange,
          progressBarBufferedColor: const Color(0xff676767),
          progressBarBackgroundColor: const Color(0xff676767),
        ),
        fit: BoxFit.cover,
      ),
      betterPlayerDataSource: BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        videoPath,
      ),
    );
    betterPlayerController.videoPlayerController!.addListener(() {
      playerTime = betterPlayerController.videoPlayerController!.value.position;
      update();
    });
    update();
  }

  //----------------------Validate string-----------------------
  bool validate(String value) {
    return RegExp(r"^[a-zA-Z0-9_\-=@,\.;' ']+$").hasMatch(value) ? true : false;
  }

  String returnUrl() {
    return videoPath;
  }

  Map returnSharedMap() {
    return sharedData;
  }

  void checkVideo() {
    if (betterPlayerController.isPlaying() == true) {
      betterPlayerController.pause();
    }
  }

  String convertTime(String time) {
    var dateList = time.split(" ").first;
    return dateList;
  }

  String convertIntoDateTime(String month) {
    if (month == "01") {
      return ' Jan';
    } else if (month == "02") {
      return ' Feb';
    } else if (month == "03") {
      return ' Mar';
    } else if (month == "04") {
      return ' Apr';
    } else if (month == "05") {
      return ' May';
    } else if (month == "06") {
      return ' Jun';
    } else if (month == "07") {
      return ' Jul';
    } else if (month == "08") {
      return ' Aug';
    } else if (month == "09") {
      return ' Sep';
    } else if (month == "10") {
      return ' Oct';
    } else if (month == "11") {
      return ' Nov';
    } else {
      return ' Dec';
    }
  }

  String convertDateUtc(String cdate) {
    var strToDateTime = DateTime.parse(cdate);
    final convertLocal = strToDateTime.toLocal();
    var newFormat = DateFormat("dd MM");
    String updatedDt = newFormat.format(convertLocal);
    String q = updatedDt.split(' ').last;
    String a = updatedDt.split(' ').first;
    return a + convertIntoDateTime(q);
  }

  void eveB(e) async {
    if (e.betterPlayerEventType == BetterPlayerEventType.play) {
      if (isSharedData.value == true) {
        if (sharedData['startDuration'] != null) {
          await betterPlayerController.videoPlayerController!.seekTo(Duration(
              milliseconds:
                  double.parse(sharedData['startDuration']).round().toInt()));
          betterPlayerController.videoPlayerController!.addListener(() {
            if (betterPlayerController
                    .videoPlayerController!.value.position.inMilliseconds
                    .round()
                    .toInt() >=
                double.parse(sharedData['endDuration']).round().toInt()) {
              checkVideo();
            }
            if (betterPlayerController
                    .videoPlayerController!.value.position.inMilliseconds
                    .round()
                    .toInt() <
                double.parse(sharedData['startDuration']).round().toInt()) {
              checkVideo();
            }
          });
          startTimer(true);
          Wakelock.enable();
        } else {
          startTimer(true);
          Wakelock.enable();
        }
      } else {
        startTimer(true);
        Wakelock.enable();
      }
    } else if (e.betterPlayerEventType == BetterPlayerEventType.pause) {
      if (isSharedData.value == true) {
        if (sharedData['startDuration'] != null) {
          await betterPlayerController.videoPlayerController!.seekTo(Duration(
              milliseconds:
                  double.parse(sharedData['startDuration']).round().toInt()));
          betterPlayerController.videoPlayerController!.addListener(() {
            if (betterPlayerController
                    .videoPlayerController!.value.position.inMilliseconds
                    .round()
                    .toInt() >=
                double.parse(sharedData['endDuration']).round().toInt()) {
              checkVideo();
            }
          });
          startTimer(true);
          Wakelock.enable();
        } else {
          startTimer(true);
          Wakelock.enable();
        }
      } else {
        startTimer(false);
      }
    } else if (e.betterPlayerEventType ==
        BetterPlayerEventType.controlsVisible) {
      showBack(true);
    } else if (e.betterPlayerEventType ==
        BetterPlayerEventType.hideFullscreen) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    } else if (e.betterPlayerEventType ==
        BetterPlayerEventType.openFullscreen) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    }
  }

  Color check(String d, Duration s) {
    String splittext = d.split('-').first;
    String splittext2 = d.split('-').last;
    double starttime = double.parse(splittext);
    // print('Time in Min $s');
    double endtime = double.parse(splittext2);

    var z = s.inMilliseconds / 1000;
    if (starttime < z && endtime > z) {
      return Colors.yellow;
    } else {
      // print('Is true Return Color Else');
      return Colors.transparent;
    }
    // return Colors.transparent;
  }

  Color check1(String d, Duration s) {
    String splittext = d.split('-').first;
    String splittext2 = d.split('-').last;
    double starttime = double.parse(splittext);
    // print('Time in Min $s');
    double endtime = double.parse(splittext2);

    var z = s.inMilliseconds / 1000;

    if (starttime < z && endtime > z) {
      return Colors.yellow;
    } else {
      // print('Is true Return Color Else');
      return Colors.transparent;
    }
    // return Colors.transparent;
  }

  String getTopicString(List segment) {
    List topic2 = [];
    List topic3 = [];

    String topic2string = "";
    String topic3string = "";

    String topic = "";
    // Get.log('Segments $segment');
    //_.job[index]['segments'][0]['topics']['topic1']
    for (var element in segment) {
      if (element['topics']['topic2'].toString().length != 2) {
        element['topics']['topic2'].forEach((q) {
          topic2.add(q);
        });
      }
      if (element['topics']['topic3'].toString().length != 2) {
        element['topics']['topic3'].forEach((qw) {
          topic3.add(qw);
        });
      }
    }

    if (topic2.isNotEmpty) {
      topic2string = topic2.join('-');
    }
    if (topic3.isNotEmpty) {
      topic3string = topic3.join('-');
    }
    if (topic2.isEmpty && topic3.isNotEmpty) {
      topic = topic3.join('-');
    }
    if (topic2.isNotEmpty && topic3.isEmpty) {
      topic = topic2.join('-');
    }
    if (topic2.isNotEmpty && topic3.isNotEmpty) {
      topic = "$topic2string | $topic3string";
    }
    if (topic2.isEmpty && topic3.isEmpty) {
      topic = '';
    }
    return topic;
  }

  String subTopicString(List c) {
    var sTopic = c.join(", ");
    return sTopic;
  }

  String anchorString(List c) {
    var anchor = c.join(", ");
    return anchor;
  }

  String guestString(List c) {
    List g = [];
    for (int i = 0; i < c.length; i++) {
      g.add(c[i]['name']);
    }
    // update();
    var guest = g.join(", ");
    // var guest = " ";
    return guest;
  }

//-----------------Webshare sharing module function---------
  void audioplay(String audioPath) {
    try {
      isPlay.value = true;
      update();
      mPlayer!
          .startPlayer(
              fromURI: audioPath,
              whenFinished: () {
                isPlay.value = false;
                update();
              })
          .then((value) {});
    } catch (e) {}
  }

  void stopPlayer() {
    isPlay.value = false;
    try {
      mPlayer!.stopPlayer().then((value) {
        update();
      });
    } catch (e) {}
  }

  void pausePlayer() {
    isPlay.value = false;
    try {
      mPlayer!.pausePlayer().then((value) {});
    } catch (e) {}
  }

  Future<void> initRecorder() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      // throw 'Microphone permission not granted';
      final status2 = await Permission.microphone.request();
    }

    await recorder.openRecorder();
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

  Future<void> sendDataWithoutAudio(String id) async {
    try {
      Get.back();
      companyUserController.isBottomLoading.value = true;
      Map sharedBy = {
        "id": senderId,
        "name": "${senderFirstName} ${senderLastName}",
      };
      Map jobInfo = {
        "title": addTitle.text,
        "comments": addDescription.text,
        "startDuration": startDuration.toString(),
        "endDuration": endDuration.toString(),
      };
      String token = await storage.read("AccessToken");
      Map<String, String> h = {'Authorization': 'Bearer $token'};
      var uri = Uri.parse(baseUrlService.baseUrl + ApiData.shareClippedJob);
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
      Get.log('Check Response audio/video ${result}');
      if (response.statusCode == 200) {
        companyUserController.sharingUser.clear();
        homeScreenController.isLoading.value = true;
        await homeScreenController.getSentJobs();
        homeScreenController.isLoading.value = false;
        companyUserController.isBottomLoading.value = false;
        betterPlayerController.dispose();

        mPlayer!.closePlayer();
        mPlayer = null;
        Wakelock.disable();
        Get.delete<VideoController>();

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

  Future<void> sendData(String id) async {
    try {
      Get.back();
      companyUserController.isBottomLoading.value = true;
      Map sharedBy = {
        "id": senderId,
        "name": "${senderFirstName} ${senderLastName}",
      };
      Map jobInfo = {
        "title": addTitle.text,
        "comments": addDescription.text,
        "startDuration": startDuration.toString(),
        "endDuration": endDuration.toString(),
      };
      String token = await storage.read("AccessToken");
      Map<String, String> h = {'Authorization': 'Bearer $token'};
      var uri = Uri.parse(baseUrlService.baseUrl + ApiData.shareClippedJob);
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
      Get.log('Check Response audio/video ${result}');
      if (response.statusCode == 200) {
        companyUserController.sharingUser.clear();
        homeScreenController.isLoading.value = true;
        await homeScreenController.getSentJobs();
        homeScreenController.isLoading.value = false;
        companyUserController.isBottomLoading.value = false;
        betterPlayerController.dispose();

        mPlayer!.closePlayer();
        mPlayer = null;
        Wakelock.disable();
        Get.delete<VideoController>();
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

  Future<void> sharing(String id) async {
    Get.log("job id in sharing ${id}");
    Get.back();
    Map sharedBy = {
      "id": senderId,
      "name": "${senderFirstName} ${senderLastName}",
    };
    DateTime now = DateTime.now();
    String formatDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    Map bodyData = {
      "jobId": id,
      "sharedTime": formatDateTime,
      "shareType": "Full",
      "sharedBy": sharedBy,
      "sharedTo": companyUserController.sharingUser,
    };
    Get.log("Check Sharing data $bodyData");
    companyUserController.isBottomLoading.value = true;
    try {
      String token = await storage.read("AccessToken");
      var res =
          await http.post(Uri.parse(baseUrlService.baseUrl + ApiData.shareJobs),
              headers: {
                'Authorization': "Bearer $token",
                "Content-type": "application/json",
                "Accept": "application/json"
              },
              body: json.encode(bodyData));
      var data = json.decode(res.body);
      Get.log('Shared Job Result is $data');
      if (res.statusCode == 201) {
        companyUserController.sharingUser.clear();
        homeScreenController.isLoading.value = true;
        await homeScreenController.getSentJobs();
        homeScreenController.isLoading.value = false;
        companyUserController.isBottomLoading.value = false;
        betterPlayerController.dispose();

        mPlayer!.closePlayer();
        mPlayer = null;
        Wakelock.disable();
        Get.delete<VideoController>();
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

  String dataformat() {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  }
}
