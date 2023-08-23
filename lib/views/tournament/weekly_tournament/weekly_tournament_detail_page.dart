import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:pl_fantasy_online/base/custom_app_bar.dart';
import 'package:pl_fantasy_online/base/custom_snack_bar.dart';
import 'package:pl_fantasy_online/controllers/event_status_controller.dart';
import 'package:pl_fantasy_online/controllers/general_controller.dart';
import 'package:pl_fantasy_online/utils/app_constants.dart';
import 'package:pl_fantasy_online/utils/colors.dart';
import 'package:pl_fantasy_online/utils/dimensions.dart';
import 'package:pl_fantasy_online/widgets/app_text_field.dart';
import 'package:pl_fantasy_online/widgets/player.dart';
import 'package:pl_fantasy_online/widgets/sub_player.dart';

class WeeklyTournamentDetailPage extends StatefulWidget {
  const WeeklyTournamentDetailPage({Key? key}) : super(key: key);

  @override
  State<WeeklyTournamentDetailPage> createState() => _WeeklyTournamentDetailPageState();
}

class _WeeklyTournamentDetailPageState extends State<WeeklyTournamentDetailPage> {

  final FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  late Stream<DocumentSnapshot> _tokenStream;

  EventStatusController eventStatusController = Get.put(EventStatusController());
  GeneralController generalController = Get.put(GeneralController());


  List<dynamic> tournament = Get.arguments;

  late String teamName;
  late int gkData;
  late int rbData;
  late int rcbData;
  late int lcbData;
  late int lbData;
  late int rmdData;
  late int mdData;
  late int lmdData;
  late int rfwdData;
  late int fwdData;
  late int lfwdData;
  late int gkSubData;
  late int defSubData;
  late int midSubData;
  late int fwdSubData;
  late int captainData;

  int gkDataDialogue = 0;
  int rbDataDialogue = 0;
  int rcbDataDialogue = 0;
  int lcbDataDialogue = 0;
  int lbDataDialogue = 0;
  int rmdDataDialogue = 0;
  int mdDataDialogue = 0;
  int lmdDataDialogue = 0;
  int rfwdDataDialogue = 0;
  int fwdDataDialogue = 0;
  int lfwdDataDialogue = 0;
  int gkSubDataDialogue = 0;
  int defSubDataDialogue = 0;
  int midSubDataDialogue = 0;
  int fwdSubDataDialogue = 0;
  int captainDataDialogue = 0;
  bool isSubMadeDataDialogue = false;
  bool isTripleCaptainedDataDialogue = false;


  String team = "";
  int points = 0;

  int gkPoints = 0;
  int rbPoints = 0;
  int rCbPoints = 0;
  int lCbPoints = 0;
  int lbPoints = 0;
  int rMdPoints = 0;
  int mdPoints = 0;
  int lMdPoints = 0;
  int rFwdPoints = 0;
  int fwdPoints = 0;
  int lFwdPoints = 0;
  int gkSubPoints = 0;
  int defSubPoints = 0;
  int midSubPoints = 0;
  int fwdSubPoints = 0;

  late Map players;
  late Map winners;
  late List<dynamic> allPoints;
  late List<dynamic> allTeams;
  late List<dynamic> allKeys;
  late List<dynamic> allFirstPlace;
  late List<dynamic> allSecondPlace;
  late List<dynamic> allThirdPlace;

  late List<dynamic> allGk;
  late List<dynamic> allRb;
  late List<dynamic> allRcb;
  late List<dynamic> allLcb;
  late List<dynamic> allLb;
  late List<dynamic> allRmd;
  late List<dynamic> allMd;
  late List<dynamic> allLmd;
  late List<dynamic> allRfwd;
  late List<dynamic> allFwd;
  late List<dynamic> allLfwd;
  late List<dynamic> allGkSub;
  late List<dynamic> allDefSub;
  late List<dynamic> allMidSub;
  late List<dynamic> allFwdSub;
  late List<dynamic> allCaptain;
  late List<dynamic> allIsSubMade;
  late List<dynamic> allIsTripleCaptained;

  bool formOkay = false;
  late bool isBonusAdded;

  TextEditingController idController = TextEditingController();

  List<bool?>? boolEventStatusList;
  List<int?>? eventStatusList;
  List<int?>? playerPointList;
  List<int?>? idList;
  List<String?>? webNameList;
  List<int?>? photoList;

  late int gameWeek;
  late int winnersPot;
  late int adminPot;
  late bool isPaidOut;

  late String tournamentName;

  Future<void> firebaseGetData() async {
    await db.collection("user_teams").doc(auth.currentUser!.uid).get().then((data) {
      teamName = data["alias"];
      gkData = data["gk"];
      rbData = data["rb"];
      rcbData = data["rcb"];
      lcbData = data["lcb"];
      lbData = data["lb"];
      rmdData = data["rmd"];
      mdData = data["md"];
      lmdData = data["lmd"];
      rfwdData = data["rfwd"];
      fwdData = data["fwd"];
      lfwdData = data["lfwd"];
      gkSubData = data["gk_sub"];
      defSubData = data["def_sub"];
      midSubData = data["mid_sub"];
      fwdSubData = data["fwd_sub"];
      captainData = data["captain"];
    });
  }

  Future<void> firebaseGetTourneyData() async {
    try{
      await db.collection("tournaments").doc(tournament[7]).get().then((data) {
        tournamentName = data["name"];
      });
    }catch(_){showCustomSnackBar(title: "Error", "Something went wrong, refresh page.");}
  }

  void getGameWeekAndStatus() {
    idList = generalController.generalModel?.elements!.map((info) => info.id).toList();
    playerPointList = generalController.generalModel?.elements!.map((info) => info.eventPoints).toList();
    eventStatusList = eventStatusController.eventStatusModel?.status!.map((info) => info.event).toList();
    boolEventStatusList = eventStatusController.eventStatusModel?.status!.map((info) => info.bonusAdded).toList();
    webNameList = generalController.generalModel?.elements!.map((info) => info.webName).toList();
    photoList = generalController.generalModel?.elements!.map((info) => info.code).toList();
  }

  @override
  void initState() {
    super.initState();
    firebaseGetData();
    getGameWeekAndStatus();

    _tokenStream = db.collection("user_data").doc(auth.currentUser?.uid).snapshots();

    isBonusAdded = boolEventStatusList?.last ?? false;
    idController.text = "";

    gameWeek = tournament[1];
    isPaidOut = tournament[10];
    
    winners = {};
  }

  @override
  void dispose() {
    idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    players = tournament[4];

    winnersPot = ((int.parse(tournament[2])*players.length)*0.95).round();
    adminPot = ((int.parse(tournament[2])*players.length)*0.05).round();

    //pay winners
    if(gameWeek == eventStatusList?.first! && isBonusAdded && !isPaidOut){
    payFunction();
    }

    final playerPointMap = Map.fromIterables(idList ?? [], playerPointList ?? []);

    allPoints = [];allTeams = [];allKeys = [];allFirstPlace = [];allSecondPlace = [];allThirdPlace = [];
    allGk = [];allRb = [];allRcb = [];allLcb = [];allLb = [];allRmd = [];allMd = [];allLmd = [];allRfwd = [];
    allFwd = [];allLfwd = [];allGkSub = [];allDefSub = [];allMidSub = [];allFwdSub = [];allCaptain = [];
    allIsSubMade = [];allIsTripleCaptained = [];

    for (var e in players.keys) {
      var gkInt = players[e]["gk"];
      var rbInt = players[e]["rb"];
      var rcbInt = players[e]["rcb"];
      var lcbInt = players[e]["lcb"];
      var lbInt = players[e]["lb"];
      var rMdInt = players[e]["rmd"];
      var mdInt = players[e]["md"];
      var lMdInt = players[e]["lmd"];
      var rFwdInt = players[e]["rfwd"];
      var fwdInt = players[e]["fwd"];
      var lFwdInt = players[e]["lfwd"];
      var gkSubInt = players[e]["gk_sub"];
      var defSubInt = players[e]["def_sub"];
      var midSubInt = players[e]["mid_sub"];
      var fwdSubInt = players[e]["fwd_sub"];
      var captainInt = players[e]["captain"];
      bool isTripleCaptained = players[e]["is_triple_captained"];
      bool isBenchBoosted = players[e]["is_bench_boosted"];


      //adding elements of map values to list
      gkPoints = isTripleCaptained && captainInt == gkInt ? playerPointMap[gkInt] * 3 ?? 0
          : (captainInt != gkInt ? playerPointMap[gkInt] ?? 0
          : (playerPointMap[gkInt]?? 0) * 2 ?? 0);
      rbPoints = isTripleCaptained && captainInt == rbInt ? playerPointMap[rbInt] * 3 ?? 0
          : (captainInt != rbInt ? playerPointMap[rbInt] ?? 0
          : (playerPointMap[rbInt]?? 0) * 2 ?? 0);
      rCbPoints = isTripleCaptained && captainInt == rcbInt ? playerPointMap[rcbInt] * 3 ?? 0
          : (captainInt != rcbInt ? playerPointMap[rcbInt] ?? 0
          : (playerPointMap[rcbInt]?? 0) * 2 ?? 0);
      lCbPoints = isTripleCaptained && captainInt == lcbInt ? playerPointMap[lcbInt] * 3 ?? 0
          : (captainInt != lcbInt ? playerPointMap[lcbInt] ?? 0
          : (playerPointMap[lcbInt]?? 0) * 2 ?? 0);
      lbPoints = isTripleCaptained && captainInt == lbInt ? playerPointMap[lbInt] * 3 ?? 0
          : (captainInt != lbInt ? playerPointMap[lbInt] ?? 0
          : (playerPointMap[lbInt]?? 0) * 2 ?? 0);
      rMdPoints = isTripleCaptained && captainInt == rMdInt ? playerPointMap[rMdInt] * 3 ?? 0
          : (captainInt != rMdInt ? playerPointMap[rMdInt] ?? 0
          : (playerPointMap[rMdInt]?? 0) * 2 ?? 0);
      mdPoints = isTripleCaptained && captainInt == mdInt ? playerPointMap[mdInt] * 3 ?? 0
          : (captainInt != mdInt ? playerPointMap[mdInt] ?? 0
          : (playerPointMap[mdInt]?? 0) * 2 ?? 0);
      lMdPoints = isTripleCaptained && captainInt == lMdInt ? playerPointMap[lMdInt] * 3 ?? 0
          : (captainInt != lMdInt ? playerPointMap[lMdInt] ?? 0
          : (playerPointMap[lMdInt]?? 0) * 2 ?? 0);
      rFwdPoints = isTripleCaptained && captainInt == rFwdInt ? playerPointMap[rFwdInt] * 3 ?? 0
          : (captainInt != rFwdInt ? playerPointMap[rFwdInt] ?? 0
          : (playerPointMap[rFwdInt]?? 0) * 2 ?? 0);
      fwdPoints = isTripleCaptained && captainInt == fwdInt ? playerPointMap[fwdInt] * 3 ?? 0
          : (captainInt != fwdInt ? playerPointMap[fwdInt] ?? 0
          : (playerPointMap[fwdInt]?? 0) * 2 ?? 0);
      lFwdPoints = isTripleCaptained && captainInt == lFwdInt ? playerPointMap[lFwdInt] * 3 ?? 0
          : (captainInt != lFwdInt ? playerPointMap[lFwdInt] ?? 0
          : (playerPointMap[lFwdInt]?? 0) * 2 ?? 0);
      gkSubPoints = playerPointMap[gkSubInt] ?? 0;
      defSubPoints = playerPointMap[defSubInt] ?? 0;
      midSubPoints = playerPointMap[midSubInt] ?? 0;
      fwdSubPoints = playerPointMap[fwdSubInt] ?? 0;

      isBenchBoosted ? allPoints.add(gkPoints + rbPoints + rCbPoints + lCbPoints
          + lbPoints + rMdPoints + mdPoints + lMdPoints + rFwdPoints
          + fwdPoints + lFwdPoints + gkSubPoints + defSubPoints + midSubPoints +
          fwdSubPoints)
          : allPoints.add(gkPoints + rbPoints + rCbPoints + lCbPoints
          + lbPoints + rMdPoints + mdPoints + lMdPoints + rFwdPoints
          + fwdPoints + lFwdPoints);
    }
    //sort list of map values
    var sorted = (allPoints..sort()).reversed.toList();

    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  AppColors.gradientOne,
                  AppColors.gradientTwo,
                ]
            )
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: const CustomAppBar(title: "Tournament",),
            body:
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.all(Dimensions.width10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text("Team",
                              style: TextStyle(fontWeight: FontWeight.bold,
                                  color: Colors.white),),),
                            DataColumn(label: Text("Points",
                              style: TextStyle(fontWeight: FontWeight.bold,
                                  color: Colors.white),),),
                          ],
                          rows: List<DataRow>.generate(players.length, (index) {
                            //looping through player map with keys and getting & equating points to sorted list
                            for (var e in players.keys) {
                              var gkData = players[e]["gk"];
                              var rbData = players[e]["rb"];
                              var rcbData = players[e]["rcb"];
                              var lcbData = players[e]["lcb"];
                              var lbData = players[e]["lb"];
                              var rmdData = players[e]["rmd"];
                              var mdData = players[e]["md"];
                              var lmdData = players[e]["lmd"];
                              var rfwdData = players[e]["rfwd"];
                              var fwdData = players[e]["fwd"];
                              var lfwdData = players[e]["lfwd"];
                              var gkSubData = players[e]["gk_sub"];
                              var defSubData = players[e]["def_sub"];
                              var midSubData = players[e]["mid_sub"];
                              var fwdSubData = players[e]["fwd_sub"];
                              var captainData = players[e]["captain"];
                              bool isBenchBoosted = players[e]["is_bench_boosted"];
                              bool isTripleCaptained = players[e]["is_triple_captained"];

                              var gkPoints = isTripleCaptained && captainData == gkData ? (playerPointMap[gkData] ?? 0) * 3 ?? 0
                                  : (captainData != gkData ? playerPointMap[gkData] ?? 0
                                  : (playerPointMap[gkData] ?? 0) * 2 ?? 0);
                              var rbPoints = isTripleCaptained && captainData == rbData ? (playerPointMap[rbData] ?? 0) * 3 ?? 0
                                  : (captainData != rbData ? playerPointMap[rbData] ?? 0
                                  : (playerPointMap[rbData] ?? 0) * 2 ?? 0);
                              var rCbPoints = isTripleCaptained && captainData == rcbData ? (playerPointMap[rcbData] ?? 0) * 3 ?? 0
                                  : (captainData != rcbData ? playerPointMap[rcbData] ?? 0
                                  : (playerPointMap[rcbData] ?? 0) * 2 ?? 0);
                              var lCbPoints = isTripleCaptained && captainData == lcbData ? (playerPointMap[lcbData] ?? 0) * 3 ?? 0
                                  : (captainData != lcbData ? playerPointMap[lcbData] ?? 0
                                  : (playerPointMap[lcbData] ?? 0) * 2 ?? 0);
                              var lbPoints = isTripleCaptained && captainData == lbData ? (playerPointMap[lbData] ?? 0) * 3 ?? 0
                                  : (captainData != lbData ? playerPointMap[lbData] ?? 0
                                  : (playerPointMap[lbData] ?? 0) * 2 ?? 0);
                              var rMdPoints = isTripleCaptained && captainData == rmdData ? (playerPointMap[rmdData] ?? 0) * 3 ?? 0
                                  : (captainData != rmdData ? playerPointMap[rmdData] ?? 0
                                  : (playerPointMap[rmdData] ?? 0) * 2 ?? 0);
                              var mdPoints = isTripleCaptained && captainData == mdData ? (playerPointMap[mdData] ?? 0) * 3 ?? 0
                                  : (captainData != mdData ? playerPointMap[mdData] ?? 0
                                  : (playerPointMap[mdData] ?? 0) * 2 ?? 0);
                              var lMdPoints = isTripleCaptained && captainData == lmdData ? (playerPointMap[lmdData] ?? 0) * 3 ?? 0
                                  : (captainData != lmdData ? playerPointMap[lmdData] ?? 0
                                  : (playerPointMap[lmdData] ?? 0) * 2 ?? 0);
                              var rFwdPoints = isTripleCaptained && captainData == rfwdData ? (playerPointMap[rfwdData] ?? 0) * 3 ?? 0
                                  : (captainData != rfwdData ? playerPointMap[rfwdData] ?? 0
                                  : (playerPointMap[rfwdData] ?? 0) * 2 ?? 0);
                              var fwdPoints = isTripleCaptained && captainData == fwdData ? (playerPointMap[fwdData] ?? 0) * 3 ?? 0
                                  : (captainData != fwdData ? playerPointMap[fwdData] ?? 0
                                  : (playerPointMap[fwdData] ?? 0) * 2 ?? 0);
                              var lFwdPoints = isTripleCaptained && captainData == lfwdData ? (playerPointMap[lfwdData] ?? 0) * 3 ?? 0
                                  : (captainData != lfwdData ? playerPointMap[lfwdData] ?? 0
                                  : (playerPointMap[lfwdData] ?? 0) * 2 ?? 0);
                              var gkSubPoints = playerPointMap[gkSubData] ?? 0;
                              var defSubPoints = playerPointMap[defSubData] ?? 0;
                              var midSubPoints = playerPointMap[midSubData] ?? 0;
                              var fwdSubPoints = playerPointMap[fwdSubData] ?? 0;

                              points = isBenchBoosted ? gkPoints + rbPoints + rCbPoints + lCbPoints
                                  + lbPoints + rMdPoints + mdPoints +
                                  lMdPoints + rFwdPoints
                                  + fwdPoints + lFwdPoints + gkSubPoints +
                                  defSubPoints + midSubPoints + fwdSubPoints
                                  : gkPoints + rbPoints + rCbPoints + lCbPoints
                                  + lbPoints + rMdPoints + mdPoints +
                                  lMdPoints + rFwdPoints
                                  + fwdPoints + lFwdPoints;

                              if (points.isEqual(sorted[index])) {
                                team = players[e]["alias"];
                                allTeams.add(team);
                                allKeys.add(e);

                                gkDataDialogue = players[e]["gk"];
                                rbDataDialogue = players[e]["rb"];
                                rcbDataDialogue = players[e]["rcb"];
                                lcbDataDialogue = players[e]["lcb"];
                                lbDataDialogue = players[e]["lb"];
                                rmdDataDialogue = players[e]["rmd"];
                                mdDataDialogue = players[e]["md"];
                                lmdDataDialogue = players[e]["lmd"];
                                rfwdDataDialogue = players[e]["rfwd"];
                                fwdDataDialogue = players[e]["fwd"];
                                lfwdDataDialogue = players[e]["lfwd"];
                                gkSubDataDialogue = players[e]["gk_sub"];
                                defSubDataDialogue = players[e]["def_sub"];
                                midSubDataDialogue = players[e]["mid_sub"];
                                fwdSubDataDialogue = players[e]["fwd_sub"];
                                captainDataDialogue = players[e]["captain"];
                                isSubMadeDataDialogue =
                                players[e]["is_sub_made"];
                                isTripleCaptainedDataDialogue =
                                players[e]["is_triple_captained"];

                                allGk.add(gkDataDialogue);
                                allRb.add(rbDataDialogue);
                                allRcb.add(rcbDataDialogue);
                                allLcb.add(lcbDataDialogue);
                                allLb.add(lbDataDialogue);
                                allRmd.add(rmdDataDialogue);
                                allMd.add(mdDataDialogue);
                                allLmd.add(lmdDataDialogue);
                                allRfwd.add(rfwdDataDialogue);
                                allFwd.add(fwdDataDialogue);
                                allLfwd.add(lfwdDataDialogue);
                                allGkSub.add(gkSubDataDialogue);
                                allDefSub.add(defSubDataDialogue);
                                allMidSub.add(midSubDataDialogue);
                                allFwdSub.add(fwdSubDataDialogue);
                                allCaptain.add(captainDataDialogue);
                                allIsSubMade.add(isSubMadeDataDialogue);
                                allIsTripleCaptained.add(isTripleCaptainedDataDialogue);
                              }
                            }

                            //removing duplicate values from list
                            List setTeams = allTeams.toSet().toList();
                            List setKeys = allKeys.toSet().toList();

                            //checking for winner
                            if (players.length < 5) {
                              List trimmedSorted = sorted.toSet().toList();
                              if (sorted[index] == trimmedSorted[0]) {
                                if (allKeys.isNotEmpty) {
                                  allFirstPlace.add(allKeys.toSet().toList()[index]);
                                }
                              }
                            } else {
                              List trimmedSorted = sorted.toSet().toList();
                              if (sorted[index] == trimmedSorted[0]) {
                                if (allKeys.isNotEmpty) {
                                  allFirstPlace.add(allKeys.toSet().toList()[index]);
                                }
                              }
                              if (sorted[index] == trimmedSorted[1]) {
                                if (allKeys.isNotEmpty) {
                                  allSecondPlace.add(allKeys.toSet().toList()[index]);
                                }
                              }
                              if (sorted[index] == trimmedSorted[2]) {
                                if (allKeys.isNotEmpty) {
                                  allThirdPlace.add(allKeys.toSet().toList()[index]);
                                }
                              }
                            }
                            return DataRow(cells: [
                              DataCell(
                                  onTap: () {showPlayerTeamDialogue(setKeys[index]);},
                                  Text(setTeams.isNotEmpty?setTeams[index]
                                      : '--', style: const TextStyle(color: Colors.white))),
                              DataCell(
                                index == 0 ? Row(
                                  children: [
                                    Text(sorted[index].toString(),
                                        style: const TextStyle(color: Colors.white)),
                                    SizedBox(width: Dimensions.width20,),
                                    Image.asset("assets/icon/tournament_icon.png",
                                        height: Dimensions.height30),
                                  ],
                                ) : Text(sorted[index].toString(), style: const TextStyle(
                                        color: Colors.white)),
                              ),
                            ]);
                          }),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(tournament[0], style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: Dimensions.font16,
                                        color: Colors.white),),
                                    SizedBox(height: Dimensions.height10,),
                                    Text("Game Week ${tournament[1]}", style: TextStyle(
                                        fontSize: Dimensions.font14,
                                        color: Colors.white)),
                                    SizedBox(height: Dimensions.height10,),
                                    Text("${tournament[2]} Token Entry Fee",
                                        style: TextStyle(fontSize: Dimensions.font14,
                                            color: Colors.white)),
                                    SizedBox(height: Dimensions.height10,),
                                    Text("${tournament[3]} Token Total Pot",
                                        style: TextStyle(fontSize: Dimensions.font14,
                                            color: Colors.white)),
                                    SizedBox(height: Dimensions.height10,),
                                    Text("${players.length} Total Player(s)",
                                        style: TextStyle(fontSize: Dimensions.font14,
                                            color: Colors.white)),
                                    SizedBox(height: Dimensions.height15,),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    prizeStructureDialogue();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        right: Dimensions.width10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(Dimensions.radius20/2),
                                      ),
                                      child: Image.asset(
                                        "assets/image/prize_structure_img.png",
                                        width: Dimensions.height20 * 3,),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Map dbPlayers = {};
                                    dbPlayers.addAll(tournament[4]);
                                    firebaseGetTourneyData().then((_){
                                      if(tournamentName==tournament[0]){
                                        //add token checker condition here
                                        if(gameWeek != eventStatusList?.first!){
                                          if (teamName.isNotEmpty && gkData != 0 &&
                                              rbData != 0 && rcbData != 0 &&
                                              lcbData != 0 && lbData != 0 &&
                                              rmdData != 0 && mdData != 0 &&
                                              lmdData != 0 && rfwdData != 0 &&
                                              fwdData != 0 && lfwdData != 0
                                              && gkSubData != 0 && defSubData != 0 &&
                                              midSubData != 0 && fwdSubData != 0) {
                                            if (captainData == 0) {
                                              showCustomSnackBar("Please select your captain", title: "Error");
                                            } else {
                                              if (tournament[8] != "") {
                                                if (!dbPlayers.containsKey(auth.currentUser!.uid)) {
                                                  showIdDialogue();
                                                } else {
                                                  showCustomSnackBar(title: "Error", "You have already joined this tournament");
                                                }
                                              } else {
                                                if (!dbPlayers.containsKey(auth.currentUser!.uid)) {
                                                  showJoinDialogue();
                                                } else {
                                                  showCustomSnackBar(title: "Error", "You have already joined this tournament");
                                                }
                                              }
                                            }
                                          } else {
                                            showCustomSnackBar(
                                                "Please select your team", title: "Error");
                                          }
                                        }else{
                                          showCustomSnackBar(title: "Tournament Closed", "Tournament entry has closed");
                                        }
                                      }else{
                                        showCustomSnackBar("Something went wrong, refresh page", title: "Error");
                                      }
                                    });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: Dimensions.width8),
                                    child: Image.asset(
                                      "assets/icon/join_icon.png",
                                      height: Dimensions.height20 * 4,
                                      color: Colors.yellow,),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: Dimensions.screenWidth*0.55,
                                      child: Text("Created by ${tournament[6]}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              fontSize: Dimensions.font14,
                                              color: Colors.white)),
                                    ),
                                    SizedBox(height: Dimensions.height10,),
                                    Text("${tournament[5]}", style: TextStyle(
                                        fontSize: Dimensions.font14,
                                        color: Colors.white)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
        ));
  }

  void showIdDialogue() {
    showDialog(context: context, builder: (context) =>
        AlertDialog(
          title: const Text(
            "Enter Tournament ID", style: TextStyle(color: Colors.black),),
          content: AppTextField(
            textEditingController: idController,
            hintText: 'Tournament ID',
            icon: Icons.edit,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                idController.clear();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainColor,
              ),
              child: const Text('Close'),
            ),
            StreamBuilder<DocumentSnapshot>(
                stream: _tokenStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    debugPrint("Error getting snapshot");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {}
                  Map<String, dynamic>? data = snapshot.data?.data() as Map<
                      String,
                      dynamic>?;
                  return ElevatedButton(
                    onPressed: () {
                      idFormCheck();
                      if (formOkay) {
                        if (gameWeek != eventStatusList?.first!) {
                          if (idController.text == tournament[8]) {
                            if (players.containsKey(auth.currentUser!.uid)) {
                              showCustomSnackBar(title: "Error",
                                  "You have already joined this tournament");
                            } else {
                              Navigator.of(context).pop();
                              showBoosterDialogue(data?["tokens"]);
                              idController.clear();
                            }
                          } else {
                            showCustomSnackBar(
                                title: "Error", "Enter correct tournament ID");
                          }
                        } else {
                          showCustomSnackBar(title: "Tournament Closed",
                              "Tournament entry has closed");
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainColor,
                    ),
                    //return false when click on "NO"
                    child: const Text('Join'),
                  );
                }
            ),
          ],
        ));
  }

  void idFormCheck() {
    String tournamentId = idController.text.trim();

    if (tournamentId.isEmpty) {
      showCustomSnackBar("Type in tournament ID", title: "Tournament ID");
      formOkay = false;
    } else {
      formOkay = true;
    }
  }

  void showJoinDialogue() {
    showDialog(context: context, builder: (context) =>
        AlertDialog(
          title: const Text(
            "Join Tournament", style: TextStyle(color: Colors.black),),
          content: Text("Join ${tournament[0]} for ${tournament[2]} Tokens?",
            style: const TextStyle(color: Colors.black),),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainColor,
              ),
              child: const Text('No'),
            ),
            StreamBuilder<DocumentSnapshot>(
                stream: _tokenStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    debugPrint("Error getting snapshot");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {}
                  Map<String, dynamic>? data = snapshot.data?.data() as Map<
                      String,
                      dynamic>?;
                  return ElevatedButton(
                    onPressed: () {
                      if (gameWeek != eventStatusList?.first!) {
                        if (players.containsKey(auth.currentUser!.uid)) {
                          showCustomSnackBar(title: "Error",
                              "You have already joined this tournament");
                        } else {
                          Navigator.of(context).pop();
                          showBoosterDialogue(data?["tokens"]);
                        }
                      } else {
                        showCustomSnackBar(title: "Tournament Closed",
                            "Tournament entry has closed");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainColor,
                    ),
                    //return false when click on "NO"
                    child: const Text('Yes'),
                  );
                }
            ),
          ],
        ));
  }

  void joinTournament(bool isTripleCaptained, bool isBenchBoosted) {
    String user = auth.currentUser!.uid;
    Map players = {
      user: {
        'alias': teamName,
        'gk': gkData,
        'rb': rbData,
        'rcb': rcbData,
        'lcb': lcbData,
        'lb': lbData,
        'rmd': rmdData,
        'md': mdData,
        'lmd': lmdData,
        'rfwd': rfwdData,
        'fwd': fwdData,
        'lfwd': lfwdData,
        'gk_sub': gkSubData,
        'def_sub': defSubData,
        'mid_sub': midSubData,
        'fwd_sub': fwdSubData,
        'captain': captainData,
        'is_sub_made': false,
        'is_bench_boosted': isBenchBoosted,
        'is_triple_captained': isTripleCaptained,
      }
    };
    firebaseGetTourneyData().then((_) async {
      if(tournamentName==tournament[0]){
        try {
          final collection = db.collection('tournaments');
          await collection.doc(tournament[7]).set({
            'players': players}, SetOptions(merge: true)
          );
          showCustomSnackBar(title: "Success", "Tournament joined successfully");
        } catch (e) {
          showCustomSnackBar("$e");
        }
      }else{showCustomSnackBar("Something went wrong, refresh page", title: "Error");}
    });
  }

  showPlayerTeamDialogue(String key) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final double fieldH = 0.6773399 * height / 1.4;

    final webNameMap = Map.fromIterables(idList ?? [], webNameList ?? []);
    final photoMap = Map.fromIterables(idList ?? [], photoList ?? []);
    final playerPointMap = Map.fromIterables(idList ?? [], playerPointList ?? []);

    String activeBooster = "";

    int gkDataDialogue = players[key]["gk"];
    int rbDataDialogue = players[key]["rb"];
    int rcbDataDialogue = players[key]["rcb"];
    int lcbDataDialogue = players[key]["lcb"];
    int lbDataDialogue = players[key]["lb"];
    int rmdDataDialogue = players[key]["rmd"];
    int mdDataDialogue = players[key]["md"];
    int lmdDataDialogue = players[key]["lmd"];
    int rfwdDataDialogue = players[key]["rfwd"];
    int fwdDataDialogue = players[key]["fwd"];
    int lfwdDataDialogue = players[key]["lfwd"];
    int gkSubDataDialogue = players[key]["gk_sub"];
    int defSubDataDialogue = players[key]["def_sub"];
    int midSubDataDialogue = players[key]["mid_sub"];
    int fwdSubDataDialogue = players[key]["fwd_sub"];
    int captainDataDialogue = players[key]["captain"];
    bool isSubMade = players[key]["is_sub_made"];
    bool isTripleCaptained = players[key]["is_triple_captained"];
    bool isBenchBoosted = players[key]["is_bench_boosted"];


    var gkPhoto = photoMap[gkDataDialogue];
    var rbPhoto = photoMap[rbDataDialogue];
    var rCbPhoto = photoMap[rcbDataDialogue];
    var lCbPhoto = photoMap[lcbDataDialogue];
    var lbPhoto = photoMap[lbDataDialogue];
    var rMdPhoto = photoMap[rmdDataDialogue];
    var mdPhoto = photoMap[mdDataDialogue];
    var lMdPhoto = photoMap[lmdDataDialogue];
    var rFwdPhoto = photoMap[rfwdDataDialogue];
    var fwdPhoto = photoMap[fwdDataDialogue];
    var lFwdPhoto = photoMap[lfwdDataDialogue];
    var gkSubPhoto = photoMap[gkSubDataDialogue];
    var defSubPhoto = photoMap[defSubDataDialogue];
    var midSubPhoto = photoMap[midSubDataDialogue];
    var fwdSubPhoto = photoMap[fwdSubDataDialogue];

    var gkName = webNameMap[gkDataDialogue];
    var rbName = webNameMap[rbDataDialogue];
    var rCbName = webNameMap[rcbDataDialogue];
    var lCbName = webNameMap[lcbDataDialogue];
    var lbName = webNameMap[lbDataDialogue];
    var rMdName = webNameMap[rmdDataDialogue];
    var mdName = webNameMap[mdDataDialogue];
    var lMdName = webNameMap[lmdDataDialogue];
    var rFwdName = webNameMap[rfwdDataDialogue];
    var fwdName = webNameMap[fwdDataDialogue];
    var lFwdName = webNameMap[lfwdDataDialogue];
    var gkSubName = webNameMap[gkSubDataDialogue];
    var defSubName = webNameMap[defSubDataDialogue];
    var midSubName = webNameMap[midSubDataDialogue];
    var fwdSubName = webNameMap[fwdSubDataDialogue];

    var gkPoints = isTripleCaptained && captainDataDialogue == gkDataDialogue ? (playerPointMap[gkDataDialogue] ?? 0) * 3 ?? 0
        : (captainDataDialogue != gkDataDialogue ? playerPointMap[gkDataDialogue] ?? 0
        : (playerPointMap[gkDataDialogue] ?? 0) * 2 ?? 0);
    var rbPoints = isTripleCaptained && captainDataDialogue == rbDataDialogue ? (playerPointMap[rbDataDialogue] ?? 0) * 3 ?? 0
        : (captainDataDialogue != rbDataDialogue ? playerPointMap[rbDataDialogue] ?? 0
        : (playerPointMap[rbDataDialogue] ?? 0) * 2 ?? 0);
    var rCbPoints = isTripleCaptained && captainDataDialogue == rcbDataDialogue ? (playerPointMap[rcbDataDialogue] ?? 0) * 3 ?? 0
        : (captainDataDialogue != rcbDataDialogue ? playerPointMap[rcbDataDialogue] ?? 0
        : (playerPointMap[rcbDataDialogue] ?? 0) * 2 ?? 0);
    var lCbPoints = isTripleCaptained && captainDataDialogue == lcbDataDialogue ? (playerPointMap[lcbDataDialogue] ?? 0) * 3 ?? 0
        : (captainDataDialogue != lcbDataDialogue ? playerPointMap[lcbDataDialogue] ?? 0
        : (playerPointMap[lcbDataDialogue] ?? 0) * 2 ?? 0);
    var lbPoints = isTripleCaptained && captainDataDialogue == lbDataDialogue ? (playerPointMap[lbDataDialogue] ?? 0) * 3 ?? 0
        : (captainDataDialogue != lbDataDialogue ? playerPointMap[lbDataDialogue] ?? 0
        : (playerPointMap[lbDataDialogue] ?? 0) * 2 ?? 0);
    var rMdPoints = isTripleCaptained && captainDataDialogue == rmdDataDialogue ? (playerPointMap[rmdDataDialogue] ?? 0) * 3 ?? 0
        : (captainDataDialogue != rmdDataDialogue ? playerPointMap[rmdDataDialogue] ?? 0
        : (playerPointMap[rmdDataDialogue] ?? 0) * 2 ?? 0);
    var mdPoints = isTripleCaptained && captainDataDialogue == mdDataDialogue ? (playerPointMap[mdDataDialogue] ?? 0) * 3 ?? 0
        : (captainDataDialogue != mdDataDialogue ? playerPointMap[mdDataDialogue] ?? 0
        : (playerPointMap[mdDataDialogue] ?? 0) * 2 ?? 0);
    var lMdPoints = isTripleCaptained && captainDataDialogue == lmdDataDialogue ? (playerPointMap[lmdDataDialogue] ?? 0) * 3 ?? 0
        : (captainDataDialogue != lmdDataDialogue ? playerPointMap[lmdDataDialogue] ?? 0
        : (playerPointMap[lmdDataDialogue] ?? 0) * 2 ?? 0);
    var rFwdPoints = isTripleCaptained && captainDataDialogue == rfwdDataDialogue ? (playerPointMap[rfwdDataDialogue] ?? 0) * 3 ?? 0
        : (captainDataDialogue != rfwdDataDialogue ? playerPointMap[rfwdDataDialogue] ?? 0
        : (playerPointMap[rfwdDataDialogue] ?? 0) * 2 ?? 0);
    var fwdPoints = isTripleCaptained && captainDataDialogue == fwdDataDialogue ? (playerPointMap[fwdDataDialogue] ?? 0) * 3 ?? 0
        : (captainDataDialogue != fwdDataDialogue ? playerPointMap[fwdDataDialogue] ?? 0
        : (playerPointMap[fwdDataDialogue] ?? 0) * 2 ?? 0);
    var lFwdPoints = isTripleCaptained && captainDataDialogue == lfwdDataDialogue ? (playerPointMap[lfwdDataDialogue] ?? 0) * 3 ?? 0
        : (captainDataDialogue != lfwdDataDialogue ? playerPointMap[lfwdDataDialogue] ?? 0
        : (playerPointMap[lfwdDataDialogue] ?? 0) * 2 ?? 0);

    var gkSubPoints = playerPointMap[gkSubDataDialogue] ?? 0;
    var defSubPoints = playerPointMap[defSubDataDialogue] ?? 0;
    var midSubPoints = playerPointMap[midSubDataDialogue] ?? 0;
    var fwdSubPoints = playerPointMap[fwdSubDataDialogue] ?? 0;

    if(isTripleCaptained){
      activeBooster = "T/C";
    }else if(isBenchBoosted){
      activeBooster = "B/B";
    }else{
      activeBooster = "N/A";
    }

    return showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(0),
            contentPadding: const EdgeInsets.all(0),
            content: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.all(Dimensions.width8),
                        child: Container(
                          margin: EdgeInsets.only(right: Dimensions.width30),
                            child: Text("Active Booster: $activeBooster",
                              style: TextStyle(color: Colors.white, fontSize: Dimensions.font10, fontWeight: FontWeight.bold),)
                        ),
                      )
                  ),
                  Stack(
                      children: [
                        SizedBox(
                          height: fieldH,
                          width: width,
                          child: Image.asset(
                            'assets/image/field.png', fit: BoxFit.fill,),),
                        Player(
                          image: AppConstants.showImgData!="true"?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$gkPhoto.png',
                          name: gkName ?? "--",
                          top: 0.07272727 * fieldH,
                          right: 0.0,
                          left: 0.0,
                          position: "GK",
                          points: gkPoints ?? 0,
                          onTap: () {
                            key != auth.currentUser!.uid
                                ? null
                                : showSubDialogue(
                                gkDataDialogue, "gk", "gk_sub",
                                gkSubDataDialogue, isSubMade, key);
                          },
                          captainBand: captainDataDialogue == gkDataDialogue
                              ? Image.asset("assets/image/captain_img.png",
                            height: Dimensions.height10,)
                              : Container(),),
                        Player(
                          image: AppConstants.showImgData!="true"?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$rbPhoto.png',
                          name: rbName ?? "--",
                          top: 0.21818182 * fieldH,
                          right: 0.70666667 * width,
                          left: 0.0,
                          position: "RB",
                          points: rbPoints ?? 0,
                          onTap: () {
                            key != auth.currentUser!.uid
                                ? null
                                : showSubDialogue(
                                rbDataDialogue, "rb", "def_sub",
                                defSubDataDialogue, isSubMade, key);
                          },
                          captainBand: captainDataDialogue == rbDataDialogue
                              ? Image.asset("assets/image/captain_img.png",
                            height: Dimensions.height10,)
                              : Container(),),
                        Player(
                          image: AppConstants.showImgData!="true"?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$rCbPhoto.png',
                          name: rCbName ?? "--",
                          top: 0.23636364 * fieldH,
                          right: 0.29333333 * width,
                          left: 0.0,
                          position: "CB",
                          points: rCbPoints ?? 0,
                          onTap: () {
                            key != auth.currentUser!.uid
                                ? null
                                : showSubDialogue(
                                rcbDataDialogue, "rcb", "def_sub",
                                defSubDataDialogue, isSubMade, key);
                          },
                          captainBand: captainDataDialogue == rcbDataDialogue
                              ? Image.asset("assets/image/captain_img.png",
                            height: Dimensions.height10,)
                              : Container(),),
                        Player(
                          image: AppConstants.showImgData!="true"?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$lCbPhoto.png',
                          name: lCbName ?? "--",
                          top: 0.23636364 * fieldH,
                          right: 0.0,
                          left: 0.29333333 * width,
                          position: "CB",
                          points: lCbPoints ?? 0,
                          onTap: () {
                            key != auth.currentUser!.uid
                                ? null
                                : showSubDialogue(
                                lcbDataDialogue, "lcb", "def_sub",
                                defSubDataDialogue, isSubMade, key);
                          },
                          captainBand: captainDataDialogue == lcbDataDialogue
                              ? Image.asset("assets/image/captain_img.png",
                            height: Dimensions.height10,)
                              : Container(),),
                        Player(
                          image: AppConstants.showImgData!="true"?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$lbPhoto.png',
                          name: lbName ?? "--",
                          top: 0.21818182 * fieldH,
                          right: 0.0,
                          left: 0.70666667 * width,
                          position: "LB",
                          points: lbPoints ?? 0,
                          onTap: () {
                            key != auth.currentUser!.uid
                                ? null
                                : showSubDialogue(
                                lbDataDialogue, "lb", "def_sub",
                                defSubDataDialogue, isSubMade, key);
                          },
                          captainBand: captainDataDialogue == lbDataDialogue
                              ? Image.asset("assets/image/captain_img.png",
                            height: Dimensions.height10,)
                              : Container(),),
                        Player(
                          image: AppConstants.showImgData!="true"?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$rMdPhoto.png',
                          name: rMdName ?? "--",
                          top: 0.47272727 * fieldH,
                          right: 0.0,
                          left: 0.70666667 * width,
                          position: "LMF",
                          points: rMdPoints ?? 0,
                          onTap: () {
                            key != auth.currentUser!.uid
                                ? null
                                : showSubDialogue(
                                rmdDataDialogue, "rmd", "mid_sub",
                                midSubDataDialogue, isSubMade, key);
                          },
                          captainBand: captainDataDialogue == rmdDataDialogue
                              ? Image.asset("assets/image/captain_img.png",
                            height: Dimensions.height10,)
                              : Container(),),
                        Player(
                          image: AppConstants.showImgData!="true"?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$mdPhoto.png',
                          name: mdName ?? "--",
                          top: 0.44454545 * fieldH,
                          right: 0.01333333 * width,
                          left: 0.0,
                          position: "AMF",
                          points: mdPoints ?? 0,
                          onTap: () {
                            key != auth.currentUser!.uid
                                ? null
                                : showSubDialogue(
                                mdDataDialogue, "md", "mid_sub",
                                midSubDataDialogue, isSubMade, key);
                          },
                          captainBand: captainDataDialogue == mdDataDialogue
                              ? Image.asset("assets/image/captain_img.png",
                            height: Dimensions.height10,)
                              : Container(),),
                        Player(
                          image: AppConstants.showImgData!="true"?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$lMdPhoto.png',
                          name: lMdName ?? "--",
                          top: 0.47272727 * fieldH,
                          right: 0.70666667 * width,
                          left: 0.0,
                          position: "RMF",
                          points: lMdPoints ?? 0,
                          onTap: () {
                            key != auth.currentUser!.uid
                                ? null
                                : showSubDialogue(
                                lmdDataDialogue, "lmd", "mid_sub",
                                midSubDataDialogue, isSubMade, key);
                          },
                          captainBand: captainDataDialogue == lmdDataDialogue
                              ? Image.asset("assets/image/captain_img.png",
                            height: Dimensions.height10,)
                              : Container(),),
                        Player(
                          image: AppConstants.showImgData!="true"?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$rFwdPhoto.png',
                          name: rFwdName ?? "--",
                          top: 0.68090909 * fieldH,
                          right: 0.29333333 * width,
                          left: 0.29333333 * width,
                          position: "CF",
                          points: rFwdPoints ?? 0,
                          onTap: () {
                            key != auth.currentUser!.uid
                                ? null
                                : showSubDialogue(
                                rfwdDataDialogue, "rfwd", "fwd_sub",
                                fwdSubDataDialogue, isSubMade, key);
                          },
                          captainBand: captainDataDialogue == rfwdDataDialogue
                              ? Image.asset("assets/image/captain_img.png",
                            height: Dimensions.height10,)
                              : Container(),),
                        Player(
                          image: AppConstants.showImgData!="true"?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$fwdPhoto.png',
                          name: fwdName ?? "--",
                          top: 0.68090909 * fieldH,
                          right: 0.5 * width,
                          left: 0.0,
                          position: "RWF",
                          points: fwdPoints ?? 0,
                          onTap: () {
                            key != auth.currentUser!.uid
                                ? null
                                : showSubDialogue(
                                fwdDataDialogue, "fwd", "fwd_sub",
                                fwdSubDataDialogue, isSubMade, key);
                          },
                          captainBand: captainDataDialogue == fwdDataDialogue
                              ? Image.asset("assets/image/captain_img.png",
                            height: Dimensions.height10,)
                              : Container(),),
                        Player(
                          image: AppConstants.showImgData!="true"?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$lFwdPhoto.png',
                          name: lFwdName ?? "--",
                          top: 0.68090909 * fieldH,
                          right: 0.1 * width,
                          left: 0.55333333 * width,
                          position: "LWF",
                          points: lFwdPoints ?? 0,
                          onTap: () {
                            key != auth.currentUser!.uid
                                ? null
                                : showSubDialogue(
                                lfwdDataDialogue, "lfwd", "fwd_sub",
                                fwdSubDataDialogue, isSubMade, key);
                          },
                          captainBand: captainDataDialogue == lfwdDataDialogue
                              ? Image.asset("assets/image/captain_img.png",
                            height: Dimensions.height10,)
                              : Container(),)
                      ]),
                  Container(
                    width: width,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(Dimensions.height10)
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      reverse: true,
                      child: Padding(
                        padding: EdgeInsets.all(Dimensions.width1 * 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                width: width * 0.25,
                                child: SubPlayer(
                                  image: AppConstants.showImgData!="true"?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$gkSubPhoto.png',
                                  name: gkSubName ?? "--",
                                  position: "DEF",
                                  points: gkSubPoints ?? 0,)),
                            SizedBox(width: Dimensions.width5,),
                            SizedBox(
                                width: width * 0.25,
                                child: SubPlayer(
                                  image: AppConstants.showImgData!="true"?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$defSubPhoto.png',
                                  name: defSubName ?? "--",
                                  position: "DEF",
                                  points: defSubPoints ?? 0,)),
                            SizedBox(width: Dimensions.width5,),
                            SizedBox(
                                width: width * 0.25,
                                child: SubPlayer(
                                  image: AppConstants.showImgData!="true"?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$midSubPhoto.png',
                                  name: midSubName ?? "--",
                                  position: "MID",
                                  points: midSubPoints ?? 0,)),
                            SizedBox(width: Dimensions.width5,),
                            SizedBox(
                                width: width * 0.25,
                                child: SubPlayer(
                                  image: AppConstants.showImgData!="true"?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$fwdSubPhoto.png',
                                  name: fwdSubName ?? "--",
                                  position: "FWD",
                                  points: fwdSubPoints ?? 0,)),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
    );
  }

  void showSubDialogue(int playerInt, String player, String benchPlayer,
      int benchPlayerInt, bool isSubMade, String key) {
    showDialog(context: context, builder: (context) =>
        AlertDialog(
          backgroundColor: Colors.transparent,
          content: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ElevatedButton(
              onPressed: () {
                firebaseGetTourneyData().then((_)async{
                  if(tournamentName==tournament[0]){
                    if (isSubMade) {
                      Navigator.of(context).pop();
                      showCustomSnackBar("Can't make another sub", title: "Error");
                    } else {
                      Map players = {
                        key: {
                          benchPlayer: playerInt,
                          player: benchPlayerInt,
                          'is_sub_made': true,
                        }
                      };
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      try {
                        final collection = FirebaseFirestore.instance.collection(
                            'tournaments');
                        await collection.doc(tournament[7]).set({
                          'players': players,
                        }, SetOptions(merge: true)).then((_) => showCustomSnackBar(
                            "Substitution Made", title: "Success"));
                      } catch (e) {
                        showCustomSnackBar(e.toString());
                      }
                    }
                  }else{showCustomSnackBar("Something went wrong, refresh page", title: "Error");}
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                maximumSize: Size(Dimensions.width100, Dimensions.height100),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/image/sub_img.png", height: Dimensions.width50,),
                  SizedBox(height: Dimensions.height1 * 5,),
                  Text(
                    "Make Sub", style: TextStyle(fontSize: Dimensions.font14),),
                ],
              ),
            ),
          ),
        ));
  }

  void showBoosterDialogue(int totalTokens) {
    showDialog(
        context: context, barrierDismissible: false, builder: (context) =>
        AlertDialog(
          backgroundColor: Colors.transparent,
          title: Text("Apply Triple Captain or Bench Boost for 5 tokens?",
            style: TextStyle(
                color: Colors.white, fontSize: Dimensions.font14),),
          content: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    firebaseGetTourneyData().then((_){
                      if (int.parse(tournament[2]) + AppConstants.boosterCost >
                          totalTokens) {
                        showCustomSnackBar("Not enough tokens to join", title: "Token Amount");
                      }else {
                        if(tournamentName==tournament[0]){
                          joinTournament(true, false);
                          FirebaseFirestore.instance.collection('user_data')
                              .doc(auth.currentUser!.uid).update({
                            'tokens': totalTokens - (int.parse(tournament[2]) +
                                AppConstants.boosterCost)
                          }).then((_) => collectProfit('triple_captain_booster'));
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        }else{showCustomSnackBar("Something went wrong, refresh page", title: "Error");}
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(
                        Dimensions.width10 * 10, Dimensions.height10 * 10),
                    backgroundColor: Colors.white,
                  ),
                  child: Image.asset("assets/image/triple_captain_img.png",
                    width: Dimensions.width10 * 9,
                    height: Dimensions.height10 * 10,),
                ),
                ElevatedButton(
                  onPressed: () {
                    firebaseGetTourneyData().then((_){
                      if (int.parse(tournament[2]) + AppConstants.boosterCost >
                          totalTokens) {
                        showCustomSnackBar(
                            "Not enough tokens to join", title: "Token Amount");
                      } else {
                        if(tournamentName==tournament[0]){
                          joinTournament(false, true);
                          FirebaseFirestore.instance.collection('user_data')
                              .doc(auth.currentUser!.uid).update({
                            'tokens': totalTokens - (int.parse(tournament[2]) +
                                AppConstants.boosterCost)
                          }).then((_) => collectProfit('bench_booster'));
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        }else{showCustomSnackBar("Something went wrong, refresh page", title: "Error");}
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(
                        Dimensions.width10 * 10, Dimensions.height10 * 10),
                    backgroundColor: Colors.white,
                  ),
                  child: Image.asset("assets/image/bench_boost_img.png",
                    width: Dimensions.width10 * 9,),
                ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    firebaseGetTourneyData().then((_){
                      if (int.parse(tournament[2]) > totalTokens) {
                        showCustomSnackBar(
                            "Not enough tokens to join", title: "Token Amount");
                      } else {
                        if(tournamentName==tournament[0]){
                          joinTournament(false, false);
                          FirebaseFirestore.instance.collection('user_data')
                              .doc(auth.currentUser!.uid).update(
                              {'tokens': totalTokens - (int.parse(tournament[2]))});
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        }else{
                          showCustomSnackBar("Something went wrong, refresh page", title: "Error");
                        }
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainColor,
                  ),
                  child: const Text('Skip'),
                ),
                SizedBox(width: Dimensions.width10,),
                ElevatedButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                )
              ],
            )
          ],
        ));
  }

  Future<void> payWinners(String userId, int winnings) async {
    int currentTokens = 0;
    try {
      await db.collection("user_data").doc(userId).get().then((data) {
        currentTokens = data["tokens"];
      }).then((_) {
        db.collection('user_data').doc(userId).update({
          'tokens': currentTokens + winnings,
        });
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> payAdmin() async {
    int currentTokens = 0;
    try {
      await db.collection("user_data").doc(tournament[9]).get().then((data) {
        currentTokens = data["tokens"];
      }).then((_) {
        db.collection('user_data').doc(tournament[9]).update({
          'tokens': currentTokens + adminPot,
        });
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> payFunction() async {
    firebaseGetTourneyData().then((_){
      if(tournamentName==tournament[0]){
        if(!isPaidOut){
          if(players.length < 5){
            Future.delayed(const Duration(seconds: 1), () {
              for (var i = 0; i < allFirstPlace.length; i++) {
                payWinners(allFirstPlace.toSet().toList()[i],
                    (((winnersPot).round()) / allFirstPlace.length).round());

                winners[allFirstPlace.toSet().toList()[i]]=(((winnersPot).round()) / allFirstPlace.length).round();
                //sending notification to user phone
                sendNotification(allFirstPlace.toSet().toList()[i], "You have won ${(((winnersPot).round()) / allFirstPlace.length).round()} tokens");
              }
            });
          }else{
            Future.delayed(const Duration(seconds: 1), () {
              for (var i = 0; i < allFirstPlace.length; i++) {
                payWinners(allFirstPlace.toSet().toList()[i],
                    (((winnersPot * 0.50).round()) / allFirstPlace.length).round());

                winners[allFirstPlace.toSet().toList()[i]]=(((winnersPot*0.50).round()) / allFirstPlace.length).round();
                //sending notification to user phone
                sendNotification(allFirstPlace.toSet().toList()[i], "You have won ${(((winnersPot*0.50).round()) / allFirstPlace.length).round()} tokens");
              }
              for (var i = 0; i < allSecondPlace.length; i++) {
                payWinners(allSecondPlace.toSet().toList()[i],
                    (((winnersPot * 0.35).round()) / allSecondPlace.length).round());

                winners[allSecondPlace.toSet().toList()[i]]=(((winnersPot*0.35).round()) / allSecondPlace.length).round();
                //sending notification to user phone
                sendNotification(allSecondPlace.toSet().toList()[i], "You have won ${(((winnersPot*0.35).round()) / allSecondPlace.length).round()} tokens");
              }
              for (var i = 0; i < allThirdPlace.length; i++) {
                payWinners(allThirdPlace.toSet().toList()[i],
                    (((winnersPot * 0.15).round()) / allThirdPlace.length).round());

                winners[allThirdPlace.toSet().toList()[i]]=(((winnersPot*0.15).round()) / allThirdPlace.length).round();
                //sending notification to user phone
                sendNotification(allThirdPlace.toSet().toList()[i], "You have won ${(((winnersPot*0.15).round()) / allThirdPlace.length).round()} tokens");
              }
            });
          }
          Future.delayed(const Duration(seconds: 2), () async{
            payAdmin();
            var createdAt = DateFormat('h:mm a, dd-MMM-yy').format(DateTime.now());
            try {
              final collection = FirebaseFirestore.instance.collection('tournaments');
              await collection.doc(tournament[7]).update({
                'is_paid_out': true,
                'winners':winners,
                'settlement_time': createdAt,
              }).then((_) => winnersPot = 0);
            } catch (e) {
              debugPrint(e.toString());
            }
          });
        }
      }else{showCustomSnackBar("Something went wrong, refresh page", title: "Error");}
    });
  }

  Future<void> collectProfit(booster)async{
    int currentTokens = 0;
    try {
      await db.collection("profit").doc("pot").get().then((data) {
        currentTokens = data[booster];
      }).then((_) {
        db.collection('profit').doc("pot").update({
          booster: currentTokens + AppConstants.boosterCost,
        });
      });
    }catch (e) {
      debugPrint(e.toString());
    }
  }

  void prizeStructureDialogue() {
    showDialog(context: context, builder: (context) =>
        AlertDialog(
          backgroundColor: Colors.transparent,
          title: Center(
            child: Text(
              "Prize Structure", style: TextStyle(fontSize: Dimensions.font16, color: Colors.white),),
          ),
          content: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.only(left: Dimensions.width30, right: Dimensions.width30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("1st Place",
                        style: TextStyle(fontSize: Dimensions.font14, color: Colors.white, fontStyle: FontStyle.italic),),
                      players.length>=5?Text("${(winnersPot*0.50).round()} Tokens",
                        style: TextStyle(fontSize: Dimensions.font14, color: Colors.white, fontStyle: FontStyle.italic),)
                          :Text("$winnersPot Tokens",
                        style: TextStyle(fontSize: Dimensions.font14, color: Colors.white, fontStyle: FontStyle.italic),),
                    ],
                  ),
                  SizedBox(height: Dimensions.height10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      players.length>=5?Text("2nd Place",
                        style: TextStyle(fontSize: Dimensions.font14, color: Colors.white, fontStyle: FontStyle.italic),):Container(),
                      players.length>=5?Text("${(winnersPot*0.35).round()} Tokens",
                        style: TextStyle(fontSize: Dimensions.font14, color: Colors.white, fontStyle: FontStyle.italic),):Container(),
                    ],
                  ),
                  SizedBox(height: Dimensions.height10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      players.length>=5?Text("3rd Place",
                        style: TextStyle(fontSize: Dimensions.font14, color: Colors.white, fontStyle: FontStyle.italic),):Container(),
                      players.length>=5?Text("${(winnersPot*0.15).round()} Tokens",
                        style: TextStyle(fontSize: Dimensions.font14, color: Colors.white, fontStyle: FontStyle.italic),):Container(),
                    ],
                  ),
                  SizedBox(height: Dimensions.height10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Admin",
                        style: TextStyle(fontSize: Dimensions.font14, color: Colors.white, fontStyle: FontStyle.italic),),
                      Text("${(adminPot).round()} Tokens",
                        style: TextStyle(fontSize: Dimensions.font14, color: Colors.white, fontStyle: FontStyle.italic),),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
  
  void sendNotification(String uid, String body) async{
    DocumentSnapshot snap = await db.collection("user_tokens").doc(uid).get();
    String token = snap['token'];

    sendPushMessage(token, body);
  }

  void sendPushMessage(String token, String body) async{
    try{
      await http.post(
          Uri.parse("https://fcm.googleapis.com/fcm/send"),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':'key=AAAAkHNR9Uw:APA91bHiDK29nPNVx9PFEdyu4oOydbOuMGhf0-MwsYTfMD6qmyDuIeLZq9IGJm_mG6IEsFFM2GXWBL-o-Zw2rwHdEQGn1sb1r5HDlBJk-49THrCiI5uCwz1Cbn5WCYlZ0FGS4QhFAfbH',
          },
        body: jsonEncode(<String, dynamic>{
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done',
            'body': body,
            'title': 'Hooray!!!',
          },
          "notification": <String, dynamic>{
            "title": 'Hooray!!!',
            "body": body,
            "android_channel_id": "PL Fantasy Online"
          },
          "to": token,
        })
      );
    }catch(e){
      debugPrint(e.toString());
    }
  }
}
