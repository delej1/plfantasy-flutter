import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pl_fantasy_online/utils/dimensions.dart';


class TournamentHistory extends StatefulWidget {
  const TournamentHistory({Key? key}) : super(key: key);

  @override
  State<TournamentHistory> createState() => _TournamentHistoryState();
}

class _TournamentHistoryState extends State<TournamentHistory> {

  Stream<List<ReadTournamentBody>> readTournament() => FirebaseFirestore.instance
      .collection('tournament_history')
      .snapshots()
      .map((snapshot) => snapshot.docs
      .map((doc) => ReadTournamentBody.fromJson(doc.data()))
      .toList());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: StreamBuilder<List<ReadTournamentBody>>(
          stream: readTournament(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Container();
            } else if (snapshot.hasData) {
              final feedback = snapshot.data!;
              return ListView(
                children: feedback.map(buildTournament).toList(),
              );
            } else {
              return Container();
            }
          },
        ));
  }
}

Widget buildTournament(ReadTournamentBody readTournamentBody) {
  FirebaseAuth auth = FirebaseAuth.instance;
  if(readTournamentBody._players.containsKey(auth.currentUser!.uid)){
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: Dimensions.height1*3),
          child: Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radius20/2),
              color: Colors.black.withOpacity(0.1),
            ),
            child: Padding(
              padding: EdgeInsets.all(Dimensions.width15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.all(Dimensions.height1*4),
                      child: Text(readTournamentBody._settlementTime,
                        style: TextStyle(fontSize: Dimensions.font14, color: Colors.white),),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(Dimensions.height1*4),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.height1*4),
                          child: Text("Tourney: ", style: TextStyle(fontSize: Dimensions.font14, color: Colors.white)),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.height1*4),
                          child: Text(readTournamentBody._name.toString(), style: TextStyle(fontSize: Dimensions.font14, color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(Dimensions.height1*4),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: Dimensions.height1*4),
                              child: Text("Game Week: ", style: TextStyle(fontSize: Dimensions.font14, color: Colors.white)),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: Dimensions.height1*4),
                              child: Text(readTournamentBody._gameWeek.toString(), style: TextStyle(fontSize: Dimensions.font14, color: Colors.white)),
                            ),
                          ],
                        ),
                        Text(" | ", style: TextStyle(fontSize: Dimensions.font20, fontWeight: FontWeight.bold),),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: Dimensions.height1*4),
                              child: Text("Entry: ", style: TextStyle(fontSize: Dimensions.font14, color: Colors.white)),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: Dimensions.height1*4),
                              child: Text("${readTournamentBody._entryFee.toString()} Tokens", style: TextStyle(fontSize: Dimensions.font14, color: Colors.white)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(Dimensions.height1*4),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.height1*4),
                          child: Text("Status: ", style: TextStyle(fontSize: Dimensions.font14, color: Colors.white)),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.height1*4),
                          child: readTournamentBody._winners.containsKey(auth.currentUser!.uid)
                              ?Row(
                                children: [
                                  Text("WON", style: TextStyle(fontSize: Dimensions.font14, color: Colors.white)),
                                  Text(" | ", style: TextStyle(fontSize: Dimensions.font20, fontWeight: FontWeight.bold),),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: Dimensions.height1*4),
                                        child: Text("Prize: ", style: TextStyle(fontSize: Dimensions.font14, color: Colors.white)),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: Dimensions.height1*4),
                                        child: Text("${readTournamentBody._winners[auth.currentUser!.uid].toString()} Tokens", style: TextStyle(fontSize: Dimensions.font14, color: Colors.white)),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                              :Text("LOST", style: TextStyle(fontSize: Dimensions.font14, color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }else{
    return Container();
  }
}

class ReadTournamentBody {
  late String _name;
  late int _entryFee;
  late int _gameWeek;
  late Map _players;
  late Map _winners;
  late String _settlementTime;

  ReadTournamentBody({
    required String name,
    required int entryFee,
    required int gameWeek,
    required Map players,
    required Map winners,
    required String settlementTime,
  }) {
    _name = name;
    _entryFee = entryFee;
    _gameWeek = gameWeek;
    _players = players;
    _winners = winners;
    _settlementTime = settlementTime;
  }

  ReadTournamentBody.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _entryFee = json['entry_fee'];
    _gameWeek = json['game_week'];
    _players = json['players'];
    _winners = json['winners'];
    _settlementTime = json['settlement_time'];
  }
}
