import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pl_fantasy_online/base/custom_app_bar.dart';
import 'package:pl_fantasy_online/base/custom_snack_bar.dart';
import 'package:pl_fantasy_online/controllers/general_controller.dart';
//import 'package:pl_fantasy_online/utils/app_constants.dart';
import 'package:pl_fantasy_online/utils/colors.dart';
import 'package:pl_fantasy_online/utils/dimensions.dart';
import 'package:pl_fantasy_online/widgets/select_player_card.dart';

class PickTeamPage extends StatefulWidget {
  const PickTeamPage({Key? key}) : super(key: key);

  @override
  State<PickTeamPage> createState() => _PickTeamPageState();
}

class _PickTeamPageState extends State<PickTeamPage> {
  //final FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  List<dynamic> team = Get.arguments;

  List<int?>? idList;
  List<String?>? webNameList;
  List<int?>? photoList;
  List<double?>? playerPriceList;
  List<int?>? playerPositionList;
  List<int?>? teamIdList;
  List<String?>? teamNameList;
  List<int?>? teamPhotoList;
  List<int?>? playerTeam;
  List<String?>? playerStatus;
  List selectedPlayerPosition = [];
  List selectedPlayers = [];

  bool approved = false;
  late bool isPlayerSelected;

  GeneralController generalController = Get.put(GeneralController());

  @override
  Widget build(BuildContext context) {
    idList = generalController.generalModel?.elements!
        .map((info) => info.id)
        .toList();
    webNameList = generalController.generalModel?.elements!
        .map((info) => info.webName)
        .toList();
    photoList = generalController.generalModel?.elements!
        .map((info) => info.code)
        .toList();
    playerPriceList = generalController.generalModel?.elements!
        .map((info) => info.nowCost! / 10)
        .toList();
    playerPositionList = generalController.generalModel?.elements!
        .map((info) => info.elementType)
        .toList();
    teamIdList =
        generalController.generalModel?.teams!.map((info) => info.id).toList();
    teamNameList = generalController.generalModel?.teams!
        .map((info) => info.name)
        .toList();
    playerTeam = generalController.generalModel?.elements!
        .map((info) => info.team)
        .toList();
    playerStatus = generalController.generalModel?.elements!
        .map((info) => info.status)
        .toList();

    final positionMap =
        Map.fromIterables(idList ?? [], playerPositionList ?? []);
    final webNameMap = Map.fromIterables(idList ?? [], webNameList ?? []);
    final photoMap = Map.fromIterables(idList ?? [], photoList ?? []);
    final teamNameMap = Map.fromIterables(teamIdList ?? [], teamNameList ?? []);
    final playerTeamMap = Map.fromIterables(idList ?? [], playerTeam ?? []);
    final playerPriceMap =
        Map.fromIterables(idList ?? [], playerPriceList ?? []);
    final playerStatusMap = Map.fromIterables(idList ?? [], playerStatus ?? []);

    for (var e in positionMap.keys) {
      //adding elements of map values to list
      if (positionMap[e] == team[0]) {
        if (playerStatusMap[e] != "u") {
          selectedPlayerPosition.add(e);
        }
      }
    }

    selectedPlayers = team[4];
    approved = team[5];

    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
              AppColors.gradientOne,
              AppColors.gradientTwo,
            ])),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: const CustomAppBar(
              title: "Pick Team",
            ),
            body: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: Dimensions.height1 * 8),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius15 / 3),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(Dimensions.width8),
                        child: Text(
                          "Balance: ${num.parse(team[1].toStringAsFixed(2))}m",
                          style: TextStyle(
                              fontSize: Dimensions.font14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      )),
                ),
                Expanded(
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: selectedPlayerPosition.length,
                      itemBuilder: (ctx, index) {
                        if (selectedPlayerPosition[index] ==
                            selectedPlayers[0]) {
                          isPlayerSelected = true;
                        } else if (selectedPlayerPosition[index] ==
                            selectedPlayers[1]) {
                          isPlayerSelected = true;
                        } else if (selectedPlayerPosition[index] ==
                            selectedPlayers[2]) {
                          isPlayerSelected = true;
                        } else if (selectedPlayerPosition[index] ==
                            selectedPlayers[3]) {
                          isPlayerSelected = true;
                        } else if (selectedPlayerPosition[index] ==
                            selectedPlayers[4]) {
                          isPlayerSelected = true;
                        } else if (selectedPlayerPosition[index] ==
                            selectedPlayers[5]) {
                          isPlayerSelected = true;
                        } else if (selectedPlayerPosition[index] ==
                            selectedPlayers[6]) {
                          isPlayerSelected = true;
                        } else if (selectedPlayerPosition[index] ==
                            selectedPlayers[7]) {
                          isPlayerSelected = true;
                        } else if (selectedPlayerPosition[index] ==
                            selectedPlayers[8]) {
                          isPlayerSelected = true;
                        } else if (selectedPlayerPosition[index] ==
                            selectedPlayers[9]) {
                          isPlayerSelected = true;
                        } else if (selectedPlayerPosition[index] ==
                            selectedPlayers[10]) {
                          isPlayerSelected = true;
                        } else if (selectedPlayerPosition[index] ==
                            selectedPlayers[11]) {
                          isPlayerSelected = true;
                        } else if (selectedPlayerPosition[index] ==
                            selectedPlayers[12]) {
                          isPlayerSelected = true;
                        } else if (selectedPlayerPosition[index] ==
                            selectedPlayers[13]) {
                          isPlayerSelected = true;
                        } else if (selectedPlayerPosition[index] ==
                            selectedPlayers[14]) {
                          isPlayerSelected = true;
                        } else {
                          isPlayerSelected = false;
                        }
                        return SelectPlayerCard(
                          player: webNameMap[selectedPlayerPosition[index]],
                          team: teamNameMap[
                              playerTeamMap[selectedPlayerPosition[index]]],
                          price: playerPriceMap[selectedPlayerPosition[index]],
                          image: !approved /*&& AppConstants.showImgData!="true"*/
                              ? ''
                              : 'https://resources.premierleague.com/premierleague/photos/players/110x140/p${photoMap[selectedPlayerPosition[index]]}.png',
                          onPressed: () {
                            showConfirmDialogue(
                              webNameMap[selectedPlayerPosition[index]],
                              playerPriceMap[selectedPlayerPosition[index]],
                              selectedPlayerPosition[index],
                            );
                          },
                          position: team[2],
                          isPlayerSelected: isPlayerSelected,
                        );
                      }),
                ),
              ],
            )));
  }

  Future showConfirmDialogue(String playerName, double price, int playerId) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Confirm',
          style: TextStyle(color: Colors.black),
        ),
        content: Text(
          'Confirm $playerName selection for ${price}m?',
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainColor,
            ),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              if (price > team[1]) {
                showCustomSnackBar("Insufficient balance", title: "Error");
              } else {
                uploadTeamData(playerId, price);
                Navigator.of(context).pop(false);
                Navigator.of(context).pop(false);
              }
            },
            //return true when click on "Yes"
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainColor,
            ),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void uploadTeamData(int player, price) async {
    try {
      final collection = FirebaseFirestore.instance.collection('user_teams');
      await collection.doc(auth.currentUser!.uid).update({
        team[3]: player,
        'money': team[1] - price,
      });
    } catch (e) {
      showCustomSnackBar(e.toString());
    }
  }
}
