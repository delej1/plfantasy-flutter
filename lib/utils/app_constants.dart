import 'package:cloud_firestore/cloud_firestore.dart';


final FirebaseFirestore db = FirebaseFirestore.instance;

int createTournament = 0;
int booster = 0;
int tokenPriceOne = 0;
int tokenPriceThree = 0;
int tokenPriceFive = 0;
int tokenPriceTen = 0;
int tokenPriceFifteen = 0;
int tokenPriceTwenty = 0;
String tokenLinkOne = "";
String tokenLinkThree = "";
String tokenLinkFive = "";
String tokenLinkTen = "";
String tokenLinkFifteen = "";
String tokenLinkTwenty = "";
String redeemText = "";
String about = "";
String howToPlayGeneral = "";
String howToPlayWeekly = "";
String faq = "";
String apiTermii = "";
String adminNum = "";
String iosLink = "";
String androidLink = "";
String showData = "";


class AppConstants{
  void firebaseGetData() async {
    await db.collection("constants").doc("details").get().then((data){
      createTournament = data["create_tournament_cost"];
      booster = data["booster_cost"];
      tokenPriceOne = data["token_price_1"];
      tokenPriceThree = data["token_price_3"];
      tokenPriceFive = data["token_price_5"];
      tokenPriceTen = data["token_price_10"];
      tokenPriceFifteen = data["token_price_15"];
      tokenPriceTwenty = data["token_price_20"];
      tokenLinkOne = data["token_link_1"];
      tokenLinkThree = data["token_link_3"];
      tokenLinkFive = data["token_link_5"];
      tokenLinkTen = data["token_link_10"];
      tokenLinkFifteen = data["token_link_15"];
      tokenLinkTwenty = data["token_link_20"];
      redeemText = data["redeem_text"];
      about = data["about"];
      howToPlayGeneral = data["how_to_play_general"];
      howToPlayWeekly = data["how_to_play_weekly"];
      faq = data["faq"];
      apiTermii = data["termii_api"];
      adminNum = data["admin_number"];
      iosLink = data["IOS_link"];
      androidLink = data["android_link"];
      showData = data["show_data"];
    });
  }
  static int createTournamentCost = createTournament;
  static int boosterCost = booster;
  static int createTournamentAndBoost = createTournament + booster;
  static int tokenPrice1 = tokenPriceOne;
  static int tokenPrice3 = tokenPriceThree;
  static int tokenPrice5 = tokenPriceFive;
  static int tokenPrice10 = tokenPriceTen;
  static int tokenPrice15 = tokenPriceFifteen;
  static int tokenPrice20 = tokenPriceTwenty;
  static String tokenLink1 = tokenLinkOne;
  static String tokenLink3 = tokenLinkThree;
  static String tokenLink5 = tokenLinkFive;
  static String tokenLink10 = tokenLinkTen;
  static String tokenLink15 = tokenLinkFifteen;
  static String tokenLink20 = tokenLinkTwenty;
  static String redeemTextString = redeemText;
  static String aboutString = about;
  static String howToPlayGeneralString = howToPlayGeneral;
  static String howToPlayWeeklyString = howToPlayWeekly;
  static String frequentlyAskedQuestions = faq;
  static String termiiApi = apiTermii;
  static String adminPhoneNumber = adminNum;
  static String shareLinkIOS = iosLink;
  static String shareLinkAndroid = androidLink;
  //static String showImgData = showData;
}