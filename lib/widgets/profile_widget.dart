import 'package:flutter/material.dart';
import 'package:pl_fantasy_online/utils/dimensions.dart';
import 'package:pl_fantasy_online/widgets/app_icon.dart';



class ProfileWidget extends StatelessWidget {
  final AppIcon appIcon;
  final Text text;
  const ProfileWidget({Key? key, required this.appIcon, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Dimensions.width10),
      child: Container(
        width: Dimensions.screenWidth*0.88,
        padding: EdgeInsets.only(left: Dimensions.width20,
            top: Dimensions.width10,
            bottom: Dimensions.width10),
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(Dimensions.radius20*5),
            boxShadow:[
              BoxShadow(
                blurRadius: 1,
                offset:const Offset(0,2),
                color: Colors.black.withOpacity(0.5),
              )
            ]
        ),
        child: Row(
          children: [
            appIcon,
            SizedBox(width: Dimensions.width20,),
            SizedBox(width: Dimensions.screenWidth*0.55, child: text)
          ],
        ),
      ),
    );
  }
}
