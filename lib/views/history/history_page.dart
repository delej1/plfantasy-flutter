import 'package:flutter/material.dart';
import 'package:pl_fantasy_online/utils/colors.dart';
import 'package:pl_fantasy_online/utils/dimensions.dart';
import 'package:pl_fantasy_online/views/history/navigations/purchase_history.dart';
import 'package:pl_fantasy_online/views/history/navigations/redeem_history.dart';
import 'package:pl_fantasy_online/views/history/navigations/tournament_history.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

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
          appBar: AppBar(title: const Text('History'),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
                onPressed: Navigator.of(context).pop,
                icon: const Icon(Icons.arrow_back_ios)),
            bottom: TabBar(
              indicatorWeight: 1.0,
              indicatorColor: Colors.white.withOpacity(0.4),
              tabs: [
                Padding(
                  padding: EdgeInsets.all(Dimensions.width8),
                  child: const Text("Requests"),
                ),
                Padding(
                  padding: EdgeInsets.all(Dimensions.width8),
                  child: const Text("Contests"),
                ),
                Padding(
                  padding: EdgeInsets.all(Dimensions.width8),
                  child: const Text("Wins"),
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
