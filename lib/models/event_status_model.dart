import 'dart:convert';

EventStatusModel eventStatusFromJson(String str) => EventStatusModel.fromJson(json.decode(str));


class EventStatusModel {
  EventStatusModel({
    required this.status,
  });

  List<Status>? status;

  factory EventStatusModel.fromJson(Map<String, dynamic> json) => EventStatusModel(
    status: List<Status>.from(json["status"].map((x) => Status.fromJson(x))),
  );
}

class Status {
  Status({
    required this.event,
    required this.bonusAdded
  });

  int? event;
  bool? bonusAdded;

  Status.fromJson(Map<String, dynamic> json) {
    event = json["event"];
    bonusAdded = json["bonus_added"];
  }

}
