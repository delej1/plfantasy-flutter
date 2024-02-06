import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pl_fantasy_online/base/custom_app_bar.dart';
import 'package:pl_fantasy_online/base/custom_snack_bar.dart';
import 'package:pl_fantasy_online/controllers/event_status_controller.dart';
import 'package:pl_fantasy_online/utils/app_constants.dart';
import 'package:pl_fantasy_online/utils/colors.dart';
import 'package:pl_fantasy_online/utils/dimensions.dart';
import 'package:pl_fantasy_online/widgets/app_text_field.dart';
import 'package:toggle_switch/toggle_switch.dart';


class WeeklyTournamentsPage extends StatefulWidget {
  const WeeklyTournamentsPage({Key? key}) : super(key: key);

  @override
  State<WeeklyTournamentsPage> createState() => _WeeklyTournamentsPageState();
}

class _WeeklyTournamentsPageState extends State<WeeklyTournamentsPage> {

  final FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  late Stream<QuerySnapshot> _tournamentStream;

  bool formOkay = false;

  TextEditingController tournamentNameController = TextEditingController();
  TextEditingController tournamentIdController = TextEditingController();
  TextEditingController feeController = TextEditingController();
  TextEditingController restrictedIdController = TextEditingController();

  EventStatusController eventStatusController = Get.put(EventStatusController());


  late Stream<DocumentSnapshot> _tokenStream;

  late String userName;
  late String userId;
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

  List<int?>? eventStatusList;
  List idKeys = [];
  int gameWeek = 0;

  int restricted = 0;

  void getGameWeekAndStatus(){
    eventStatusList = eventStatusController.eventStatusModel?.status!.map((info)
    => info.event).toList();
  }

  void firebaseGetData() async {
    await db.collection("user_teams").doc(auth.currentUser!.uid).get().then((data){
      userName = data["user_name"];
      userId = data["user_id"];
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

  @override
  void initState() {
    super.initState();
    firebaseGetData();
    getGameWeekAndStatus();

    _tournamentStream = db.collection("tournaments").snapshots();
    _tokenStream = db.collection("user_data").doc(auth.currentUser?.uid).snapshots();

    gameWeek = (eventStatusList?.first!??0)+1;

    tournamentNameController.text = "";
    tournamentIdController.text = "";
    feeController.text = "";
    restrictedIdController.text = "";
  }

  @override
  void dispose() {
    tournamentNameController.dispose();
    tournamentIdController.dispose();
    feeController.dispose();
    restrictedIdController.dispose();
    super.dispose();
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
              ]
          )
      ),
      child: StreamBuilder<QuerySnapshot>(
          stream: _tournamentStream,
          builder: (context, snapshot) {
            if(snapshot.hasError){
              debugPrint("Error getting snapshot");
            }
            if(snapshot.connectionState == ConnectionState.waiting){

            }
            List<dynamic>? data = snapshot.data?.docs;

            //get keys of query snapshot and add to list
            snapshot.data?.docs.map((DocumentSnapshot document) {
              idKeys.add(document.id);
            }).toList();

            return Scaffold(
              backgroundColor: Colors.transparent,
              appBar: const CustomAppBar(title: 'Weekly Contests',),
              floatingActionButton: data!=null&&data.isNotEmpty?FloatingActionButton(
                onPressed: () { showCreateDialogue(); },
                tooltip: "Create Tournament",
                child: Icon(Icons.add, size: Dimensions.iconSize15*3,),
              ):Container(),
              body:
              data!=null&&data.isNotEmpty?GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: data.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, childAspectRatio: 3),
                  itemBuilder: (context, index){

                    Map players = data[index]['players'];
                    String tournamentName = data[index]['name'];
                    int gameWeek = data[index]['game_week'];
                    String entryFee = data[index]['entry_fee'].toString();
                    String pot = (data[index]['entry_fee']*players.length).toString();
                    String createdAt = data[index]['created_at'];
                    String createdBy = data[index]['created_by'];
                    String key = idKeys[index];
                    String tournamentId = data[index]['id'];
                    String adminId = data[index]['admin_id'];
                    bool isPaidOut = data[index]['is_paid_out'];
                    Map winners = data[index]['winners'];
                    String settlementTime = data[index]['settlement_time'];

                    if(isPaidOut){
                      setTournamentHistory(tournamentName,tournamentId
                          ,data[index]['entry_fee'],data[index]['entry_fee']*players.length,data[index]['game_week']
                          ,createdBy,createdAt,players,winners,key,settlementTime);
                    }

                    return GestureDetector(
                      onTap: (){
                        if(players.containsKey(auth.currentUser!.uid)){
                          Get.toNamed('/tournament-screen',
                              arguments: [tournamentName, gameWeek, entryFee,
                                pot, players, createdAt, createdBy, key, tournamentId, adminId, isPaidOut]);
                        }else if(tournamentId!=""&&data[index]['restricted']==1){
                          showIdDialogue(tournamentName, gameWeek, entryFee, pot, players, createdAt, createdBy, key, tournamentId, adminId, isPaidOut);
                        }else{
                          Get.toNamed('/tournament-screen',
                              arguments: [tournamentName, gameWeek, entryFee,
                                pot, players, createdAt, createdBy, key, tournamentId, adminId, isPaidOut]);
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: Dimensions.height1*7),
                        child: Container(
                          color: Colors.black.withOpacity(0.3),
                          child: Padding(
                            padding: EdgeInsets.all(Dimensions.width15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    //tournament name
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width*0.40,
                                      child: Text(data[index]['name'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: Dimensions.font16,
                                          fontWeight: FontWeight.bold,
                                        ),),
                                    ),
                                    //status
                                    Row(
                                      children: [
                                        Image.asset("assets/icon/status_icon.png", height: Dimensions.iconSize16,),
                                        SizedBox(width: Dimensions.width1*2,),
                                        SizedBox(
                                          child: Text(" Status: ",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: Dimensions.font14,
                                            ),),
                                        ),
                                        SizedBox(
                                          child: data[index]['id']==""?Text(" Public",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: Dimensions.font14,
                                            ),):Text(" Private",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: Dimensions.font14,
                                            ),),
                                        ),
                                        SizedBox(width: Dimensions.width1*2,),
                                        data[index]['id']!=""&&data[index]['restricted']==1
                                            ?Icon(Icons.lock, size: Dimensions.iconSize16,):Container(),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: Dimensions.height30,),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  child: Row(
                                    children: [
                                      //week
                                      Row(
                                        children: [
                                          Image.asset("assets/icon/calendar_icon.png", height: Dimensions.iconSize16,),
                                          SizedBox(width: Dimensions.width1*2,),
                                          SizedBox(
                                            child: Text(" Week: ",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: Dimensions.font14,
                                              ),),
                                          ),
                                          SizedBox(
                                            child: Text(" ${data[index]['game_week']}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: Dimensions.font14,
                                                  fontWeight: FontWeight.bold
                                              ),),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: Dimensions.width1*7,),
                                      //players
                                      Row(
                                        children: [
                                          Image.asset("assets/icon/people_icon.png", height: Dimensions.iconSize16,),
                                          SizedBox(width: Dimensions.width1*2,),
                                          SizedBox(
                                            child: Text("Players: ",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: Dimensions.font14,
                                              ),),
                                          ),
                                          SizedBox(
                                            child: Text(" ${players.length}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: Dimensions.font14,
                                                  fontWeight: FontWeight.bold
                                              ),),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: Dimensions.width1*7,),
                                      //fee
                                      Row(
                                        children: [
                                          Image.asset("assets/icon/entry_fee_icon.png", height: Dimensions.iconSize16,),
                                          SizedBox(width: Dimensions.width1*2,),
                                          SizedBox(
                                            child: Text(" Entry: ",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: Dimensions.font14,
                                              ),),
                                          ),
                                          SizedBox(
                                            child: Text(" ${data[index]['entry_fee']}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: Dimensions.font14,
                                                  fontWeight: FontWeight.bold
                                              ),),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: Dimensions.width1*7,),
                                      //total pot
                                      Row(
                                        children: [
                                          Image.asset("assets/icon/total_pot_icon.png", height: Dimensions.iconSize16,),
                                          SizedBox(width: Dimensions.width1*2,),
                                          SizedBox(
                                            child: Text(" Pot: ",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: Dimensions.font14,
                                              ),),
                                          ),
                                          SizedBox(
                                            child: Text(" ${data[index]['entry_fee']*players.length}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: Dimensions.font14,
                                                  fontWeight: FontWeight.bold
                                              ),),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  })
                  :GestureDetector(onTap: (){
                    showCreateDialogue();}, child: Padding(
                padding: EdgeInsets.all(Dimensions.width20), child: Container(
                height: MediaQuery.of(context).size.height*0.27,
                width: MediaQuery.of(context).size.width*0.45,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(Dimensions.width10),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_circle, size: Dimensions.iconSize24*3, color: Colors.green[800],),
                      SizedBox(height: Dimensions.height15,),
                      Text("Create",
                        style: TextStyle(color: Colors.white,
                            fontSize: Dimensions.font16,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ]
                ),
              ),),),
            );
          }
      ),
    );
  }

  void showCreateDialogue(){
    showDialog(context: context, builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: const Text("Create Tournament", style: TextStyle(color: Colors.black),),
          content: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              child: Column(
                children: [
                  AppTextField(
                    textEditingController: tournamentNameController,
                    hintText: 'Tournament Name',
                    icon: Icons.edit,
                    textCapitalization: TextCapitalization.words,
                  ),
                  AppTextField(
                    textEditingController: tournamentIdController,
                    hintText: 'ID (optional private)',
                    icon: Icons.lock,
                  ),
                  AppTextField(
                    textEditingController: feeController,
                    hintText: 'Tournament Fee',
                    icon: Icons.monetization_on,
                    textInputType: TextInputType.number,
                  ),
                  SizedBox(height: Dimensions.height10,),

                  Container(
                    margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Restrict", style: TextStyle(fontSize: Dimensions.font14, color: Colors.black),),
                        ToggleSwitch(
                          initialLabelIndex: 0,
                          totalSwitches: 2,
                          labels: const ['No', 'Yes'],
                          onToggle: (index) {
                            restricted = index!;
                          },
                          fontSize:Dimensions.font14,
                          minWidth: Dimensions.width50,
                          minHeight: Dimensions.height25,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Dimensions.height10,),
                  Container(
                    margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Game Week", style: TextStyle(fontSize: Dimensions.font14, color: Colors.black),),
                        Text(gameWeek<38?gameWeek.toString():"", style: TextStyle(fontSize: Dimensions.font14, color: Colors.black)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: (){
                Navigator.of(context).pop();
                tournamentNameController.clear();
                tournamentIdController.clear();
                feeController.clear();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainColor,
              ),
              child: const Text('Close'),
            ),
            StreamBuilder<DocumentSnapshot>(
              stream: _tokenStream,
              builder: (context, snapshot) {
                if(snapshot.hasError){
                  debugPrint("Error getting snapshot");
                }
                if(snapshot.connectionState == ConnectionState.waiting){
                }
                Map<String, dynamic>? data = snapshot.data?.data() as Map<String, dynamic>?;
                return ElevatedButton(
                  onPressed: () {
                    createFormCheck();
                    //add token checker condition here
                    if(teamName.isNotEmpty && gkData != 0 && rbData != 0 && rcbData != 0 && lcbData != 0 && lbData != 0 &&
                        rmdData != 0 && mdData != 0 && lmdData != 0 && rfwdData != 0 && fwdData != 0 && lfwdData != 0
                        && gkSubData != 0 && defSubData != 0 && midSubData != 0 && fwdSubData != 0){
                      if(captainData != 0){
                        if(formOkay){
                          if(restricted == 1 && tournamentIdController.text.isEmpty){
                            showCustomSnackBar("Enter ID to restrict access", title: "Error");
                          }else{
                            Navigator.of(context).pop();
                            showBoosterDialogue(data?["tokens"]);
                          }
                        }
                      }else{
                        showCustomSnackBar("Please select your captain", title: "Error");
                      }
                    }else{
                      showCustomSnackBar("Please select your team", title: "Error");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainColor,
                  ),
                  //return false when click on "NO"
                  child: const Text('Create'),
                );
              }
            )
          ],
        );
      },
    ));
  }

  void createFormCheck(){
    String name = tournamentNameController.text.trim();
    String fee = feeController.text.trim();

    if(name.isEmpty){
      showCustomSnackBar("Type in tournament name", title: "Tournament Name");
      formOkay = false;
    }else if(name.length<3||name.length>20){
      showCustomSnackBar("Invalid name length", title: "Tournament Name");
      formOkay = false;
    }else if(!fee.isNum){
      showCustomSnackBar("Type in valid entry fee", title: "Tournament Fee");
      formOkay = false;
    }else if(fee.isEmpty){
      showCustomSnackBar("Type in entry fee", title: "Tournament Fee");
      formOkay = false;
    }else if(int.parse(fee) == 0){
      showCustomSnackBar("Enter a valid amount", title: "Tournament Fee");
      formOkay = false;
    }else if(gameWeek>38){
      showCustomSnackBar("Season Over", title: "Error");
      formOkay = false;
    }else{
      formOkay = true;
    }
  }

  Future<void> createTournament(bool isTripleCaptained, bool isBenchBoosted) async {
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

    String tournamentName = tournamentNameController.text;
    String tournamentId = tournamentIdController.text;
    int tournamentFee = int.parse(feeController.text);
    var createdAt = DateFormat('dd-MMM-yy').format(DateTime.now());
    String createdBy = userName;
    String adminId = userId;
    try{
      final collection = FirebaseFirestore.instance.collection('tournaments');
      await collection.doc().set({
        'name': tournamentName,
        'admin_id': adminId,
        'id': tournamentId,
        'entry_fee': tournamentFee,
        'game_week': gameWeek,
        'created_by': createdBy,
        'created_at': createdAt,
        'players': players,
        'restricted': restricted,
        'is_paid_out': false,
        'winners':{},
        'settlement_time':"",
      });
      showCustomSnackBar(title: "Success","Tournament created successfully");
    }catch(e){ showCustomSnackBar("$e");}
  }

  void showIdDialogue(String tournamentName, int gameWeek, String entryFee,
      String pot, Map players, String createdAt, String createdBy,
      String key, String tournamentId, String adminId, isPaidOut){
    showDialog(context: context, builder: (context) => AlertDialog(
      title: const Text("Restricted Access", style: TextStyle(color: Colors.black),),
      content: AppTextField(
        textEditingController: restrictedIdController,
        hintText: 'Tournament ID',
        icon: Icons.lock,
      ),
      actions: [
        ElevatedButton(
          onPressed: (){
            Navigator.of(context).pop();
            restrictedIdController.clear();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mainColor,
          ),
          child: const Text('Close'),
        ),
         ElevatedButton(
           onPressed: () {
             idFormCheck();
             if(formOkay){
               if(restrictedIdController.text == tournamentId){
                 Navigator.of(context).pop();
                 restrictedIdController.clear();
                 Get.toNamed('/tournament-screen',
                     arguments: [tournamentName, gameWeek, entryFee,
                       pot, players, createdAt, createdBy, key, tournamentId, adminId, isPaidOut]);
               }else{
                 showCustomSnackBar("Incorrect ID", title: "Error");
               }
             }},
           style: ElevatedButton.styleFrom(
             backgroundColor: AppColors.mainColor,
           ),
           //return false when click on "NO"
           child: const Text('Continue'),
         )],
    ));
  }

  void idFormCheck(){
    String fplId = restrictedIdController.text.trim();

    if(fplId.isEmpty){
      showCustomSnackBar("Type in tournament ID", title: "Tournament ID");
      formOkay = false;
    }else{
      formOkay = true;
    }
  }

  void showBoosterDialogue(int totalTokens){
    showDialog(context: context, barrierDismissible: false, builder: (context) => AlertDialog(
      backgroundColor: Colors.transparent,
      title: Text("Apply Triple Captain or Bench Boost for ${AppConstants.boosterCost} tokens?", style: TextStyle(color: Colors.white, fontSize: Dimensions.font14),),
      content: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: (){
                if(int.parse(feeController.text)+AppConstants.createTournamentAndBoost > totalTokens){
                  showCustomSnackBar("Invalid token amount", title: "Token Amount");
                }else{
                  createTournament(true, false);
                  FirebaseFirestore.instance.collection('user_data')
                      .doc(auth.currentUser!.uid)
                      .update({'tokens': totalTokens-(int.parse(feeController.text)
                      +AppConstants.createTournamentAndBoost)})
                      .then((_) => collectBoosterProfit('triple_captain_booster'));
                  Navigator.of(context).pop();
                  tournamentNameController.clear();
                  tournamentIdController.clear();
                  feeController.clear();
                }},
              style: ElevatedButton.styleFrom(
                minimumSize: Size(Dimensions.width10*10, Dimensions.height10*10),
                backgroundColor: Colors.white,
              ),
              child: Image.asset("assets/image/triple_captain_img.png", width: Dimensions.width10*9, height: Dimensions.height10*10,),
            ),
            ElevatedButton(
              onPressed: (){
                if(int.parse(feeController.text)+AppConstants.createTournamentAndBoost > totalTokens){
                  showCustomSnackBar("Invalid token amount", title: "Token Amount");
                }else{
                  createTournament(false, true);
                  FirebaseFirestore.instance.collection('user_data')
                      .doc(auth.currentUser!.uid)
                      .update({'tokens': totalTokens-(int.parse(feeController.text)
                      +AppConstants.createTournamentAndBoost)})
                      .then((_) => collectBoosterProfit('bench_booster'));
                  Navigator.of(context).pop();
                  tournamentNameController.clear();
                  tournamentIdController.clear();
                  feeController.clear();
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(Dimensions.width10*10, Dimensions.height10*10),
                backgroundColor: Colors.white,
              ),
              child: Image.asset("assets/image/bench_boost_img.png", width: Dimensions.width10*9,),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: (){
                if(int.parse(feeController.text)+AppConstants.createTournamentCost > totalTokens){
                  showCustomSnackBar("Invalid token amount", title: "Token Amount");
                }else{
                  createTournament(false, false);
                  FirebaseFirestore.instance.collection('user_data')
                      .doc(auth.currentUser!.uid)
                      .update({'tokens': totalTokens-(int.parse(feeController.text)
                      +AppConstants.createTournamentCost)})
                      .then((_) => collectTourneyProfit());
                  Navigator.of(context).pop();
                  tournamentNameController.clear();
                  tournamentIdController.clear();
                  feeController.clear();
                }},
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
            ),
          ],
        )
      ],
    ));
  }

  Future<void> setTournamentHistory(name, tournamentId, entryFee, totalPot,
      gameWeek, createdBy, createdAt, players, winners, key, settlementTime) async {
    try{
      final collection = FirebaseFirestore.instance.collection('tournament_history');
      await collection.doc().set({
        'name': name,
        'id': tournamentId,
        'entry_fee': entryFee,
        'total_pot': totalPot,
        'game_week': gameWeek,
        'created_by': createdBy,
        'created_at': createdAt,
        'players': players,
        'winners':winners,
        'settlement_time': settlementTime,
      }).then((_) => deleteTournamentData(key));
    }catch(e){ debugPrint("$e");}
  }

  Future<void> deleteTournamentData(key) async{
      await FirebaseFirestore.instance.runTransaction((Transaction myTransaction) async {
        myTransaction.delete(FirebaseFirestore.instance.collection('tournaments')
            .doc(key));});
  }

  Future<void> collectBoosterProfit(booster)async{
    int currentBoosterTokens = 0;
    int currentTourneyTokens = 0;
    try {
      await db.collection("profit").doc("pot").get().then((data) {
        currentBoosterTokens = data[booster];
        currentTourneyTokens = data['tournament_creation_fee'];
      }).then((_) {
        db.collection('profit').doc("pot").update({
        booster: currentBoosterTokens + AppConstants.boosterCost,
        'tournament_creation_fee': currentTourneyTokens + AppConstants.createTournamentCost,
        });
      });
    }catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> collectTourneyProfit()async{
    int currentTourneyTokens = 0;
    try {
      await db.collection("profit").doc("pot").get().then((data) {
        currentTourneyTokens = data['tournament_creation_fee'];
      }).then((_) {
        db.collection('profit').doc("pot").update({
          'tournament_creation_fee': currentTourneyTokens + AppConstants.createTournamentCost,
        });
      });
    }catch (e) {
      debugPrint(e.toString());
    }
  }
}