import 'package:flutter/material.dart';
import 'package:pl_fantasy_online/utils/dimensions.dart';

class CreatePlayer extends StatelessWidget {
  const CreatePlayer({
    Key? key,
    required this.image,
    required this.top,
    required this.right,
    required this.left,
    required this.position,
    required this.onTap,
  })  : assert(top > 0.0),
        super(key: key);
  final String image;
  final String position;
  final double top;
  final double right;
  final double left;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final double _height = MediaQuery.of(context).size.height;
    double height = 0.18181818 * (0.6773399 * _height/1.7);
    return Positioned(
      top: top,
      right: right,
      left: left,
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          height: (height + Dimensions.height45),
          child: Column(children: [
            Image.asset(image, height: position == 'GK' ? height - 10.0 : height),
            const Icon(Icons.add_circle, size: 24, color: Colors.black,),
          ]),
        ),
      ),
    );
  }
}
