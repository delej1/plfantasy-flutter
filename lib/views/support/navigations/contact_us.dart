import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pl_fantasy_online/base/custom_app_bar.dart';
import 'package:pl_fantasy_online/base/custom_snack_bar.dart';
import 'package:pl_fantasy_online/utils/colors.dart';
import 'package:pl_fantasy_online/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {

  List<String> details = Get.arguments;

  final FirebaseFirestore db = FirebaseFirestore.instance;

  bool _pressed = false;

  TextEditingController topicController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    messageController.text = "";
    topicController.text = "";
  }

  @override
  void dispose() {
    messageController.dispose();
    topicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _pressed=false;
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
          appBar: const CustomAppBar(title: 'Contact Us',),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(Dimensions.width30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Topic",
                          style: TextStyle(fontSize: Dimensions.font16, color: Colors.white)),
                      SizedBox(height: Dimensions.height20,),
                      Container(
                        padding: EdgeInsets.all(Dimensions.width10),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(Dimensions.radius15),
                          color: Colors.white54.withOpacity(0.1),
                        ),
                        child: TextField(
                          controller: topicController,
                          maxLength: 20,
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(fontSize: Dimensions.font14,),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),

                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Message",
                          style: TextStyle(fontSize: Dimensions.font16, color: Colors.white)),
                      SizedBox(height: Dimensions.height20,),
                      Container(
                        padding: EdgeInsets.all(Dimensions.width10),
                        height: MediaQuery.of(context).size.height*0.2,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(Dimensions.radius15),
                          color: Colors.white54.withOpacity(0.1),
                        ),
                        child: TextField(
                          controller: messageController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          maxLength: 100,
                          expands: true,
                          textCapitalization: TextCapitalization.sentences,
                          style: TextStyle(fontSize: Dimensions.font14,),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),

                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height20,),
                  GestureDetector(
                      onTap: () async{
                        if(_pressed==false){
                          String topic = topicController.text;
                          String message = messageController.text;
                          try{
                            if(message.isNotEmpty && topic.isNotEmpty){
                              _pressed = true;
                              final collection = FirebaseFirestore.instance.collection('feedback');
                              await collection.doc().set({
                                'topic': topic,
                                'message': message,
                                'name': details[0],
                                'user_email': details[1],
                                'user_number': details[2],});
                              if (!mounted) return;
                              Navigator.of(context).pop();
                              showCustomSnackBar(title: "Sent", "Message sent successfully");
                              topicController.clear();
                              messageController.clear();
                            }else{showCustomSnackBar(title: "Error", "Type in a topic & message");}
                          }catch(e){ debugPrint(e.toString());}
                        }else{
                          showCustomSnackBar(title: "Error", "Message sent already");
                        }
                      } ,
                      child: Container(
                          padding: EdgeInsets.all(Dimensions.width10),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.width8),
                            color: AppColors.mainColor,),
                          child: Text("Send", style: TextStyle(fontSize: Dimensions.font20, color: Colors.white)))),
                ],
              ),
            ),
          ),
        ));
  }
}
