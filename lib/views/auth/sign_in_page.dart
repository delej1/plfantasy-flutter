import 'package:pl_fantasy_online/base/custom_loader.dart';
import 'package:pl_fantasy_online/base/custom_snack_bar.dart';
import 'package:pl_fantasy_online/controllers/auth_controller.dart';
import 'package:pl_fantasy_online/utils/colors.dart';
import 'package:pl_fantasy_online/utils/dimensions.dart';
import 'package:pl_fantasy_online/views/auth/reset_account_page.dart';
import 'package:pl_fantasy_online/views/auth/sign_up_page.dart';
import 'package:pl_fantasy_online/widgets/app_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  AuthController authController = Get.put(AuthController());

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool formOkay = false;

  @override
  void initState() {
    super.initState();
    emailController.text="";
    passwordController.text="";
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Obx(()=>authController.isLoading.value?const Center(child: CustomLoader()):SingleChildScrollView(
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
                          Text("Sign in to your account",
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
                    AppTextField(
                        textEditingController: passwordController,
                        hintText: "Password",
                        icon: Icons.password_sharp,
                        isObscure:true),

                    SizedBox(height: Dimensions.height10,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.width30),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.all(Dimensions.width5),
                          child: RichText(text: TextSpan(
                              recognizer: TapGestureRecognizer()..
                              onTap=()=>Get.to(()=> const ResetAccountPage(),
                                  transition: Transition.fade),
                              text: "Forgot Password?",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: Dimensions.font14,
                                  fontWeight: FontWeight.bold,
                              )
                          )),
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.height30,),
                    //sign in button
                    GestureDetector(
                      onTap: (){
                        formCheck();
                        if(formOkay){
                          AuthController.instance.signIn(emailController.text.trim(), passwordController.text.trim());
                        }else{}
                      },
                      child: Container(
                        width: Dimensions.screenWidth/3,
                        height: Dimensions.screenHeight/14,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radius30),
                          color: AppColors.mainColor,
                        ),
                        child: Center(
                          child: Text("Sign In",
                            style: TextStyle(
                              fontSize: Dimensions.font20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.height20,),
                    //sign up options
                    RichText(text: TextSpan(
                        text: "Don't have an account?",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Dimensions.font14,
                        ),
                        children:[
                          TextSpan(
                              recognizer: TapGestureRecognizer()..onTap=()=>Get.to(()=>const SignUpPage(), transition: Transition.fade),
                              text: " Sign Up",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: Dimensions.font14,
                              )),
                        ]
                    )),
                    // SizedBox(height: Dimensions.height56,),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     GestureDetector(
                    //         onTap: () {
                    //           showCustomSnackBar("Coming Soon", title: "Oops");
                    //         },
                    //         child: Column(
                    //           children: [
                    //             Image.asset('assets/image/apple_logo.png', width: Dimensions.width20*4, height: Dimensions.height56,),
                    //             SizedBox(height: Dimensions.height10/2,),
                    //             Text("Apple Login", style: TextStyle(color: Colors.white, fontSize: Dimensions.font14),)
                    //           ],
                    //         )),
                    //     SizedBox(width: Dimensions.width30,),
                    //     GestureDetector(
                    //         onTap: () {
                    //           AuthController.instance.signInWithGoogle();
                    //         },
                    //         child: Column(
                    //           children: [
                    //             Image.asset('assets/image/google_logo.png', width: Dimensions.width20*4, height: Dimensions.height56,),
                    //             SizedBox(height: Dimensions.height10/2,),
                    //             Text("Google Login", style: TextStyle(color: Colors.white, fontSize: Dimensions.font14),)
                    //           ],
                    //         )),
                    //   ],
                    // ),
                  ],
                ),
              )
        ),
      ),
    ));
  }
  void formCheck(){
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if(email.isEmpty){
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
    }else{
      formOkay = true;
    }
  }
}
