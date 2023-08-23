import 'dart:convert';

DreamTeamModel dreamTeamFromJson(String str) => DreamTeamModel.fromJson(json.decode(str));

class DreamTeamModel {
  DreamTeamModel({
    required this.team,
  });

  List<Team>? team;

  factory DreamTeamModel.fromJson(Map<String, dynamic> json) => DreamTeamModel(
    team: List<Team>.from(json["team"].map((x) => Team.fromJson(x))),
  );
}

class Team {
  Team({
    required this.element,
    required this.points,
    required this.position,
  });

  int? element;
  int? points;
  int? position;

  Team.fromJson(Map<String, dynamic> json){
    element = json["element"];
    points = json["points"];
    position = json["position"];
  }
}
