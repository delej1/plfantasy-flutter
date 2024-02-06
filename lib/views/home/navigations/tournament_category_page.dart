import 'dart:math';
import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pl_fantasy_online/base/custom_snack_bar.dart';
import 'package:pl_fantasy_online/helpers/route_helper.dart';
import 'package:pl_fantasy_online/utils/dimensions.dart';

class TournamentCategoryPage extends StatefulWidget {
  const TournamentCategoryPage({Key? key}) : super(key: key);

  @override
  State<TournamentCategoryPage> createState() => _TournamentCategoryPageState();
}

class _TournamentCategoryPageState extends State<TournamentCategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        margin: EdgeInsets.only(top: Dimensions.height20),
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: Dimensions.width10, right: Dimensions.width10, bottom: Dimensions.width8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Get.toNamed(RouteHelper.getWeeklyTournamentPage());
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.30,
                        width: MediaQuery.of(context).size.width*0.45,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(Dimensions.radius20/2),
                        ),
                        child: Center(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(Dimensions.width10),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text("Weekly Contests",
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: Dimensions.font14, color: Colors.white),),
                                    ),
                                  ),
                                  SizedBox(height: Dimensions.height20,),
                                  Image.asset("assets/image/trophy_img.png",
                                    height: MediaQuery.of(context).size.height*0.15,
                                  ),
                                  SizedBox(height: Dimensions.height20,),
                                  BlinkText(
                                    'Join',
                                    style: TextStyle(fontSize: Dimensions.font16, color: Colors.white,),
                                    endColor: Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1),
                                    times: 2,
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        showCustomSnackBar("Coming Soon", title: "Oops");
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.30,
                        width: MediaQuery.of(context).size.width*0.45,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(Dimensions.radius20/2),
                        ),
                        child: Center(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(Dimensions.width10),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text("Guess the Player",
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: Dimensions.font14, color: Colors.white),),
                                    ),
                                  ),
                                  SizedBox(height: Dimensions.height20,),
                                  Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Image.asset("assets/image/predict_player_img.png",
                                          height: MediaQuery.of(context).size.height*0.15,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Image.asset("assets/image/coming_soon_img.png",
                                          height: MediaQuery.of(context).size.height*0.15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: Dimensions.height20,),
                                  BlinkText(
                                    'Play',
                                    style: TextStyle(fontSize: Dimensions.font16, color: Colors.white,),
                                    endColor: Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1),
                                    times: 2,
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: Dimensions.width10, right: Dimensions.width10, bottom: Dimensions.width8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: (){
                        showCustomSnackBar("Coming Soon", title: "Oops");
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.30,
                        width: MediaQuery.of(context).size.width*0.45,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(Dimensions.radius20/2),
                        ),
                        child: Center(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(Dimensions.width10),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text("Six-A-Side",
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: Dimensions.font14, color: Colors.white),),
                                    ),
                                  ),
                                  SizedBox(height: Dimensions.height20,),
                                  Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Image.asset("assets/image/five-a-side_img.png",
                                          width: MediaQuery.of(context).size.height*0.15,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Image.asset("assets/image/coming_soon_img.png",
                                          height: MediaQuery.of(context).size.height*0.15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: Dimensions.height20,),
                                  BlinkText(
                                    'Play',
                                    style: TextStyle(fontSize: Dimensions.font16, color: Colors.white,),
                                    endColor: Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1),
                                    times: 2,
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        showCustomSnackBar("Coming Soon", title: "Oops");
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.30,
                        width: MediaQuery.of(context).size.width*0.45,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(Dimensions.radius20/2),
                        ),
                        child: Center(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(Dimensions.width10),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text("Head-to-Head",
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: Dimensions.font14, color: Colors.white),),
                                    ),
                                  ),
                                  SizedBox(height: Dimensions.height20,),
                                  Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Image.asset("assets/image/head_to_head.png",
                                          width: MediaQuery.of(context).size.height*0.15,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Image.asset("assets/image/coming_soon_img.png",
                                          height: MediaQuery.of(context).size.height*0.15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: Dimensions.height20,),
                                  BlinkText(
                                    'Play',
                                    style: TextStyle(fontSize: Dimensions.font16, color: Colors.white,),
                                    endColor: Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1),
                                    times: 2,
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
