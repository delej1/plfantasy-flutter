import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:pl_fantasy_online/base/custom_loader.dart';
import 'package:pl_fantasy_online/base/custom_snack_bar.dart';
import 'package:pl_fantasy_online/controllers/auth_controller.dart';
import 'package:pl_fantasy_online/helpers/route_helper.dart';
import 'package:pl_fantasy_online/utils/app_constants.dart';
import 'package:pl_fantasy_online/utils/colors.dart';
import 'package:pl_fantasy_online/utils/dimensions.dart';
import 'package:pl_fantasy_online/widgets/app_text_field.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with AutomaticKeepAliveClientMixin{

  final FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  late Stream<DocumentSnapshot> _tokenStream;

  late String name;
  late String bankName;
  late String accountName;
  late String accountNumber;
  late String tokenBalance;
  late String phone;
  late String email;
  late String fplId;
  late bool approved;
  late String userId;

  bool isLoaded = false;
  bool formOkay = false;
  bool result = false;

  TextEditingController tokenController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();

  void firebaseGetData() async {
    await db.collection("user_data").doc(auth.currentUser!.uid).get().then((data){
      name = data["name"];
      bankName = data["bank"];
      accountName = data["account_name"];
      accountNumber = data["account_number"];
      tokenBalance = data["tokens"].toString();
      phone = data["phone"];
      email = data["email"];
      fplId = data["fpl_id"];
      approved = data["approved"];
      userId = data.id;
    });
    setState(() {
      isLoaded = true;
    });
  }

  @override
  bool get wantKeepAlive => false;

  @override
  void initState() {
    super.initState();
    _tokenStream = db.collection("user_data").doc(auth.currentUser?.uid).snapshots();
    firebaseGetData();
    name = "";
    bankName = "";
    accountName = "";
    accountNumber = "";
    tokenBalance = "";
    phone = "";
    email = "";
    fplId = "";
    approved = false;
    tokenController.text = "";
    nameController.text = "";
    bankNameController.text = "";
    accountNumberController.text = "";
  }

  @override
  void dispose() {
    tokenController.dispose();
    nameController.dispose();
    bankNameController.dispose();
    accountNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    nameController.text = accountName;
    bankNameController.text = bankName;
    accountNumberController.text = accountNumber;
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(Dimensions.width10),
              child: Container(
                height: MediaQuery.of(context).size.height/3.5,
                width: MediaQuery.of(context).size.width,
                decoration: approved /*&& AppConstants.showImgData =="true"*/?BoxDecoration(
                  color: Colors.white54.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(Dimensions.radius20/2),
                  image: const DecorationImage(
                    image: ExactAssetImage('assets/image/club_badges.png'),
                    fit: BoxFit.cover,
                  ),
                ):BoxDecoration(
                  color: Colors.white54.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(Dimensions.radius20/2),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(Dimensions.width8),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.width100),
                                  color: AppColors.mainColor
                                ),
                                child:
                                IconButton(
                                  onPressed: (){
                                    AuthController.instance.signOut();
                                  },
                                  icon: const Icon(Icons.logout, color: Colors.white,),
                                  tooltip: "Sign Out",
                                ),
                              ),
                            ),
                          ),
                          isLoaded?Align(
                            alignment: Alignment.center,
                            child: Container(
                              margin: EdgeInsets.only(top: Dimensions.height20),
                              child: CircleAvatar(
                                radius: Dimensions.width50,
                                child: RandomAvatar(name),
                              ),
                            ),
                          ):Container(),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(Dimensions.width8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(Dimensions.radius20/2),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(Dimensions.width8),
                            child: Text(name,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: Dimensions.font16, fontWeight: FontWeight.bold, color: Colors.white),),
                          ),
                        ),
                      ),
                  ]),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height/2,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: Dimensions.width10, right: Dimensions.width10, bottom: Dimensions.width8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: (){
                            hasConnection().then((_){
                              if(result){
                                if(tokenBalance != "0" && approved /*&& AppConstants.redeemTextString == "Redeem Tokens"*/){
                                  showRedeemDialogue();
                                }
                              }else{
                                showCustomSnackBar("Kindly check internet connection", title: "Error");
                              }
                            });
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height*0.19,
                            width: MediaQuery.of(context).size.width*0.47,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(Dimensions.radius20/2),
                            ),
                            child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset("assets/icon/entry_fee_icon.png", height: Dimensions.iconSize15*2),
                                        isLoaded?Text(" $tokenBalance",
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: Dimensions.font26, color: Colors.white),):
                                        Text("--", style: TextStyle(fontWeight: FontWeight.bold, fontSize: Dimensions.font26, color: Colors.white),),
                                      ],
                                    ),
                                    SizedBox(height: Dimensions.height1*5,),
                                    tokenBalance != "0" && approved /*&& AppConstants.redeemTextString == "Redeem Tokens"*/?Text("Redeem Tokens",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: Dimensions.font10, color: Colors.yellow),)
                                        :Text("Token Balance",
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: Dimensions.font10, color: Colors.yellow),
                                    )
                                  ],
                                )),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){Get.toNamed(RouteHelper.getHistoryPage());},
                          child: Container(
                            height: MediaQuery.of(context).size.height*0.19,
                            width: MediaQuery.of(context).size.width*0.47,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(Dimensions.radius20/2),
                            ),
                            child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.history, size: Dimensions.iconSize15*2, color: Colors.white,),
                                    Text("History",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: Dimensions.font14, color: Colors.white),),
                                  ],
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: Dimensions.width10, right: Dimensions.width10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: (){Get.toNamed(RouteHelper.getAccountPage(),
                              arguments: [name, email, phone, fplId, tokenBalance, approved, userId]);},
                          child: Container(
                            height: MediaQuery.of(context).size.height*0.19,
                            width: MediaQuery.of(context).size.width*0.47,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(Dimensions.radius20/2),
                            ),
                            child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.person, size: Dimensions.iconSize15*2, color: Colors.white,),
                                    Text("Account",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: Dimensions.font14, color: Colors.white),),
                                  ],
                                )),
                          ),
                        ),
                        GestureDetector(
                          onTap: ()=>Get.toNamed(RouteHelper.getSupportPage(),
                              arguments: [name, email, phone]),
                          child: Container(
                            height: MediaQuery.of(context).size.height*0.19,
                            width: MediaQuery.of(context).size.width*0.47,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(Dimensions.radius20/2),
                            ),
                            child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.support_agent, size: Dimensions.iconSize15*2, color: Colors.white,),
                                    Text("Support",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: Dimensions.font14, color: Colors.white),),
                                  ],
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showRedeemDialogue(){
    showDialog(context: context, builder: (context) => isLoaded?AlertDialog(
      title: Text(AppConstants.redeemTextString, style: const TextStyle(color: Colors.black),),
      content: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          child: Column(
            children: [
              AppTextField(
                textEditingController: tokenController,
                hintText: 'Token Amount',
                icon: Icons.monetization_on,
                textInputType: TextInputType.number,
              ),
              AppTextField(
                textEditingController: bankNameController,
                hintText: 'Bank Name',
                icon: Icons.account_balance,
                enabled: false,
                readOnly: true,
              ),
              AppTextField(
                textEditingController: nameController,
                hintText: 'Full Name',
                icon: Icons.person,
                enabled: false,
                readOnly: true,
              ),
              AppTextField(
                textEditingController: accountNumberController,
                hintText: 'Account Number',
                icon: Icons.numbers,
                textInputType: TextInputType.number,
                enabled: false,
                readOnly: true,
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: (){
            Navigator.of(context).pop();
            tokenController.clear();
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
                onPressed: (){
                  redeemFormCheck();
                  if(result){
                    if(formOkay){
                      if(int.parse(tokenController.text) > data?["tokens"]){
                        showCustomSnackBar("Invalid token amount", title: "Token Amount");
                      }else{try{
                        FirebaseFirestore.instance.collection('user_data')
                            .doc(auth.currentUser!.uid).update({'tokens': data?["tokens"]-int.parse(tokenController.text)});
                        uploadRedeemData();
                      }catch(e){showCustomSnackBar(e.toString());}
                      Navigator.of(context).pop();
                      tokenController.clear();
                      }
                    }
                  }else{
                    showCustomSnackBar("Kindly check internet connection", title: "Error");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainColor,
                ),
                //return false when click on "NO"
                child: const Text('Redeem'),
              );
            }
        ),
      ],
    ):const CustomLoader());
  }

  void redeemFormCheck(){
    String token = tokenController.text.trim();
    String name = nameController.text.trim();
    String bank = bankNameController.text.trim();
    String account = accountNumberController.text.trim();

    if(token.isEmpty){
      showCustomSnackBar("Type in token amount to redeem", title: "Token Amount");
      formOkay = false;
    }else if(int.parse(token) == 0){
      showCustomSnackBar("Enter a valid amount", title: "Token Amount");
      formOkay = false;
    }else if(!token.isNum){
      showCustomSnackBar("Type in valid characters", title: "Token Amount");
      formOkay = false;
    }else if(name.isEmpty && bank.isEmpty && account.isEmpty){
      showCustomSnackBar("Kindly update your bank details", title: "Bank Details");
      formOkay = false;
    }else{
      formOkay = true;
    }
  }

  void uploadRedeemData() async{
    int tokenAmount = int.parse(tokenController.text);
    var createdAt = DateFormat('h:mm a, dd-MMM-yy').format(DateTime.now());
    try{
      final collection = FirebaseFirestore.instance.collection('redeem_token');
      await collection.doc().set({
        'id': auth.currentUser!.uid,
        'token_amount': tokenAmount,
        'name': name,
        'email': email,
        'phone_number': phone,
        'account_name': accountName,
        'bank_name': bankName,
        'account_number': accountNumber,
        'paid': false,
        'created_at': createdAt,
      }).then((_) {
        sendTermiiSMS(name, tokenAmount, bankName, accountNumber, accountName);
      });
    }catch(e){ showCustomSnackBar(e.toString());}
  }

  void sendTermiiSMS(name, tokenAmount, bankName, accountNumber, accountName) async{
    try{
      http.Response response = await http.post(
          Uri.tryParse("https://api.ng.termii.com/api/sms/send")!,
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, dynamic>{
            "to": AppConstants.adminPhoneNumber,
            "from": "PL Fantasy",
            "sms": "Pay $name $tokenAmount credits to $accountName, $accountNumber $bankName",
            "type": "plain",
            "channel": "generic",
            "api_key": AppConstants.termiiApi,
          })
      );
      if(response.statusCode==200){
        showCustomSnackBar(title: "Request Sent Successfully",
            "Your request has been sent successfully. You will receive feedback shortly");
      }else{
        showCustomSnackBar(title: "Oops",
            "Your request failed. Please try again");
      }
    }catch(e){
      debugPrint(e.toString());
    }
  }

  Future<void> hasConnection() async{
    result = await InternetConnectionChecker().hasConnection;
  }
}
