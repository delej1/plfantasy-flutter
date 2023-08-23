//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'package:pl_fantasy_online/base/custom_snack_bar.dart';
import 'package:pl_fantasy_online/views/auth/sign_in_page.dart';
import 'package:pl_fantasy_online/views/loading/loading_screen.dart';

class AuthController extends GetxController{
  static AuthController instance = Get.find();
  FirebaseAuth auth = FirebaseAuth.instance;

  var isLoading = false.obs;
  var isGoogleSignInLoading = false;

  void register(String email, password) async{
    try{
      isLoading(true);
      await auth.createUserWithEmailAndPassword(email: email, password: password).then((value) => Get.offAll(()=>const LoadingScreen()));
    }catch(e){
      showCustomSnackBar(e.toString());
    }finally{
      isLoading(false);
    }
  }

  void signIn(String email, password) async{
    try{
      isLoading(true);
      await auth.signInWithEmailAndPassword(email: email, password: password).then((value) => Get.offAll(()=>const LoadingScreen()));
    }catch(e){
      showCustomSnackBar(e.toString());
    }finally{
      isLoading(false);
    }
  }

  // signInWithGoogle() async {
  //   // Trigger the authentication flow
  //   final GoogleSignInAccount? googleUser =
  //   await GoogleSignIn(scopes: <String>["email"]).signIn();
  //
  //   // Obtain the auth details from the request
  //   final GoogleSignInAuthentication googleAuth =
  //   await googleUser!.authentication;
  //
  //   // Create a new credential
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );
  //   // Once signed in, return the UserCredential
  //   checkIfEmailInUse(googleUser.displayName, googleUser.email);
  //   Future.delayed(const Duration(seconds: 1), () async{
  //     await FirebaseAuth.instance.signInWithCredential(credential);
  //     Get.offAll(()=>const LoadingScreen());
  //   });
  // }

  void resetPassword(String email) async{
    try{
      isLoading(true);
      await auth.sendPasswordResetEmail(email: email);
      showCustomSnackBar(title: "Success", "Password reset sent successfully");
    }catch(e){
      showCustomSnackBar(e.toString());
    }finally{
      isLoading(false);
    }
  }

  void signOut() async{
    await auth.signOut();
    Get.offAll(()=>const SignInPage());
  }

}

// Future<void> checkIfEmailInUse(String? displayName, String email) async {
//   try {
//     final list = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
//     if (list.isEmpty) {
//       Future.delayed(const Duration(seconds: 3), () async{
//         uploadUserData(displayName, email);
//         uploadUserTeamData(displayName);
//       });
//     }
//   } catch (e) {
//     debugPrint(e.toString());
//   }
// }
//
// void uploadUserData(name, email) async{
//   try{
//     final collection = FirebaseFirestore.instance.collection('user_data');
//     await collection.doc(FirebaseAuth.instance.currentUser!.uid).set({
//       'name': name??"",
//       'phone': "",
//       'email': email,
//       'tokens': 0,
//       'bank': "",
//       'account_name': "",
//       'account_number': "",
//       'bank_code': "",
//       'fpl_id':"",
//       'approved':false,
//     }).then((_) => showCustomSnackBar(title: "Success",
//         "You have successfully signed in. Thanks!"));
//   }catch(e){ debugPrint(e.toString());}
// }
//
// void uploadUserTeamData(name) async{
//   try{
//     final collection = FirebaseFirestore.instance.collection('user_teams');
//     await collection.doc(FirebaseAuth.instance.currentUser!.uid).set({
//       'alias': "",
//       'gk': 0,
//       'rb': 0,
//       'rcb': 0,
//       'lcb': 0,
//       'lb': 0,
//       'rmd': 0,
//       'md': 0,
//       'lmd': 0,
//       'rfwd': 0,
//       'fwd': 0,
//       'lfwd': 0,
//       'gk_sub': 0,
//       'def_sub': 0,
//       'mid_sub': 0,
//       'fwd_sub': 0,
//       'captain': 0,
//       'money': 100,
//       'user_id': FirebaseAuth.instance.currentUser!.uid,
//       'user_name': name??"",
//     });
//   }catch(e){ debugPrint(e.toString());}
// }

