import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pl_fantasy_online/base/custom_app_bar.dart';
import 'package:pl_fantasy_online/base/custom_snack_bar.dart';
import 'package:pl_fantasy_online/controllers/event_status_controller.dart';
import 'package:pl_fantasy_online/controllers/general_controller.dart';
//import 'package:pl_fantasy_online/utils/app_constants.dart';
import 'package:pl_fantasy_online/utils/colors.dart';
import 'package:pl_fantasy_online/utils/dimensions.dart';
import 'package:pl_fantasy_online/widgets/player.dart';
import 'package:pl_fantasy_online/widgets/sub_player.dart';


class MyTeam extends StatefulWidget {
  const MyTeam({Key? key}) : super(key: key);

  @override
  State<MyTeam> createState() => _MyTeamState();
}

class _MyTeamState extends State<MyTeam> {
  String  alias = "";
  int gkData = 0;
  int rbData = 0;
  int rcbData = 0;
  int lcbData = 0;
  int lbData = 0;
  int rmdData = 0;
  int mdData = 0;
  int lmdData = 0;
  int rfwdData = 0;
  int fwdData = 0;
  int lfwdData = 0;
  int gkSubData = 0;
  int defSubData = 0;
  int midSubData = 0;
  int fwdSubData = 0;

  List<int?>? idList;
  List<String?>? webNameList;
  List<int?>? photoList;
  List<int?>? eventStatusList;
  List<int?>? playerPointList;

  final FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  late Stream<DocumentSnapshot> _userTeamStream;
  bool isLoaded = false;
  late bool approved;

  GeneralController generalController = Get.put(GeneralController());
  EventStatusController eventStatusController = Get.put(EventStatusController());

  void firebaseGetData() async {
    await db.collection("user_data").doc(auth.currentUser!.uid).get().then((data){
      approved = data["approved"];
    });
  }

  @override
  void initState() {
    super.initState();
    _userTeamStream = db.collection("user_teams").doc(auth.currentUser?.uid).snapshots();
    firebaseGetData();

    approved = false;
  }

  @override
  Widget build(BuildContext context) {

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final double fieldH = 0.6773399 * height/1.15;

    idList = generalController.generalModel?.elements!.map((info) => info.id).toList();
    webNameList = generalController.generalModel?.elements!.map((info) => info.webName).toList();
    photoList = generalController.generalModel?.elements!.map((info) => info.code).toList();
    playerPointList = generalController.generalModel?.elements!.map((info) => info.eventPoints).toList();
    eventStatusList = eventStatusController.eventStatusModel?.status!.map((info) => info.event).toList();

    final webNameMap = Map.fromIterables(idList??[], webNameList??[]);
    final photoMap = Map.fromIterables(idList??[], photoList??[]);
    final playerPointMap = Map.fromIterables(idList??[], playerPointList??[]);

    var gameWeek = eventStatusList?.first??"--";

    return StreamBuilder<DocumentSnapshot>(
      stream: _userTeamStream,
      builder: (context, snapshot) {
        if(snapshot.hasError){
          debugPrint("Error getting snapshot");
        }
        if(snapshot.connectionState == ConnectionState.waiting){

        }else{
          isLoaded = true;
        }
        Map<String, dynamic>? data = snapshot.data?.data() as Map<String, dynamic>?;
        var gkInt = data?['gk'];
        var rbInt = data?['rb'];
        var rCbInt = data?['rcb'];
        var lCbInt = data?['lcb'];
        var lbInt = data?['lb'];
        var rMidInt = data?['rmd'];
        var midInt = data?['md'];
        var lMidInt = data?['lmd'];
        var rFwdInt = data?['rfwd'];
        var fwdInt = data?['fwd'];
        var lFwdInt = data?['lfwd'];
        var gkSubInt = data?["gk_sub"];
        var defSubInt = data?["def_sub"];
        var midSubInt = data?["mid_sub"];
        var fwdSubInt = data?["fwd_sub"];
        var captain = data?["captain"];
        var name = data?['alias'];

        var gkName = webNameMap[gkInt];
        var rbName = webNameMap[rbInt];
        var rCbName = webNameMap[rCbInt];
        var lCbName = webNameMap[lCbInt];
        var lbName = webNameMap[lbInt];
        var rMdName = webNameMap[rMidInt];
        var mdName = webNameMap[midInt];
        var lMdName = webNameMap[lMidInt];
        var rFwdName = webNameMap[rFwdInt];
        var fwdName = webNameMap[fwdInt];
        var lFwdName = webNameMap[lFwdInt];
        var gkSubName = webNameMap[gkSubInt];
        var defSubName = webNameMap[defSubInt];
        var midSubName = webNameMap[midSubInt];
        var fwdSubName = webNameMap[fwdSubInt];

        var gkPhoto = photoMap[gkInt];
        var rbPhoto = photoMap[rbInt];
        var rCbPhoto = photoMap[rCbInt];
        var lCbPhoto = photoMap[lCbInt];
        var lbPhoto = photoMap[lbInt];
        var rMdPhoto = photoMap[rMidInt];
        var mdPhoto = photoMap[midInt];
        var lMdPhoto = photoMap[lMidInt];
        var rFwdPhoto = photoMap[rFwdInt];
        var fwdPhoto = photoMap[fwdInt];
        var lFwdPhoto = photoMap[lFwdInt];
        var gkSubPhoto = photoMap[gkSubInt];
        var defSubPhoto = photoMap[defSubInt];
        var midSubPhoto = photoMap[midSubInt];
        var fwdSubPhoto = photoMap[fwdSubInt];

        var gkPoints = playerPointMap[gkInt]??0;
        var rbPoints = playerPointMap[rbInt]??0;
        var rCbPoints = playerPointMap[rCbInt]??0;
        var lCbPoints = playerPointMap[lCbInt]??0;
        var lbPoints = playerPointMap[lbInt]??0;
        var rMdPoints = playerPointMap[rMidInt]??0;
        var mdPoints = playerPointMap[midInt]??0;
        var lMdPoints = playerPointMap[lMidInt]??0;
        var rFwdPoints = playerPointMap[rFwdInt]??0;
        var fwdPoints = playerPointMap[fwdInt]??0;
        var lFwdPoints = playerPointMap[lFwdInt]??0;
        var gkSubPoints = playerPointMap[gkSubInt]??0;
        var defSubPoints = playerPointMap[defSubInt]??0;
        var midSubPoints = playerPointMap[midSubInt]??0;
        var fwdSubPoints = playerPointMap[fwdSubInt]??0;

        int totalPlayerPoints =
            gkPoints+rbPoints+rCbPoints+lCbPoints+lbPoints+rMdPoints
                +mdPoints+lMdPoints+rFwdPoints+fwdPoints+lFwdPoints;

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
            appBar: const CustomAppBar(title: 'My Team',),
            body: SafeArea(
                child: Container(
                    margin: EdgeInsets.only(top: Dimensions.height25),
                    height: height,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: Dimensions.width15),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(Dimensions.radius15/3),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(Dimensions.width8),
                                      child: Row(
                                        children: [
                                          Text("Game Week : ", style: TextStyle(fontSize: Dimensions.font14, color: Colors.white),),
                                          Text(gameWeek.toString(), style: TextStyle(fontSize: Dimensions.font14, color: Colors.white),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: Dimensions.height1*5),
                                Padding(
                                  padding: EdgeInsets.only(left: Dimensions.width15),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(Dimensions.radius15/3),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(Dimensions.width8),
                                      child: Row(
                                        children: [
                                          Text("Total Points : ", style: TextStyle(fontSize: Dimensions.font14, color: Colors.white),),
                                          Text(totalPlayerPoints.toString(), style: TextStyle(fontSize: Dimensions.font14, color: Colors.white),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: Dimensions.width15),
                              child: Container(
                                  width: MediaQuery.of(context).size.width*0.5,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(Dimensions.radius15/3),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(Dimensions.width8),
                                    child: Center(
                                      child: Text(name??"",
                                        style: TextStyle(fontSize: Dimensions.font14, color: Colors.white),),
                                    ),
                                  )
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Dimensions.height1*5),
                        Column(
                          children: [
                            Stack(
                                children: [
                                  SizedBox(
                                    height: fieldH,
                                    width: width,
                                    child: Image.asset('assets/image/field.png', fit: BoxFit.fill,),),
                                  Player(image: !approved /*&& AppConstants.showImgData!="true"*/?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$gkPhoto.png', name: gkName??"--", top: 0.07272727 * fieldH, right: 0.0, left: 0.0, position: "GK", points: gkPoints??0,
                                    onTap: (){showSubCaptainDialogue(gkInt, "gk", "gk_sub", gkSubInt);}, captainBand: captain==gkInt&&captain!=0?Image.asset("assets/image/captain_img.png", height: Dimensions.height10,):Container(),),
                                  Player(image: !approved /*&& AppConstants.showImgData!="true"*/?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$rbPhoto.png', name: rbName??"--", top: 0.21818182 * fieldH, right: 0.70666667 * width, left: 0.0, position: "RB", points: rbPoints??0,
                                    onTap: (){showSubCaptainDialogue(rbInt, "rb", "def_sub", defSubInt);}, captainBand: captain==rbInt&&captain!=0?Image.asset("assets/image/captain_img.png", height: Dimensions.height10,):Container(),),
                                  Player(image: !approved /*&& AppConstants.showImgData!="true"*/?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$rCbPhoto.png', name: rCbName??"--", top: 0.23636364 * fieldH, right: 0.29333333 * width, left: 0.0, position: "CB", points: rCbPoints??0,
                                    onTap: (){showSubCaptainDialogue(rCbInt, "rcb", "def_sub", defSubInt);}, captainBand: captain==rCbInt&&captain!=0?Image.asset("assets/image/captain_img.png", height: Dimensions.height10,):Container(),),
                                  Player(image: !approved /*&& AppConstants.showImgData!="true"*/?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$lCbPhoto.png', name: lCbName??"--", top: 0.23636364 * fieldH, right: 0.0, left: 0.29333333 * width, position: "CB", points: lCbPoints??0,
                                    onTap: (){showSubCaptainDialogue(lCbInt, "lcb", "def_sub", defSubInt);}, captainBand: captain==lCbInt&&captain!=0?Image.asset("assets/image/captain_img.png", height: Dimensions.height10,):Container(),),
                                  Player(image: !approved /*&& AppConstants.showImgData!="true"*/?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$lbPhoto.png', name: lbName??"--", top: 0.21818182 * fieldH,right: 0.0, left: 0.70666667 * width, position: "LB", points: lbPoints??0,
                                    onTap: (){showSubCaptainDialogue(lbInt, "lb", "def_sub", defSubInt);}, captainBand: captain==lbInt&&captain!=0?Image.asset("assets/image/captain_img.png", height: Dimensions.height10,):Container(),),
                                  Player(image: !approved /*&& AppConstants.showImgData!="true"*/?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$rMdPhoto.png', name: rMdName??"--", top: 0.47272727 * fieldH, right: 0.0, left: 0.70666667 * width, position: "LMF", points: rMdPoints??0,
                                    onTap: (){showSubCaptainDialogue(rMidInt, "rmd", "mid_sub", midSubInt);}, captainBand: captain==rMidInt&&captain!=0?Image.asset("assets/image/captain_img.png", height: Dimensions.height10,):Container(),),
                                  Player(image: !approved /*&& AppConstants.showImgData!="true"*/?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$mdPhoto.png', name: mdName??"--", top: 0.45454545 * fieldH, right: 0.01333333 * width, left: 0.0, position: "AMF", points: mdPoints??0,
                                    onTap: (){showSubCaptainDialogue(midInt, "md", "mid_sub", midSubInt);}, captainBand: captain==midInt&&captain!=0?Image.asset("assets/image/captain_img.png", height: Dimensions.height10,):Container(),),
                                  Player(image: !approved /*&& AppConstants.showImgData!="true"*/?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$lMdPhoto.png', name: lMdName??"--", top: 0.47272727 * fieldH, right: 0.70666667 * width, left: 0.0, position: "RMF", points: lMdPoints??0,
                                    onTap: (){showSubCaptainDialogue(lMidInt, "lmd", "mid_sub", midSubInt);}, captainBand: captain==lMidInt&&captain!=0?Image.asset("assets/image/captain_img.png", height: Dimensions.height10,):Container(),),
                                  Player(image: !approved /*&& AppConstants.showImgData!="true"*/?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$rFwdPhoto.png', name: rFwdName??"--", top: 0.71 * fieldH, right: 0.29333333 * width, left: 0.29333333 * width, position: "CF", points: rFwdPoints??0,
                                    onTap: (){showSubCaptainDialogue(rFwdInt, "rfwd", "fwd_sub", fwdSubInt);}, captainBand: captain==rFwdInt&&captain!=0?Image.asset("assets/image/captain_img.png", height: Dimensions.height10,):Container(),),
                                  Player(image: !approved /*&& AppConstants.showImgData!="true"*/?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$fwdPhoto.png', name: fwdName??"--", top: 0.71 * fieldH, right: 0.5 * width, left: 0.0, position: "RWF", points: fwdPoints??0,
                                    onTap: (){showSubCaptainDialogue(fwdInt, "fwd", "fwd_sub", fwdSubInt);}, captainBand: captain==fwdInt&&captain!=0?Image.asset("assets/image/captain_img.png", height: Dimensions.height10,):Container(),),
                                  Player(image: !approved /*&& AppConstants.showImgData!="true"*/?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$lFwdPhoto.png', name: lFwdName??"--", top: 0.71 * fieldH, right: 0.1 * width, left: 0.65333333 * width, position: "LWF", points: lFwdPoints??0,
                                    onTap: (){showSubCaptainDialogue(lFwdInt, "lfwd", "fwd_sub", fwdSubInt);}, captainBand: captain==lFwdInt&&captain!=0?Image.asset("assets/image/captain_img.png", height: Dimensions.height10,):Container(),)
                                ]),
                            Container(
                              width: width,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(Dimensions.radius20/2)
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                reverse: true,
                                child: Padding(
                                  padding: EdgeInsets.only(left: Dimensions.width1*3, right: Dimensions.width1*3, top: Dimensions.height20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                          width: width*0.25,
                                          child: SubPlayer(image: !approved /*&& AppConstants.showImgData!="true"*/?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$gkSubPhoto.png', name: gkSubName??"--", position: "DEF", points: gkSubPoints??0,)),
                                      SizedBox(width: Dimensions.width5,),
                                      SizedBox(
                                          width: width*0.25,
                                          child: SubPlayer(image: !approved /*&& AppConstants.showImgData!="true"*/?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$defSubPhoto.png', name: defSubName??"--", position: "DEF", points: defSubPoints??0,)),
                                      SizedBox(width: Dimensions.width5,),
                                      SizedBox(
                                          width: width*0.25,
                                          child: SubPlayer(image: !approved /*&& AppConstants.showImgData!="true"*/?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$midSubPhoto.png', name: midSubName??"--", position: "MID", points: midSubPoints??0,)),
                                      SizedBox(width: Dimensions.width5,),
                                      SizedBox(
                                          width: width*0.25,
                                          child: SubPlayer(image: !approved /*&& AppConstants.showImgData!="true"*/?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$fwdSubPhoto.png', name: fwdSubName??"--", position: "FWD", points: fwdSubPoints??0,)),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ]),
            )),
          ),
        );
      }
    );
  }
  void showSubCaptainDialogue(int playerInt, String player, String benchPlayer, int benchPlayerInt) {
    showDialog(context: context, builder: (context) => AlertDialog(
      backgroundColor: Colors.transparent,
      content: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: ()async{
                Navigator.of(context).pop(false);
                try{
                  final collection = FirebaseFirestore.instance.collection('user_teams');
                  await collection.doc(auth.currentUser!.uid).update({
                    'captain': playerInt,
                  });
                }catch(e){ showCustomSnackBar(e.toString());}
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                maximumSize: Size(Dimensions.width10*11, Dimensions.height100),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/image/captain_img.png", height: Dimensions.height100/2,),
                  SizedBox(height: Dimensions.height1*5,),
                  Text("Captain", style: TextStyle(fontSize: Dimensions.font14),),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: ()async{
                Navigator.of(context).pop(false);
                try{
                  final collection = FirebaseFirestore.instance.collection('user_teams');
                  await collection.doc(auth.currentUser!.uid).update({
                    benchPlayer: playerInt,
                    player: benchPlayerInt,
                  });
                }catch(e){ showCustomSnackBar(e.toString());}
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                maximumSize: Size(Dimensions.width10*11, Dimensions.height100),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/image/sub_img.png", height: Dimensions.height100/2,),
                  SizedBox(height: Dimensions.height1*5,),
                  Text("Make Sub", style: TextStyle(fontSize: Dimensions.font14),),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
