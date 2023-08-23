import 'package:flutter/material.dart';
import 'package:pl_fantasy_online/utils/dimensions.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  final bool backButtonExist;
  final Function? onBackPressed;

  const CustomAppBar({Key? key, required this.title,
    this.backButtonExist=true,
    this.onBackPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title,
        style: TextStyle(color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: Dimensions.font20,
        ),),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      elevation: 0,
      leading: backButtonExist?IconButton(
          onPressed: ()=>onBackPressed!=null?onBackPressed!()
              :Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios)):const SizedBox(),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(Dimensions.height56);
}
