import 'dart:convert';

PicksModel picksModelFromJson(String str) => PicksModel.fromJson(json.decode(str));

class PicksModel {
  PicksModel({
    required this.picks,
  });

  List<Pick>? picks;

  factory PicksModel.fromJson(Map<String, dynamic> json) => PicksModel(
    picks: List<Pick>.from(json["picks"].map((x) => Pick.fromJson(x))),
  );
}

class Pick {
  Pick({
    required this.element,
    required this.isCaptain,
  });

  int? element;
  bool? isCaptain;

  Pick.fromJson(Map<String, dynamic> json){
    element = json["element"];
    isCaptain = json["is_captain"];
  }
}
