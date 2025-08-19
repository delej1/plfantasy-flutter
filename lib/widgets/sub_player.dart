import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pl_fantasy_online/utils/dimensions.dart';

class SubPlayer extends StatelessWidget {
  const SubPlayer({
    super.key,
    required this.image,
    required this.name,
    this.points,
    required this.position,
    this.onTap,
  });
  final String image;
  final String name;
  final int? points;
  final String position;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final double _height = MediaQuery.of(context).size.height;
    double height = 0.18181818 * (0.6773399 * _height / 1.7);
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: (height + Dimensions.height45),
        child: Column(children: [
          CachedNetworkImage(
            imageUrl: image,
            errorWidget: (context, url, error) => Image.asset(position != "GK"
                ? "assets/image/jersey_img.png"
                : "assets/image/jersey_gk.png"),
            height: position == 'GK' ? height - 10.0 : height / 1.3,
          ),
          SizedBox(
            height: Dimensions.height45,
            child: Padding(
                padding: EdgeInsets.only(
                    left: Dimensions.width1 * 2, right: Dimensions.width1 * 2),
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
                )),
          ),
        ]),
      ),
    );
  }
}
