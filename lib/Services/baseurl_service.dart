import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class BaseUrlService extends GetxService {
  final storage = GetStorage();
  String baseUrl = '';

  Future<BaseUrlService> init() async {
    await isBaseUrlCheck();
    return this;
  }

  Future<String> isBaseUrlCheck() async {
    if (storage.hasData("Url")) {
      baseUrl = storage.read("Url");
    } else {
      baseUrl = 'https://backend.lytics.systems';
    }
    if (kDebugMode) {
      print("Base-Url $baseUrl");
    }
    return baseUrl;
  }
}
