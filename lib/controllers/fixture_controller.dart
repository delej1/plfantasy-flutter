import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pl_fantasy_online/controllers/event_status_controller.dart';
import 'package:pl_fantasy_online/models/fixture_model.dart';

class FixtureController extends GetxController {
  var isLoading = false.obs;
  FixtureModel? _fixtureModel;

  FixtureModel? get fixtureModel => _fixtureModel;

  List<int?>? eventStatusList;
  EventStatusController eventStatusController = Get.put(EventStatusController());


  @override
  Future<void> onInit() async {
    super.onInit();
    isLoading(true);
    fetchData();
  }

  fetchData() async {
    try {
      eventStatusList = eventStatusController.eventStatusModel?.status!.map((info) => info.event).toList();
      var gameWeek = (eventStatusList!.first).toString();
      isLoading(true);
      http.Response response = await http.get(Uri.tryParse(
          "https://fantasy.premierleague.com/api/fixtures/?event=$gameWeek"
      )!);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        Map<String, dynamic> fixtureResult = {"fixtures": result};
        _fixtureModel = FixtureModel.fromJson(fixtureResult);
      } else {
        debugPrint("Error fetching data");
      }
    } catch (e) {
      debugPrint("Error $e getting while fetching data");
    } finally {
      isLoading(false);
    }
  }
}