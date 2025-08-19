import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pl_fantasy_online/base/custom_loader.dart';
import 'package:pl_fantasy_online/controllers/dream_team_controller.dart';
import 'package:pl_fantasy_online/controllers/event_status_controller.dart';
import 'package:pl_fantasy_online/controllers/fixture_controller.dart';
import 'package:pl_fantasy_online/controllers/upcoming_fixture_controller.dart';
import 'package:pl_fantasy_online/helpers/route_helper.dart';
import 'package:pl_fantasy_online/utils/app_constants.dart';
import 'package:pl_fantasy_online/utils/colors.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final InternetConnectionChecker _net = InternetConnectionChecker.instance;

  late String token;
  List<int?>? eventStatusList;
  EventStatusController eventStatusController =
      Get.put(EventStatusController());
  late String gameWeek;

  Future<void> hasConnection() async {
    bool result = await _net.hasConnection;
    if (result == true && token != "") {
      Get.offAndToNamed(RouteHelper.getInitial());
    } else {
      Get.offAndToNamed(RouteHelper.getOfflinePage());
    }
  }

  // Future<void> hasNetwork() async {
  //   try {
  //     var gameWeek = (eventStatusList?.first).toString();
  //     final result = await http.get(Uri.parse('www.example.com'));
  //     if(result.statusCode==200&& gameWeek != "null" && token != ""){
  //       Future.delayed(const Duration(seconds: 3), () async{
  //         Get.offAndToNamed(RouteHelper.getInitial());
  //       });
  //     }
  //     else{
  //       Future.delayed(const Duration(seconds: 4), () async{
  //         Get.offAndToNamed(RouteHelper.getOfflinePage());
  //       });
  //     }
  //   }
  //   on SocketException catch (_) {
  //     Future.delayed(const Duration(seconds: 4), () async{
  //       Get.offAndToNamed(RouteHelper.getOfflinePage());
  //     });
  //   }
  // }

  Future getToken() async {
    var collection = FirebaseFirestore.instance.collection('paystack');
    var docSnapshot = await collection.doc('details').get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      try {
        token = data?['secret_key'];
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    token = "";
    gameWeek = "";
    eventStatusList = eventStatusController.eventStatusModel?.status!
        .map((info) => info.event)
        .toList();

    Future.delayed(const Duration(seconds: 4), () async {
      gameWeek = (eventStatusList?.first).toString();
    }).then((value) => setState(() {
          if (gameWeek != "") {
            getToken().then((_) => hasConnection());
          } else {
            Get.offAndToNamed(RouteHelper.getOfflinePage());
          }
        }));

    Get.put(FixtureController());
    Get.put(UpcomingFixtureController());
    Get.put(DreamTeamController());
    AppConstants().firebaseGetData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
              AppColors.gradientOne,
              AppColors.gradientTwo,
            ])),
        child: const Scaffold(
            backgroundColor: Colors.transparent, body: CustomLoader()));
  }
}
