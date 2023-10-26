// ignore_for_file: unused_catch_clause

import 'dart:convert';
import 'dart:io';
import 'package:change_case/change_case.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lytics_lens/Constants/common_color.dart';
import 'package:lytics_lens/Controllers/company_user/companyUser_controller.dart';
import 'package:lytics_lens/Controllers/home_controller.dart';
import 'package:lytics_lens/Controllers/playerController.dart';
import 'package:lytics_lens/Controllers/searchScreen_controller.dart';
import 'package:lytics_lens/Models/alltopicmodel.dart';
import 'package:lytics_lens/Models/channelmodel.dart';
import 'package:lytics_lens/Models/datesmodel1.dart';
import 'package:lytics_lens/Views/player_Screen.dart';
import 'package:lytics_lens/abstract/getstorage_abstract.dart';
import 'package:lytics_lens/utils/api.dart';
import 'package:lytics_lens/views/Search_Screen.dart';
import 'package:lytics_lens/widget/snackbar/common_snackbar.dart';
import 'package:path_provider/path_provider.dart';

import '../Models/channel.dart';
import '../Models/guestmodel.dart';
import '../Models/hostmodel.dart';
import '../Models/programtypemodel.dart';
import '../Services/baseurl_service.dart';
import '../widget/multiselectDropdown/utils/multi_select_item.dart';

class SearchBarController extends GetxController with GetxStorage {
  RxBool isLoading = true.obs;
  String newString = '';
  int daysDiff=0;

  BaseUrlService baseUrlService = Get.find<BaseUrlService>();
  CompanyUserController companyUserController =
      Get.find<CompanyUserController>();
  HomeScreenController homeScreenController = Get.find<HomeScreenController>();

  List headlinelist = [];

  List allData = [];
  List topic2allData = [];

  List topiclist = [];
  List topic2list = [];
  List topic3list = [];
  List<AllTopicModel> alltopic = [];

  List searchtopiclist = [];

  Rx<TextEditingController> searchText = TextEditingController().obs;

  bool isShowList = false;
  bool isHeadline = false;
  bool isSocket = false;

  // <-------------------- Filter ------------------------>

  List listofRamdomNo = [];

  var isSocketError = false.obs;

  // <----------- Filter Data ----------->

  var filterChannelList = [].obs;
  RxList filterProgramType = [].obs;

  // List<String> filterHost = [];

  // List<String> filterGuests = [];
  List clist = [];
  List uniquechanellist = [];
  List cchannellist = [];

  List programList = [];
  List programTypeList = [];
  List uniqueProgramList = [];

  List aList = [];
  List uniqueanchorlist = [];
  List anchorlistonly = [];

  List gList = [];
  List uniqueguestsList = [];
  List guestListonly = [];

  var isMore = false.obs;
  var totalPages = 0.obs;
  var pageno = 1.obs;
  var tpageno = 1.obs;
  var job = [].obs;
  DateTime now = DateTime.now();

  //<----------------------------------->

  var searchjob = [].obs;

  var filterlist = [].obs;
  List programTypefilterdata = [];


  var filterSourceList = [].obs;

  List sourcelist = [];
  List<SourceTypeModel> sourceModelList = [];

  var selectformDate = DateTime.now().obs;
  var selecttoDate = DateTime.now().obs;

  RegExp stringvalidate = RegExp(r'^[a-zA-Z0-9&| ]+$');

  Rx<TextEditingController> lastSearchText = TextEditingController().obs;

  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController(
      text:
          '${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}');

  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();

  Rx<TextEditingController> guestselect = TextEditingController().obs;
  Rx<TextEditingController> hostselect = TextEditingController().obs;

  DateTime selectedDays = DateTime.now();
  TimeOfDay prviousDays = TimeOfDay.now();

  var dateFormat = DateFormat("h:mm a");

  static CollectionReference headline =
      FirebaseFirestore.instance.collection('Headline');

  Rx<TextEditingController> searchdata = TextEditingController().obs;

//<------ Instance variable
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // <------------- Filer Data ------------------>
  List<ChannelModel> channellist = [];
  List<HostModel> hostList = [];
  List<GuestModel> guestModelList = [];
  var filterHost = [].obs;
  var filterGuests = [].obs;

  List<String> channellistonly = [];
  List<ProgramTypeModel> programType = [];

  List<String> selectedchannel = [];
  List<String> anchorList = [];
  List<String> guestsList = [];

  List jobsdate = [];

  // List topiclist = [];

  List<Channel> channels = [];
  List allChannels = [];

  List<MultiSelectItem<Channel>> item = [];

  List<Channel> selectedChannels = [];

  List<dynamic> checkNames = [];

  String senderId = '';
  String senderFirstName = '';
  String senderLastName = '';

  // ----------------------- Date variables-----------------------

  String searchStartDate = '';
  String searchEndDate = '';

  // DateTime now = DateTime.now();
  List datelist = [];

  DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
  DateTime week = DateTime.now().subtract(const Duration(days: 6));
  DateTime quarter = DateTime.now().subtract(const Duration(days: 15));

  // TextEditingController startSearchDate = TextEditingController();
  // TextEditingController endSearchDate = TextEditingController();
  List<DatesModel1> alldatelist1 = [];

  //-------------------Filters bool veriables-------------
  bool searchContentTypeSelect = false;
  bool searchChannelSelect = false;
  bool searchStartDateSelect = false;
  bool searchEndDateSelect = false;
  bool searchHostSelect = false;
  bool searchGuestSelect = false;
  DateTime? endData;
  DateTime? startData;

  List responseprogramtyperesult = [];
  List responseprogramlist = [];

  var isJobRead=false.obs;

  RxBool downloadLoader=false.obs;
  late String localPath;
  String transcription='';
  String source='';
  String channelName='';

  @override
  Future<void> onInit() async {
    DateTime searchDate = DateTime.now().subtract(const Duration(days: 1));
    startDate.text = searchDate.toString().split(" ").first;
    endDate.text = DateTime.now().toString().split(" ").first;
    
    if (kDebugMode) {
      print("default data ${startDate.text}");
      print("default end data ${endDate.text}");
    }
    for (var e in sourcelist) {
      sourceModelList.add(SourceTypeModel.fromJSON(e));
    }
    for (var element in sourceModelList) {
      if (element.name == 'All') {
        element.check.value = true;
      }
    }
    sourcelist = [
      {
        "name": "All",
      },
      {
        "name": "Tv",
      },
      {
        "name": "Online",
      },
      {
        "name": "Print",
      },
      {
        "name": "Blog",
      },
      {
        "name": "Social",
      },
      {
        "name": "Ticker",
      },
    ];

    for (var e in sourcelist) {
      sourceModelList.add(SourceTypeModel.fromJSON(e));
    }
    for (var element in sourceModelList) {
      if (element.name == 'All') {
        element.check.value = true;
      }
    }
    await gettopic();

    allChannels.add('All Channels');
    update();
    cchannellist.add({
      'id': 'all',
      'name': 'All Channels',
      'source': '',
    });
    channellistonly.add('All Channels');
    selectedchannel.add('All Channels');
    update();
    storage.read('UsersChannels').forEach((e) {
      if (e.toString().isLowerCase == 'all') {
      } else {
        allChannels.add(e);
        channellistonly.add(e);
        filterChannelList.add(e.toString().split('|').first.trim());
        cchannellist.add({
          'id': e,
          'name': e.toString().split('|').first.trim(),
          'source': e.toString().split('|').last.trim()
        });
      }
    });

    for (var element in cchannellist) {
      channellist.add(ChannelModel.fromJSON(element));
    }
    update();

    filterlist.clear();
    filterlist.add('All Channels');
    filterlist.add('All');
    // filterChannelList.add('All Channels');
    for (var element in channellist) {
      if (element.name == 'All Channels') {
        element.check.value = true;
      }
    }

    // Channel For BottomSheet
    for (int i = 1; i < allChannels.length; i++) {
      channels.add(Channel(id: i, name: allChannels[i]));
    }
    update();
    item = channels.map((e) => MultiSelectItem<Channel>(e, e.name!)).toList();

    getdates();
    getProgramType();
    getAllHost();
    getAllGuest();
    super.onInit();
  }

  @override
  void onReady() async {
    isLoading.value = false;
    senderId = await storage.read('id');
    senderFirstName = await storage.read('firstName');
    senderLastName = await storage.read('lastName');
    getHeadlines();
    update();
    super.onReady();
  }


  Future<void> downloadImage(String thumbnailPath) async {
    downloadLoader.value = true;
    update();

    try {
      final http.Response response = await http.get(Uri.parse(thumbnailPath));
      final Directory directory = await getApplicationDocumentsDirectory();
      localPath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
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

  //------------Get all hosts-------





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
        hostList.add(HostModel.fromJSON(element));
      }
      update();
    } on SocketException {
      isLoading.value = false;
      update();
      isSocket = true;
      update();
    }
  }
  String convertTimeIntoUtc(String time){
    final dateTime=DateTime.parse(time).toUtc();
    final timeFormat=DateFormat('HH:mm');
    final utcTime=timeFormat.format(dateTime.add(Duration(hours: 0)));

    return formatTime(utcTime);
  }
  String formatTime(String time){
    final parseTime=DateFormat('HH:mm').parse(time);
    return DateFormat('h:mm a').format(parseTime);
  }

  //-------------Get all program types----------
  Future<void> getProgramType() async {
    responseprogramtyperesult.clear();
    responseprogramlist.clear();
    programType.clear();
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
          filterlist.add(element['name']);
          programTypefilterdata
              .add({'id': element['name'], 'name': element['name']});
        }
        // programTypesList.add({"id": element['name'], "name": element['name']});
      }
      update();
      for (var element in responseprogramlist) {
        programType.add(ProgramTypeModel.fromJSON(element));
      }
      update();
    } on SocketException {
      isLoading.value = false;
      update();
      isSocket = true;
      update();
    } catch (e) {
      isLoading.value = false;
      update();
    }
  }


  //------------Get all guests----------------
  Future<void> getAllGuest() async {
    List allGuests = [];
    guestsList.clear();
    List aGuest = [];
    List guest = [];
    update();
    try {
      String token = await storage.read("AccessToken");
      var res = await http
          .get(Uri.parse(baseUrlService.baseUrl + ApiData.guest), headers: {
        'Authorization': 'Bearer $token',
      });
      var response = json.decode(res.body);
      allGuests.addAll(response['results']);

      for (var e in allGuests) {
        aGuest.add(e['name']);
      }
      aGuest = Set.of(aGuest).toList();
      for (var e in aGuest) {
        guestsList.add(e);
      }
      guestsList.sort((a, b) => a.toString().compareTo(b.toString()));

      for (var e in guestsList) {
        guest.add({
          "id": e,
          "name": e,
        });
      }

      for (var element in guest) {
        guestModelList.add(GuestModel.fromJSON(element));
      }
      update();
    } on SocketException {
      isLoading.value = false;
      update();
      isSocket = true;
      update();
    }
  }




  void getdates() {
    alldatelist1.clear();
    update();
    for (var element in datelist) {
      alldatelist1.add(DatesModel1.fromJSON(element));
    }
    update();
  }

  Future<void> getFilterJobs(String searchText, int p) async {
    if (searchText.contains('&') == true) {
      //Get.log("---------------------11$searchText");
      searchText = searchText.replaceAll('&', '%26');
     // Get.log("---------------------12$searchText");
    } else if (searchText.contains('||') == true) {
      searchText = searchText.replaceAll('||', '%20');
      //Get.log("---------------------12$searchText");
    } else if (searchText.contains('||') && searchText.contains('&')) {
      searchText = searchText.replaceAll('||', '%20');
      searchText = searchText.replaceAll('&', '%26');
    }

    isSocketError.value = false;
    bool searchValid = RegExp(r'^[a-zA-Z]*$').hasMatch(searchText);
    if (searchText.isEmpty || searchText == '') {
      newString = lastSearchText.value.text;
    }
    else {
      lastSearchText.value.text = searchText;
    }
    // lastSearchText.value.text = searchText;
    // job.clear();
    var res;
    try {
      if (p == 1) {
        tpageno.value = 1;
        var fh = json.encode(filterHost);
        var fg = json.encode(filterGuests);
        var fpt = json.encode(filterProgramType);
        // for (int i = 0; i < filterSourceList.length; i++) {
        //   Get.log("The list is $filterSourceList");
        //   if (filterSourceList[i] == 'Web') {
        //     filterSourceList[i] = 'Blog';
        //     update();
        //   }
        //   if (filterSourceList[i] == 'TV') {
        //     filterSourceList[i] = 'Tv';
        //     update();
        //   }
        //   // if (filterSourceList[i] == 'Twitter') {
        //   //   filterSourceList[i] = 'Social';
        //   //   update();
        //   // }
        //   if (filterSourceList[i] == 'Video') {
        //     if(filterSourceList[i] != 'Online'){
        //       filterSourceList[i] = 'Online';
        //
        //     }
        //     update();
        //   }
        //   Get.log("The value of list now is $filterSourceList");
        // }
        filterSourceList.toList().toSet();
        Get.log("The $filterSourceList");
        update();
        isLoading.value = true;
        job.clear();
        searchjob.clear();
        String token = await storage.read("AccessToken");

        if(kDebugMode){
          print('Check Query ${baseUrlService.baseUrl}${ApiData.jobs}?start_date=${startDate.text}&end_date=${endDate.text}&limit=30&page=$p&source=${filterSourceList.isEmpty ? 'All' : json.encode(filterSourceList.toSet().toList())}&searchText=$searchText&hosts=$fh&guest=$fg&programType=$fpt&device=mobile&channel=${json.encode(filterChannelList)}');

        }
        searchValid == true
            ? res = await http.get(
                Uri.parse(
                    '${baseUrlService.baseUrl}${ApiData.jobs}?start_date=${startDate.text}&end_date=${endDate.text}&limit=30&page=$p&source=${filterSourceList.isEmpty ? 'All' : json.encode(filterSourceList.toSet().toList())}&searchText=$searchText&hosts=$fh&guest=$fg&programType=$fpt&device=mobile&channel=${json.encode(filterChannelList)}'),
                headers: {
                    'Authorization': "Bearer $token",
                  })
            : res = await http.get(
                Uri.parse('${baseUrlService.baseUrl}${ApiData.jobs}?start_date=${startDate.text}&end_date=${endDate.text}&limit=30&page=$p&source=${filterSourceList.isEmpty ? 'All' : json.encode(filterSourceList.toSet().toList())}&searchText=$searchText&hosts=$fh&guest=$fg&programType=$fpt&device=mobile&channel=${json.encode(filterChannelList)}'),
                headers: {
                    'Authorization': "Bearer $token",
                  });

        var data = json.decode(res.body);
        searchjob.addAll(data['results']);
        Get.log("Search query result $searchjob");
        if (p == 1) {
          totalPages.value = data['totalPages'];
          update();
        }

        if(kDebugMode){
          print('Check Search Text before pagination------------ $searchText');

        }
        isLoading.value = false;

      } else {

        if(kDebugMode){
          print('Check Search text after pagination--------------------${lastSearchText.value.text}');

        }
        if (tpageno.value <= totalPages.value) {


          isMore.value = true;
          String token = await storage.read("AccessToken");
          var fh = json.encode(filterHost);
          var fg = json.encode(filterGuests);
          var fpt = json.encode(filterProgramType);
          for (int i = 0; i < filterSourceList.length; i++) {
            Get.log("The list is $filterSourceList");
            if (filterSourceList[i] == 'Web') {
              filterSourceList[i] = 'Blog';
              update();
            }
            if (filterSourceList[i] == 'Twitter') {
              filterSourceList[i] = 'Social';
              update();
            }
            Get.log("The value of list now is $filterSourceList");
          }
          filterSourceList.toSet().toList();
          if(kDebugMode){
            print("The value in list after pagination-------- $filterSourceList");

          }
          if(kDebugMode){
            print('Check Query after pagination------------ ${baseUrlService.baseUrl}${ApiData.jobs}?start_date=${startDate.text}&end_date=${endDate.text}&limit=30&page=$p&source=${filterSourceList.isEmpty ? 'All' : json.encode(filterSourceList.toSet().toList())}&searchText=${lastSearchText.value.text}&hosts=$fh&guest=$fg&programType=$fpt&device=mobile&channel=${json.encode(filterChannelList)}');

          }

          searchValid == true
              ? res = await http.get(
                  Uri.parse(
                      '${baseUrlService.baseUrl}${ApiData.jobs}?start_date=${startDate.text}&end_date=${endDate.text}&limit=30&page=$p&source=${filterSourceList.isEmpty ? 'All' : json.encode(filterSourceList.toSet().toList())}&searchText=${lastSearchText.value.text}&hosts=$fh&guest=$fg&programType=$fpt&device=mobile&channel=${json.encode(filterChannelList)}'),
                  headers: {
                      'Authorization': "Bearer $token",
                    })
              : res = await http.get(
                  Uri.parse(
                      '${baseUrlService.baseUrl}${ApiData.jobs}?start_date=${startDate.text}&end_date=${endDate.text}&limit=30&page=$p&source=${filterSourceList.isEmpty ? 'All' : json.encode(filterSourceList.toSet().toList())}&searchText=${lastSearchText.value.text}&hosts=$fh&guest=$fg&programType=$fpt&device=mobile&channel=${json.encode(filterChannelList)}'),
                  headers: {
                      'Authorization': "Bearer $token",
                    });
          var data = json.decode(res.body);
          // debugPrint('Search Data $data');
          // print('chanels ${data['results'][0]['channel']}');
          searchjob.addAll(data['results']);
          // searchjob
          //     .sort((b, a) => a["programDate"].compareTo(b["programDate"]));

          // if (p == 1) {
          //   totalPages = data['totalPages'];
          //   update();
          // }
          isLoading.value = false;
          isMore.value = false;
        }
        else {
          isMore.value = false;
        }
      }
    } on SocketException {
      isLoading.value = false;
      isSocketError.value = true;
      // CustomSnackBar.showSnackBar(
      //     title: AppStrings.unable,
      //     message: "",
      //     backgroundColor: CommonColor.snackbarColour);
    } catch (e) {
      isLoading.value = false;
      // Get.snackbar("Error", e.toString(), backgroundColor: Colors.red);
    }
  }

  searchFunction(String v) {
    searchtopiclist.clear();
    for (var e in topiclist) {
      if (e['name'].toString().toLowerCase().contains(v.toLowerCase())) {
        searchtopiclist.add(e);
      }
      update();
    }
  }

  Future<void> getHeadlines() async {
    isHeadline = true;
    headlinelist.clear();
    update();
    try {
      Stream<QuerySnapshot> data = headline.snapshots();
      await data.forEach((e) {
        headlinelist.clear();
        for (var value in e.docs) {
          headlinelist.add(value.data());
        }
        isHeadline = false;
        update();
      }).catchError((e) {
        // CustomSnackBar.showSnackBar(title: AppStrings.unable, message: "", backgroundColor: Color(0xff48beeb));
      });
    } on FirebaseException catch (e) {
      // CustomSnackBar.showSnackBar(title: AppStrings.unable, message: "", backgroundColor: Color(0xff48beeb));
    }
  }

  Future<void> gettopic() async {
    try {
      isSocket = false;
      update();
      String token = await storage.read("AccessToken");
      var res = await http
          .get(Uri.parse(baseUrlService.baseUrl + ApiData.topic), headers: {
        'Authorization': "Bearer $token",
      });
      var data = json.decode(res.body);
      //Get.log('Data is $data');
      // print('Data is $data');
      allData.addAll(data['results']);
      update();
      for (var e in allData) {
        topiclist.add({'id': e['name'], 'name': e['name']});
        e['topic2'].forEach((a) {
          topic2allData.add(a);
        });
      }
      update();
      for (var element in topic2allData) {
        topiclist.add({'id': element['name'], 'name': element['name']});
        element['topic3'].forEach((a) {
          topic3list.add(a);
        });
      }
      update();
      for (var q in topic3list) {
        topiclist.add({'id': q['name'], 'name': q['name']});
      }
      update();
      topiclist = Set.of(topiclist).toList();
      update();
      for (var w in topiclist) {
        alltopic.add(AllTopicModel.fromJSON(w));
      }
      update();
    } on SocketException catch (e) {
      isLoading.value = false;
      isSocket = true;
      update();
      // CustomSnackBar.showSnackBar(
      //     title: AppStrings.unable,
      //     message: "",
      //     backgroundColor: Color(0xff48beeb),isWarning: true);
    } catch (e) {
      isLoading.value = false;
      update();
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

  String convertTime(String time) {
    var dateList = time.split(" ").first;

    return dateList;
  }

  int generateRandomNumber(int i) {
    // int  c = i + ;
    int c = 0;
    for (var element in listofRamdomNo) {
      if (element['id'] == i) {
        c = element['value'];
      }
    }
    return c;
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
      } else {
        isAvailable = false;
        update();
      }
      update();
    }
  }

  void addGuestsdata() {
    if (guestselect.value.text != "0") {
      bool isAvailable = false;
      for (var element in filterlist) {
        if (element == guestselect.value.text) {
          isAvailable = true;
          update();
        }
      }
      if (isAvailable == false) {
        filterlist.add(guestselect.value.text);
      } else {
        isAvailable = false;
        update();
      }
      update();
    }
  }

  void deleteChannelFromFilter(String f) {
    if (f == 'All Channels') {
    } else {
      for (var r in channellist) {
        if (r.name == f) {
          r.check.value = false;
          filterChannelList.remove(f);
          filterlist.remove(f);
        }
      }
      if (filterChannelList.isEmpty) {
        for (var w in channellist) {
          if (w.name == 'All Channels') {
            filterlist.add(w.name);
            w.check.value = true;
          } else {
            filterChannelList.add(w.name);
          }
        }
      }
    }
  }

  void deleteData(String c) {
    for (int i = 0; i < channellist.length; i++) {
      if (channellist[i].name.toString() == c) {
        filterChannelList.removeWhere((element) => element == c);
        channellist[i].check.value = false;
        update();
      }
    }
    for (int i = 0; i < programType.length; i++) {
      if (programType[i].name.toString() == c) {
        filterProgramType.removeWhere((element) => element == c);
        programType[i].check.value = false;
        update();
      }
    }
  }

  String getTopicString(List segment) {
    List topic2 = [];
    List topic3 = [];

    String topic2string = "";
    String topic3string = "";

    String topic = "";

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

  String getGuestsString(List guest) {
    List allguest = [];
    for (var element in guest) {
      allguest.add(element['name']);
    }
    return allguest.join(', ');
  }

  // FOR REad UnReAD

  bool escalations(List escalationsList) {
    bool isRead = false;
    var name = '${storage.read("firstName")} ${storage.read("lastName")}';
    for (var e in escalationsList) {
      if (e['to'].toString().toLowerCase() == name.toLowerCase()) {
        isRead = true;
      } else {
        isRead = false;
      }
    }
    return isRead;
  }

  String escalationsJob(List escalationsList) {
    String c = '';
    var name = '${storage.read("firstName")} ${storage.read("lastName")}';
    for (int i = 0; i < escalationsList.length; i++) {
      if (escalationsList[i]['to'].toString().toLowerCase() == name.toLowerCase()) {
        c = escalationsList[i]['read'].toString();
      }
    }
    return c;
  }

  Future<void> jobStatus(String id, String imageUrl) async {
    String token = await storage.read("AccessToken");

    await http.post(
      Uri.parse(baseUrlService.baseUrl + ApiData.escalationsread),
      body: {'id': id},
      headers: {
        'Authorization': "Bearer $token",
      },
    );

    await getFilterJobs(lastSearchText.value.text, 1);
    Get.delete<VideoController>();
    Get.to(
      () => const PlayerScreen(),
      arguments: {"id": id,
        "receiverName":"",
      },
    );
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
        // await sharing();
        companyUserController.sharingUser.clear();
        companyUserController.searchContact.clear();
        homeScreenController.isLoading.value = true;
        await homeScreenController.getSentJobs();
        homeScreenController.isLoading.value = false;
        companyUserController.isBottomLoading.value = false;
        Get.back();
        // Get.back(closeOverlays: true);
        CustomSnackBar.showSnackBar(
          title: "Job shared successfully",
          message: "",
          isWarning: false,
          backgroundColor: CommonColor.greenColor,
        );
      } else {
        companyUserController.isBottomLoading.value = false;
      }
    } on SocketException {
      companyUserController.isBottomLoading.value = false;
      update();
    } catch (e) {
      companyUserController.isBottomLoading.value = false;
      update();
    }
  }

  // Search Host in List

  String checkList(String name) {
    var r = filterHost.firstWhere((e) => e == name, orElse: () => 'not found');
    return r;
  }

  String checkGuestList(String name) {
    var r =
        filterGuests.firstWhere((e) => e == name, orElse: () => 'not found');
    return r;
  }

  void showCalendar(BuildContext context) {
    return showCustomDateRangePicker(
      fontFamily: 'Roboto',
      primaryColor: Colors.transparent,
      backgroundColor: Colors.green,
      context,
      dismissible: true,
      minimumDate: DateTime(1947,01,01),
      maximumDate: DateTime.now(),
      endDate: endData,
      startDate: startData,
      onApplyClick: (start, end) {
        endData = end;
        startData = start;

        startDate.text = startData.toString().split(" ").first;
        endDate.text = endData.toString().split(" ").first;
        if (kDebugMode) {
          print("Start date ${startDate.text}");
          print("End date ${endDate.text}");
        }
        daysDiff= endData!.difference(startData!).inDays;
        Get.log("date differenceeeeeeeee ${daysDiff.toString()}");
        update();
      },
      onCancelClick: () {
        endData = null;
        startData = null;
        update();
      },
    );
  }

    String content(List t) {
    List c = [];
    for (var element in t) {
      c.add(element['line']);
    }
    return c.join('. ');
  }

}
