import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pl_fantasy_online/base/custom_app_bar.dart';
import 'package:pl_fantasy_online/base/custom_snack_bar.dart';
import 'package:pl_fantasy_online/controllers/general_controller.dart';
import 'package:pl_fantasy_online/controllers/picks_controller.dart';
import 'package:pl_fantasy_online/helpers/route_helper.dart';
import 'package:pl_fantasy_online/utils/app_constants.dart';
import 'package:pl_fantasy_online/utils/colors.dart';
import 'package:pl_fantasy_online/utils/dimensions.dart';
import 'package:pl_fantasy_online/widgets/app_text_field.dart';
import 'package:pl_fantasy_online/widgets/create_player.dart';
import 'package:pl_fantasy_online/widgets/player.dart';
import 'package:pl_fantasy_online/widgets/sub_create_player.dart';
import 'package:pl_fantasy_online/widgets/sub_player.dart';


class CreateTeam extends StatefulWidget {
  const CreateTeam({Key? key}) : super(key: key);

  @override
  State<CreateTeam> createState() => _CreateTeamState();
}

class _CreateTeamState extends State<CreateTeam> {

  String  alias = "";
  num money = 0;
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

  List teamNames = [];
  List selectedPlayers = [];

  late String name;
  late String phone;
  late String fplId;

  final FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  PicksController picksController = Get.put(PicksController());

  //get document snapshots to check if team name exists
  getDocumentData () async {
    CollectionReference cat = FirebaseFirestore.instance.collection("user_teams");
    QuerySnapshot querySnapshot = await cat.get();
    final docData = querySnapshot.docs.map((doc) => doc.data()).toList();
    for (int i = 0; i < docData.length; i++) {
      Map aliasMap = docData[i] as Map;
      String aliasString = aliasMap["alias"];
      teamNames.add(aliasString.replaceAll(' ', '').toLowerCase());
    }
  }

  void firebaseGetData() async {
    await db.collection("user_data").doc(auth.currentUser!.uid).get().then((data){
      name = data["name"];
      phone = data["phone"];
      fplId = data["fpl_id"];
    });
  }

  late Stream<DocumentSnapshot> _userTeamStream;
  bool isLoaded = false;
  bool formOkay = false;


  TextEditingController teamNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    firebaseGetData();
    getDocumentData();

    _userTeamStream = db.collection("user_teams").doc(auth.currentUser?.uid).snapshots();
    teamNameController.text = "";
  }

  @override
  void dispose() {
    teamNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    List<int?>? idList;
    List<String?>? webNameList;
    List<int?>? photoList;
    List<double?>? playerPriceList;


    GeneralController generalController = Get.put(GeneralController());

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final double fieldH = 0.6773399 * height/1.15;

    idList = generalController.generalModel?.elements!.map((info) => info.id).toList();
    webNameList = generalController.generalModel?.elements!.map((info) => info.webName).toList();
    photoList = generalController.generalModel?.elements!.map((info) => info.code).toList();
    playerPriceList = generalController.generalModel?.elements!.map((info) => info.nowCost!/10).toList();

    final webNameMap = Map.fromIterables(idList??[], webNameList??[]);
    final photoMap = Map.fromIterables(idList??[], photoList??[]);
    final playerPriceMap = Map.fromIterables(idList??[], playerPriceList??[]);


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
      child: StreamBuilder<DocumentSnapshot>(
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
          alias = data?["alias"]??"";
          money = data?["money"]??0;
          gkData = data?["gk"]??0;
          rbData = data?["rb"]??0;
          rcbData = data?["rcb"]??0;
          lcbData = data?["lcb"]??0;
          lbData = data?["lb"]??0;
          rmdData = data?["rmd"]??0;
          mdData = data?["md"]??0;
          lmdData = data?["lmd"]??0;
          rfwdData = data?["rfwd"]??0;
          fwdData = data?["fwd"]??0;
          lfwdData = data?["lfwd"]??0;
          gkSubData = data?["gk_sub"]??0;
          defSubData = data?["def_sub"]??0;
          midSubData = data?["mid_sub"]??0;
          fwdSubData = data?["fwd_sub"]??0;

          var gk = webNameMap[gkData];
          var rb = webNameMap[rbData];
          var rCb = webNameMap[rcbData];
          var lCb = webNameMap[lcbData];
          var lb = webNameMap[lbData];
          var rMd = webNameMap[rmdData];
          var md = webNameMap[mdData];
          var lMd = webNameMap[lmdData];
          var rFwd = webNameMap[rfwdData];
          var fwd = webNameMap[fwdData];
          var lFwd = webNameMap[lfwdData];
          var gkSub = webNameMap[gkSubData];
          var defSub = webNameMap[defSubData];
          var midSub = webNameMap[midSubData];
          var fwdSub = webNameMap[fwdSubData];

          var gkPhoto = photoMap[gkData];
          var rbPhoto = photoMap[rbData];
          var rCbPhoto = photoMap[rcbData];
          var lCbPhoto = photoMap[lcbData];
          var lbPhoto = photoMap[lbData];
          var rMdPhoto = photoMap[rmdData];
          var mdPhoto = photoMap[mdData];
          var lMdPhoto = photoMap[lmdData];
          var rFwdPhoto = photoMap[rfwdData];
          var fwdPhoto = photoMap[fwdData];
          var lFwdPhoto = photoMap[lfwdData];
          var gkSubPhoto = photoMap[gkSubData];
          var defSubPhoto = photoMap[defSubData];
          var midSubPhoto = photoMap[midSubData];
          var fwdSubPhoto = photoMap[fwdSubData];

          var gkPrice = playerPriceMap[gkData];
          var rbPrice = playerPriceMap[rbData];
          var rCbPrice = playerPriceMap[rcbData];
          var lCbPrice = playerPriceMap[lcbData];
          var lbPrice = playerPriceMap[lbData];
          var rMdPrice = playerPriceMap[rmdData];
          var mdPrice = playerPriceMap[mdData];
          var lMdPrice = playerPriceMap[lmdData];
          var rFwdPrice = playerPriceMap[rfwdData];
          var fwdPrice = playerPriceMap[fwdData];
          var lFwdPrice = playerPriceMap[lfwdData];
          var gkSubPrice = playerPriceMap[gkSubData];
          var defSubPrice = playerPriceMap[defSubData];
          var midSubPrice = playerPriceMap[midSubData];
          var fwdSubPrice = playerPriceMap[fwdSubData];

          selectedPlayers.clear();
          selectedPlayers.addAll([gkData, rbData, rcbData, lcbData, lbData, rmdData, mdData,
              lmdData, rfwdData, fwdData, lfwdData, gkSubData, defSubData, midSubData, fwdSubData]);

          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: const CustomAppBar(title: 'Create Team',),
            floatingActionButton: alias==""?FloatingActionButton(
              onPressed: () {
                showEditNameDialogue();
              },
              tooltip: "Edit Team Name",
              child: const Icon(Icons.create),
            ):Container(),
            body: SafeArea(
                    child: Container(
                        margin: EdgeInsets.only(top: Dimensions.height15),
                        height: height,
                        child: ListView(
                            physics: const BouncingScrollPhysics(),
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: Dimensions.width15, right: Dimensions.width15, bottom: Dimensions.height15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(0.5),
                                              borderRadius: BorderRadius.circular(Dimensions.radius15/3),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(Dimensions.width8),
                                              child: Text("Balance: ${num.parse(money.toStringAsFixed(2))}m",
                                                style: TextStyle(fontSize: Dimensions.font14, fontWeight: FontWeight.bold, color: Colors.white),),
                                            )
                                        ),
                                        SizedBox(height: Dimensions.width5,),
                                        Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(0.5),
                                              borderRadius: BorderRadius.circular(Dimensions.radius15/3),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(Dimensions.width8),
                                              child: Text(alias!=""?alias:"Update Team Name",
                                                style: TextStyle(fontSize: Dimensions.font14, color: Colors.white),),
                                            )
                                        ),
                                      ],
                                    ),
                                    Obx(()=>picksController.isLoading.value? Container(
                                      margin: EdgeInsets.only(right: Dimensions.width50, bottom: Dimensions.height10),
                                      width:Dimensions.width20,
                                      height: Dimensions.width20,
                                      child: const CircularProgressIndicator(),
                                    )
                                        :GestureDetector(
                                        onTap: (){
                                          if(fplId.isEmpty){
                                            showCustomSnackBar("Kindly update FPL ID in account section", title: "FPL ID");
                                          }else{
                                            var gkDataFpl = picksController.picksModel?.picks![0].element??0;
                                            var rbDataFpl = picksController.picksModel?.picks![1].element??0;
                                            var rcbDataFpl = picksController.picksModel?.picks![2].element??0;
                                            var lcbDataFpl = picksController.picksModel?.picks![3].element??0;
                                            var lbDataFpl = picksController.picksModel?.picks![4].element??0;
                                            var rmdDataFpl = picksController.picksModel?.picks![5].element??0;
                                            var mdDataFpl = picksController.picksModel?.picks![6].element??0;
                                            var lmdDataFpl = picksController.picksModel?.picks![7].element??0;
                                            var rfwdDataFpl = picksController.picksModel?.picks![8].element??0;
                                            var fwdDataFpl = picksController.picksModel?.picks![9].element??0;
                                            var lfwdDataFpl = picksController.picksModel?.picks![10].element??0;
                                            var gkSubDataFpl = picksController.picksModel?.picks![11].element??0;
                                            var defSubDataFpl = picksController.picksModel?.picks![12].element??0;
                                            var midSubDataFpl = picksController.picksModel?.picks![13].element??0;
                                            var fwdSubDataFpl = picksController.picksModel?.picks![14].element??0;

                                            bool? gkIsCaptain = picksController.picksModel?.picks![0].isCaptain??false;
                                            bool? rbIsCaptain = picksController.picksModel?.picks![1].isCaptain??false;
                                            bool? rcbIsCaptain = picksController.picksModel?.picks![2].isCaptain??false;
                                            bool? lcbIsCaptain = picksController.picksModel?.picks![3].isCaptain??false;
                                            bool? lbIsCaptain = picksController.picksModel?.picks![4].isCaptain??false;
                                            bool? rmdIsCaptain = picksController.picksModel?.picks![5].isCaptain??false;
                                            bool? mdIsCaptain = picksController.picksModel?.picks![6].isCaptain??false;
                                            bool? lmdIsCaptain = picksController.picksModel?.picks![7].isCaptain??false;
                                            bool? rfwdIsCaptain = picksController.picksModel?.picks![8].isCaptain??false;
                                            bool? fwdIsCaptain = picksController.picksModel?.picks![9].isCaptain??false;
                                            bool? lfwdIsCaptain = picksController.picksModel?.picks![10].isCaptain??false;

                                            var gkPriceFpl = playerPriceMap[gkDataFpl]??0;
                                            var rbPriceFpl = playerPriceMap[rbDataFpl]??0;
                                            var rCbPriceFpl = playerPriceMap[rcbDataFpl]??0;
                                            var lCbPriceFpl = playerPriceMap[lcbDataFpl]??0;
                                            var lbPriceFpl = playerPriceMap[lbDataFpl]??0;
                                            var rMdPriceFpl = playerPriceMap[rmdDataFpl]??0;
                                            var mdPriceFpl = playerPriceMap[mdDataFpl]??0;
                                            var lMdPriceFpl = playerPriceMap[lmdDataFpl]??0;
                                            var rFwdPriceFpl = playerPriceMap[rfwdDataFpl]??0;
                                            var fwdPriceFpl = playerPriceMap[fwdDataFpl]??0;
                                            var lFwdPriceFpl = playerPriceMap[lfwdDataFpl]??0;
                                            var gkSubPriceFpl = playerPriceMap[gkSubDataFpl]??0;
                                            var defSubPriceFpl = playerPriceMap[defSubDataFpl]??0;
                                            var midSubPriceFpl = playerPriceMap[midSubDataFpl]??0;
                                            var fwdSubPriceFpl = playerPriceMap[fwdSubDataFpl]??0;

                                            var gkPrice = playerPriceMap[gkData]??0;
                                            var rbPrice = playerPriceMap[rbData]??0;
                                            var rCbPrice = playerPriceMap[rcbData]??0;
                                            var lCbPrice = playerPriceMap[lcbData]??0;
                                            var lbPrice = playerPriceMap[lbData]??0;
                                            var rMdPrice = playerPriceMap[rmdData]??0;
                                            var mdPrice = playerPriceMap[mdData]??0;
                                            var lMdPrice = playerPriceMap[lmdData]??0;
                                            var rFwdPrice = playerPriceMap[rfwdData]??0;
                                            var fwdPrice = playerPriceMap[fwdData]??0;
                                            var lFwdPrice = playerPriceMap[lfwdData]??0;
                                            var gkSubPrice = playerPriceMap[gkSubData]??0;
                                            var defSubPrice = playerPriceMap[defSubData]??0;
                                            var midSubPrice = playerPriceMap[midSubData]??0;
                                            var fwdSubPrice = playerPriceMap[fwdSubData]??0;

                                            var currentTeamPrice = gkPrice+rbPrice+rCbPrice+lCbPrice+lbPrice
                                                +rMdPrice+mdPrice+lMdPrice+rFwdPrice+fwdPrice+lFwdPrice
                                                +gkSubPrice+defSubPrice+midSubPrice+fwdSubPrice;

                                            var fplTeamPrice = gkPriceFpl+rbPriceFpl+rCbPriceFpl+lCbPriceFpl+lbPriceFpl
                                                +rMdPriceFpl+mdPriceFpl+lMdPriceFpl+rFwdPriceFpl+fwdPriceFpl+lFwdPriceFpl
                                                +gkSubPriceFpl+defSubPriceFpl+midSubPriceFpl+fwdSubPriceFpl;

                                            var price = (money+currentTeamPrice)-fplTeamPrice;

                                            int? captain;

                                            if(gkIsCaptain){
                                              captain = gkDataFpl;
                                            }else if(rbIsCaptain){captain = rbDataFpl;}else if(rcbIsCaptain){captain = rcbDataFpl;}else if(lcbIsCaptain){captain = lcbDataFpl;}
                                            else if(lbIsCaptain){captain = lbDataFpl;}else if(rmdIsCaptain){captain = rmdDataFpl;}else if(mdIsCaptain){captain = mdDataFpl;}
                                            else if(lmdIsCaptain){captain = lmdDataFpl;}else if(rfwdIsCaptain){captain = rfwdDataFpl;}else if(fwdIsCaptain){captain = fwdDataFpl;}
                                            else if(lfwdIsCaptain){captain = lfwdDataFpl;}


                                            if(fplTeamPrice>money+currentTeamPrice){
                                              showCustomSnackBar("Balance insufficient to import team", title: "Oops");
                                            }else{
                                              uploadTeamData(gkDataFpl,rbDataFpl,rcbDataFpl,lcbDataFpl,lbDataFpl,rmdDataFpl,
                                                  mdDataFpl,lmdDataFpl,rfwdDataFpl,fwdDataFpl,lfwdDataFpl,
                                                  gkSubDataFpl,defSubDataFpl,midSubDataFpl,fwdSubDataFpl,price,captain);
                                              showCustomSnackBar("Process completed (or no FPL team history)", title: "Success");}
                                          }},

                                        child: Padding(
                                          padding: EdgeInsets.only(bottom: Dimensions.height25),
                                          child: Row(
                                            children: [
                                              Image.asset('assets/image/fpl_logo.png', width: Dimensions.width50,),
                                              Container(
                                                width: Dimensions.width20*6,
                                                decoration: BoxDecoration(color: Colors.black.withOpacity(0.5),
                                                    borderRadius: BorderRadius.only(topRight: Radius.circular(Dimensions.radius15/3),
                                                    bottomRight: Radius.circular(Dimensions.radius15/3)),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(Dimensions.width5),
                                                  child: Text("Import FPL Team",
                                                    style: TextStyle(fontSize: Dimensions.font12, fontStyle: FontStyle.italic, color: Colors.white),),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
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
                                        gkData==0?CreatePlayer(image: 'assets/image/jersey_gk.png', top: 0.07272727 * fieldH, right: 0.0, left: 0.0, position: "GK",
                                          onTap: () {Get.toNamed(RouteHelper.getPickTeamPage(), arguments: [1, money, "GK", "gk", selectedPlayers]);},):
                                        Player(image: AppConstants.showImgData!="true"?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$gkPhoto.png', name: gk??"--", top: 0.07272727 * fieldH, right: 0.0, left: 0.0, position: "GK", points: null,
                                          onTap: () {Get.toNamed(RouteHelper.getEditTeamPage(), arguments: [1, money, "GK", "gk", gkPrice, selectedPlayers]);}, captainBand: Container(),),
                                        rbData==0?CreatePlayer(image: 'assets/image/jersey_img.png', top: 0.21818182 * fieldH, right: 0.70666667 * width, left: 0.0, position: "RB",
                                          onTap: () {Get.toNamed(RouteHelper.getPickTeamPage(), arguments: [2, money, "DEF", "rb", selectedPlayers]);},):
                                        Player(image: AppConstants.showImgData!="true"?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$rbPhoto.png', name: rb??"--", top: 0.21818182 * fieldH, right: 0.70666667 * width, left: 0.0, position: "RB", points:null,
                                          onTap: () {Get.toNamed(RouteHelper.getEditTeamPage(), arguments: [2, money, "DEF", "rb", rbPrice, selectedPlayers]);}, captainBand: Container(),),
                                        rcbData==0?CreatePlayer(image: 'assets/image/jersey_img.png', top: 0.23636364 * fieldH, right: 0.29333333 * width, left: 0.0, position: "CB",
                                          onTap: () {Get.toNamed(RouteHelper.getPickTeamPage(), arguments: [2, money, "DEF", "rcb", selectedPlayers]);},):
                                        Player(image: AppConstants.showImgData!="true"?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$rCbPhoto.png', name: rCb??"--", top: 0.23636364 * fieldH, right: 0.29333333 * width, left: 0.0, position: "CB", points:null,
                                          onTap: () {Get.toNamed(RouteHelper.getEditTeamPage(), arguments: [2, money, "DEF", "rcb", rCbPrice, selectedPlayers]);}, captainBand: Container(),),
                                        lcbData==0?CreatePlayer(image: 'assets/image/jersey_img.png', top: 0.23636364 * fieldH, right: 0.0, left: 0.29333333 * width, position: "CB",
                                          onTap: () {Get.toNamed(RouteHelper.getPickTeamPage(), arguments: [2, money, "DEF", "lcb", selectedPlayers]);},):
                                        Player(image: AppConstants.showImgData!="true"?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$lCbPhoto.png', name: lCb??"--", top: 0.23636364 * fieldH, right: 0.0, left: 0.29333333 * width, position: "CB", points:null,
                                          onTap: () {Get.toNamed(RouteHelper.getEditTeamPage(), arguments: [2, money, "DEF", "lcb", lCbPrice, selectedPlayers]);}, captainBand: Container(),),
                                        lbData==0?CreatePlayer(image: 'assets/image/jersey_img.png', top: 0.21818182 * fieldH,right: 0.0, left: 0.70666667 * width, position: "LB",
                                          onTap: () {Get.toNamed(RouteHelper.getPickTeamPage(), arguments: [2, money, "DEF", "lb", selectedPlayers]);},):
                                        Player(image: AppConstants.showImgData!="true"?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$lbPhoto.png', name: lb??"--", top: 0.21818182 * fieldH,right: 0.0, left: 0.70666667 * width, position: "LB", points:null,
                                          onTap: () {Get.toNamed(RouteHelper.getEditTeamPage(), arguments: [2, money, "DEF", "lb", lbPrice, selectedPlayers]);}, captainBand: Container(),),
                                        rmdData==0?CreatePlayer(image: 'assets/image/jersey_img.png', top: 0.47272727 * fieldH, right: 0.0, left: 0.70666667 * width, position: "LMF",
                                          onTap: () {Get.toNamed(RouteHelper.getPickTeamPage(), arguments: [3, money, "MID", "rmd", selectedPlayers]);},):
                                        Player(image: AppConstants.showImgData!="true"?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$rMdPhoto.png', name: rMd??"--", top: 0.47272727 * fieldH, right: 0.0, left: 0.70666667 * width, position: "LMF", points:null,
                                          onTap: () {Get.toNamed(RouteHelper.getEditTeamPage(), arguments: [3, money, "MID", "rmd", rMdPrice, selectedPlayers]);}, captainBand: Container(),),
                                        mdData==0?CreatePlayer(image: 'assets/image/jersey_img.png', top: 0.45454545 * fieldH, right: 0.01333333 * width, left: 0.0, position: "AMF",
                                          onTap: () {Get.toNamed(RouteHelper.getPickTeamPage(), arguments: [3, money, "MID", "md", selectedPlayers]);},):
                                        Player(image: AppConstants.showImgData!="true"?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$mdPhoto.png', name: md??"--", top: 0.45454545 * fieldH, right: 0.01333333 * width, left: 0.0, position: "AMF", points:null,
                                          onTap: () {Get.toNamed(RouteHelper.getEditTeamPage(), arguments: [3, money, "MID", "md", mdPrice, selectedPlayers]);}, captainBand: Container(),),
                                        lmdData==0?CreatePlayer(image: 'assets/image/jersey_img.png', top: 0.47272727 * fieldH, right: 0.70666667 * width, left: 0.0, position: "RMF",
                                          onTap: () {Get.toNamed(RouteHelper.getPickTeamPage(), arguments: [3, money, "MID", "lmd", selectedPlayers]);},):
                                        Player(image: AppConstants.showImgData!="true"?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$lMdPhoto.png', name: lMd??"--", top: 0.47272727 * fieldH, right: 0.70666667 * width, left: 0.0, position: "RMF", points:null,
                                          onTap: () {Get.toNamed(RouteHelper.getEditTeamPage(), arguments: [3, money, "MID", "lmd", lMdPrice, selectedPlayers]);}, captainBand: Container(),),
                                        rfwdData==0?CreatePlayer(image: 'assets/image/jersey_img.png', top: 0.69090909 * fieldH, right: 0.29333333 * width, left: 0.29333333 * width, position: "CF",
                                          onTap: () {Get.toNamed(RouteHelper.getPickTeamPage(), arguments: [4, money, "FWD", "rfwd", selectedPlayers]);},):
                                        Player(image: AppConstants.showImgData!="true"?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$rFwdPhoto.png', name: rFwd??"--", top: 0.69090909 * fieldH, right: 0.29333333 * width, left: 0.29333333 * width, position: "CF", points:null,
                                          onTap: () {Get.toNamed(RouteHelper.getEditTeamPage(), arguments: [4, money, "FWD", "rfwd", rFwdPrice, selectedPlayers]);}, captainBand: Container(),),
                                        fwdData==0?CreatePlayer(image: 'assets/image/jersey_img.png', top: 0.69090909 * fieldH, right: 0.5 * width, left: 0.0, position: "RWF",
                                          onTap: () {Get.toNamed(RouteHelper.getPickTeamPage(), arguments: [4, money, "FWD", "fwd", selectedPlayers]);},):
                                        Player(image: AppConstants.showImgData!="true"?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$fwdPhoto.png', name: fwd??"--", top: 0.69090909 * fieldH, right: 0.5 * width, left: 0.0, position: "RWF", points:null,
                                          onTap: () {Get.toNamed(RouteHelper.getEditTeamPage(), arguments: [4, money, "FWD", "fwd", fwdPrice, selectedPlayers]);}, captainBand: Container(),),
                                        lfwdData==0?CreatePlayer(image: 'assets/image/jersey_img.png', top: 0.69090909 * fieldH, right: 0.1 * width, left: 0.65333333 * width, position: "LWF",
                                          onTap: () {Get.toNamed(RouteHelper.getPickTeamPage(), arguments: [4, money, "FWD", "lfwd", selectedPlayers]);},):
                                        Player(image: AppConstants.showImgData!="true"?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$lFwdPhoto.png', name: lFwd??"--", top: 0.69090909 * fieldH, right: 0.1 * width, left: 0.65333333 * width, position: "LWF", points:null,
                                          onTap: () {Get.toNamed(RouteHelper.getEditTeamPage(), arguments: [4, money, "FWD", "lfwd", lFwdPrice, selectedPlayers]);}, captainBand: Container(),)
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
                                              child: gkSubData==0?SubCreatePlayer(image: 'assets/image/jersey_gk.png', position: "DEF",
                                                onTap: () {Get.toNamed(RouteHelper.getPickTeamPage(), arguments: [1, money, "GK", "gk_sub", selectedPlayers]);},):
                                              SubPlayer(image: AppConstants.showImgData!="true"?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$gkSubPhoto.png', name: gkSub??"--", position: "DEF", points:null,
                                                onTap: () {Get.toNamed(RouteHelper.getEditTeamPage(), arguments: [1, money, "GK", "gk_sub", gkSubPrice, selectedPlayers]);},),
                                            ),
                                            SizedBox(width: Dimensions.width5,),
                                            SizedBox(
                                              width: width*0.25,
                                              child: defSubData==0?SubCreatePlayer(image: 'assets/image/jersey_img.png', position: "DEF",
                                                onTap: () {Get.toNamed(RouteHelper.getPickTeamPage(), arguments: [2, money, "DEF", "def_sub", selectedPlayers]);},):
                                              SubPlayer(image: AppConstants.showImgData!="true"?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$defSubPhoto.png', name: defSub??"--", position: "DEF", points:null,
                                                onTap: () {Get.toNamed(RouteHelper.getEditTeamPage(), arguments: [2, money, "DEF", "def_sub", defSubPrice, selectedPlayers]);},),
                                            ),
                                            SizedBox(width: Dimensions.width5,),
                                            SizedBox(
                                              width: width*0.25,
                                              child: midSubData==0?SubCreatePlayer(image: 'assets/image/jersey_img.png', position: "MID",
                                                onTap: () {Get.toNamed(RouteHelper.getPickTeamPage(), arguments: [3, money, "MID", "mid_sub", selectedPlayers]);},):
                                              SubPlayer(image: AppConstants.showImgData!="true"?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$midSubPhoto.png', name: midSub??"--", position: "MID", points:null,
                                                onTap: () {Get.toNamed(RouteHelper.getEditTeamPage(), arguments: [3, money, "MID", "mid_sub", midSubPrice, selectedPlayers]);},),
                                            ),
                                            SizedBox(width: Dimensions.width5,),
                                            SizedBox(
                                              width: width*0.25,
                                              child: fwdSubData==0?SubCreatePlayer(image: 'assets/image/jersey_img.png', position: "FWD",
                                                onTap: () {Get.toNamed(RouteHelper.getPickTeamPage(), arguments: [4, money, "FWD", "fwd_sub", selectedPlayers]);},):
                                              SubPlayer(image: AppConstants.showImgData!="true"?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$fwdSubPhoto.png', name: fwdSub??"--", position: "FWD", points:null,
                                                onTap: () {Get.toNamed(RouteHelper.getEditTeamPage(), arguments: [4, money, "FWD", "fwd_sub", fwdSubPrice, selectedPlayers]);},),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ]),
                    )),
          );
        }
      ),
    );
  }

  void showEditNameDialogue() {
    showDialog(context: context, builder: (context) => AlertDialog(
      title: const Text("Update Team Name", style: TextStyle(color: Colors.black),),
      content: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: AppTextField(
          textEditingController: teamNameController,
          hintText: 'Team Name',
          icon: Icons.edit,
          textInputType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: (){
            Navigator.of(context).pop(false);
            teamNameController.clear();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mainColor,
          ),
          child: const Text('Close'),
        ),
        ElevatedButton(
          onPressed: () {
            teamNameFormCheck();
            Future.delayed(const Duration(seconds: 1), (){
              if(name.isEmpty || phone.isEmpty){
                showCustomSnackBar("Kindly update details in account page", title: "Missing Details");
              }else{
                if(formOkay){
                  try{
                    FirebaseFirestore.instance.collection('user_teams')
                        .doc(auth.currentUser!.uid).update({
                      'alias': teamNameController.text.trim()})
                        .then((_) => showCustomSnackBar(title: "Success", "Team Name Updated Successfully"));
                  }catch(e){debugPrint(e.toString());}
                  Navigator.of(context).pop(false);
                  teamNameController.clear();
                }
              }
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mainColor,
          ),
          //return false when click on "NO"
          child: const Text('Update'),
        ),
      ],
    ));
  }

  void teamNameFormCheck(){
    String name = teamNameController.text.trim();
    if(name.isEmpty){
      showCustomSnackBar("Type in your team name", title: "Team Name");
      formOkay = false;
    }else if(name.length>20){
      showCustomSnackBar("Team name too long", title: "Team Name");
      formOkay = false;
    }else if(teamNames.contains(name.replaceAll(' ', '').toLowerCase())){
      showCustomSnackBar("Team name already taken", title: "Team Name");
      formOkay = false;
    }else{
      formOkay = true;
    }
  }

  void uploadTeamData(gk,rb,rcb,lcb,lb,rmd,md,lmd,rfwd,fwd,lfwd,
      gkSubDataFpl,defSubDataFpl,midSubDataFpl,fwdSubDataFpl,price,captain) async{
    try{
      final collection = FirebaseFirestore.instance.collection('user_teams');
      await collection.doc(auth.currentUser!.uid).update({
        'gk': gk,
        'rb': rb,
        'rcb': rcb,
        'lcb': lcb,
        'lb': lb,
        'rmd': rmd,
        'md': md,
        'lmd': lmd,
        'rfwd': rfwd,
        'fwd': fwd,
        'lfwd': lfwd,
        'gk_sub': gkSubDataFpl,
        'def_sub': defSubDataFpl,
        'mid_sub': midSubDataFpl,
        'fwd_sub': fwdSubDataFpl,
        'captain': captain,
        'money': price,
      });
    }catch(e){ showCustomSnackBar(e.toString());}
  }
}
