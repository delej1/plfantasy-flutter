import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pl_fantasy_online/models/general_model.dart';

class GeneralController extends GetxController{
  var isLoading = false.obs;

  GeneralModel? _generalModel;
  GeneralModel? get generalModel => _generalModel;

  @override
  Future<void> onInit()async{
    super.onInit();
    fetchData();
  }

  fetchData()async{
    try{
      isLoading(true);
      http.Response response = await http.get(Uri.tryParse(
          "https://fantasy.premierleague.com/api/bootstrap-static/"
      )!);
      if(response.statusCode == 200){
        var result = jsonDecode(response.body);
        _generalModel = GeneralModel.fromJson(result);
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