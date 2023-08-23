import 'package:flutter/material.dart';
import 'package:pl_fantasy_online/utils/dimensions.dart';

class SubCreatePlayer extends StatelessWidget {
  const SubCreatePlayer({
    Key? key,
    required this.image,
    required this.position,
    required this.onTap,
  })  : super(key: key);
  final String image;
  final String position;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final double _height = MediaQuery.of(context).size.height;
    double height = 0.18181818 * (0.6773399 * _height/1.7);
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: (height + Dimensions.height45),
        child: Column(children: [
          Image.asset(image, height: position == 'GK' ? height - 10.0 : height),
          Icon(Icons.add_circle, size: Dimensions.iconSize15*2, color: Colors.black,),
        ]),
      ),
    );
  }
}
