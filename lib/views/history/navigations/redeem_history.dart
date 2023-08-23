import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pl_fantasy_online/utils/dimensions.dart';


class RedeemHistory extends StatefulWidget {
  const RedeemHistory({Key? key}) : super(key: key);

  @override
  State<RedeemHistory> createState() => _RedeemHistoryState();
}

class _RedeemHistoryState extends State<RedeemHistory> {

  Stream<List<ReadRedeemBody>> readFeedback() => FirebaseFirestore.instance
      .collection('redeem_token')
      .snapshots()
      .map((snapshot) => snapshot.docs
      .map((doc) => ReadRedeemBody.fromJson(doc.data()))
      .toList());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: StreamBuilder<List<ReadRedeemBody>>(
          stream: readFeedback(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Container();
            } else if (snapshot.hasData) {
              final feedback = snapshot.data!;
              return ListView(
                children: feedback.map(buildRedeem).toList(),
              );
            } else {
              return Container();
            }
          },
        )
    );
  }
}

Widget buildRedeem(ReadRedeemBody readRedeemBody) {
  FirebaseAuth auth = FirebaseAuth.instance;
  if(auth.currentUser!.uid == readRedeemBody._id){
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
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.all(Dimensions.height1*4),
                      child: Text(readRedeemBody._date, style: TextStyle(fontSize: Dimensions.font14, color: Colors.white),),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(Dimensions.height1*4),
                        child: Text(readRedeemBody._name, style: TextStyle(fontSize: Dimensions.font14, color: Colors.white),),
                      ),
                      Padding(
                        padding: EdgeInsets.all(Dimensions.height1*4),
                        child: Text(readRedeemBody._bankName, style: TextStyle(fontSize: Dimensions.font14, color: Colors.white),),
                      ),
                      Padding(
                        padding: EdgeInsets.all(Dimensions.height1*4),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.numbers, size: Dimensions.iconSize16, color: Colors.white54,),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: Dimensions.height1*4),
                                  child: Text(readRedeemBody._accountNumber, style: TextStyle(fontSize: Dimensions.font14, color: Colors.white)),
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
                                  child: Text(readRedeemBody._quantity.toString(), style: TextStyle(fontSize: Dimensions.font14, color: Colors.white)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
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

// Widget buildRedeem(ReadRedeemBody readRedeemBody) {
//   FirebaseAuth auth = FirebaseAuth.instance;
//   if(auth.currentUser!.uid == readRedeemBody._id){
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
//                 children: [
//                   Align(
//                     alignment: Alignment.topRight,
//                     child: Padding(
//                       padding: EdgeInsets.all(Dimensions.height1*4),
//                       child: Text(readRedeemBody._date, style: TextStyle(fontSize: Dimensions.font14, color: Colors.white),),
//                     ),
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.all(Dimensions.height1*4),
//                         child: Text(readRedeemBody._name, style: TextStyle(fontSize: Dimensions.font14, color: Colors.white),),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.all(Dimensions.height1*4),
//                         child: Text(readRedeemBody._email, style: TextStyle(fontSize: Dimensions.font14, color: Colors.white),),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.all(Dimensions.height1*4),
//                         child: Row(
//                           children: [
//                             Row(
//                               children: [
//                                 Icon(Icons.phone, size: Dimensions.iconSize16, color: Colors.white54,),
//                                 Padding(
//                                   padding: EdgeInsets.symmetric(horizontal: Dimensions.height1*4),
//                                   child: Text(readRedeemBody._phone, style: TextStyle(fontSize: Dimensions.font14, color: Colors.white)),
//                                 ),
//                               ],
//                             ),
//                             Row(
//                               children: [
//                                 ImageIcon(
//                                   const AssetImage("assets/icon/entry_fee_icon.png"),
//                                   size: Dimensions.iconSize16, color: Colors.white54,),
//                                 Padding(
//                                   padding: EdgeInsets.symmetric(horizontal: Dimensions.height1*4),
//                                   child: Text(readRedeemBody._quantity.toString(), style: TextStyle(fontSize: Dimensions.font14, color: Colors.white)),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
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

class ReadRedeemBody {
  late String _name;
  late String _bankName;
  late String _accountNumber;
  late int _quantity;
  late String _date;
  late String _id;

  ReadRedeemBody({
    required String name,
    required String bankName,
    required String accountNumber,
    required int quantity,
    required String date,
    required String id,
  }) {
    _name = name;
    _bankName = bankName;
    _accountNumber = accountNumber;
    _quantity = quantity;
    _date = date;
    _id = id;
  }

  ReadRedeemBody.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _bankName = json['bank_name'];
    _accountNumber = json['account_number'];
    _quantity = json['token_amount'];
    _date = json['created_at'];
    _id = json['id'];
  }
}

// class ReadRedeemBody {
//   late String _name;
//   late String _email;
//   late String _phone;
//   late int _quantity;
//   late String _date;
//   late String _id;
//
//   ReadRedeemBody({
//     required String name,
//     required String email,
//     required String phone,
//     required int quantity,
//     required String date,
//     required String id,
//   }) {
//     _name = name;
//     _email = email;
//     _phone = phone;
//     _quantity = quantity;
//     _date = date;
//     _id = id;
//   }
//
//   ReadRedeemBody.fromJson(Map<String, dynamic> json) {
//     _name = json['name'];
//     _email = json['email'];
//     _phone = json['phone_number'];
//     _quantity = json['token_amount'];
//     _date = json['created_at'];
//     _id = json['id'];
//   }
// }