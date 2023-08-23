import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pl_fantasy_online/controllers/auth_controller.dart';
import 'package:pl_fantasy_online/controllers/bank_list_controller.dart';
import 'package:pl_fantasy_online/controllers/event_status_controller.dart';
import 'package:pl_fantasy_online/controllers/general_controller.dart';
import 'package:pl_fantasy_online/helpers/route_helper.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  debugPrint('Handling a background message ${message.messageId}');
}

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {
    Get.put(AuthController());
    Get.put(BankListController());
  });
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  Get.put(GeneralController());
  Get.put(EventStatusController());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
        runApp(const MyApp());
  });
  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }
}

class MyApp extends StatelessWidget  {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PL Fantasy Online',
      initialRoute: RouteHelper.getSplashPage(),
      getPages: RouteHelper.routes,
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme.apply(
              // bodyColor: Colors.white,
              // displayColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
