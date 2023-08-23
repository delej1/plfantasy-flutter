import 'package:pl_fantasy_online/base/custom_loader.dart';
import 'package:pl_fantasy_online/controllers/auth_controller.dart';
import 'package:pl_fantasy_online/utils/colors.dart';
import 'package:pl_fantasy_online/utils/dimensions.dart';
import 'package:pl_fantasy_online/views/auth/sign_in_page.dart';
import 'package:pl_fantasy_online/widgets/app_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


class ResetAccountPage extends StatefulWidget {

  const ResetAccountPage({Key? key}) : super(key: key);

  @override
  State<ResetAccountPage> createState() => _ResetAccountPageState();
}

class _ResetAccountPageState extends State<ResetAccountPage> {

  AuthController authController = Get.put(AuthController());

  final emailController = TextEditingController();


  @override
  void initState() {
    super.initState();
    emailController.text="";
  }

  @override
  void dispose() {
    emailController.dispose();
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
                    SizedBox(height: Dimensions.screenHeight*0.40,),
                    Container(
                      margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20),
                      width: double.maxFinite,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Enter email to send password reset request",
                            style: TextStyle(
                              fontSize: Dimensions.font16,
                              color: Colors.white,
                            ),)
                        ],
                      ),
                    ),
                    SizedBox(height: Dimensions.height20,),
                    SizedBox(
                        child: AppTextField(
                            textEditingController: emailController,
                            hintText: "Email",
                            icon: Icons.email_outlined,
                            textInputType: TextInputType.emailAddress,
                            inputFormatters:[FilteringTextInputFormatter.deny(
                                RegExp(r"\s\b|\b\s"))
                            ]
                        )),
                    SizedBox(height: Dimensions.height20*3,),
                    GestureDetector(
                      onTap: (){
                        AuthController.instance.resetPassword(emailController.text.trim());
                        emailController.clear();
                      },
                      child: Container(
                        width: Dimensions.screenWidth/3,
                        height: Dimensions.screenHeight/14,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radius30),
                          color: AppColors.mainColor,
                        ),
                        child: Center(
                          child: Text("Reset",
                            style: TextStyle(
                              fontSize: Dimensions.font20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.height20),
                    Padding(
                      padding: EdgeInsets.all(Dimensions.width5),
                      child: RichText(text: TextSpan(
                          recognizer: TapGestureRecognizer()..
                          onTap=()=>Get.to(()=> const SignInPage(),
                              transition: Transition.fade),
                          text: "Go Back",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: Dimensions.font16,
                              fontWeight: FontWeight.bold,
                          )
                      )),
                    ),
                  ],
                ),
              )),
        )
    ));}
}