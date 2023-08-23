import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pl_fantasy_online/base/custom_snack_bar.dart';
import 'package:pl_fantasy_online/utils/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';

bool isSuccessful = false;

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();
String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

String name = "";
String phone = "";
String email = "";
bool approved = false;
//String reference = getRandomString(10);
//late int tokenBalance;
//late String token;

final FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

class MakePayment extends GetConnect implements GetxService{
  MakePayment({required this.ctx, required this.amount, required this.tokenPurchase, required this.link});
  BuildContext ctx;
  int amount;
  int tokenPurchase;
  String link;

  //PaystackPlugin paystack = PaystackPlugin();

  // PaymentCard _getCardUI(){
  //   return PaymentCard(
  //       number: "",
  //       cvc: "",
  //       expiryMonth: 0,
  //       expiryYear: 0,
  //   );
  // }

  void firebaseGetData() async {
    await db.collection("user_data").doc(auth.currentUser!.uid).get().then((data){
      name = data["name"];
      phone = data["phone"];
      email = data["email"];
      approved = data["approved"];
      //tokenBalance = data["tokens"];
    });
  }

  // Future initializePlugin() async{
  //   var collection = FirebaseFirestore.instance.collection('paystack');
  //   var docSnapshot = await collection.doc('details').get();
  //   if(docSnapshot.exists){
  //     Map<String, dynamic>? data = docSnapshot.data();
  //     try {
  //       String  publicKey = data?['public_key'];
  //       token = data?['secret_key'];
  //       await paystack.initialize(publicKey: publicKey);
  //     }catch(e){debugPrint(e.toString());}
  //   }
  // }
  //
  // chargeCard(){
  //   firebaseGetData();
  //   initializePlugin().then((_) async{
  //     Charge charge = Charge()
  //       ..amount = amount * 100
  //       ..email = email
  //       ..reference = reference
  //       ..card = _getCardUI();
  //
  //       CheckoutResponse response = await paystack.checkout(
  //           ctx,
  //           charge: charge,
  //           method: CheckoutMethod.card,
  //           fullscreen: false,
  //           logo: ClipRRect(
  //               borderRadius: BorderRadius.circular(Dimensions.radius30),
  //               child: Image.asset("assets/image/app_emblem.png", fit: BoxFit.cover,
  //                 height: Dimensions.height10*5,
  //                 width: Dimensions.width10*5,))
  //       );
  //
  //       if(response.status == true){
  //         isSuccessful = true;
  //         sendDataToFirestore(amount, tokenPurchase);
  //         verifyPayment(tokenPurchase);
  //       }else{
  //         isSuccessful = false;
  //         sendDataToFirestore(amount, tokenPurchase);
  //     }
  //   });
  // }
  //
  // Future<Response> verifyPayment(int tokenPurchase) async {
  //     try {
  //       Response response = await get(
  //           'https://api.paystack.co/transaction/verify/$reference',
  //           headers: {
  //             'Authorization': 'Bearer $token',
  //           });
  //       Map result = response.body;
  //       if(result["status"] == true){
  //         try{
  //           FirebaseFirestore.instance.collection('user_data')
  //               .doc(auth.currentUser!.uid)
  //               .update({'tokens': tokenBalance + tokenPurchase})
  //               .then((_) => showCustomSnackBar(title: "Status", "Transaction successful, thank you"));
  //         }catch(e){showCustomSnackBar(e.toString());}
  //         reference = getRandomString(10);
  //       }
  //       return response;
  //     } catch (e) {
  //       return Response(statusCode: 1, statusText: e.toString());
  //     }
  // }

  Future<Response> sendTermiiSMS(name, phone, tokenPurchase, tokenAmount, link) async{
    try{
      Response response = await post("https://api.ng.termii.com/api/sms/send",
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        {
          "to": phone.replaceAll("+",""),
          "from": "PL Fantasy",
          "sms": "Hi $name, kindly visit the following link: $link.",
          "type": "plain",
          "channel": "generic",
          "api_key": AppConstants.termiiApi,
        },
      );
      if(response.statusCode==200){
        showCustomSnackBar(title: "Status", "Request successful, You will receive feedback shortly");
      }else{
        showCustomSnackBar(title: "Oops", "Request failed, kindly try again");
      }
      return response;
    }catch(e){
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> sendAdminAlertSMS(name) async{
    try{
      Response response = await post("https://api.ng.termii.com/api/sms/send",
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        {
          "to": AppConstants.adminPhoneNumber,
          "from": "PL Fantasy",
          "sms": "Request alert from $name",
          "type": "plain",
          "channel": "generic",
          "api_key": AppConstants.termiiApi,
        },
      );
      if(response.statusCode==200){
        showCustomSnackBar(title: "Status", "Request successful, You will receive feedback shortly");
      }else{
        showCustomSnackBar(title: "Oops", "Request failed, kindly try again");
      }
      return response;
    }catch(e){
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<void> openStack (url) async{
    Uri uri = Uri.parse(url);
    try{
      await launchUrl(uri, mode: LaunchMode.inAppWebView);
    }catch(e){
      debugPrint(e.toString());
    }
    // if (await canLaunchUrl(uri)) {
    // await launchUrl(uri, mode: LaunchMode.inAppWebView);
    // }else{throw 'Could not launch $uri';}
  }

  void sendDataToFirestore () {
    final requestDetails = FirebaseFirestore.instance.collection('purchase_token').doc();
    firebaseGetData();
    Future.delayed(const Duration(seconds: 2), (){
      try{
        requestDetails.set({
          'name': name,
          'phone': phone,
          'email': email,
          'user_id': auth.currentUser!.uid,
          'request_time': DateFormat('h:mm:s a, dd-MMM-yy').format(DateTime.now()),
          'amount': amount,
          'tokens_purchased': tokenPurchase,
          'settled': false,
        }, SetOptions(merge: true))
            .then((_){
              if(approved) {
                openStack(link);
                //sendTermiiSMS(name, phone, tokenPurchase, amount, link);
              }else{
                sendAdminAlertSMS(name);
              }
        });
      }catch(e){debugPrint(e.toString());}
    });
  }

}

// void sendDataToFirestore (int amount, int tokenPurchase) {
//   final paymentDetails = FirebaseFirestore.instance.collection('purchase_token').doc();
//   if (isSuccessful) {
//     try{
//       paymentDetails.set({
//         'name': name,
//         'phone': phone,
//         'email': email,
//         'user_id': auth.currentUser!.uid,
//         'payment_reference': reference,
//         'payment_time': DateFormat('h:mm a, dd-MMM-yy').format(DateTime.now()),
//         'amount': amount,
//         'tokens_purchased': tokenPurchase,
//       }, SetOptions(merge: true));
//     }catch(e){debugPrint(e.toString());}
//   }else {
//     showCustomSnackBar(title: "Status", "Transaction failed, please try again");
//   }
// }

