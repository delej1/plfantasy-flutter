import 'package:flutter/material.dart';
import 'package:pl_fantasy_online/base/custom_app_bar.dart';
import 'package:pl_fantasy_online/utils/app_constants.dart';
import 'package:pl_fantasy_online/utils/colors.dart';
import 'package:pl_fantasy_online/utils/dimensions.dart';

class HowToPlay extends StatelessWidget {
  const HowToPlay({Key? key}) : super(key: key);

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
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: const CustomAppBar(title: 'How To Play',),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(Dimensions.width20),
              child: Column(
                children: [
                  Text("General",
                    style: TextStyle(color: Colors.white, fontSize: Dimensions.font16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: Dimensions.height20,),
                  Text(AppConstants.howToPlayGeneralString.replaceAll("\\n", "\n"),
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.white, fontSize: Dimensions.font16, height: Dimensions.height1*2),
                  ),
                  SizedBox(height: Dimensions.height30,),
                  Text("Weekly Contests",
                    style: TextStyle(color: Colors.white, fontSize: Dimensions.font16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: Dimensions.height20,),
                  Text(AppConstants.howToPlayWeeklyString.replaceAll("\\n", "\n"),
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.white, fontSize: Dimensions.font16, height: Dimensions.height1*2),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}