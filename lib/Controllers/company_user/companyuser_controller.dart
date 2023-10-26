// ignore_for_file: file_names, unused_catch_clause

import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lytics_lens/Services/baseurl_service.dart';
import 'package:lytics_lens/abstract/getstorage_abstract.dart';
import 'package:lytics_lens/utils/api.dart';

class CompanyUserController extends GetxController with GetxStorage {
  BaseUrlService baseUrlService = Get.find<BaseUrlService>();

  RxBool isLoading = false.obs;
  RxBool nodata = false.obs;
  RxBool isBottomLoading = false.obs;
  RxBool isEveryonePress = false.obs;

  RxList companyUser = [].obs;
  RxList searchcompanyUser = [].obs;
  RxList sharingUser = [].obs;

  TextEditingController searchContact = TextEditingController();

  @override
  Future<void> onReady() async {

    await getCompanyUser();
    isEveryonePress.value=false;
    super.onReady();
  }

  Future<void> getCompanyUser() async {
    try {
      String token = await storage.read("AccessToken");
      String id = await storage.read('company_id');
      update();
      var res = await http.get(
          Uri.parse(baseUrlService.baseUrl + ApiData.companyuser + id),
          headers: {
            'Authorization': "Bearer $token",
          });
      var data = json.decode(res.body);
     // Get.log("Company Data $data");
      data['users'].forEach((e) {
        companyUser.add(e);
      });
    } on SocketException catch (e) {
      isLoading.value = false;
      update();
    } catch (e) {
      isLoading.value = false;
      update();
    }
  }

  searchUserFunction(String v) {
    nodata.value = false;
    if (v.isEmpty || v == '') {
      searchcompanyUser.clear();
    } else {
      searchcompanyUser.clear();
      for (var e in companyUser) {
        if (e['firstName'].toString().toLowerCase().contains(v.toLowerCase())) {
          searchcompanyUser.add(e);
        } else if (e['lastName']
            .toString()
            .toLowerCase()
            .contains(v.toLowerCase())) {
          searchcompanyUser.add(e);
        } else if (e['firstName']
                .toString()
                .toLowerCase()
                .contains(v.split(' ').first.toLowerCase()) &&
            e['lastName']
                .toString()
                .toLowerCase()
                .contains(v.split(' ').last.toLowerCase())) {
          searchcompanyUser.add(e);
        }
      }
      if (searchcompanyUser.isEmpty) {
        nodata.value = true;
      }
    }
  }

  String namesSplit(String n) {
    var f = n.split(' ').first;
    var l = n.split(' ').last;
    return '${f[0]} ${l[0]}';
  }

  String addDataList(String id) {
    var r = sharingUser.firstWhere((element) => element['id'] == id,
        orElse: () => {'id': 'nofound'});
    return r['id'];
  }

  void deletedata(String id) {
    sharingUser.removeWhere((element) => element['id'] == id);
  }
}
