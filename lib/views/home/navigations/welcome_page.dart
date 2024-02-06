import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pl_fantasy_online/base/custom_loader.dart';
import 'package:pl_fantasy_online/controllers/dream_team_controller.dart';
import 'package:pl_fantasy_online/controllers/fixture_controller.dart';
import 'package:pl_fantasy_online/controllers/general_controller.dart';
import 'package:pl_fantasy_online/controllers/upcoming_fixture_controller.dart';
import 'package:pl_fantasy_online/helpers/route_helper.dart';
//import 'package:pl_fantasy_online/utils/app_constants.dart';
import 'package:pl_fantasy_online/utils/dimensions.dart';
import 'package:pl_fantasy_online/widgets/dream_player.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin{

  @override
  bool get wantKeepAlive => true;

  final FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  late bool approved;
  late TabController tabController;

  bool isLoaded = false;

  void firebaseGetData() async {
    await db.collection("user_data").doc(auth.currentUser!.uid).get().then((data){
      approved = data["approved"];
    });
    setState(() {
      isLoaded = true;
    });
  }

  DreamTeamController dreamTeamController = Get.put(DreamTeamController());
  GeneralController generalController = Get.put(GeneralController());
  FixtureController fixtureController = Get.put(FixtureController());
  UpcomingFixtureController upcomingFixtureController = Get.put(UpcomingFixtureController());

  List<int?>? idList;
  List<String?>? webNameList;
  List<int?>? photoList;
  List<int?>? teamIdList;
  List<String?>? teamNameList;
  List<int?>? teamPhotoList;

  // String  alias = "";
  // int gkData = 0;
  // int rbData = 0;
  // int rcbData = 0;
  // int lcbData = 0;
  // int lbData = 0;
  // int rmdData = 0;
  // int mdData = 0;
  // int lmdData = 0;
  // int rfwdData = 0;
  // int fwdData = 0;
  // int lfwdData = 0;

  @override
  void initState() {
    super.initState();
    firebaseGetData();
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    approved = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final double fieldH = 0.6773399 * height/1.5;

    idList = generalController.generalModel?.elements!.map((info) => info.id).toList();
    webNameList = generalController.generalModel?.elements!.map((info) => info.webName).toList();
    photoList = generalController.generalModel?.elements!.map((info) => info.code).toList();
    teamIdList = generalController.generalModel?.teams!.map((info) => info.id).toList();
    teamNameList = generalController.generalModel?.teams!.map((info) => info.name).toList();
    teamPhotoList = generalController.generalModel?.teams!.map((info) => info.code).toList();

    final webNameMap = Map.fromIterables(idList??[], webNameList??[]);
    final photoMap = Map.fromIterables(idList??[], photoList??[]);
    final teamNameMap = Map.fromIterables(teamIdList??[], teamNameList??[]);
    final teamPhotoMap = Map.fromIterables(teamIdList??[], teamPhotoList??[]);

    var gkInt = dreamTeamController.dreamTeamModel?.team![0].element;
    var rbInt = dreamTeamController.dreamTeamModel?.team![1].element;
    var rCbInt = dreamTeamController.dreamTeamModel?.team![2].element;
    var lCbInt = dreamTeamController.dreamTeamModel?.team![3].element;
    var lbInt = dreamTeamController.dreamTeamModel?.team![4].element;
    var rMidInt = dreamTeamController.dreamTeamModel?.team![5].element;
    var midInt = dreamTeamController.dreamTeamModel?.team![6].element;
    var lMidInt = dreamTeamController.dreamTeamModel?.team![7].element;
    var rFwdInt = dreamTeamController.dreamTeamModel?.team![8].element;
    var fwdInt = dreamTeamController.dreamTeamModel?.team![9].element;
    var lFwdInt = dreamTeamController.dreamTeamModel?.team![10].element;

    var gkPoints = dreamTeamController.dreamTeamModel?.team![0].points;
    var rbPoints = dreamTeamController.dreamTeamModel?.team![1].points;
    var rCbPoints = dreamTeamController.dreamTeamModel?.team![2].points;
    var lCbPoints = dreamTeamController.dreamTeamModel?.team![3].points;
    var lbPoints = dreamTeamController.dreamTeamModel?.team![4].points;
    var rMidPoints = dreamTeamController.dreamTeamModel?.team![5].points;
    var midPoints = dreamTeamController.dreamTeamModel?.team![6].points;
    var lMidPoints = dreamTeamController.dreamTeamModel?.team![7].points;
    var rFwdPoints = dreamTeamController.dreamTeamModel?.team![8].points;
    var fwdPoints = dreamTeamController.dreamTeamModel?.team![9].points;
    var lFwdPoints = dreamTeamController.dreamTeamModel?.team![10].points;

    var gk = webNameMap[gkInt];
    var rb = webNameMap[rbInt];
    var rCb = webNameMap[rCbInt];
    var lCb = webNameMap[lCbInt];
    var lb = webNameMap[lbInt];
    var rMd = webNameMap[rMidInt];
    var md = webNameMap[midInt];
    var lMd = webNameMap[lMidInt];
    var rFwd = webNameMap[rFwdInt];
    var fwd = webNameMap[fwdInt];
    var lFwd = webNameMap[lFwdInt];

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


    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(Dimensions.width10),
            child: Text("Welcome to PL Fantasy Online",
              style: TextStyle(fontSize: Dimensions.font16, fontWeight: FontWeight.bold, color: Colors.white),),
          ),
          Padding(
            padding: EdgeInsets.only(left: Dimensions.width10, right: Dimensions.width10, bottom: Dimensions.width8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: (){Get.toNamed(RouteHelper.getCreateTeamPage());},
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.20,
                    width: MediaQuery.of(context).size.width*0.47,
                    decoration: BoxDecoration(
                      color: Colors.white54.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(Dimensions.radius20/2),
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(Dimensions.width1*2),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height*0.16,
                              width: MediaQuery.of(context).size.width*0.47,
                              child: ClipRRect(
                                child: Image.asset('assets/image/create_team.png'),
                              ),
                            ),
                          ),
                          Text("Create Team", style: TextStyle(fontSize: Dimensions.font12, fontWeight: FontWeight.bold, color: Colors.white),)
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){Get.toNamed(RouteHelper.getMyTeamPage());},
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.20,
                    width: MediaQuery.of(context).size.width*0.47,
                    decoration: BoxDecoration(
                      color: Colors.white54.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(Dimensions.radius20/2),
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(Dimensions.width1*2),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height*0.16,
                              width: MediaQuery.of(context).size.width*0.47,
                              child: ClipRRect(
                                child: Image.asset('assets/icon/team_icon.png'),
                              ),
                            ),
                          ),
                          Text("My Team", style: TextStyle(fontSize: Dimensions.font12, fontWeight: FontWeight.bold, color: Colors.white),)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          isLoaded && approved /*&& AppConstants.showImgData == "true"*/?Padding(
            padding: EdgeInsets.all(Dimensions.width10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Fixtures",
                  style: TextStyle(fontSize: Dimensions.font16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),),
                SizedBox(height: Dimensions.height1*7,),
                Container(
                  height: MediaQuery.of(context).size.height*0.35,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(Dimensions.radius20/2),
                  ),
                  child: Column(
                    children: [
                      TabBar(
                        controller: tabController,
                        indicatorWeight: 1.0,
                        indicatorColor: Colors.white.withOpacity(0.4),
                        tabs: [
                          Padding(
                            padding: EdgeInsets.all(Dimensions.width8),
                            child: Text("Current", style: TextStyle(fontSize: Dimensions.font16,)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(Dimensions.width8),
                            child: Text("Upcoming", style: TextStyle(fontSize: Dimensions.font16,)),
                          ),
                        ],
                      ),
                      Expanded(
                        flex: 1,
                        child: TabBarView(
                          controller: tabController,
                          children: [
                            Obx(()=>fixtureController.isLoading.value?const Center(child: CustomLoader()):
                            ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: fixtureController.fixtureModel?.fixtures!.length,
                                itemBuilder: (context, index){
                                  return Padding(
                                    padding: EdgeInsets.all(Dimensions.width8),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(Dimensions.radius15/3),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(Dimensions.width8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                if (fixtureController.fixtureModel?.fixtures![index].teamH != null) SizedBox(
                                                  width: Dimensions.width30,
                                                  child: CachedNetworkImage(
                                                    imageUrl: "https://resources.premierleague.com/premierleague/badges/t${teamPhotoMap[fixtureController.fixtureModel?.fixtures![index].teamH]}.png",
                                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                                    fit: BoxFit.cover,
                                                    height: Dimensions.height30,
                                                  ),
                                                ) else Container(),
                                                SizedBox(width: Dimensions.width10,),
                                                if (fixtureController.fixtureModel?.fixtures![index].teamH != null) SizedBox(width: Dimensions.width10*4, child: Text(teamNameMap[fixtureController.fixtureModel?.fixtures![index].teamH]??"--",
                                                  style: TextStyle(fontSize: Dimensions.font14, color: Colors.white),)) else Container(),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                if (fixtureController.fixtureModel?.fixtures![index].teamHScore!=null) Container(
                                                    width: Dimensions.width30,
                                                    padding: EdgeInsets.all(Dimensions.width1),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white.withOpacity(0.6),
                                                      borderRadius: BorderRadius.circular(Dimensions.radius20/10),
                                                    ),
                                                    child: Center(
                                                      child: Text(fixtureController.fixtureModel?.fixtures![index].teamHScore.toString()??"", style: const TextStyle(
                                                        color: Colors.black, fontWeight: FontWeight.bold,
                                                      ),),
                                                    )) else Container(),
                                                SizedBox(width: Dimensions.width10,),
                                                const Text("vs", style: TextStyle(color: Colors.white),),
                                                SizedBox(width: Dimensions.width10,),
                                                if (fixtureController.fixtureModel?.fixtures![index].teamAScore!=null) Container(
                                                    width: Dimensions.width30,
                                                    padding: EdgeInsets.all(Dimensions.width1),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white.withOpacity(0.6),
                                                      borderRadius: BorderRadius.circular(Dimensions.radius20/10),
                                                    ),
                                                    child: Center(
                                                      child: Text(fixtureController.fixtureModel?.fixtures![index].teamAScore.toString()??"", style: const TextStyle(
                                                        color: Colors.black, fontWeight: FontWeight.bold,
                                                      ),),
                                                    )) else Container(),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                if (fixtureController.fixtureModel?.fixtures![index].teamA != null) SizedBox(width: Dimensions.width10*4, child: Text(teamNameMap[fixtureController.fixtureModel?.fixtures![index].teamA]??"--",
                                                  style: TextStyle(fontSize: Dimensions.font14, color: Colors.white), textDirection: TextDirection.rtl,)) else Container(),
                                                SizedBox(width: Dimensions.width10,),
                                                if (fixtureController.fixtureModel?.fixtures![index].teamA != null) SizedBox(
                                                  width: Dimensions.width30,
                                                  child: CachedNetworkImage(
                                                    imageUrl: "https://resources.premierleague.com/premierleague/badges/t${teamPhotoMap[fixtureController.fixtureModel?.fixtures![index].teamA]}.png",
                                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                                    fit: BoxFit.cover,
                                                    height: Dimensions.height30,
                                                  ),
                                                ) else Container(),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                            ),
                            Obx(()=>upcomingFixtureController.isLoading.value?const Center(child: CustomLoader()):
                            ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: upcomingFixtureController.fixtureModel?.fixtures!.length,
                                itemBuilder: (context, index){
                                  return Padding(
                                    padding: EdgeInsets.all(Dimensions.width8),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(Dimensions.radius15/3),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(Dimensions.width8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                if (upcomingFixtureController.fixtureModel?.fixtures![index].teamH != null) SizedBox(
                                                  width: Dimensions.width30,
                                                  child: CachedNetworkImage(
                                                    imageUrl: "https://resources.premierleague.com/premierleague/badges/t${teamPhotoMap[upcomingFixtureController.fixtureModel?.fixtures![index].teamH]}.png",
                                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                                    fit: BoxFit.cover,
                                                    height: Dimensions.height30,
                                                  ),
                                                ) else Container(),
                                                SizedBox(width: Dimensions.width10,),
                                                if (upcomingFixtureController.fixtureModel?.fixtures![index].teamH != null) SizedBox(width: Dimensions.width10*4, child: Text(teamNameMap[upcomingFixtureController.fixtureModel?.fixtures![index].teamH]??"--",
                                                  style: TextStyle(fontSize: Dimensions.font14, color: Colors.white),)) else Container(),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                if (upcomingFixtureController.fixtureModel?.fixtures![index].teamHScore!=null) Container(
                                                    width: Dimensions.width30,
                                                    padding: EdgeInsets.all(Dimensions.width1),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white.withOpacity(0.6),
                                                      borderRadius: BorderRadius.circular(Dimensions.radius20/10),
                                                    ),
                                                    child: Center(
                                                      child: Text(upcomingFixtureController.fixtureModel?.fixtures![index].teamHScore.toString()??"", style: const TextStyle(
                                                        color: Colors.black, fontWeight: FontWeight.bold,
                                                      ),),
                                                    )) else Container(),
                                                SizedBox(width: Dimensions.width10,),
                                                const Text("vs", style: TextStyle(color: Colors.white),),
                                                SizedBox(width: Dimensions.width10,),
                                                if (upcomingFixtureController.fixtureModel?.fixtures![index].teamAScore!=null) Container(
                                                    width: Dimensions.width30,
                                                    padding: EdgeInsets.all(Dimensions.width1),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white.withOpacity(0.6),
                                                      borderRadius: BorderRadius.circular(Dimensions.radius20/10),
                                                    ),
                                                    child: Center(
                                                      child: Text(upcomingFixtureController.fixtureModel?.fixtures![index].teamAScore.toString()??"", style: const TextStyle(
                                                        color: Colors.black, fontWeight: FontWeight.bold,
                                                      ),),
                                                    )) else Container(),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                if (upcomingFixtureController.fixtureModel?.fixtures![index].teamA != null) SizedBox(width: Dimensions.width10*4, child: Text(teamNameMap[upcomingFixtureController.fixtureModel?.fixtures![index].teamA]??"--",
                                                  style: TextStyle(fontSize: Dimensions.font14, color: Colors.white), textDirection: TextDirection.rtl,)) else Container(),
                                                SizedBox(width: Dimensions.width10,),
                                                if (upcomingFixtureController.fixtureModel?.fixtures![index].teamA != null) SizedBox(
                                                  width: Dimensions.width30,
                                                  child: CachedNetworkImage(
                                                    imageUrl: "https://resources.premierleague.com/premierleague/badges/t${teamPhotoMap[upcomingFixtureController.fixtureModel?.fixtures![index].teamA]}.png",
                                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                                    fit: BoxFit.cover,
                                                    height: Dimensions.height30,
                                                  ),
                                                ) else Container(),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ):Container(),
          isLoaded?Padding(
            padding: EdgeInsets.all(Dimensions.width10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Top Performers",
                  style: TextStyle(fontSize: Dimensions.font16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),),
                SizedBox(height: Dimensions.height1*7,),
                Container(
                  height: MediaQuery.of(context).size.height*0.45,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(Dimensions.radius20/2),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child:
                    Obx(()=>dreamTeamController.isLoading.value?const Center(child: CustomLoader()):
                          Stack(
                              children: [
                            SizedBox(
                              height: fieldH,
                              width: width,
                              child: Image.asset('assets/image/field.png', fit: BoxFit.fill,),),
                                if (gkInt!=null) DreamPlayer(image: !approved /*&& AppConstants.showImgData!="true"*/?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$gkPhoto.png', name: gk??"--", top: 0.07272727 * fieldH, right: 0.0, left: 0.0, position: "GK", points:gkPoints??0,) else Container(),
                                if (rbInt!=null) DreamPlayer(image: !approved /*&& AppConstants.showImgData!="true"*/?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$rbPhoto.png', name: rb??"--", top: 0.21818182 * fieldH, right: 0.70666667 * width, left: 0.0, position: "RB", points:rbPoints??0,) else Container(),
                                if (rCbInt!=null) DreamPlayer(image: !approved /*&& AppConstants.showImgData!="true"*/?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$rCbPhoto.png', name: rCb??"--", top: 0.23636364 * fieldH, right: 0.29333333 * width, left: 0.0, position: "CB", points:rCbPoints??0,) else Container(),
                                if (lCbInt!=null) DreamPlayer(image: !approved /*&& AppConstants.showImgData!="true"*/?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$lCbPhoto.png', name: lCb??"--", top: 0.23636364 * fieldH, right: 0.0, left: 0.29333333 * width, position: "CB", points:lCbPoints??0,) else Container(),
                                if (lbInt!=null) DreamPlayer(image: !approved /*&& AppConstants.showImgData!="true"*/?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$lbPhoto.png', name: lb??"--", top: 0.21818182 * fieldH,right: 0.0, left: 0.70666667 * width, position: "LB", points:lbPoints??0,) else Container(),
                                if (rMidInt!=null) DreamPlayer(image: !approved /*&& AppConstants.showImgData!="true"*/?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$rMdPhoto.png', name: rMd??"--", top: 0.47272727 * fieldH, right: 0.0, left: 0.70666667 * width, position: "LMF", points:rMidPoints??0,) else Container(),
                                if (midInt!=null) DreamPlayer(image: !approved /*&& AppConstants.showImgData!="true"*/?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$mdPhoto.png', name: md??"--", top: 0.45454545 * fieldH, right: 0.01333333 * width, left: 0.0, position: "AMF", points:midPoints??0,) else Container(),
                                if (lMidInt!=null) DreamPlayer(image: !approved /*&& AppConstants.showImgData!="true"*/?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$lMdPhoto.png', name: lMd??"--", top: 0.47272727 * fieldH, right: 0.70666667 * width, left: 0.0, position: "RMF", points:lMidPoints??0,) else Container(),
                                if (rFwdInt!=null) DreamPlayer(image: !approved /*&& AppConstants.showImgData!="true"*/?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$rFwdPhoto.png', name: rFwd??"--", top: 0.69090909 * fieldH, right: 0.29333333 * width, left: 0.29333333 * width, position: "CF", points:rFwdPoints??0,) else Container(),
                                if (fwdInt!=null) DreamPlayer(image: !approved /*&& AppConstants.showImgData!="true"*/?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$fwdPhoto.png', name: fwd??"--", top: 0.69090909 * fieldH, right: 0.5 * width, left: 0.0, position: "RWF", points:fwdPoints??0,) else Container(),
                                if (lFwdInt!=null) DreamPlayer(image: !approved /*&& AppConstants.showImgData!="true"*/?'':'https://resources.premierleague.com/premierleague/photos/players/110x140/p$lFwdPhoto.png', name: lFwd??"--", top: 0.69090909 * fieldH, right: 0.1 * width, left: 0.65333333 * width, position: "LWF", points:lFwdPoints??0,) else Container(),
                          ]),
                    ),
                  ),
                ),
              ],
            ),
          ):Container(),
        ],
      ),
    );
  }
}
