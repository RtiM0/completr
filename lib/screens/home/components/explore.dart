import 'dart:convert';

import 'package:completr/models/tmdb.dart';
import 'package:completr/screens/Details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Explore extends StatelessWidget {
  const Explore({
    Key? key,
  }) : super(key: key);

  Future<List<Similar>> getPopular(String type) async {
    final response = await http.get(Uri.https("api.themoviedb.org",
        "/3/${type}/popular", {"api_key": "aa83b59842709a91c2855a4dbf200f79"}));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)["results"].map<Similar>((json) {
        return Similar.fromJson(json, type);
      }).toList();
    } else {
      throw Exception("Error Loading Popular Shows");
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<List<Similar>> popularMovie = getPopular("movie");
    Future<List<Similar>> popularTV = getPopular("tv");

    return ListView(physics: BouncingScrollPhysics(), children: [
      Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(16),
          child: Text("APP CONCEPT", style: TextStyle(letterSpacing: 1.5))),
      Container(
          alignment: Alignment.center,
          child: Text("COMPLETR",
              style: GoogleFonts.barlowSemiCondensed(
                  letterSpacing: 1.5,
                  textStyle: Theme.of(context).textTheme.headline3,
                  fontWeight: FontWeight.w800,
                  color: Colors.white))),
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16),
        child: Text("For the completionist"),
      ),
      Padding(
        padding: EdgeInsets.all(16),
        child: TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
              autofocus: false,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  hintText: "Search for Movies/TV",
                  filled: true)),
          suggestionsCallback: (query) async {
            if (query != "") {
              final response = await http.get(Uri.https(
                  "api.themoviedb.org", "/3/search/multi", {
                "api_key": "aa83b59842709a91c2855a4dbf200f79",
                "query": query
              }));
              return jsonDecode(response.body)['results']
                  .map<SearchResult>((result) {
                return SearchResult.fromJson(result);
              }).toList();
            }
            return <SearchResult>[];
          },
          itemBuilder: (context, dynamic suggestion) {
            return ListTile(
              leading: (suggestion.type == "tv")
                  ? Icon(Icons.tv)
                  : Icon(Icons.movie),
              title: Text(suggestion.name != null ? suggestion.name : ""),
              subtitle:
                  Text(suggestion.overview != null ? suggestion.overview : ""),
            );
          },
          onSuggestionSelected: (dynamic suggestion) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Details(
                        tmdbid: suggestion.tmdbid, type: suggestion.type)));
          },
          hideSuggestionsOnKeyboardHide: false,
          suggestionsBoxDecoration: SuggestionsBoxDecoration(elevation: 0.0),
          hideOnEmpty: true,
        ),
      ),
      Container(
        padding: EdgeInsets.all(8),
        child: Text(
          "Trending TV Shows",
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
      ),
      FutureBuilder<List<Similar>>(
        future: popularTV,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return ItemList(data: snapshot.data!, type: "tv");
          } else {
            return CircularProgressIndicator();
          }
        }),
      ),
      Container(
        padding: EdgeInsets.all(8),
        child: Text(
          "Trending Movies",
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
      ),
      FutureBuilder<List<Similar>>(
        future: popularMovie,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return ItemList(
              data: snapshot.data!,
              type: "movie",
            );
          } else {
            return CircularProgressIndicator();
          }
        }),
      ),
    ]);
  }
}

class ItemList extends StatelessWidget {
  final List<Similar> data;
  final String type;
  const ItemList({Key? key, required this.data, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (context, index) {
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
                              image: data[index].posterPath!,
                              placeholder: 'assets/profile_placeholder.jpg',
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          Text(data[index].name!,
                              maxLines: 2,
                              style: GoogleFonts.barlowSemiCondensed(
                                  color: Colors.white)),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Details(
                                  tmdbid: data[index].tmdbid!, type: type)));
                    }));
          }),
    );
  }
}
