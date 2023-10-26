// ignore_for_file: unused_catch_clause, unused_local_variable, non_constant_identifier_names, empty_catches, prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lytics_lens/Constants/constants.dart';
import 'package:lytics_lens/Controllers/account_controller.dart';
import 'package:lytics_lens/Controllers/company_user/companyUser_controller.dart';
import 'package:lytics_lens/Controllers/login_screen_controller.dart';
import 'package:lytics_lens/Controllers/playerController.dart';
import 'package:lytics_lens/Models/jobsmodel.dart';
import 'package:http/http.dart' as http;
import 'package:lytics_lens/abstract/getstorage_abstract.dart';
import 'package:lytics_lens/utils/api.dart';
import 'package:lytics_lens/views/dashboard_screen.dart';
import 'package:lytics_lens/views/player_Screen.dart';
import 'package:path_provider/path_provider.dart';

import '../Constants/common_color.dart';
import '../Services/baseurl_service.dart';
import '../views/home_screen.dart';
import '../widget/dialog_box/force_logout_dialogbox.dart';
import '../widget/snackbar/common_snackbar.dart';

class HomeScreenController extends GetxController with GetxStorage {
  TextEditingController searchController = TextEditingController();

  RxBool downloadLoader = false.obs;

  var isLoading = true.obs;
  var isLoadingsource = false.obs;
  var isLoading1 = true.obs;
  var isSendLoading = true.obs;
  BaseUrlService baseUrlService = Get.find<BaseUrlService>();

  String id = '';
  String shareId = '';

  var isAvailable = false.obs;
  var isRead = false.obs;

  var isMore = false.obs;
  var isSearchData = false.obs;

  var isDataFailed = false.obs;

  var isSocketError = false.obs;
  var isSocketError1 = false.obs;

  int totalPages = 0;
  int tvTotalPages = 0;

  RxBool isFound = false.obs;

  // late NetworkController networkController;
  //-------Tabbar varibles------

  TextEditingController selectedTab = TextEditingController(text: "All");
  List<String> sources = [
    'All',
    'TV',
    'Web',
    'Print',
    'Online',
    'Youtube',
    'Twitter',
    'Ticker'
  ];

  DateTime now = DateTime.now();
  DateTime startDate = DateTime.now().subtract(const Duration(days: 2));

  var random = Random();

  List<String> headLines = [];

  RxInt tabIndex = 0.obs;

  var pageno = 1.obs;
  var tpageno = 1.obs;

  var job = [].obs;
  var dummyAlljobsdata = [].obs;
  var searchjob = [].obs;
  var sentjob = [].obs;

  var receivedJobsList = [].obs;

  var escalation = <dynamic>[].obs;
  var hashtags = [];

  int i = 0;

  List<Jobs> jobslist = [];
  List s = [];
  List sourceOfInformation = [
    "Online video",
    "Web",
    "Social Media",
    "TV",
    "Print"
  ];

  int sourcetotalPages = 0;
  var spageno = 1.obs;
  var sourcejob = [].obs;
  var isSMore = false.obs;

  //<----------------- Share Twitter Job ----------------->

  TextEditingController searchContact = TextEditingController();
  String senderId = '';
  String senderFirstName = '';
  String senderLastName = '';

  //------------------ Only TV jobs variables--------------
  var tvJobs = [].obs;
  var tvPageNo = 1.obs;
  var tvIsMore = false.obs;

  //------------------Only Online Jobs Variables---------
  var onlineJobs = [].obs;
  int onlineTotalPages = 0;

//---------------------Twitter Jobs Variables-----------
  var twitterJobs = [].obs;
  int twitterTotalPages = 0;

  //------------Ticker Jobs variables-----------
  var tickerJobs = [].obs;
  int tickerTotalPages = 0;

  //<------------------- All Sources ---------------->
  //<-------- Web ----------->
  int webtotalPages = 0;
  var webpageno = 1.obs;
  var webjob = [].obs;
  var isWebMore = false.obs;
  var isLoadingWeb = false.obs;

  //<-------- Print ----------->
  int printtotalPages = 0;
  var printpageno = 1.obs;
  var printjob = [].obs;
  var isPrintMore = false.obs;
  var isLoadingPrint = false.obs;

  //<-------- Online ----------->
  int onlinetotalPages = 0;
  var onlinepageno = 1.obs;
  var onlinejob = [].obs;
  var isOnlineMore = false.obs;
  var isLoadingOnline = false.obs;

  //<-------- Twitter ----------->
  int twittertotalPages = 0;
  var twitterpageno = 1.obs;
  var twitterjob = [].obs;
  var isTwitterMore = false.obs;
  var isLoadingTwitter = false.obs;

  //<-------- Ticker ----------->
  int tickertotalPages = 0;
  var tickerpageno = 1.obs;
  var tickerjob = [].obs;
  var isTickerMore = false.obs;
  var isLoadingTicker = false.obs;
  String isLibraryJob = '';
  String checkDeleteIsLibrary = '';

  //----------------------------------delete variables--------------
  int statusCode = 0;

  String deviceTokenOfNewUSer = '';
  String loggedUserId = '';
  //<------------- Controller for send job to user ----------->

  CompanyUserController companyUserController =
      Get.find<CompanyUserController>();
  String isJobLibrary = '';

  RxBool isForceLogout = false.obs;
  String hintText = "";

  late String localPath = '';
  String transcription = '';
  String source = '';
  String channelName = '';

  AccountController accCntrl = Get.put(AccountController());

  // StreamSubscription<ReceivedAction>? notificationsActionStreamSubscription;

  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title description
    importance: Importance.max,
  );

  @override
  void onInit() async {
    //notificationStream();

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        // hintText = message.data["hint"] ?? "";

        FlutterAppBadger.updateBadgeCount(message.data.length);

        // if (hintText != "") {
        //   if (kDebugMode) {
        //     print("I am in hint notification hint value------${hintText}");
        //   }
        //   deviceTokenOfNewUSer = message.data["deviceTokenOfNewUser"] ?? "";
        //   loggedUserId = message.data["loggedUserId"] ?? "";
        //   update();
        //
        //   Get.snackbar(
        //       "${message.notification!.title}", "${message.notification!.body}",
        //       messageText: Column(
        //         children: [
        //           Text(
        //             "${message.notification!.body}",
        //             style: const TextStyle(),
        //           ),
        //           Row(
        //             crossAxisAlignment: CrossAxisAlignment.end,
        //             mainAxisAlignment: MainAxisAlignment.end,
        //             children: [
        //               TextButton(
        //                 child: const Text(
        //                   'Cancel',
        //                   style: TextStyle(color: Colors.black),
        //                 ),
        //                 onPressed: () async {
        //                   await cancelLogout();
        //                   Get.back();
        //
        //                   // Implement your action here
        //                 },
        //               ),
        //               TextButton(
        //                 child: const Text(
        //                   'Logout',
        //                   style: TextStyle(color: Colors.black),
        //                 ),
        //                 onPressed: () async {
        //                   await acceptLogoutRequest();
        //                   Get.back();
        //                   // Implement your action here
        //                 },
        //               ),
        //             ],
        //           ),
        //         ],
        //       ),
        //       forwardAnimationCurve: Curves.easeOutBack,
        //       backgroundColor: CommonColor.snackbarColour,
        //       onTap: (value) async {},
        //       duration: const Duration(seconds: 30));
        // }

        // Get.snackbar(
        //     "${message.notification!.title}", "${message.notification!.body}",
        //     messageText: Text(
        //       "${message.notification!.body}",
        //       style: const TextStyle(),
        //     ),
        //     forwardAnimationCurve: Curves.easeOutBack,
        //     backgroundColor: CommonColor.snackbarColour,
        //     onTap: (value) async {
        //   if (message.data["source"] != 'Social') {
        //     if (message.data["source"] == 'Ticker') {
        //     } else {
        //       if (Get.currentRoute == '/PlayerScreen') {
        //         VideoController videoController = Get.find<VideoController>();
        //         videoController.betterPlayerController.pause();
        //         videoController.stopPlayer();
        //         videoController.isLoading.value = true;
        //         videoController.betterPlayerController.dispose();
        //         if (message.data["shareId"] == '') {
        //           await videoController.getSingleJob(message.data["jobID"]);
        //         } else {
        //           await videoController.getSingleJobForNotification(
        //               message.data["jobID"], message.data['shareId'], 'true');
        //         }
        //         videoController.isLoading.value = false;
        //         videoController.update();
        //       } else {
        //         if (message.data["shareId"] == '') {
        //           Get.to(() => const PlayerScreen(),
        //               arguments: {"id": message.data["jobID"]});
        //         } else {
        //           Get.to(() => const PlayerScreen(), arguments: {
        //             "id": message.data["jobID"],
        //             "shareId": message.data["shareId"],
        //             "sentPage": "true",
        //             "sharedJob": "true"
        //           });
        //         }
        //       }
        //     }
        //   } else {}
        // });

        if (message.data["jobID"] != '') {
          if (kDebugMode) {
            print("i am in notification if");
          }
          isLibraryJob = message.data["isJobLibrary"];
          // if (kDebugMode) {
          //   print("-------islibrary job ${message.data["isJobLibrary"]}");
          // }

          // if (kDebugMode) {
          //   print("-------islibrary job in variable store ${isLibraryJob}");
          // }
          await getSingleJobForNotification(
              message.data["jobID"], message.data["shareId"]);
        }
      },
    );

    FirebaseMessaging.instance.getInitialMessage().then((message) async {
      // if (kDebugMode) {
      //   print("When the app is killed ");
      //   print("value of force logout---------------------${isForceLogout}");
      // }

      // if (hintText!="") {
      //   deviceTokenOfNewUSer = message!.data["deviceTokenOfNewUser"] ?? "";
      //   loggedUserId = message.data["loggedUserId"] ?? "";
      //   isForceLogout.value = true;
      //   HomeScreenController controller = Get.find();
      //   controller.refresh();
      //   update();
      //
      //   // if (kDebugMode) {
      //   //   print("value of force logout---------------------${isForceLogout}");
      //   // }
      //
      //   if (isForceLogout.value == true) {
      //     ForceLogout.showDialogBox(
      //       title: "Alert",
      //       message: 'Someone is trying to login, is that you? Please confirm.',
      //       onPressed1: () async {
      //         await cancelLogout();
      //         Get.back();
      //       },
      //       onPressed2: () async {
      //         await acceptLogoutRequest();
      //         Get.back();
      //       },
      //     );
      //   }
      // }

      // if (message!.data["hint"] == "concurrentLoginAttempt") {
      //   if (kDebugMode) {
      //     print("kill state helllooo");
      //   }
      //   deviceTokenOfNewUSer = message.data["deviceTokenOfNewUser"] ?? "";
      //   loggedUserId = message.data["loggedUserId"] ?? "";
      //   isForceLogout.value = true;
      //   // HomeScreenController controller = Get.find();
      //   // controller.refresh();
      //   update();
      // }

      // Get.log("Hello");
      if (message != null) {
        if (message.data["source"] != 'Social') {
          if (message.data["source"] == 'Ticker') {
            // Get.to(()=>HomeScreen());
            // Get.log("No Action Perform ${message.data["source"]}");
          } else {
            if (Get.currentRoute == '/PlayerScreen') {
              // Get.log("If Condition True");
              VideoController videoController = Get.find<VideoController>();
              videoController.betterPlayerController.pause();
              videoController.stopPlayer();
              videoController.isLoading.value = true;
              videoController.betterPlayerController.dispose();
              if (message.data["shareId"] == '') {
                await videoController.getSingleJob(message.data["jobID"]);
              } else {
                await videoController.getSingleJobForNotification(
                    message.data["jobID"], message.data['shareId'], 'true');
              }
              videoController.isLoading.value = false;
              videoController.update();
            } else {
              // Get.log("Else Condition True");
              if (message.data["shareId"] == '') {
                Get.to(() => const PlayerScreen(), arguments: {
                  "id": message.data["jobID"],
                  "receiverName": "",
                });
              } else {
                Get.to(() => const PlayerScreen(), arguments: {
                  "id": message.data["jobID"],
                  "shareId": message.data["shareId"],
                  "sentPage": "true",
                  "sharedJob": "true",
                  "receiverName": "",
                });
              }
            }
          }
        } else {
          // Get.log("Else Condition");
        }
        if (message.data["jobID"] != '') {
          await getSingleJobForNotification(
              message.data["jobID"], message.data["shareId"]);
        }
      } else {
        // Get.log("HEllo");
      }
    });

    //----------------------------Background messageing service------------------

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // if (hintText!="") {
      //   deviceTokenOfNewUSer = message.data["deviceTokenOfNewUser"] ?? "";
      //   loggedUserId = message.data["loggedUserId"] ?? "";
      //   isForceLogout.value = true;
      //   HomeScreenController controller = Get.find();
      //   controller.refresh();
      //   update();
      //
      //   if (kDebugMode) {
      //     print("The app is in background value of force logout 2---------------------${isForceLogout}");
      //   }
      //
      //        if (isForceLogout.value == true) {
      //     ForceLogout.showDialogBox(
      //       title: "Alert",
      //       message: 'Someone is trying to login, is that you? Please confirm.',
      //       onPressed1: () async {
      //         await cancelLogout();
      //         Get.back();
      //       },
      //       onPressed2: () async {
      //         await acceptLogoutRequest();
      //         Get.back();
      //       },
      //     );
      //   }
      //
      //   // Get.to(const Dashboard());
      //
      // }

      // if (kDebugMode) {
      //   print("When the app is killed ");
      // }
      // Get.log("Hello");

      // if (message.data["hint"] == "concurrentLoginAttempt") {
      //   if (kDebugMode) {
      //     print("hellllooooo----------------");
      //   }
      //   deviceTokenOfNewUSer = message.data["deviceTokenOfNewUser"] ?? "";
      //   loggedUserId = message.data["loggedUserId"] ?? "";
      //   isForceLogout.value = true;
      //   // HomeScreenController controller = Get.find();
      //   //   controller.refresh();
      //   update();
      // }

      if (message != null) {
        if (message.data["source"] != 'Social') {
          if (message.data["source"] == 'Ticker') {
            // Get.to(()=>HomeScreen());

          } else {
            if (Get.currentRoute == '/PlayerScreen') {
              VideoController videoController = Get.find<VideoController>();
              videoController.betterPlayerController.pause();
              videoController.stopPlayer();
              videoController.isLoading.value = true;
              videoController.betterPlayerController.dispose();
              if (message.data["shareId"] == '') {
                await videoController.getSingleJob(message.data["jobID"]);
              } else {
                await videoController.getSingleJobForNotification(
                    message.data["jobID"], message.data['shareId'], 'true');
              }
              videoController.isLoading.value = false;
              videoController.update();
            } else {
              if (message.data["shareId"] == '') {
                Get.to(() => const PlayerScreen(), arguments: {
                  "id": message.data["jobID"],
                  "receiverName": ""
                });
              } else {
                Get.to(() => const PlayerScreen(), arguments: {
                  "id": message.data["jobID"],
                  "shareId": message.data["shareId"],
                  "sentPage": "true",
                  "sharedJob": "true",
                  "receiverName": "",
                });
              }
            }
          }
        } else {}
        if (message.data["jobID"] != '') {
          await getSingleJobForNotification(
              message.data["jobID"], message.data["shareId"]);
        }
      }
    });
    super.onInit();
  }

  @override
  void onReady() async {
    senderId = await storage.read('id');
    senderFirstName = await storage.read('firstName');
    senderLastName = await storage.read('lastName');
    companyUserController.searchcompanyUser.clear();
    companyUserController.sharingUser.clear();

    if (storage.read('id') != null) {
      id = await storage.read('id');
      FlutterAppBadger.removeBadge();
      //
      await getJobs(pageno.value);
      isLoadingsource.value = true;
      isLoadingWeb.value = true;
      isLoadingPrint.value = true;
      isLoadingOnline.value = true;
      isLoadingTwitter.value = true;
      isLoadingTicker.value = true;
      getJobBySource('["Tv"]', spageno.value);
      getWebJob('["Blog"]', webpageno.value);
      getPrintJob('["Print"]', printpageno.value);
      getOnlineJob('["Online"]', onlinepageno.value);
      getTwitterJob('["Social"]', twitterpageno.value);
      getTickerJob('["Ticker"]', tickerpageno.value);
      getSentJobs();
      getReceiveJob();
      sendDeviceToken();

      // if(kDebugMode){
      //   print("------------onready------${isForceLogout.value}");
      // }
      //        if (isForceLogout.value == true) {
      //     ForceLogout.showDialogBox(
      //       title: "Alert",
      //       message: 'Someone is trying to login, is that you? Please confirm.',
      //       onPressed1: () async {
      //         await cancelLogout();
      //         Get.back();
      //       },
      //       onPressed2: () async {
      //         await acceptLogoutRequest();
      //         Get.back();
      //       },
      //     );
      //   }

      update();
    }
    // isLoading.value = false;
    // isLoading1.value = false;
    // isSendLoading.value = false;

    super.onReady();
  }

//-----------------------Force logout API-------------------
//   Future<void> cancelLogout() async {
//     var res = await http.post(
//       Uri.parse(baseUrlService.baseUrl + ApiData.cancelLogout),
//       body: {
//         "confirmation": "false",
//         "loggedUserId": loggedUserId,
//         "deviceTokenOfNewUser": deviceTokenOfNewUSer,
//       },
//     );
//
//     var data = json.decode(res.body);
//     if (kDebugMode) {
//       print("Cancel Api response--------------------------${res.statusCode}");
//
//       print("Cancel Api response--------------------------${data}");
//     }
//   }

  // Future<void> acceptLogoutRequest() async {
  //   var res = await http.post(
  //     Uri.parse(baseUrlService.baseUrl + ApiData.cancelLogout),
  //     body: {
  //       "confirmation": "true",
  //       "loggedUserId": loggedUserId,
  //       "deviceTokenOfNewUser": deviceTokenOfNewUSer,
  //     },
  //   );
  //
  //   var data = json.decode(res.body);
  //   if (kDebugMode) {
  //     print("Cancel Api response--------------------------${res.statusCode}");
  //
  //     print("Cancel Api response--------------------------${data}");
  //   }
  //   if (res.statusCode == 200) {
  //     accCntrl.logout();
  //   }
  // }

  Future<void> downloadImage(String thumbnailpath) async {
    downloadLoader.value = true;
    update();
    // if (kDebugMode) {
    //   print( Uri.parse("${thumbnailpath}"));
    // }
    try {
      final http.Response response =
          await http.get(Uri.parse("${thumbnailpath}"));
      final Directory directory = await getApplicationDocumentsDirectory();
      localPath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
      final File imageFile = File(localPath);
      await imageFile.writeAsBytes(response.bodyBytes);
      downloadLoader.value = false;
      update();
      if (kDebugMode) {
        print('Image downloaded successfully.');
      }
    } catch (e) {
      downloadLoader.value = false;
      update();
      if (kDebugMode) {
        print('Error while downloading the image: $e');
      }
    }
  }

  Future<void> sendDeviceToken() async {
    //Get.log("The access tokn is ${storage.read("AccessToken")}");
    String token = await storage.read("AccessToken");
    String id = await storage.read('id');
    await http.post(
      Uri.parse(baseUrlService.baseUrl + ApiData.deviceToken),
      headers: {
        'Authorization': 'Bearer $token',
        "Content-type": 'application/json',
      },
      body: json.encode({
        "userId": id,
        "deviceToken": Constants.token,
        "addToken": "true",
      }),
    );
  }

  searchFunction(String v) {
    if (v.isEmpty || v == '') {
      searchjob.clear();
    } else {
      searchjob.clear();
      for (var e in job) {
        if (e['programName']
            .toString()
            .toLowerCase()
            .contains(v.toLowerCase())) {
          searchjob.add(e);
        } else if (e['anchor']
            .toString()
            .toLowerCase()
            .contains(v.toLowerCase())) {
          searchjob.add(e);
        } else if (e['segments']
            .toString()
            .toLowerCase()
            .contains(v.toLowerCase())) {
          searchjob.add(e);
        } else if (e['segments'][0]['topics']['topic1']
            .toString()
            .toLowerCase()
            .contains(v.toLowerCase())) {
          searchjob.add(e);
        }
        update();
      }
      if (searchjob.isEmpty) {
        isSearchData.value = true;
      } else {
        isSearchData.value = false;
      }
    }
  }

  List<int> indexAdress = [];

  Future<void> getJobs(int p) async {
    try {
      isSocketError.value = false;
      isDataFailed.value = false;
      //isMore.value = false;

      // update();
      String id = await storage.read('id');
      if (p == 1) {
        isMore.value = false;
        isLoading.value = true;
        job.clear();
        update();
        tpageno.value = 1;
        String token = await storage.read("AccessToken");
        var res = await http.get(
          Uri.parse(
              '${baseUrlService.baseUrl}${ApiData.jobs}?limit=30&page=$p&source=All&device=mobile&escalation=$id'),
          headers: {
            'Authorization': 'Bearer $token',
            "Content-type": 'application/json',
          },
        );
        if (kDebugMode) {
          print(
              'The query is ${baseUrlService.baseUrl}${ApiData.jobs}?limit=30&page=$p&source=All&device=mobile&escalation=$id');
        }
        var data = json.decode(res.body);

        if (p == 1) {
          totalPages = data['totalPages'];
          update();
        }

        job.addAll(data['results']);
        // job.forEach((element) {
        //
        //   if(element["source"]=="Tv"){
        //     sourcejob.add(element);
        //   }
        //   else if(element["source"]=="Blog")
        //   {
        //     webjob.add(element);
        //
        //   }
        //   else if(element["source"]=="Print")
        //   {
        //     printjob.add(element);
        //
        //   }
        //   else if(element["source"]=="Online")
        //   {
        //     onlinejob.add(element);
        //
        //   }
        //   else if(element["source"]=="Ticker")
        //   {
        //     tickerjob.add(element);
        //
        //   }
        //   else if(element["source"]=="Social")
        //   {
        //     twitterjob.add(element);
        //
        //   }
        // });
        // // job.assignAll(List.from(job.reversed));
        // job.toList().sort((b ,a) => b['programDate'].compareTo(a))
        // job.sort((a,b) => a['programDate'].compareTo(b['programDate']));

        isLoading.value = false;
      } else {
        if (tpageno.value <= totalPages) {
          isMore.value = true;
          String token = await storage.read("AccessToken");
          if (kDebugMode) {
            print('-------Ismore value ${isMore.value}');
          }
          var res = await http.get(
            Uri.parse(
                '${baseUrlService.baseUrl}${ApiData.jobs}?limit=30&page=$p&source=All&device=mobile&escalation=$id'),
            headers: {
              'Authorization': 'Bearer $token',
              "Content-type": 'application/json',
            },
          );
          if (kDebugMode) {
            print(
                'The query is ${baseUrlService.baseUrl}${ApiData.jobs}?limit=30&page=$p&source=All&device=mobile&escalation=$id');
          }
          var data = json.decode(res.body);
          if (p == 1) {
            totalPages = data['totalPages'];
            update();
          }
          job.addAll(data['results']);
          // job.forEach((element) {
          //   if(element["source"]=="Tv"){
          //     sourcejob.add(element);
          //   }
          //   else if(element["source"]=="Blog")
          //   {
          //     webjob.add(element);
          //
          //   }
          //   else if(element["source"]=="Print")
          //   {
          //     printjob.add(element);
          //
          //   }
          //   else if(element["source"]=="Online")
          //   {
          //     onlinejob.add(element);
          //
          //   }
          //   else if(element["source"]=="Ticker")
          //   {
          //     tickerjob.add(element);
          //
          //   }
          //   else if(element["source"]=="Social")
          //   {
          //     twitterjob.add(element);
          //
          //   }
          // });
          isMore.value = false;
        } else {
          isMore.value = false;
        }
      }
    } on SocketException catch (e) {
      isLoading.value = false;
      isSocketError.value = true;
    } catch (e) {
      isLoading.value = false;
      isDataFailed.value = true;
    }
  }

  Future<void> getJobBySource(String source, int p) async {
    try {
      String id = await storage.read('id');
      if (p == 1) {
        isSMore.value = false;
        isLoadingsource.value = true;
        sourcejob.clear();
        update();
        spageno.value = 1;
        String token = await storage.read("AccessToken");
        var res = await http.get(
          Uri.parse(
              '${baseUrlService.baseUrl}${ApiData.jobs}?limit=30&page=$p&source=$source&device=mobile&escalation=$id'),
          headers: {
            'Authorization': 'Bearer $token',
            "Content-type": 'application/json',
          },
        );
        // Get.log('tv status code ${res.statusCode}');

        var data = json.decode(res.body);
        // Get.log('$source Source Api $data');
        if (p == 1) {
          sourcetotalPages = data['totalPages'];
          update();
        }
        sourcejob.addAll(data['results']);
        // Get.log("Tv jobs result $data");
        // job.assignAll(List.from(job.reversed));
        // job.toList().sort((b ,a) => b['programDate'].compareTo(a))
        // job.sort((a,b) => a['programDate'].compareTo(b['programDate']));
        isLoadingsource.value = false;
      } else {
        if (spageno.value <= sourcetotalPages) {
          isSMore.value = true;
          String token = await storage.read("AccessToken");
          var res = await http.get(
            Uri.parse(
                '${baseUrlService.baseUrl}${ApiData.jobs}?limit=30&page=$p&source=$source&device=mobile&escalation=$id'),
            headers: {
              'Authorization': 'Bearer $token',
              "Content-type": 'application/json',
            },
          );
          // Get.log('tv status code ${res.statusCode}');

          var data = json.decode(res.body);
          if (p == 1) {
            sourcetotalPages = data['totalPages'];
            update();
          }
          sourcejob.addAll(data['results']);
          // Get.log("Tv jobs result $data");

          isSMore.value = false;
        } else {
          isSMore.value = false;
        }
      }
    } on SocketException catch (e) {
      isLoadingsource.value = false;
    } catch (e) {
      isLoadingsource.value = false;
    }
  }

  // <--------- Source ------------->

  Future<void> getWebJob(String source, int p) async {
    try {
      String id = await storage.read('id');
      if (p == 1) {
        isWebMore.value = false;

        isLoadingWeb.value = true;
        webjob.clear();
        update();
        webpageno.value = 1;
        String token = await storage.read("AccessToken");
        var res = await http.get(
          Uri.parse(
              '${baseUrlService.baseUrl}${ApiData.jobs}?limit=30&page=$p&source=$source&device=mobile&escalation=$id'),
          headers: {
            'Authorization': 'Bearer $token',
            "Content-type": 'application/json',
          },
        );

        var data = json.decode(res.body);
        // Get.log('$source Source Api $data');
        if (p == 1) {
          webtotalPages = data['totalPages'];
          update();
        }
        webjob.addAll(data['results']);
        // job.assignAll(List.from(job.reversed));
        // job.toList().sort((b ,a) => b['programDate'].compareTo(a))
        // job.sort((a,b) => a['programDate'].compareTo(b['programDate']));
        isLoadingWeb.value = false;
      } else {
        if (webpageno.value <= webtotalPages) {
          isWebMore.value = true;
          String token = await storage.read("AccessToken");

          var res = await http.get(
            Uri.parse(
                '${baseUrlService.baseUrl}${ApiData.jobs}?limit=30&page=$p&source=$source&device=mobile&escalation=$id'),
            headers: {
              'Authorization': 'Bearer $token',
              "Content-type": 'application/json',
            },
          );
          if (kDebugMode) {
            print(
                "web is more-----------------${Uri.parse('${baseUrlService.baseUrl}${ApiData.jobs}?limit=30&page=$p&source=$source&device=mobile&escalation=$id')}");
          }

          var data = json.decode(res.body);
          if (p == 1) {
            webtotalPages = data['totalPages'];
            update();
          }
          webjob.addAll(data['results']);
          isWebMore.value = false;
        } else {
          isWebMore.value = false;
        }
      }
    } on SocketException catch (e) {
      isLoadingWeb.value = false;
    } catch (e) {
      isLoadingWeb.value = false;
    }
  }

  Future<void> getPrintJob(String source, int p) async {
    try {
      String id = await storage.read('id');
      if (p == 1) {
        isPrintMore.value = false;

        isLoadingPrint.value = true;
        printjob.clear();
        update();
        printpageno.value = 1;
        String token = await storage.read("AccessToken");
        var res = await http.get(
          Uri.parse(
              '${baseUrlService.baseUrl}${ApiData.jobs}?limit=30&page=$p&source=$source&device=mobile&escalation=$id'),
          headers: {
            'Authorization': 'Bearer $token',
            "Content-type": 'application/json',
          },
        );
        var data = json.decode(res.body);
        // Get.log('$source Source Api $data');
        if (p == 1) {
          printtotalPages = data['totalPages'];
          update();
        }
        printjob.addAll(data['results']);
        // job.assignAll(List.from(job.reversed));
        // job.toList().sort((b ,a) => b['programDate'].compareTo(a))
        // job.sort((a,b) => a['programDate'].compareTo(b['programDate']));
        isLoadingPrint.value = false;
      } else {
        if (printpageno.value <= printtotalPages) {
          isPrintMore.value = true;
          // Get.log("------------------------------a");
          String token = await storage.read("AccessToken");
          var res = await http.get(
            Uri.parse(
                '${baseUrlService.baseUrl}${ApiData.jobs}?limit=30&page=$p&source=$source&device=mobile&escalation=$id'),
            headers: {
              'Authorization': 'Bearer $token',
              "Content-type": 'application/json',
            },
          );
          var data = json.decode(res.body);
          if (p == 1) {
            printtotalPages = data['totalPages'];
            update();
          }
          printjob.addAll(data['results']);
          isPrintMore.value = false;
        } else {
          isPrintMore.value = false;
        }
      }
    } on SocketException catch (e) {
      isLoadingPrint.value = false;
    } catch (e) {
      isLoadingPrint.value = false;
    }
  }

  Future<void> getOnlineJob(String source, int p) async {
    try {
      String id = await storage.read('id');
      if (p == 1) {
        isOnlineMore.value = false;

        isLoadingOnline.value = true;
        onlinejob.clear();
        update();
        onlinepageno.value = 1;
        String token = await storage.read("AccessToken");
        var res = await http.get(
          Uri.parse(
              '${baseUrlService.baseUrl}${ApiData.jobs}?limit=30&page=$p&source=$source&device=mobile&escalation=$id'),
          headers: {
            'Authorization': 'Bearer $token',
            "Content-type": 'application/json',
          },
        );
        if (kDebugMode) {
          print(
              "Online job query${Uri.parse('${baseUrlService.baseUrl}${ApiData.jobs}?limit=30&page=$p&source=$source&device=mobile&escalation=$id')}");
        }
        var data = json.decode(res.body);
        // Get.log('$source Source Api $data');
        if (p == 1) {
          onlinetotalPages = data['totalPages'];
          isOnlineMore.value = false;

          update();
        }
        onlinejob.addAll(data['results']);
        // job.assignAll(List.from(job.reversed));
        // job.toList().sort((b ,a) => b['programDate'].compareTo(a))
        // job.sort((a,b) => a['programDate'].compareTo(b['programDate']));
        isLoadingOnline.value = false;
      } else {
        if (onlinepageno.value <= onlinetotalPages) {
          isOnlineMore.value = true;
          String token = await storage.read("AccessToken");
          var res = await http.get(
            Uri.parse(
                '${baseUrlService.baseUrl}${ApiData.jobs}?limit=30&page=$p&source=$source&device=mobile&escalation=$id'),
            headers: {
              'Authorization': 'Bearer $token',
              "Content-type": 'application/json',
            },
          );
          var data = json.decode(res.body);
          if (p == 1) {
            onlinetotalPages = data['totalPages'];
            update();
          }
          onlinejob.addAll(data['results']);
          isOnlineMore.value = false;
        } else {
          isOnlineMore.value = false;
        }
      }
    } on SocketException catch (e) {
      isLoadingOnline.value = false;
    } catch (e) {
      isLoadingOnline.value = false;
    }
  }

  Future<void> getTwitterJob(String source, int p) async {
    try {
      String id = await storage.read('id');
      if (p == 1) {
        isTwitterMore.value = false;

        isLoadingTwitter.value = true;
        twitterjob.clear();
        update();
        twitterpageno.value = 1;
        String token = await storage.read("AccessToken");
        var res = await http.get(
          Uri.parse(
              '${baseUrlService.baseUrl}${ApiData.jobs}?limit=30&page=$p&source=$source&device=mobile&escalation=$id'),
          headers: {
            'Authorization': 'Bearer $token',
            "Content-type": 'application/json',
          },
        );
        var data = json.decode(res.body);
        // Get.log('$source Source Api $data');
        if (p == 1) {
          twittertotalPages = data['totalPages'];
          update();
        }
        twitterjob.addAll(data['results']);
        // job.assignAll(List.from(job.reversed));
        // job.toList().sort((b ,a) => b['programDate'].compareTo(a))
        // job.sort((a,b) => a['programDate'].compareTo(b['programDate']));
        isLoadingTwitter.value = false;
      } else {
        if (twitterpageno.value <= twittertotalPages) {
          isTwitterMore.value = true;
          String token = await storage.read("AccessToken");
          var res = await http.get(
            Uri.parse(
                '${baseUrlService.baseUrl}${ApiData.jobs}?limit=30&page=$p&source=$source&device=mobile&escalation=$id'),
            headers: {
              'Authorization': 'Bearer $token',
              "Content-type": 'application/json',
            },
          );
          var data = json.decode(res.body);
          if (p == 1) {
            twittertotalPages = data['totalPages'];
            update();
          }
          twitterjob.addAll(data['results']);
          isTwitterMore.value = false;
        } else {
          isTwitterMore.value = false;
        }
      }
    } on SocketException catch (e) {
      isLoadingTwitter.value = false;
    } catch (e) {
      isLoadingTwitter.value = false;
    }
  }

  Future<void> getTickerJob(String source, int p) async {
    try {
      String id = await storage.read('id');
      if (p == 1) {
        isTickerMore.value = false;
        isLoadingTicker.value = true;
        tickerjob.clear();
        update();
        tickerpageno.value = 1;
        String token = await storage.read("AccessToken");
        var res = await http.get(
          Uri.parse(
              '${baseUrlService.baseUrl}${ApiData.jobs}?limit=30&page=$p&source=$source&device=mobile&escalation=$id'),
          headers: {
            'Authorization': 'Bearer $token',
            "Content-type": 'application/json',
          },
        );
        var data = json.decode(res.body);
        // Get.log('$source Source Api $data');
        if (p == 1) {
          tickertotalPages = data['totalPages'];
          update();
        }
        tickerjob.addAll(data['results']);
        // job.assignAll(List.from(job.reversed));
        // job.toList().sort((b ,a) => b['programDate'].compareTo(a))
        // job.sort((a,b) => a['programDate'].compareTo(b['programDate']));
        isLoadingTicker.value = false;
      } else {
        if (tickerpageno.value <= tickertotalPages) {
          isTickerMore.value = true;
          String token = await storage.read("AccessToken");
          var res = await http.get(
            Uri.parse(
                '${baseUrlService.baseUrl}${ApiData.jobs}?limit=30&page=$p&source=$source&device=mobile&escalation=$id'),
            headers: {
              'Authorization': 'Bearer $token',
              "Content-type": 'application/json',
            },
          );
          var data = json.decode(res.body);
          if (p == 1) {
            tickertotalPages = data['totalPages'];
            update();
          }
          tickerjob.addAll(data['results']);
          isTickerMore.value = false;
        } else {
          isTickerMore.value = false;
        }
      }
    } on SocketException catch (e) {
      isLoadingTicker.value = false;
    } catch (e) {
      isLoadingTicker.value = false;
    }
  }

  Future<void> getSentJobs() async {
    sentjob.clear();
    try {
      isSocketError.value = false;
      isDataFailed.value = false;
      isSendLoading.value = true;
      String id = await storage.read('id');
      String token = await storage.read("AccessToken");
      var res = await http.get(
        Uri.parse(baseUrlService.baseUrl + ApiData.getSentJobs + id),
        headers: {
          'Authorization': 'Bearer $token',
          "Content-type": 'application/json',
        },
      );
      var data = json.decode(res.body);
      // if (kDebugMode) {
      //   print("sent api called ${data[0]["originalJobId"].toString()}");
      // }

      // Get.log("Check ALL Shared Data ${res.body}");
      sentjob.addAll(data);
      shareId = data['shareId'];
      isDataFailed.value = false;
      isSendLoading.value = false;
    } on SocketException catch (e) {
      isSendLoading.value = false;
      isSocketError.value = true;
      // CustomSnackBar.showSnackBar(
      //     title: AppStrings.unable,
      //     message: "",
      //     backgroundColor: Color(0xff48beeb),
      //     isWarning: true);

    } catch (e) {
      isSendLoading.value = false;
      isDataFailed.value = false;
      // Get.snackbar("Error", e.toString(), backgroundColor: Colors.red);
    }
  }

  Future<void> getReceiveJob() async {
    Get.log("received job api called");
    isLoading1.value = true;
    isSocketError1.value = false;
    isDataFailed.value = false;
    receivedJobsList.clear();
    try {
      String token = await storage.read("AccessToken");
      String id = await storage.read('id');
      var res = await http.get(
        Uri.parse(baseUrlService.baseUrl + ApiData.getReceivedJobs + id),
        headers: {
          'Authorization': 'Bearer $token',
          "Content-type": 'application/json',
        },
      );
      var data = json.decode(res.body);
      receivedJobsList.addAll(data);

      isLoading1.value = false;
    } on SocketException catch (e) {
      isLoading1.value = false;
      isSocketError1.value = true;
    } catch (e) {
      isLoading1.value = false;
      isDataFailed.value = true;
    }
  }

  void reset() {
    searchController.text = '';
    update();
    // getJobs(1);
  }

  int searchForNews(String data) {
    bool match = false;
    for (int i = 0; i < headLines.length; i++) {
      if (headLines[i].contains(data.toUpperCase())) {
        indexAdress.add(i);
        match = true;
        break;
      }
    }
    return indexAdress.length;
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

  //-----------------Convert Tv UTC time into local time-----------
  String convertTimeIntoUtc(String time) {
    final dateTime = DateTime.parse(time).toUtc();
    final timeFormat = DateFormat('HH:mm');
    final utcTime = timeFormat.format(dateTime.add(const Duration(hours: 0)));

    return formatTime(utcTime);
  }

  String formatTime(String time) {
    final parseTime = DateFormat('HH:mm').parse(time);
    return DateFormat('h:mm a').format(parseTime);
  }

  String convertTime(String time) {
    var dateList = time.split(" ").first;

    return dateList;
  }

  // int generateRandomNumber(int i) {
  //   // int  c = i + ;
  //
  //   i++;
  //   int mul = i * 40;
  //   if (mul > 100) {
  //     mul = i * 10;
  //     return mul;
  //   } else {
  //     return mul;
  //   }
  // }

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
      for (var element in topic2) {}
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

  String getGuestsString(List guest) {
    List allguest = [];
    for (var element in guest) {
      allguest.add(element['name']);
    }
    return allguest.join(', ');
  }

  String getSharePerson(List r) {
    List rec = [];
    for (int i = 0; i < r.length; i++) {
      if (id == r[i]['recieverId']) {
        rec.add('${r[i]['senderFirstName']} ${r[i]['senderLastName']}');
      }
    }
    return rec.join(', ');
  }

  String getReceivedPerson(List r) {
    List sen = [];
    for (int i = 0; i < r.length; i++) {
      if (id == r[i]['senderId']) {
        sen.add('${r[i]['recieverFirstName']} ${r[i]['recieverLastName']}');
      }
    }
    return sen.join(', ');
  }

  Future<void> getSingleJob(String jobId) async {
    isLoading.value = true;
    String token = await storage.read("AccessToken");
    var res = await http.get(
        Uri.parse(baseUrlService.baseUrl + ApiData.singleJob + jobId),
        headers: {
          'Authorization': "Bearer $token",
        });
    var data = json.decode(res.body);
    if (kDebugMode) {
      //Get.log('Check Data $data');
    }

    data['escalations'].forEach((e) {
      escalation.add(e);
    });
    await checkEscalation(data, jobId);
  }

  //-------------Delete shared job API-------------
  Future<void> deleteReceivedSharedJob(String shareId) async {
    String token = await storage.read("AccessToken");
    if (kDebugMode) {
      print(
          "delete query ${baseUrlService.baseUrl}${checkDeleteIsLibrary == "true" ? ApiData.deleteSharedReceivedLibraryJob : ApiData.deleteSharedReceivedJob}$shareId");
    }

    var res = await http.patch(
        Uri.parse(
            "${baseUrlService.baseUrl}${checkDeleteIsLibrary == "true" ? ApiData.deleteSharedReceivedLibraryJob : ApiData.deleteSharedReceivedJob}${shareId}"),
        headers: {
          'Authorization': "Bearer $token",
        });

    //var data = json.decode(res.body);
    if (kDebugMode) {
      print('Check Data ${res.statusCode}');
      print('Check Data ${res.body}');
    }
    statusCode = res.statusCode;
    update();
  }

  Future<void> deleteSentSharedJob(String shareId) async {
    String token = await storage.read("AccessToken");
    if (kDebugMode) {
      print(
          "delete query ${baseUrlService.baseUrl}${checkDeleteIsLibrary == "true" ? ApiData.deleteSharedSentLibraryJob : ApiData.deleteSharedSentJob}$shareId");
    }

    var res = await http.patch(
        Uri.parse(
            "${baseUrlService.baseUrl}${checkDeleteIsLibrary == "true" ? ApiData.deleteSharedSentLibraryJob : ApiData.deleteSharedSentJob}${shareId}"),
        headers: {
          'Authorization': "Bearer $token",
        });

    //var data = json.decode(res.body);
    if (kDebugMode) {
      print('Check Data ${res.statusCode}');
      print('Check Data ${res.body}');
    }
    statusCode = res.statusCode;
    update();
  }

//-------------------------Delete esclilation Jobs-------------------
  Future<void> deleteEscalationJobs(String jobId) async {
    String token = await storage.read("AccessToken");
    if (kDebugMode) {
      print(
          "delete query ${baseUrlService.baseUrl}${ApiData.deleteEscalateJobs}$jobId");
    }

    var res = await http.patch(
        Uri.parse(
            "${baseUrlService.baseUrl}${ApiData.deleteEscalateJobs}$jobId"),
        headers: {
          'Authorization': "Bearer $token",
        });

    //var data = json.decode(res.body);
    if (kDebugMode) {
      print('Check Data ${res.statusCode}');
      print('Check Data ${res.body}');
    }
    statusCode = res.statusCode;
    update();
  }

  Future<void> checkEscalation(Map jobMap, String id) async {
    String token = await storage.read("AccessToken");
    s.clear();
    update();
    // Get.log('check $c');

    var name = '${storage.read("firstName")} ${storage.read("lastName")}';
    for (var e in escalation) {
      if (e['to'].toString().toLowerCase() == name.toLowerCase()) {
        isAvailable.value = true;
      } else {
        s.add(e);
      }
    }
    update();
    var res = await http.patch(
      Uri.parse(baseUrlService.baseUrl + ApiData.singleJob + id),
      body: {'escalations': json.encode(s), 'device': 'mobile'},
      headers: {
        'Authorization': "Bearer $token",
      },
    );
    tpageno.value = 1;
    // await receivedJobsList();
    await getJobs(1);
  }

  String escalationsJob(List escalationsList) {
    String c = '';
    var name = '${storage.read("id")} ${storage.read("lastName")}';
    for (int i = 0; i < escalationsList.length; i++) {
      if (escalationsList[i]['to'].toString().toLowerCase() ==
          name.toLowerCase()) {
        c = escalationsList[i]['read'].toString();
      }
    }
    return c;
  }

  // Future<void> getDeleteJob(List sharingId, String Jobid) async {
  //   isSendLoading.value = true;
  //   String token = await storage.read("AccessToken");
  //   try {
  //     for (int i = 0; i < sharingId.length; i++) {
  //       await http.patch(
  //         Uri.parse(baseUrlService.baseUrl +
  //             ApiData.deleteSharedJob + sharingId[i]['_id']),
  //         headers: {
  //           'Authorization': "Bearer $token",
  //         },
  //       );
  //     }
  //     await getSentJobs();
  //     isSendLoading.value = false;
  //   } catch (e) {
  //     isSendLoading.value = false;
  //   }
  // }

  Future<void> jobStatus(String id) async {
    String token = await storage.read("AccessToken");
    await http.post(
      Uri.parse(baseUrlService.baseUrl + ApiData.escalationsread),
      body: {'id': id},
      headers: {
        'Authorization': "Bearer $token",
      },
    );
    await getJobs(1);
    // await receivedJobsList();
    Get.delete<VideoController>();
    Get.to(
      () => const PlayerScreen(),
      arguments: {
        "id": id,
        "receiverName": "",
      },
    );
  }

  Future<void> getSingleJobForNotification(
      String jobId, String sharedId) async {
    storage.write("nId", jobId);

    try {
      String token = await storage.read("AccessToken");
      var res;
      if (sharedId != '') {
        if (kDebugMode) {
          print("-----------------------------share id is ${sharedId}");
        }

        res = await http.get(
            Uri.parse(
                '${baseUrlService.baseUrl}${isLibraryJob == "true" ? ApiData.singleLibraryJob : ApiData.singleJob}$jobId?device=mobile&sentPage=true&shareId=$sharedId'),
            headers: {
              'Authorization': "Bearer $token",
            });

        if (kDebugMode) {
          print(
              "----------------------------qurey is---${Uri.parse('${baseUrlService.baseUrl}${isLibraryJob == "true" ? ApiData.singleLibraryJob : ApiData.singleJob}$jobId?device=mobile&sentPage=true&shareId=$sharedId')}");
        }
      } else {
        res = await http.get(
            Uri.parse(
                '${baseUrlService.baseUrl}${ApiData.singleJob}$jobId?device=mobile'),
            headers: {
              'Authorization': "Bearer $token",
            });
      }
      var data = json.decode(res.body);
      if (kDebugMode) {
        print("Check Data Notification $data");
      }
      if (sharedId != '') {
        if (receivedJobsList.isEmpty) {
          receivedJobsList.add(data);
        } else {
          receivedJobsList.insert(0, data);
        }
      } else {
        var tempJobsData = [];
        if (job.isEmpty) {
          job.add(data);
          update();
        } else {
          // if (kDebugMode) {
          //   print("i am in job list not empty");
          // }
          var notificationJob = [];
          notificationJob.add(data);
          var sortedJobs = [];
          notificationJob.forEach((element) {
            sortedJobs.add(element);
          });
          job.forEach((element) {
            sortedJobs.add(element);
          });
          sortedJobs.sort((a, b) =>
              convertTimeIntoUtc(b["broadcastDate"].toString()).compareTo(
                  convertTimeIntoUtc(a["broadcastDate"].toString())));

          job.clear();
          sortedJobs.forEach((e) {
            job.add(e);
          });

          //job.insert(0, data);
          // if (kDebugMode) {
          //   print("i am in job list not empty lenght ${job.length.toString()}");
          // }

          update();
        }
        if (data["source"] == 'Ticker') {
          {
            if (tickerjob.isEmpty) {
              if (kDebugMode) {
                print("i am in ticker if check");
              }
              tickerjob.add(data);
              update();
            } else {
              if (kDebugMode) {
                print("i am in ticker else check");
              }
              var notificationJob = [];
              notificationJob.add(data);
              var sortedJobs = [];
              notificationJob.forEach((element) {
                sortedJobs.add(element);
              });
              tickerjob.forEach((element) {
                sortedJobs.add(element);
              });
              sortedJobs.sort((a, b) =>
                  convertTimeIntoUtc(b["broadcastDate"].toString()).compareTo(
                      convertTimeIntoUtc(a["broadcastDate"].toString())));

              tickerjob.clear();
              sortedJobs.forEach((e) {
                tickerjob.add(e);
              });

              //tickerjob.insert(0, data);
              update();
            }
          }
        } else if (data["source"] == 'Blog') {
          {
            if (webjob.isEmpty) {
              webjob.add(data);
              update();
            } else {
              var notificationJob = [];
              notificationJob.add(data);
              var sortedJobs = [];
              notificationJob.forEach((element) {
                sortedJobs.add(element);
              });
              webjob.forEach((element) {
                sortedJobs.add(element);
              });
              sortedJobs.sort((a, b) =>
                  convertTimeIntoUtc(b["broadcastDate"].toString()).compareTo(
                      convertTimeIntoUtc(a["broadcastDate"].toString())));

              webjob.clear();
              sortedJobs.forEach((e) {
                webjob.add(e);
              });

              // webjob.insert(0, data);
              update();
            }
          }
        } else if (data["source"] == 'Print') {
          {
            if (printjob.isEmpty) {
              printjob.add(data);
              update();
            } else {
              var notificationJob = [];
              notificationJob.add(data);
              var sortedJobs = [];
              notificationJob.forEach((element) {
                sortedJobs.add(element);
              });
              printjob.forEach((element) {
                sortedJobs.add(element);
              });
              sortedJobs.sort((a, b) =>
                  convertTimeIntoUtc(b["broadcastDate"].toString()).compareTo(
                      convertTimeIntoUtc(a["broadcastDate"].toString())));

              printjob.clear();
              sortedJobs.forEach((e) {
                printjob.add(e);
              });

              //printjob.insert(0, data);
              update();
            }
          }
        } else if (data["source"] == 'Tv') {
          {
            if (sourcejob.isEmpty) {
              sourcejob.add(data);
              update();
            } else {
              var notificationJob = [];
              notificationJob.add(data);
              var sortedJobs = [];
              notificationJob.forEach((element) {
                sortedJobs.add(element);
              });
              sourcejob.forEach((element) {
                sortedJobs.add(element);
              });
              sortedJobs.sort((a, b) =>
                  convertTimeIntoUtc(b["broadcastDate"].toString()).compareTo(
                      convertTimeIntoUtc(a["broadcastDate"].toString())));

              sourcejob.clear();
              sortedJobs.forEach((e) {
                sourcejob.add(e);
              });

              //sourcejob.insert(0, data);
              update();
            }
          }
        } else if (data["source"] == 'Online') {
          {
            if (onlinejob.isEmpty) {
              onlinejob.add(data);
              update();
            } else {
              var notificationJob = [];
              notificationJob.add(data);
              var sortedJobs = [];
              notificationJob.forEach((element) {
                sortedJobs.add(element);
              });
              onlinejob.forEach((element) {
                sortedJobs.add(element);
              });
              sortedJobs.sort((a, b) =>
                  convertTimeIntoUtc(b["broadcastDate"].toString()).compareTo(
                      convertTimeIntoUtc(a["broadcastDate"].toString())));

              onlinejob.clear();
              sortedJobs.forEach((e) {
                onlinejob.add(e);
              });

              // onlinejob.insert(0, data);
              update();
            }
          }
        } else if (data["source"] == 'Social') {
          {
            if (twitterjob.isEmpty) {
              if (kDebugMode) {
                print("i am in twitter job if");
              }
              twitterjob.add(data);
              update();
            } else {
              if (kDebugMode) {
                print("i am in twitter job else");
              }
              var notificationJob = [];
              notificationJob.add(data);
              var sortedJobs = [];
              notificationJob.forEach((element) {
                sortedJobs.add(element);
              });
              twitterjob.forEach((element) {
                sortedJobs.add(element);
              });
              sortedJobs.sort((a, b) =>
                  convertTimeIntoUtc(b["broadcastDate"].toString()).compareTo(
                      convertTimeIntoUtc(a["broadcastDate"].toString())));

              twitterjob.clear();
              sortedJobs.forEach((e) {
                twitterjob.add(e);
              });

              //twitterjob.insert(0, data);
              update();
            }
          }
        }
        storage.write("npId", jobId);
      }
    } on SocketException catch (e) {
      getSingleJob(storage.read('notificationId'));
      update();
    } catch (e) {}
  }

  bool findJob(String jobId) {
    bool v = false;
    for (var element in job) {
      if (element['id'] == jobId) {
        v = true;
      } else {
        v = false;
      }
      update();
    }
    return v;
  }

  Future<void> checkFoundJob(String jobid) async {
    for (int i = 0; i < job.length; i++) {
      if (job[i]['id'] == jobid) {
        isFound.value = true;
        update();
      }
    }
    if (isFound.value == false) {
      // await getSingleJobForNotification(jobid, '');
    }
  }

  //<------------ for Twitter content ----------->

  String content(List t) {
    List c = [];
    for (var element in t) {
      c.add(element['line']);
    }
    return c.join('');
  }

  Future<void> sharing(String jobId) async {
    Map sharedBy = {
      "id": senderId,
      "name": "$senderFirstName $senderLastName",
    };
    DateTime now = DateTime.now();
    String formatDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    Map bodyData = {
      "jobId": jobId,
      "sharedTime": formatDateTime,
      "shareType": "Full",
      "sharedBy": sharedBy,
      "sharedTo": companyUserController.sharingUser,
    };
    // Get.log("Check Sharing data $bodyData");
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
      // Get.log('Shared Job Result is $data');
      if (res.statusCode == 201) {
        // await sharing();
        companyUserController.sharingUser.clear();
        searchContact.clear();
        isLoading.value = true;
        await getSentJobs();
        isLoading.value = false;
        companyUserController.isBottomLoading.value = false;
        Get.back(closeOverlays: true);
        CustomSnackBar.showSnackBar(
            title: "Job shared successfully",
            message: "",
            isWarning: false,
            backgroundColor: CommonColor.greenColor);
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
}
