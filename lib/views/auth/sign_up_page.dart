import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pl_fantasy_online/base/custom_loader.dart';
import 'package:pl_fantasy_online/base/custom_snack_bar.dart';
import 'package:pl_fantasy_online/controllers/auth_controller.dart';
import 'package:pl_fantasy_online/utils/colors.dart';
import 'package:pl_fantasy_online/utils/dimensions.dart';
import 'package:pl_fantasy_online/views/auth/sign_in_page.dart';
import 'package:pl_fantasy_online/widgets/app_text_field.dart';



class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  AuthController authController = Get.put(AuthController());

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();

  bool formOkay = false;

  @override
  void initState() {
    super.initState();
    emailController.text="";
    passwordController.text="";
    nameController.text="";
    phoneController.text="";
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
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
        child: Obx(()=>authController.isLoading.value?const Center(child: CustomLoader()):Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: Dimensions.screenHeight*0.15,),
                  //Welcome
                  Container(
                    margin: EdgeInsets.only(left: Dimensions.width20),
                    width: double.maxFinite,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Hello",
                          style: TextStyle(
                              fontSize: Dimensions.font16*3+Dimensions.font16/2,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),),
                        Text("Sign up for an account",
                          style: TextStyle(
                            fontSize: Dimensions.font16,
                            color: Colors.white,
                          ),)
                      ],
                    ),
                  ),
                  SizedBox(height: Dimensions.height20,),
                  //email
                  AppTextField(textEditingController: emailController,
                      hintText: "Email",
                      icon: Icons.email,
                      textInputType: TextInputType.emailAddress,
                      inputFormatters:[FilteringTextInputFormatter.deny(
                          RegExp(r"\s\b|\b\s"))
                      ]
                  ),
                  SizedBox(height: Dimensions.height20,),
                  //password
                  AppTextField(textEditingController: passwordController,
                      hintText: "Password",
                      icon: Icons.password_sharp,
                      isObscure:true),
                  SizedBox(height: Dimensions.height20,),
                  //name
                  AppTextField(textEditingController: nameController,
                      hintText: "Full Name",
                      textCapitalization: TextCapitalization.words,
                      icon: Icons.person),
                  SizedBox(height: Dimensions.height20,),
                  //phone
                  AppTextField(textEditingController: phoneController,
                      hintText: "+234 803 XXX",
                      icon: Icons.phone,
                      textInputType: TextInputType.phone,
                      inputFormatters:[FilteringTextInputFormatter.deny(
                          RegExp(r"\s\b|\b\s"))
                      ]),
                  SizedBox(height: Dimensions.height20,),
                  //sign up button
                  GestureDetector(
                    onTap: (){
                      formCheck();
                      if(formOkay){
                        AuthController.instance.register(emailController.text.trim(), passwordController.text.trim());
                        Future.delayed(const Duration(seconds: 3), () {
                          uploadUserData();
                          uploadUserTeamData();
                        });
                      }
                    },
                    child: Container(
                      width: Dimensions.screenWidth/3,
                      height: Dimensions.screenHeight/14,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radius30),
                        color: AppColors.mainColor,
                      ),
                      child: Center(
                        child: Text("Sign Up",
                          style: TextStyle(
                              fontSize: Dimensions.font20,
                              color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.height30,),
                  //tag line
                  Padding(
                    padding: EdgeInsets.all(Dimensions.width5),
                    child: RichText(text: TextSpan(
                        recognizer: TapGestureRecognizer()..onTap=()=>Get.to(()=>const SignInPage(), transition: Transition.fade),
                        text: "Have an account already?",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: Dimensions.font16,
                            fontWeight: FontWeight.bold,
                        )
                    )),
                  ),
                ],
              ),
            )
        ),
      ),
    ));
  }

  void formCheck(){
    String name = nameController.text.trim();
    String phone = phoneController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if(name.isEmpty){
      showCustomSnackBar("Type in your name", title: "Name");
      formOkay = false;
    }else if(phone.isEmpty){
      showCustomSnackBar("Type in your phone number", title: "Phone number");
      formOkay = false;
    }else if(email.isEmpty){
      showCustomSnackBar("Type in your email address", title: "Email address");
      formOkay = false;
    }else if(!GetUtils.isEmail(email)){
      showCustomSnackBar("Type in a valid email address", title: "Invalid email address");
      formOkay = false;
    }else if(password.isEmpty){
      showCustomSnackBar("Type in your password", title: "Password");
      formOkay = false;
    }else if(password.length<6){
      showCustomSnackBar("Password can't be less than six characters", title: "Password");
      formOkay = false;
    }else if(phone.length<14 || phone.length>14){
      showCustomSnackBar("Phone number format incorrect", title: "Phone number");
      formOkay = false;
    }else if(!phone.contains("+234")){
      showCustomSnackBar("Enter correct country code", title: "Phone number");
      formOkay = false;
    }else if(!phoneController.text.isNum){
      showCustomSnackBar("Enter correct characters", title: "Phone number");
      formOkay = false;
    }else{
      formOkay = true;
    }
  }

  void uploadUserData() async{
    String email = emailController.text.trim();
    String phone = phoneController.text.trim();
    String name = nameController.text.trim();
    try{
        final collection = FirebaseFirestore.instance.collection('user_data');
        await collection.doc(auth.currentUser!.uid).set({
          'name': name,
          'phone': phone,
          'email': email,
          'tokens': 0,
          'bank': "",
          'account_name': "",
          'account_number': "",
          'bank_code': "",
          'fpl_id': "",
          'approved':false,
        }).then((_) => showCustomSnackBar(title: "Success",
            "You have successfully signed up. Thanks!"));
    }catch(e){ debugPrint(e.toString());}
  }

  void uploadUserTeamData() async{
    String name = nameController.text.trim();
    try{
      final collection = FirebaseFirestore.instance.collection('user_teams');
      await collection.doc(auth.currentUser!.uid).set({
        'alias': "",
        'gk': 0,
        'rb': 0,
        'rcb': 0,
        'lcb': 0,
        'lb': 0,
        'rmd': 0,
        'md': 0,
        'lmd': 0,
        'rfwd': 0,
        'fwd': 0,
        'lfwd': 0,
        'gk_sub': 0,
        'def_sub': 0,
        'mid_sub': 0,
        'fwd_sub': 0,
        'captain': 0,
        'money': 100,
        'user_id': auth.currentUser!.uid,
        'user_name': name,
      });
    }catch(e){ debugPrint(e.toString());}
  }
}
