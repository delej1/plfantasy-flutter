import 'package:flutter/material.dart';
import 'package:pl_fantasy_online/utils/colors.dart';
import 'package:pl_fantasy_online/utils/dimensions.dart';
import 'package:pl_fantasy_online/views/history/navigations/purchase_history.dart';
import 'package:pl_fantasy_online/views/history/navigations/redeem_history.dart';
import 'package:pl_fantasy_online/views/history/navigations/tournament_history.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
          appBar: AppBar(title: Text('History',
            style: TextStyle(color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: Dimensions.font20,
            ),),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
                onPressed: Navigator.of(context).pop,
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white,)),
            bottom: TabBar(
              indicatorWeight: 1.0,
              indicatorColor: Colors.white.withOpacity(0.4),
              tabs: [
                Padding(
                  padding: EdgeInsets.all(Dimensions.width8),
                  child: Text("Requests", style: TextStyle(fontSize: Dimensions.font16, color: Colors.white)),
                ),
                Padding(
                  padding: EdgeInsets.all(Dimensions.width8),
                  child: Text("Contests", style: TextStyle(fontSize: Dimensions.font16, color: Colors.white)),
                ),
                Padding(
                  padding: EdgeInsets.all(Dimensions.width8),
                  child: Text("Wins", style: TextStyle(fontSize: Dimensions.font16, color: Colors.white)),
                ),
              ],),),
          backgroundColor: Colors.transparent,
          body: const TabBarView(
            physics: BouncingScrollPhysics(),
            children: [
              PurchaseHistory(),
              TournamentHistory(),
              RedeemHistory(),
            ],
          ),
        ),
      ),
    );
  }
}
