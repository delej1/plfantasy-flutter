import 'package:get/get.dart';
import 'package:pl_fantasy_online/views/account/account_page.dart';
import 'package:pl_fantasy_online/views/auth/sign_in_page.dart';
import 'package:pl_fantasy_online/views/auth/sign_up_page.dart';
import 'package:pl_fantasy_online/views/history/history_page.dart';
import 'package:pl_fantasy_online/views/home/home_page.dart';
import 'package:pl_fantasy_online/views/loading/loading_screen.dart';
import 'package:pl_fantasy_online/views/market/market_page.dart';
import 'package:pl_fantasy_online/views/splash/splash_page.dart';
import 'package:pl_fantasy_online/views/support/navigations/about.dart';
import 'package:pl_fantasy_online/views/support/navigations/contact_us.dart';
import 'package:pl_fantasy_online/views/support/navigations/faq.dart';
import 'package:pl_fantasy_online/views/support/navigations/how_to_play.dart';
import 'package:pl_fantasy_online/views/support/support_page.dart';
import 'package:pl_fantasy_online/views/teams/create_team.dart';
import 'package:pl_fantasy_online/views/teams/my_team.dart';
import 'package:pl_fantasy_online/views/teams/navigations/edit_team_page.dart';
import 'package:pl_fantasy_online/views/teams/navigations/pick_team_page.dart';
import 'package:pl_fantasy_online/views/tournament/weekly_tournament/weekly_tournament_detail_page.dart';
import 'package:pl_fantasy_online/views/tournament/weekly_tournament/weekly_tournaments_page.dart';
import 'package:pl_fantasy_online/widgets/offline_widget.dart';

class RouteHelper{
  static const String splashPage = "/splash-page";
  static const String initial = "/";
  static const String signUp = "/sign-up";
  static const String signIn = "/sign-in";
  static const String loading = "/loading-screen";
  static const String history = "/history-screen";
  static const String tournament = "/tournament-screen";
  static const String weeklyTournament = "/weekly-tournament-screen";
  static const String market = "/market-screen";
  static const String myTeam = "/my-team";
  static const String accountPage = "/account-page";
  static const String supportPage = "/support-page";
  static const String contactUsPage = "/contact-page";
  static const String aboutPage = "/about-page";
  static const String howToPlayPage = "/how-to-play-page";
  static const String faqPage = "/faq-page";
  static const String offlinePage = "/offline-page";
  static const String createTeam = "/create-team";
  static const String pickTeamPage = "/pick-team-page";
  static const String editTeamPage = "/edit-team-page";


  static String getSplashPage()=>splashPage;
  static String getInitial()=>initial;
  static String getSignUpPage()=>signUp;
  static String getSignInPage()=>signIn;
  static String getLoadingPage()=>loading;
  static String getHistoryPage()=>history;
  static String getWeeklyTournamentPage()=>weeklyTournament;
  static String getTournamentPage()=>tournament;
  static String getMarketPage()=>market;
  static String getMyTeamPage()=>myTeam;
  static String getAccountPage()=>accountPage;
  static String getSupportPage()=>supportPage;
  static String getContactPage()=>contactUsPage;
  static String getAboutPage()=>aboutPage;
  static String getHowToPlayPage()=>howToPlayPage;
  static String getFaqPage()=>faqPage;
  static String getOfflinePage()=>offlinePage;
  static String getCreateTeamPage()=>createTeam;
  static String getPickTeamPage()=>pickTeamPage;
  static String getEditTeamPage()=>editTeamPage;


  static List<GetPage>routes=[

    GetPage(name: splashPage, page: (){
      return const SplashScreen();
    }, transition: Transition.fade,),

    GetPage(name: initial, page: (){
      return const HomePage();
    }, transition: Transition.fade),

    GetPage(name: signUp, page: (){
      return const SignUpPage();
    }, transition: Transition.fade),

    GetPage(name: signIn, page: (){
      return const SignInPage();
    }, transition: Transition.fade),

    GetPage(name: loading, page: (){
      return const LoadingScreen();
    }, transition: Transition.fade),

    GetPage(name: history, page: (){
      return const HistoryPage();
    }, transition: Transition.fade),

    GetPage(name: tournament, page: (){
      return const WeeklyTournamentDetailPage();
    }, transition: Transition.fade),

    GetPage(name: weeklyTournament, page: (){
      return const WeeklyTournamentsPage();
    }, transition: Transition.fade),

    GetPage(name: market, page: (){
      return const MarketPage();
    }, transition: Transition.fade),

    GetPage(name: myTeam, page: (){
      return const MyTeam();
    }, transition: Transition.fade),

    GetPage(name: accountPage, page: (){
      return const AccountPage();
    }, transition: Transition.fade),

    GetPage(name: supportPage, page: (){
      return const SupportPage();
    }, transition: Transition.fade),

    GetPage(name: contactUsPage, page: (){
      return const ContactUs();
    }, transition: Transition.fade),

    GetPage(name: aboutPage, page: (){
      return const About();
    }, transition: Transition.fade),

    GetPage(name: howToPlayPage, page: (){
      return const HowToPlay();
    }, transition: Transition.fade),

    GetPage(name: faqPage, page: (){
      return const FrequentlyAskedQuestions();
    }, transition: Transition.fade),

    GetPage(name: offlinePage, page: (){
      return const OfflineWidget();
    }, transition: Transition.fade),

    GetPage(name: createTeam, page: (){
      return const CreateTeam();
    }, transition: Transition.fade),

    GetPage(name: pickTeamPage, page: (){
      return const PickTeamPage();
    }, transition: Transition.fade),

    GetPage(name: editTeamPage, page: (){
      return const EditTeamPage();
    }, transition: Transition.fade),
  ];
}