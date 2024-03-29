import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pl_fantasy_online/utils/colors.dart';
import 'package:pl_fantasy_online/utils/dimensions.dart';


class AppTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final IconData icon;
  final bool isObscure;
  final bool maxLines;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final bool readOnly;
  final TextCapitalization? textCapitalization;
  final Function()? onEditingComplete;

  const AppTextField({Key? key,
    required this.textEditingController,
    required this.hintText,
    required this.icon,
    this.isObscure = false,
    this.maxLines = false,
    this.textInputType,
    this.inputFormatters,
    this.enabled,
    this.readOnly = false,
    this.textCapitalization,
    this.onEditingComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20),
      decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          boxShadow: [
            BoxShadow(
              blurRadius: 13,
              spreadRadius: 1,
              offset: const Offset(1,1),
              color: Colors.grey.withOpacity(0.2),
            )
          ]
      ),
      child: TextField(
        textCapitalization: textCapitalization != null?TextCapitalization.words:TextCapitalization.none,
        readOnly: readOnly?true:false,
        enabled: enabled,
        inputFormatters: inputFormatters,
        keyboardType: textInputType,
        maxLines: maxLines?3:1,
        obscureText: isObscure?true:false,
        controller: textEditingController,
        style: TextStyle(
          color: Colors.black,
          fontSize: Dimensions.font14,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon, color: AppColors.mainColor,),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              borderSide: const BorderSide(
                width: 1.0,
                color: Colors.white,
              )
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              borderSide: const BorderSide(
                width: 1.0,
                color: Colors.white,
              )
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius15),
          ),
        ),
        onEditingComplete: onEditingComplete,
      ),
    );
  }
}
