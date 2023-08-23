import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:pl_fantasy_online/helpers/route_helper.dart';
import 'package:pl_fantasy_online/utils/colors.dart';
import 'package:pl_fantasy_online/utils/dimensions.dart';
import 'package:pl_fantasy_online/views/home/navigations/profile_page.dart';
import 'package:pl_fantasy_online/views/home/navigations/tournament_category_page.dart';
import 'package:pl_fantasy_online/views/home/navigations/welcome_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  late Stream<DocumentSnapshot> _tokenStream;

  late int _selectedPageIndex;
  late List<Widget> _pages;
  late PageController _pageController;

  bool isLoaded = false;
  String? mToken = "";
  
  void requestPermission() async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      debugPrint('User granted permission');
    }else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      debugPrint('User granted provisional permission');
    }else{
      debugPrint('User declined or has not accepted permission');
    }
  }

  void getToken() async{
    await FirebaseMessaging.instance.getToken().then((token){
      setState(() {
        mToken = token;
      });
      saveToken(token!);
    });
  }
  
  void saveToken(String token) async{
    await FirebaseFirestore.instance.collection("user_tokens").doc(auth.currentUser!.uid).set({
      'token':token,
    });
  }

  initInfo()async{
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
        macOS: initializationSettingsDarwin,);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(), htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(), htmlFormatContentTitle: true,
      );
      AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
          "PL Fantasy Online", "PL Fantasy Online", importance: Importance.high,
        styleInformation: bigTextStyleInformation, priority: Priority.high, playSound: true,
      );
      NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
      await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
          message.notification?.body, notificationDetails,
          payload: message.data['body']);
    });

  }

  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
    await Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => const HomePage()),
    );
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title!),
        content: Text(body!),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            },
          )
        ],
      ),
    );
  }



  @override
  void initState() {
    super.initState();
    _tokenStream = db.collection("user_data").doc(auth.currentUser?.uid).snapshots();
    _selectedPageIndex = 0;
    _pages = [
      const WelcomePage(),
      const TournamentCategoryPage(),
      const ProfilePage(),
    ];
    _pageController = PageController(initialPage: _selectedPageIndex);
    
    requestPermission();
    getToken();
    initInfo();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<bool> showExitPopup() async {
    return await showDialog( //show confirm dialogue
      //the return value will be from "Yes" or "No" options
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App', style: TextStyle(color: Colors.black),),
        content: const Text('Do you want to exit the App?', style: TextStyle(color: Colors.black),),
        actions:[
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainColor,),
            //return false when click on "NO"
            child:const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              if (Platform.isAndroid) {
                SystemNavigator.pop();
              } else if (Platform.isIOS) {
                Navigator.of(context).pop(false);
              }
            },
            //return true when click on "Yes"
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainColor,),
            child:const Text('Yes'),
          ),
        ],
      ),
    )??false; //if showDialog had returned null, then return false
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
          onWillPop: Platform.isAndroid?showExitPopup:null,
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
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                elevation: 0,
                leading: IconButton(
                  onPressed: (){
                    Get.offAndToNamed(RouteHelper.getLoadingPage());
                  },
                  icon: Image.asset(
                      "assets/icon/refresh_icon.png", height: Dimensions.iconSize24),
                ),
                actions: [
                  Padding(
                    padding: EdgeInsets.all(Dimensions.width8),
                    child: StreamBuilder<DocumentSnapshot>(
                        stream: _tokenStream,
                        builder: (context, snapshot) {
                          if(snapshot.hasError){
                            debugPrint("Error getting snapshot");
                          }
                          if(snapshot.connectionState == ConnectionState.waiting){

                          }else{
                            isLoaded = true;
                          }

                          Map<String, dynamic>? data = snapshot.data?.data() as Map<String, dynamic>?;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Image.asset("assets/icon/entry_fee_icon.png", height: Dimensions.iconSize24),
                                isLoaded?Text(" ${data?["tokens"]}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: Dimensions.font20),):
                                Text("--", style: TextStyle(fontWeight: FontWeight.bold, fontSize: Dimensions.font20),),
                              ],
                            ),
                            IconButton(
                                onPressed: (){
                                  Get.toNamed(RouteHelper.getMarketPage());
                                },
                                icon: Image.asset("assets/icon/add_icon.png",),)
                          ],
                        );
                      }
                    ),
                  )
                ],
              ),
              body: PageView(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (selectedPageIndex) {
                  setState(() {
                    _selectedPageIndex = selectedPageIndex;
                  });
                },
                children: _pages,
              ),
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: AppColors.gradientOne.withOpacity(0.4),
                selectedItemColor: Colors.white,
                currentIndex: _selectedPageIndex,
                //type: BottomNavigationBarType.fixed,
                showUnselectedLabels: false,
                onTap: (selectedPageIndex) {
                  setState(() {
                    _selectedPageIndex = selectedPageIndex;
                    _pageController.animateTo(selectedPageIndex.toDouble(), duration: const Duration(milliseconds: 200), curve: Curves.bounceOut);
                  });
                  _pageController.jumpToPage(selectedPageIndex);
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Image.asset(
                        "assets/icon/home_icon.png", height: Dimensions.iconSize15*2),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                        "assets/icon/tournament_icon.png", height: Dimensions.iconSize15*2),
                    label: 'Tournaments',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                        "assets/icon/profile_icon.png", height: Dimensions.iconSize15*2),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        );
  }
}
