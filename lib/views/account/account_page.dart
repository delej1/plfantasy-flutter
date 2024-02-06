import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pl_fantasy_online/base/custom_app_bar.dart';
import 'package:pl_fantasy_online/base/custom_snack_bar.dart';
import 'package:pl_fantasy_online/controllers/auth_controller.dart';
import 'package:pl_fantasy_online/controllers/bank_list_controller.dart';
//import 'package:pl_fantasy_online/utils/app_constants.dart';
import 'package:pl_fantasy_online/utils/colors.dart';
import 'package:pl_fantasy_online/utils/dimensions.dart';
import 'package:pl_fantasy_online/widgets/app_icon.dart';
import 'package:pl_fantasy_online/widgets/app_text_field.dart';
import 'package:pl_fantasy_online/widgets/profile_widget.dart';


class AccountPage extends StatefulWidget{
  const AccountPage({Key? key}) : super(key: key);
  @override
  State<AccountPage> createState() => _AccountPageState();
}

TextEditingController accountNameController = TextEditingController();

class _AccountPageState extends State<AccountPage>{

  List<dynamic> details = Get.arguments;

  FirebaseAuth auth = FirebaseAuth.instance;

  BankListController bankListController = Get.put(BankListController());


  late String name;
  late String phone;
  late String email;
  late String fplId;
  late String tokenBalance;
  late bool approved;
  late String userId;

  late String selectedBank;
  late String selectedBankCode;
  late Map bankDetailMap;

  bool isLoaded = false;
  bool formOkay = false;

  List<String> bankNames = [];
  List bankCodes = [];

  TextEditingController tokenController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController fplIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    tokenController.text = "";
    accountNameController.text = "";
    accountNumberController.text = "";
    nameController.text = "";
    phoneController.text = "";
    fplIdController.text = "";

    selectedBank = "";
    selectedBankCode = "";
    name = details[0];
    phone = details[2];
    email = details[1];
    fplId = details[3];
    tokenBalance = details[4];
    approved = details[5];
    userId = details[6];
  }

  @override
  void dispose() {
    tokenController.dispose();
    accountNumberController.dispose();
    nameController.dispose();
    phoneController.dispose();
    fplIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bankNames = bankListController.bankListModel!.data!.map((info) => info.name??"").toList();
    bankCodes = bankListController.bankListModel!.data!.map((info) => info.code??"").toList();
    bankDetailMap = Map.fromIterables(bankNames, bankCodes);
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
        appBar: const CustomAppBar(title: 'My Account',),
        body: Container(
              width: double.maxFinite,
              margin: EdgeInsets.only(top: Dimensions.height20),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          //name
                          if (name.isEmpty) Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              ProfileWidget(
                                appIcon: AppIcon(icon: Icons.person,
                                  backgroundColor: AppColors.blueColor,
                                  iconColor: Colors.white,
                                  iconSize: Dimensions.height10*5/2,
                                  size: Dimensions.height10*5,),
                                text: Text("Update Name", style: TextStyle(fontSize: Dimensions.font14, color: Colors.white)),),
                              Padding(
                                padding: EdgeInsets.only(right: Dimensions.width20),
                                child: IconButton(
                                    onPressed: (){
                                      showEditNameDialogue();
                                    },
                                    icon: Container(
                                        padding: EdgeInsets.all(Dimensions.width5),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            color: Colors.white12
                                        ),
                                        child: const Icon(Icons.arrow_forward_ios, color: Colors.white,))),
                              )
                            ],
                          ) else ProfileWidget(
                            appIcon: AppIcon(icon: Icons.person,
                              backgroundColor: AppColors.blueColor,
                              iconColor: Colors.white,
                              iconSize: Dimensions.height10*5/2,
                              size: Dimensions.height10*5,),
                            text: Text(name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: Dimensions.font14, color: Colors.white)),),
                          //phone
                          if (phone.isEmpty) Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              ProfileWidget(
                                appIcon: AppIcon(icon: Icons.phone,
                                  backgroundColor: AppColors.blueColor,
                                  iconColor: Colors.white,
                                  iconSize: Dimensions.height10*5/2,
                                  size: Dimensions.height10*5,),
                                text: Text("Update Phone Number", style: TextStyle(fontSize: Dimensions.font14, color: Colors.white)),),
                              Padding(
                                padding: EdgeInsets.only(right: Dimensions.width20),
                                child: IconButton(
                                    onPressed: (){
                                      showEditPhoneDialogue();
                                    },
                                    icon: Container(
                                        padding: EdgeInsets.all(Dimensions.width5),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            color: Colors.white12
                                        ),
                                        child: const Icon(Icons.arrow_forward_ios, color: Colors.white,))),
                              )
                            ],
                          ) else ProfileWidget(
                            appIcon: AppIcon(icon: Icons.phone,
                              backgroundColor: AppColors.blueColor,
                              iconColor: Colors.white,
                              iconSize: Dimensions.height10*5/2,
                              size: Dimensions.height10*5,),
                            text: Text(phone,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: Dimensions.font14, color: Colors.white)),),
                          //email
                          ProfileWidget(
                            appIcon: AppIcon(icon: Icons.email,
                              backgroundColor: AppColors.blueColor,
                              iconColor: Colors.white,
                              iconSize: Dimensions.height10*5/2,
                              size: Dimensions.height10*5,),
                            text: Text(email,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: Dimensions.font14, color: Colors.white)),),
                          //fpl ID
                          if (fplId.isEmpty) Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              ProfileWidget(
                                appIcon: AppIcon(icon: Icons.numbers,
                                  backgroundColor: AppColors.blueColor,
                                  iconColor: Colors.white,
                                  iconSize: Dimensions.height10*5/2,
                                  size: Dimensions.height10*5,),
                                text: Text("Update FPL ID", style: TextStyle(fontSize: Dimensions.font14, color: Colors.white)),),
                              Padding(
                                padding: EdgeInsets.only(right: Dimensions.width20),
                                child: IconButton(
                                    onPressed: (){
                                      showEditFplIdDialogue();
                                    },
                                    icon: Container(
                                        padding: EdgeInsets.all(Dimensions.width5),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            color: Colors.white12
                                        ),
                                        child: const Icon(Icons.arrow_forward_ios, color: Colors.white,))),
                              )
                            ],
                          ) else ProfileWidget(
                            appIcon: AppIcon(icon: Icons.numbers,
                              backgroundColor: AppColors.blueColor,
                              iconColor: Colors.white,
                              iconSize: Dimensions.height10*5/2,
                              size: Dimensions.height10*5,),
                            text: Text(fplId,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: Dimensions.font14, color: Colors.white)),),
                          //bank account
                          if (tokenBalance != "0" && approved /*&& AppConstants.redeemTextString == "Redeem Tokens"*/) Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              ProfileWidget(
                                appIcon: AppIcon(icon: Icons.account_balance,
                                  backgroundColor: Colors.green.shade900,
                                  iconColor: Colors.white,
                                  iconSize: Dimensions.height10*5/2,
                                  size: Dimensions.height10*5,),
                                text: Text("Update Bank Details", style: TextStyle(fontSize: Dimensions.font14, color: Colors.white)),),
                              Padding(
                                padding: EdgeInsets.only(right: Dimensions.width20),
                                child: IconButton(
                                    onPressed: (){
                                      showBankUpdateDialogue();
                                    },
                                    icon: Container(
                                        padding: EdgeInsets.all(Dimensions.width5),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            color: Colors.white12
                                        ),
                                        child: const Icon(Icons.arrow_forward_ios, color: Colors.white,))),
                              )
                            ],
                          ) else Container(),
                          Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              ProfileWidget(
                                appIcon: AppIcon(icon: Icons.delete_forever,
                                  backgroundColor: Colors.red,
                                  iconColor: Colors.white,
                                  iconSize: Dimensions.height10*5/2,
                                  size: Dimensions.height10*5,),
                                text: Text("Delete Account", style: TextStyle(fontSize: Dimensions.font14, color: Colors.white)),),
                              Padding(
                                padding: EdgeInsets.only(right: Dimensions.width20),
                                child: IconButton(
                                    onPressed: (){
                                      showDeleteAccDialogue();
                                    },
                                    icon: Container(
                                        padding: EdgeInsets.all(Dimensions.width5),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            color: Colors.white12
                                        ),
                                        child: const Icon(Icons.arrow_forward_ios, color: Colors.white,))),
                              )
                            ],
                          )
                        ],
                      )
                    ),
                  )
                ],
              ),
            ),
      ),
    );
  }

  void showEditNameDialogue() {
    showDialog(context: context, builder: (context) => AlertDialog(
      title: const Text("Update Name", style: TextStyle(color: Colors.black),),
      content: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: AppTextField(
          textEditingController: nameController,
          hintText: 'Name',
          icon: Icons.edit,
          textInputType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: (){
            Navigator.of(context).pop();
            nameController.clear();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mainColor,
          ),
          child: const Text('Close'),
        ),
        ElevatedButton(
          onPressed: () {
            if(nameController.text.trim().isEmpty){
              showCustomSnackBar("Type in your name", title: "Name");
            }else{
              try{
                FirebaseFirestore.instance.collection('user_data')
                    .doc(auth.currentUser!.uid).update({
                  'name': nameController.text.trim()})
                    .then((_) => showCustomSnackBar(title: "Success", "Name updated successfully"));
              }catch(e){debugPrint(e.toString());}
              Navigator.of(context).pop();
              nameController.clear();
            }
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

  void showEditPhoneDialogue() {
    showDialog(context: context, builder: (context) => AlertDialog(
      title: const Text("Update Phone Number", style: TextStyle(color: Colors.black),),
      content: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: AppTextField(
          textEditingController: phoneController,
          hintText: "+234 803 XXX",
          icon: Icons.edit,
          textInputType: TextInputType.phone,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: (){
            Navigator.of(context).pop();
            phoneController.clear();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mainColor,
          ),
          child: const Text('Close'),
        ),
        ElevatedButton(
          onPressed: () {
            if(!phoneController.text.contains("+234")||phoneController.text.length<14||phoneController.text.length>14||!phoneController.text.isNum){
              showCustomSnackBar("Type in correct phone number", title: "Phone");
            }else{
              try{
                FirebaseFirestore.instance.collection('user_data')
                    .doc(auth.currentUser!.uid).update({
                  'phone': phoneController.text.trim()})
                    .then((_) => showCustomSnackBar(title: "Success", "Phone number updated successfully"));
              }catch(e){debugPrint(e.toString());}
              Navigator.of(context).pop();
              phoneController.clear();
            }
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

  void showEditFplIdDialogue() {
    showDialog(context: context, builder: (context) => AlertDialog(
      title: const Text("Update FPL ID", style: TextStyle(color: Colors.black),),
      content: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Stack(
          children: [
            AppTextField(
              textEditingController: fplIdController,
              hintText: "FPL ID",
              icon: Icons.edit,
              textInputType: TextInputType.number,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: Dimensions.width20),
                child: IconButton(onPressed: (){
                  showDialog(context: context, builder: (context) => AlertDialog(
                  content: Image.asset('assets/image/find_id_img.png'),
                  ));
                },
                    icon: Icon(Icons.info, color: AppColors.mainColor, size: Dimensions.height10*3,)),
              ),
            )
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: (){
            Navigator.of(context).pop();
            fplIdController.clear();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mainColor,
          ),
          child: const Text('Close'),
        ),
        ElevatedButton(
          onPressed: () {
            if(fplIdController.text.trim().isEmpty||!fplIdController.text.isNum){
              showCustomSnackBar("Type in FPL ID", title: "FPL ID");
            }else{
              try{
                FirebaseFirestore.instance.collection('user_data')
                    .doc(auth.currentUser!.uid).update({
                  'fpl_id': fplIdController.text.trim()})
                    .then((_) => showCustomSnackBar(title: "Success", "FPL ID updated successfully"));
              }catch(e){debugPrint(e.toString());}
              Navigator.of(context).pop();
              fplIdController.clear();
            }
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

  void showBankUpdateDialogue(){
    showDialog(context: context, builder: (context) => AlertDialog(
      title: const Text("Update Bank Details", style: TextStyle(color: Colors.black),),
      content: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            RawAutocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                return bankNames.where((String option) {
                  return option.contains(textEditingValue.text.toLowerCase());
                });
              },
              fieldViewBuilder: (BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted) {
                return Container(
                  margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20),
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 13,
                          spreadRadius: 1,
                          offset: const Offset(1,1),
                          color: Colors.grey.withOpacity(0.2),
                        )
                      ]
                  ),
                  child: TextFormField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    onFieldSubmitted: (String value) {
                      onFieldSubmitted();
                    },
                    style: TextStyle(fontSize: Dimensions.font14,),
                    decoration: InputDecoration(
                    hintText: 'Bank Name',
                    prefixIcon: const Icon(Icons.account_balance, color: AppColors.mainColor,),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimensions.radius15),
                        borderSide: const BorderSide(
                          width: 1.0,
                          color: Colors.white,
                        )
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimensions.radius15),
                        borderSide: const BorderSide(
                          width: 1.0,
                          color: Colors.white,
                        )
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                    ),),),
                );
              },
              optionsViewBuilder: (BuildContext context,
                  AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4.0,
                    child: SizedBox(
                      height: Dimensions.height100*2,
                      child: ListView.builder(
                        padding: EdgeInsets.all(Dimensions.width8),
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final String option = options.elementAt(index);
                          return GestureDetector(
                            onTap: () {
                              onSelected(option);
                              selectedBank = option;
                              selectedBankCode = bankDetailMap[option];
                            },
                            child: ListTile(
                              title: Text(option, style: TextStyle(fontSize: Dimensions.font14,),),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            AppTextField(
              textEditingController: accountNumberController,
              hintText: 'Account Number',
              icon: Icons.numbers,
              textInputType: TextInputType.number,
              onEditingComplete: (){
                ResolveAccountNumber()
                    .resolveAccountNumber(accountNumberController.text, selectedBankCode);
              },
            ),
            AppTextField(
              textEditingController: accountNameController,
              hintText: 'Account Name',
              icon: Icons.person,
              enabled: false,
              readOnly: true,
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: (){
            Navigator.of(context).pop();
            accountNameController.clear();
            accountNumberController.clear();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mainColor,
          ),
          child: const Text('Close'),
        ),
        ElevatedButton(
          onPressed: () {
            bankFormCheck();
            if(formOkay){
              try{
                FirebaseFirestore.instance.collection('user_data')
                    .doc(auth.currentUser!.uid).update({
                  'bank': selectedBank,
                  'bank_code': selectedBankCode,
                  'account_number': accountNumberController.text,
                  'account_name': accountNameController.text,
                }).then((_) => showCustomSnackBar(title: "Success", "Bank Details Updated Successfully"));
              }catch(e){debugPrint(e.toString());}
              Navigator.of(context).pop();
              accountNameController.clear();
              accountNumberController.clear();
            }
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

  void bankFormCheck(){
    String name = accountNameController.text.trim();
    String accNum = accountNumberController.text.trim();

    if(name.isEmpty){
      showCustomSnackBar("Hit enter after filling acc num to verify name", title: "Missing Name");
      formOkay = false;
    }else if(accNum.isEmpty){
      showCustomSnackBar("Type in your account number", title: "Account Number");
      formOkay = false;
    }else if(!accNum.isNum){
      showCustomSnackBar("Type in valid characters", title: "Account Number");
      formOkay = false;
    }else if(accNum.length<10 || accNum.length>10){
      showCustomSnackBar("Account number format incorrect", title: "Account number");
      formOkay = false;
    }else{
      formOkay = true;
    }
  }

  void showDeleteAccDialogue() {
    showDialog(context: context, builder: (context) => AlertDialog(
      title: const Text("Delete Account", style: TextStyle(color: Colors.black),),
      content: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Text("Are you sure you want to delete account and associated details?",
          style: TextStyle(fontSize: Dimensions.font14),)
      ),
      actions: [
        ElevatedButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mainColor,
          ),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async{
              Navigator.of(context).pop();
              await FirebaseFirestore.instance.runTransaction(
                      (Transaction myTransaction) async {
                        myTransaction.delete(FirebaseFirestore
                        .instance.collection('user_data').doc(userId));
                  });
              await FirebaseFirestore.instance.runTransaction(
                      (Transaction myTransaction) async {
                    myTransaction.delete(FirebaseFirestore
                        .instance.collection('user_teams').doc(userId));
                  }).then((_) => showCustomSnackBar(title: "Success", "Account deleted successfully"));
              FirebaseAuth.instance.currentUser!.delete();
              AuthController.instance.signOut();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mainColor,
          ),
          //return false when click on "NO"
          child: const Text('Delete'),
        ),
      ],
    ));
  }
}

class ResolveAccountNumber extends GetConnect {
  Future<Response> resolveAccountNumber(var accountNumber, var code) async {
    try {
      Response response = await get(
          'https://api.paystack.co/bank/resolve?account_number=$accountNumber&bank_code=$code',
          headers: {
            'Authorization': 'Bearer $token',
          });
      Map result = response.body;
      if(result["status"] == true){
        accountNameController.text = result["data"]["account_name"];
      }else{
        showCustomSnackBar(title: "Error", "Failed to resolve account details, please try again");
      }
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }
}
