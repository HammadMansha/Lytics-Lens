import 'package:get/get.dart';

class ChannelModel {
  String? id;
  String? name;
  String? source;
  var check = false.obs;

  ChannelModel({this.id, this.name, this.source});

  factory ChannelModel.fromJSON(Map<String, dynamic> json) =>
      ChannelModel(id: json['id'], name: json['name'], source: json['source']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'source': source,
      };
}

class SourceTypeModel {
  String? name;
  var check = false.obs;

  SourceTypeModel({
    this.name,
  });

  factory SourceTypeModel.fromJSON(Map<String, dynamic> json) =>
      SourceTypeModel(
        name: json['name'],
      );
}
