import 'package:flutter/material.dart';
import 'package:pl_fantasy_online/base/custom_app_bar.dart';
import 'package:pl_fantasy_online/base/custom_loader.dart';
import 'package:pl_fantasy_online/paystack/make_payment.dart';
import 'package:pl_fantasy_online/utils/app_constants.dart';
import 'package:pl_fantasy_online/utils/colors.dart';
import 'package:pl_fantasy_online/utils/dimensions.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({Key? key}) : super(key: key);

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {

  var tokens = [
    {"id": "1", "price": "${AppConstants.tokenPrice1}", "link":AppConstants.tokenLink1},
    {"id": "3", "price": "${AppConstants.tokenPrice3}", "link":AppConstants.tokenLink3},
    {"id": "5", "price": "${AppConstants.tokenPrice5}", "link":AppConstants.tokenLink5},
    {"id": "10", "price": "${AppConstants.tokenPrice10}", "link":AppConstants.tokenLink10},
    {"id": "15", "price": "${AppConstants.tokenPrice15}", "link":AppConstants.tokenLink15},
    {"id": "20", "price": "${AppConstants.tokenPrice20}", "link":AppConstants.tokenLink20},
  ];

  bool formOkay = false;

  TextEditingController tokenController = TextEditingController();

  @override
  void initState() {
    super.initState();
    tokenController.text = "";
  }

  @override
  void dispose() {
    tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
        appBar: const CustomAppBar(title: 'Request Tokens'),
        body: Padding(
          padding: EdgeInsets.all(Dimensions.width10),
          child: GridView.count(
              physics: const BouncingScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 0.9,
              children: tokens.map((token) =>
                  GestureDetector(
                    onTap: (){
                      showDialog(context: context, builder:(builderContext) {
                        Future.delayed(
                          const Duration(seconds: 4),
                              () {
                            Navigator.of(builderContext).pop();
                          },
                        ).then((value) => {
                          MakePayment(ctx: context, amount: int.parse(token['price']!),
                              tokenPurchase: int.parse(token['id']!), link: token['link']!).sendDataToFirestore()
                        });
                        return const Center(
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: AlertDialog(
                              title: Center(child: Text("Please Wait")),
                              content: CustomLoader(),
                            ),
                          ),
                        );
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.all(Dimensions.width8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(Dimensions.width10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Padding(
                              //         padding: EdgeInsets.all(Dimensions.width8),
                              //         child: token['id']=="20"?BlinkText(
                              //           'Best Deal!',
                              //           style: TextStyle(fontSize: Dimensions.font14, color: Colors.white,),
                              //           endColor: Colors.red,
                              //         ):Text("", style: TextStyle(
                              //             fontWeight: FontWeight.bold,
                              //             color: Colors.white,
                              //             fontSize: Dimensions.font14
                              //         ),)),
                              //     Padding(
                              //       padding: EdgeInsets.all(Dimensions.width8),
                              //       child: Text("₦${token['price']!}", style: TextStyle(
                              //           fontWeight: FontWeight.bold,
                              //           color: Colors.green.shade500,
                              //           fontSize: Dimensions.font16
                              //       ),),
                              //     ),
                              //   ],
                              // ),
                              Image.asset("assets/image/token_img.png",
                                height: MediaQuery.of(context).size.height*0.12,
                              ),
                              Padding(
                                  padding: EdgeInsets.all(Dimensions.width8),
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: token['id']!="1"?Text("${token['id']!} Tokens", style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: Dimensions.font14
                                    ),):Text("${token['id']!} Token", style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: Dimensions.font14
                                    ),),
                                  )),
                            ]),
                      ),
                    ),
                  )).toList()
          ),
        )
      ),
    );
  }
}
