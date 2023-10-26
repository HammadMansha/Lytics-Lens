import 'package:get/get.dart';

class ChannelModel2 {
  String? id;
  String? name;
  String? type;
  var check = false.obs;

  ChannelModel2({
    this.id,
    this.name,
    this.type,
  });

  factory ChannelModel2.fromJSON(Map<String, dynamic> json) => ChannelModel2(
        id: json['id'],
        name: json['name'],
        type: json['type'],
      );
}

class ChannelModel3 {
  String? id;
  String? name;
  String? type;
  var check = false.obs;

  ChannelModel3({
    this.id,
    this.name,
    this.type,
  });

  factory ChannelModel3.fromJSON(Map<String, dynamic> json) => ChannelModel3(
        id: json['id'],
        name: json['name'],
        type: json['type'],
      );
}
