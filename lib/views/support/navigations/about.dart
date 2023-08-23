import 'package:pl_fantasy_online/base/custom_app_bar.dart';
import 'package:pl_fantasy_online/utils/app_constants.dart';
import 'package:pl_fantasy_online/utils/colors.dart';
import 'package:pl_fantasy_online/utils/dimensions.dart';
import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

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
          appBar: const CustomAppBar(title: 'About',),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(Dimensions.width20),
              child: Text(AppConstants.aboutString.replaceAll("\\n", "\n"),
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.white, fontSize: Dimensions.font16, height: Dimensions.height1*3),
              ),
            ),
          ),
        ));
  }
}
