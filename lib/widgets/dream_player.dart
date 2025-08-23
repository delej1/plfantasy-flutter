import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pl_fantasy_online/utils/dimensions.dart';

class DreamPlayer extends StatelessWidget {
  const DreamPlayer({
    super.key,
    required this.image,
    required this.name,
    required this.points,
    required this.top,
    required this.right,
    required this.left,
    required this.position,
  }) : assert(top > 0.0);
  final String image;
  final String name;
  final int points;
  final String position;
  final double top;
  final double right;
  final double left;

  @override
  Widget build(BuildContext context) {
    final double _height = MediaQuery.of(context).size.height / 2;
    double height = 0.18181818 * (0.6773399 * _height);
    return Positioned(
      top: top,
      right: right,
      left: left,
      child: SizedBox(
        height: (height + Dimensions.height45),
        child: Column(children: [
          CachedNetworkImage(
            imageUrl: image,
            errorWidget: (context, url, error) => Image.asset(position != "GK"
                ? "assets/image/jersey_img.png"
                : "assets/image/jersey_gk.png"),
            height: position == 'GK' ? height - 10.0 : height,
          ),
          //Image.asset(image, height: position == 'GK' ? height - 10.0 : height),
          SizedBox(
            height: Dimensions.height45,
            child: Padding(
                padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Dimensions.font14,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      ),
                      Text(
                        points.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Dimensions.font14,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )),
          ),
        ]),
      ),
    );
  }
}
