import 'package:get/get.dart';

class CheckYourMailController extends GetxController {
  bool isLoading = true;

  @override
  void onReady() async {
    isLoading = false;
    update();
    super.onReady();
  }
}
