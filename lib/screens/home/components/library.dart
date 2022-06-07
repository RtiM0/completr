import 'dart:convert';

import 'package:completr/models/tmdb.dart';
import 'package:completr/screens/Details.dart';
import 'package:completr/screens/home/components/item.dart';
import 'package:completr/utils/db.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class Library extends StatelessWidget {
  const Library({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Your Watchlist",
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
        ),
        FirebaseAnimatedList(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            query: DatabaseHelper.get_query(),
            itemBuilder: (context, snapshot, animated, x) {
              if (snapshot.value != null) {
                var value = snapshot.value as Map<dynamic, dynamic>;
                if (value["watch_list"] ?? false) {
                  List<String> data = snapshot.key!.split("_");
                  return FutureBuilder<tmdbItem>(
                    future: fetchItem(data[0], data[1]),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Padding(
                          padding:
                              const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Details(
                                            tmdbid: snapshot.data!.tmdbid,
                                            type: snapshot.data!.type,
                                          )));
                            },
                            child: Card(
                              color: Colors.white.withOpacity(0.1),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: FadeInImage.assetNetwork(
                                      placeholder:
                                          "assets/profile_placeholder.jpg",
                                      image: snapshot.data!.backdropPath,
                                    ),
                                  ),
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      snapshot.data!.name,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )),
                                  Expanded(
                                      child: IconButton(
                                    icon: Icon(Icons.check),
                                    color: Colors.white,
                                    onPressed: () {
                                      int tmdbid = snapshot.data!.tmdbid;
                                      String type = snapshot.data!.type;
                                      DatabaseHelper.toggle_completed(
                                        context,
                                        "${type}_$tmdbid",
                                      );
                                    },
                                  )),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      return SizedBox.square(
                          dimension: 50, child: CircularProgressIndicator());
                    },
                  );
                }
              }
              return SizedBox.shrink();
            }),
      ],
    );
  }
}
