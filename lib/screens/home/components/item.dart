import 'dart:convert';

import 'package:completr/screens/Details.dart';
import 'package:flutter/material.dart';
import 'package:completr/models/tmdb.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Item extends StatelessWidget {
  final tmdbItem tmdb;
  const Item({Key? key, required this.tmdb}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(8),
        child: InkWell(
            child: SizedBox(
              width: 154,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: FadeInImage.assetNetwork(
                      image: tmdb.posterPath,
                      placeholder: 'assets/profile_placeholder.jpg',
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  Text(tmdb.name,
                      maxLines: 2,
                      style:
                          GoogleFonts.barlowSemiCondensed(color: Colors.white)),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Details(tmdbid: tmdb.tmdbid, type: tmdb.type)));
            }));
    ;
  }
}

Future<tmdbItem> fetchItem(String type, String tmdbid) async {
  final response =
      await http.get(Uri.https("api.themoviedb.org", "/3/$type/$tmdbid", {
    "api_key": "aa83b59842709a91c2855a4dbf200f79",
    "append_to_response":
        "external_ids,credits,videos,recommendations,watch/providers"
  }));
  if (response.statusCode == 200) {
    return tmdbItem.fromJson(
      jsonDecode(response.body),
      type,
      int.parse(tmdbid),
    );
  } else {
    throw Exception("Error");
  }
}
