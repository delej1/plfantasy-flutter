import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pl_fantasy_online/controllers/event_status_controller.dart';
import 'package:pl_fantasy_online/models/picks_model.dart';

class PicksController extends GetxController {
  var isLoading = false.obs;
  PicksModel? _picksModel;

  PicksModel? get picksModel => _picksModel;

  List<int?>? eventStatusList;
  late String userFplId;

  EventStatusController eventStatusController = Get.put(EventStatusController());

  void firebaseGetData() async {
    await FirebaseFirestore.instance.collection("user_data").doc(FirebaseAuth.instance.currentUser!.uid).get().then((data){
      userFplId = data["fpl_id"];
    }).then((_) => fetchData());
  }


  @override
  Future<void> onInit() async {
    super.onInit();
    isLoading(true);
    firebaseGetData();
  }

  fetchData() async{
    try {
      eventStatusList = eventStatusController.eventStatusModel?.status!.map((info) => info.event).toList();
      var gameWeek = (eventStatusList!.first);
      isLoading(true);
      http.Response response = await http.get(Uri.tryParse(
          "https://fantasy.premierleague.com/api/entry/$userFplId/event/$gameWeek/picks/"
      )!);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        _picksModel = PicksModel.fromJson(result);
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