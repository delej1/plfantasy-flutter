import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pl_fantasy_online/utils/dimensions.dart';

class PurchaseHistory extends StatefulWidget {
  const PurchaseHistory({Key? key}) : super(key: key);

  @override
  State<PurchaseHistory> createState() => _PurchaseHistoryState();
}

class _PurchaseHistoryState extends State<PurchaseHistory> {

  Stream<List<ReadPurchaseBody>> readFeedback() => FirebaseFirestore.instance
      .collection('purchase_token')
      .snapshots()
      .map((snapshot) => snapshot.docs
      .map((doc) => ReadPurchaseBody.fromJson(doc.data()))
      .toList());

  // Stream<List<ReadPurchaseBody>> readIOSFeedback() => FirebaseFirestore.instance
  //     .collection('purchase_token_IOS')
  //     .snapshots()
  //     .map((snapshot) => snapshot.docs
  //     .map((doc) => ReadPurchaseBody.fromJson(doc.data()))
  //     .toList());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: StreamBuilder<List<ReadPurchaseBody>>(
          stream: readFeedback(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Container();
            } else if (snapshot.hasData) {
              final feedback = snapshot.data!;
              return ListView(
                children: feedback.map(buildPurchase).toList(),
              );
            } else {
              return Container();
            }
          },
        )
    );
  }
}

// Widget buildPurchase(ReadPurchaseBody readPurchaseBody) {
//   FirebaseAuth auth = FirebaseAuth.instance;
//   if(auth.currentUser!.uid == readPurchaseBody._id){
//     return SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: Padding(
//           padding: EdgeInsets.symmetric(vertical: Dimensions.height1*3),
//           child: Container(
//             width: double.maxFinite,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(Dimensions.radius20/2),
//               color: Colors.black.withOpacity(0.1),
//             ),
//             child: Padding(
//               padding: EdgeInsets.all(Dimensions.width15),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Align(
//                     alignment: Alignment.topRight,
//                     child: Padding(
//                       padding: EdgeInsets.all(Dimensions.height1*4),
//                       child: Text(readPurchaseBody._date,
//                         style: TextStyle(fontSize: Dimensions.font14, color: Colors.white),),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.all(Dimensions.height1*4),
//                     child: Text(readPurchaseBody._email, style: TextStyle(fontSize: Dimensions.font14, color: Colors.white),),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.all(Dimensions.height1*4),
//                     child: Row(
//                       children: [
//                         Row(
//                           children: [
//                             Icon(Icons.numbers, size: Dimensions.iconSize16, color: Colors.white54,),
//                             Padding(
//                               padding: EdgeInsets.symmetric(horizontal: Dimensions.height1*4),
//                               child: Text(readPurchaseBody._reference, style: TextStyle(fontSize: Dimensions.font14, color: Colors.white)),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             ImageIcon(
//                               const AssetImage("assets/icon/entry_fee_icon.png"),
//                               size: Dimensions.iconSize16, color: Colors.white54,),
//                             Padding(
//                               padding: EdgeInsets.symmetric(horizontal: Dimensions.height1*4),
//                               child: Text(readPurchaseBody._tokens.toString(), style: TextStyle(fontSize: Dimensions.font14, color: Colors.white)),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             ImageIcon(
//                               const AssetImage("assets/icon/naira_icon.png"),
//                               size: Dimensions.iconSize16, color: Colors.white54,),
//                             Padding(
//                               padding: EdgeInsets.symmetric(horizontal: Dimensions.height1*4),
//                               child: Text(readPurchaseBody._amount.toString(), style: TextStyle(fontSize: Dimensions.font14, color: Colors.white)),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ));
//   }else{
//     return Container();
//   }
// }

Widget buildPurchase(ReadPurchaseBody readPurchaseBody) {
  FirebaseAuth auth = FirebaseAuth.instance;
  if(auth.currentUser!.uid == readPurchaseBody._id && readPurchaseBody._settled){
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
                      child: Text(readPurchaseBody._date,
                        style: TextStyle(fontSize: Dimensions.font14, color: Colors.white),),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(Dimensions.height1*4),
                    child: Text(readPurchaseBody._email, style: TextStyle(fontSize: Dimensions.font14, color: Colors.white),),
                  ),
                  Padding(
                    padding: EdgeInsets.all(Dimensions.height1*4),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.phone, size: Dimensions.iconSize16, color: Colors.white54,),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: Dimensions.height1*4),
                              child: Text(readPurchaseBody._phone, style: TextStyle(fontSize: Dimensions.font14, color: Colors.white)),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            ImageIcon(
                              const AssetImage("assets/icon/entry_fee_icon.png"),
                              size: Dimensions.iconSize16, color: Colors.white54,),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: Dimensions.height1*4),
                              child: Text(readPurchaseBody._tokens.toString(), style: TextStyle(fontSize: Dimensions.font14, color: Colors.white)),
                            ),
                          ],
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

// class ReadPurchaseBody {
//   late String _email;
//   late String _reference;
//   late int _amount;
//   late String _date;
//   late String _id;
//   late int _tokens;
//
//   ReadPurchaseBody({
//     required String email,
//     required String reference,
//     required int amount,
//     required String date,
//     required String id,
//     required int tokens,
//   }) {
//     _email = email;
//     _reference = reference;
//     _amount = amount;
//     _date = date;
//     _id = id;
//     _tokens = tokens;
//   }
//
//   ReadPurchaseBody.fromJson(Map<String, dynamic> json) {
//     _email = json['email'];
//     _reference = json['payment_reference'];
//     _amount = json['amount'];
//     _date = json['payment_time'];
//     _id = json['user_id'];
//     _tokens = json['tokens_purchased'];
//   }
// }

class ReadPurchaseBody {
  late String _email;
  late String _phone;
  late String _date;
  late String _id;
  late int _tokens;
  late bool _settled;

  ReadPurchaseBody({
    required String email,
    required String phone,
    required int amount,
    required String date,
    required String id,
    required int tokens,
    required bool settled,
  }) {
    _email = email;
    _phone = phone;
    _date = date;
    _id = id;
    _tokens = tokens;
    _settled = settled;
  }

  ReadPurchaseBody.fromJson(Map<String, dynamic> json) {
    _email = json['email'];
    _phone = json['phone'];
    _date = json['request_time'];
    _id = json['user_id'];
    _tokens = json['tokens_purchased'];
    _settled = json['settled'];
  }
}