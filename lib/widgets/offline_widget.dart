import 'package:flutter/material.dart';
import 'package:pl_fantasy_online/utils/colors.dart';

class OfflineWidget extends StatelessWidget {
  const OfflineWidget({Key? key}) : super(key: key);

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
      child: const Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.settings, size: 50,),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Text("No Internet Connection",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                ),
                Text("Please connect to the internet and restart your app for full functionality.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
