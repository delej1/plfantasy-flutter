import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pl_fantasy_online/utils/dimensions.dart';

class SelectPlayerCard extends StatelessWidget {
  final String image;
  final String player;
  final String team;
  final double price;
  final String position;
  final Function() onPressed;
  final bool isPlayerSelected;

  const SelectPlayerCard({Key? key,
    required this.image,
    required this.player,
    required this.team,
    required this.price,
    required this.onPressed,
    required this.position,
    required this.isPlayerSelected

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Dimensions.height1*5),
      child: Container(
        height: MediaQuery.of(context).size.height*0.11,
        width: MediaQuery.of(context).size.width,
        color: Colors.black.withOpacity(0.1),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(Dimensions.width8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CachedNetworkImage(
                  imageUrl: image,
                  errorWidget: (context, url, error) =>
                      Image.asset(position!="GK"?"assets/image/jersey_img.png"
                          :"assets/image/jersey_gk.png"),
                  fit: BoxFit.cover,
                ),
                SizedBox(width: Dimensions.width5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(Dimensions.width8),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width*0.35,
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(utf8.decode(player.runes.toList()), style: TextStyle(fontSize: Dimensions.font16,
                                  color: Colors.white),),
                              Text(team, style: TextStyle(fontSize: Dimensions.font16, color: Colors.white),),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: Dimensions.width5,),
                    Padding(
                      padding:  EdgeInsets.all(Dimensions.width8),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("pos.", style: TextStyle(fontSize: Dimensions.font16, fontStyle: FontStyle.italic, color: Colors.grey),),
                            Text(position, style: TextStyle(fontSize: Dimensions.font16, color: Colors.white),),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: Dimensions.width5,),
                    Padding(
                      padding: EdgeInsets.all(Dimensions.width8),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("price", style: TextStyle(fontSize: Dimensions.font16, fontStyle: FontStyle.italic, color: Colors.grey)),
                            Text("${price}m", style: TextStyle(fontSize: Dimensions.font16, color: Colors.white),),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: Dimensions.width5,),
                !isPlayerSelected?IconButton(onPressed: onPressed,
                    icon: Icon(Icons.add_circle,
                      color: Colors.green, size: Dimensions.iconSize15*2,)):Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
