// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:lytics_lens/abstract/getstorage_abstract.dart';

class NotificationController extends GetxController with GetxStorage {
  bool isLoading = true;
  List notificationsList = [];
  bool status = false;
  bool status2 = false;
  bool status3 = false;
  bool status4 = false;

  static CollectionReference notifications =
      FirebaseFirestore.instance.collection('Notifications');

  @override
  void onReady() async {
    await getNotificationData();
    isLoading = false;
    update();
    super.onReady();
  }

  Future<void> getNotificationData() async {
    notificationsList.clear();
    var data = await notifications.get();
    for (var element in data.docs) {
      notificationsList.add(element.data());
    }
    update();
  }

  Future<void> getUpdateValue(String docId, bool v) async {
    await notifications.doc(docId).update({'isShow': v});
  }
}
