import 'dart:convert';

GeneralModel generalModelFromJson(String str) => GeneralModel.fromJson(json.decode(str));

class GeneralModel {
  GeneralModel({
    required this.elements,
    required this.teams,
  });

  List<Element>? elements;
  List<Team>? teams;

  factory GeneralModel.fromJson(Map<String, dynamic> json) => GeneralModel(
    elements: List<Element>.from(json["elements"].map((x) => Element.fromJson(x))).toList(),
    teams: List<Team>.from(json["teams"].map((x) => Team.fromJson(x))),
  );
}

class Element {
  Element({
    required this.id,
    required this.webName,
    required this.code,
    required this.nowCost,
    required this.team,
    required this.elementType,
    required this.eventPoints,
    required this.status,
  });

  int? id;
  String? webName;
  int? code;
  int? nowCost;
  int? team;
  int? elementType;
  int? eventPoints;
  String? status;

  Element.fromJson(Map<String, dynamic> json){
    id = json["id"];
    webName = json["web_name"];
    nowCost = json["now_cost"];
    code = json["code"];
    elementType = json["element_type"];
    team = json["team"];
    eventPoints = json["event_points"];
    status = json["status"];
  }
}
class Team {
  Team({
    required this.id,
    required this.name,
    required this.code,
  });

  int? id;
  String? name;
  int? code;

  Team.fromJson(Map<String, dynamic> json){
    id = json["id"];
    name = json["short_name"];
    code = json["code"];
  }
}