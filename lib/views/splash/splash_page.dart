import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pl_fantasy_online/helpers/route_helper.dart';
import 'package:pl_fantasy_online/utils/dimensions.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  FirebaseAuth auth = FirebaseAuth.instance;

  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState(){
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInQuad,
    );

    Timer(const Duration(seconds: 4), (){
      if(auth.currentUser==null){
        Get.offNamed(RouteHelper.getSignInPage());
      }else{
        Get.offNamed(RouteHelper.getLoadingPage());
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white54.withOpacity(0.8),
        body: Padding(
          padding: EdgeInsets.all(Dimensions.width8),
          child: Center(
              child: Image.asset(
                "assets/image/app_logo.png",
                width: MediaQuery.of(context).size.width,
                opacity: const AlwaysStoppedAnimation(.8),
              )),
        ),
      ),
    );
  }
}
