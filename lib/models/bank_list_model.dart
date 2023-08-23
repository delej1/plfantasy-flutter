import 'dart:convert';

BankListModel bankListModelFromJson(String str) => BankListModel.fromJson(json.decode(str));

class BankListModel {
  BankListModel({
    required this.data,
  });

  List<Datum>? data;

  factory BankListModel.fromJson(Map<String, dynamic> json) => BankListModel(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );
}

class Datum {
  Datum({
    required this.name,
    required this.code,
  });

  String? name;
  String? code;

  Datum.fromJson(Map<String, dynamic> json){
    name = json["name"];
    code = json["code"];
  }
}