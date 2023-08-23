import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pl_fantasy_online/controllers/event_status_controller.dart';
import 'package:pl_fantasy_online/models/dream_team_model.dart';

class DreamTeamController extends GetxController{
  var isLoading = false.obs;
  DreamTeamModel? _dreamTeamModel;
  DreamTeamModel? get dreamTeamModel => _dreamTeamModel;

  List<int?>? eventStatusList;
  EventStatusController eventStatusController = Get.put(EventStatusController());

  @override
  Future<void> onInit()async{
    super.onInit();
    isLoading(true);
    fetchData();
  }

  fetchData()async{
      try{
        eventStatusList = eventStatusController.eventStatusModel?.status!.map((info) => info.event).toList();
        var gameWeek = (eventStatusList!.first).toString();
        isLoading(true);
        http.Response response = await http.get(Uri.tryParse(
            "https://fantasy.premierleague.com/api/dream-team/$gameWeek/"
        )!);
        if(response.statusCode == 200){
          var result = jsonDecode(response.body);
          _dreamTeamModel = DreamTeamModel.fromJson(result);
          isLoading(false);
        }else{
          //isLoading(true);
          debugPrint("Error fetching data");
        }
      }catch(e){
        isLoading(true);
        debugPrint("Error $e getting while fetching data");
      }
  }

}