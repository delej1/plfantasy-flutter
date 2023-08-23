import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pl_fantasy_online/base/custom_app_bar.dart';
import 'package:pl_fantasy_online/helpers/route_helper.dart';
import 'package:pl_fantasy_online/utils/app_constants.dart';
import 'package:pl_fantasy_online/utils/colors.dart';
import 'package:pl_fantasy_online/utils/dimensions.dart';
import 'package:pl_fantasy_online/widgets/app_icon.dart';
import 'package:pl_fantasy_online/widgets/profile_widget.dart';
import 'package:share_plus/share_plus.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {

  List<String> details = Get.arguments;

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
          appBar: const CustomAppBar(title: 'Support',),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(Dimensions.width30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      ProfileWidget(
                        appIcon: AppIcon(icon: Icons.question_mark,
                          backgroundColor: AppColors.blueColor,
                          iconColor: Colors.white,
                          iconSize: Dimensions.height10*5/2,
                          size: Dimensions.height10*5,),
                        text: Text("About", style: TextStyle(fontSize: Dimensions.font14, color: Colors.white)),),
                      Padding(
                        padding: EdgeInsets.only(right: Dimensions.width20),
                        child: IconButton(
                            onPressed: (){
                              Get.toNamed(RouteHelper.getAboutPage());
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
                  ),
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      ProfileWidget(
                        appIcon: AppIcon(icon: Icons.info,
                          backgroundColor: AppColors.blueColor,
                          iconColor: Colors.white,
                          iconSize: Dimensions.height10*5/2,
                          size: Dimensions.height10*5,),
                        text: Text("How to play", style: TextStyle(fontSize: Dimensions.font14, color: Colors.white)),),
                      Padding(
                        padding: EdgeInsets.only(right: Dimensions.width20),
                        child: IconButton(
                            onPressed: (){
                              Get.toNamed(RouteHelper.getHowToPlayPage());
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
                  ),
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      ProfileWidget(
                        appIcon: AppIcon(icon: Icons.question_answer,
                          backgroundColor: AppColors.blueColor,
                          iconColor: Colors.white,
                          iconSize: Dimensions.height10*5/2,
                          size: Dimensions.height10*5,),
                        text: Text("FAQ", style: TextStyle(fontSize: Dimensions.font14, color: Colors.white)),),
                      Padding(
                        padding: EdgeInsets.only(right: Dimensions.width20),
                        child: IconButton(
                            onPressed: (){
                              Get.toNamed(RouteHelper.getFaqPage());
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
                  ),
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      ProfileWidget(
                        appIcon: AppIcon(icon: Icons.support_agent,
                          backgroundColor: AppColors.blueColor,
                          iconColor: Colors.white,
                          iconSize: Dimensions.height10*5/2,
                          size: Dimensions.height10*5,),
                        text: Text("Contact Us", style: TextStyle(fontSize: Dimensions.font14, color: Colors.white)),),
                      Padding(
                        padding: EdgeInsets.only(right: Dimensions.width20),
                        child: IconButton(
                            onPressed: (){
                              var name = details[0];
                              var email = details[1];
                              var phone = details[2];
                              Get.toNamed(RouteHelper.getContactPage(), arguments: [name, email, phone]);
                            },
                            icon: Container(
                                padding: EdgeInsets.all(Dimensions.width5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.white12
                                ),
                                child: const Icon(Icons.arrow_forward_ios, color: Colors.white,)
                            )
                        ),
                      )
                    ],
                  ),
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      ProfileWidget(
                        appIcon: AppIcon(icon: Icons.share,
                          backgroundColor: AppColors.blueColor,
                          iconColor: Colors.white,
                          iconSize: Dimensions.height10*5/2,
                          size: Dimensions.height10*5,),
                        text: Text("Share App", style: TextStyle(fontSize: Dimensions.font14, color: Colors.white)),),
                      Padding(
                        padding: EdgeInsets.only(right: Dimensions.width20),
                        child: IconButton(
                            onPressed: (){
                              Platform.isIOS?Share.share('Install the PLFO app from ${AppConstants.shareLinkIOS}')
                              :Share.share('Install the PLFO app from ${AppConstants.shareLinkAndroid}');
                            },
                            icon: Container(
                              padding: EdgeInsets.all(Dimensions.width5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.white12
                              ),
                                child: const Icon(Icons.arrow_forward_ios, color: Colors.white,)
                            )
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
