import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pl_fantasy_online/models/event_status_model.dart';

class EventStatusController extends GetxController{
  var isLoading = false.obs;
  EventStatusModel? _eventStatusModel;
  EventStatusModel? get eventStatusModel => _eventStatusModel;


  @override
  Future<void> onInit()async{
    super.onInit();
    fetchData();
  }

  fetchData()async{
    try{
      isLoading(true);
      http.Response response = await http.get(Uri.tryParse(
          "https://fantasy.premierleague.com/api/event-status/"
      )!);
      if(response.statusCode == 200){
        var result = jsonDecode(response.body);
        _eventStatusModel = EventStatusModel.fromJson(result);
      }else{
        debugPrint("Error fetching data");
      }
    }catch(e){
      debugPrint("Error $e getting while fetching data");
    }finally{
      isLoading(false);
    }
  }

}