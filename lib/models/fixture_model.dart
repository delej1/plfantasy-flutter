import 'dart:convert';

FixtureModel fixtureModelFromJson(String str) => FixtureModel.fromJson(json.decode(str));

class FixtureModel {
  FixtureModel({
    required this.fixtures,
  });

  List<Fixture>? fixtures;

  factory FixtureModel.fromJson(Map<String, dynamic> json) => FixtureModel(
    fixtures: List<Fixture>.from(json["fixtures"].map((x) => Fixture.fromJson(x))),
  );
}

class Fixture {
  Fixture({
    required this.kickoffTime,
    required this.teamA,
    required this.teamH,
    this.teamAScore,
    this.teamHScore,
  });

  DateTime? kickoffTime;
  int? teamA;
  int? teamH;
  int? teamAScore;
  int? teamHScore;

  Fixture.fromJson(Map<String, dynamic> json){
    kickoffTime = DateTime.parse(json["kickoff_time"]);
    teamA = json["team_a"];
    teamH = json["team_h"];
    teamAScore = json["team_a_score"];
    teamHScore = json["team_h_score"];
  }
}
