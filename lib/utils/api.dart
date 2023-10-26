// ignore_for_file: unnecessary_new

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../Services/baseurl_service.dart';

class ApiData {
  static const baseUrl = "https://backend.lytics.systems";

  // static const baseUrl = "http://192.168.100.227:5000";

  BaseUrlService baseUrlService = Get.find<BaseUrlService>();

  static CollectionReference forceUpdate =
      FirebaseFirestore.instance.collection('forceUpdate');

  static CollectionReference urlInfo =
      FirebaseFirestore.instance.collection('Urlinfo');

  static const login = "/auth/login";

  static const jobs = "/jobs";

  static const alertJobs = "/jobs/alertJobs";

  static const shareJobs = "/jobs/shareJob";
  static const libraryShareJobs = "/libraryJobs/shareLensLibraryJob";


  static const getSentJobs = "/jobs/getSentJobs/";

  static const getReceivedJobs = "/jobs/getReceivedJobs/";

  static const sharedJobs = "/jobs/sharedJobs/";

  static const singleJob = "/jobs/";

  static const singleLibraryJob = "/libraryJobs/";

  //---------------------Delete received Jobs-------------
  static const deleteSharedReceivedJob = "/jobs/hideReceivedJob/";
  static const deleteSharedReceivedLibraryJob = "/libraryJobs/hideReceivedLibraryJob/";

//---------------------Delete sent Jobs----------------------------
  static const deleteSharedSentJob = "/jobs/hideSentJob/";
  static const deleteSharedSentLibraryJob = "/libraryJobs/hideSentLibraryJob/";

  //----------------------Delete escalation jobs--------------
  static const deleteEscalateJobs = "/jobs/de-escalate-job/";





  static const deviceToken = "/users/deviceToken";

  static const companyuser = "/company/users/";

  static const getKeyWords = '/alarm';

  static const subscription = '/users';

  static const getUserInformation = '/users/';

  static const guestsgraph = "/analytics/guests";

  static const media = "/analytics/subTopics";

  static const channels = "/channels";

  static const programNames = "/programNames";

  static const programTypes = "/programTypes";

  static const hosts = "/hosts";

  static const guest = "/guests";

  static const topic = "/topic";

  static const logut = "/auth/logout";

  static const forgot = "/auth/forgot-password";

  static const resetpassword = "/auth/reset-password";

  static const reports = '/analytics/talkShowReport';

  final storage = new GetStorage();

  //
  // static const thumbnailPath = "${baseUrlService.baseUrl}/uploads/";
  // static const channelLogoPath = "$baseUrl/uploads//";
  static const changePassword = "/auth/change-password";

  static const escalationsread = "/jobs/updateEscalationRead";

  static const createClipJob = '/jobs/createClipJob';

  static const shareClippedJob = '/jobs/shareClippedJob';

  //----------------------force logout APIs----------
  static const cancelLogout = '/auth/concurrentLoginAttempt';



}
