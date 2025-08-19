import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pl_fantasy_online/utils/dimensions.dart';

class Player extends StatelessWidget {
  const Player({
    super.key,
    required this.image,
    required this.name,
    this.points,
    required this.top,
    required this.right,
    required this.left,
    required this.position,
    this.onTap,
    required this.captainBand,
  }) : assert(top > 0.0);
  final String image;
  final String name;
  final int? points;
  final String position;
  final double top;
  final double right;
  final double left;
  final Function()? onTap;
  final Widget captainBand;

  @override
  Widget build(BuildContext context) {
    final double _height = MediaQuery.of(context).size.height;
    double height = 0.18181818 * (0.6773399 * _height / 1.7);
    return Positioned(
      top: top,
      right: right,
      left: left,
      child: GestureDetector(
        onTap: onTap,
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
            SizedBox(
              height: Dimensions.height45,
              child: Padding(
                  padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Text(
                          name.isEmpty ? '--' : name,
                          style: TextStyle(
                              color: Colors.white, fontSize: Dimensions.font14),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            captainBand,
                            SizedBox(
                              width: Dimensions.width5,
                            ),
                            Text(
                              points != null ? points.toString() : "",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Dimensions.font14,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
            ),
          ]),
        ),
      ),
    );
  }
}
