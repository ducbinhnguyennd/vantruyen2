import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loginapp/getapi/trangchuapi.dart';
import 'package:loginapp/screens/detail_mangan.dart';

import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class ItemSearch extends StatelessWidget {
  const ItemSearch(
      {super.key,
      required this.theloai,
      required this.imagePath,
      required this.title,
      required this.author,
      required this.id});
  final String imagePath;
  final String title;
  final String theloai;
  final String author;

  final String id;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ZoomTapAnimation(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MangaDetailScreen(
                  mangaId: id, storyName: title, image: imagePath),
            ),
          );
        },
        child: Container(
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  width: 100,
                  height: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: imagePath,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      SizedBox(height: 20),
                      Text('Tác giả: ${author}'),
                      SizedBox(height: 10),
                      Text('Thể loại: ${theloai}'),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
