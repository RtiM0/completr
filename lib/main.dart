// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:completr/models/tmdb.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:completr/screens/Details.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Completr',
        theme: ThemeData(
            textTheme: GoogleFonts.barlowSemiCondensedTextTheme(
                Theme.of(context).textTheme),
            appBarTheme: AppBarTheme(
                textTheme: GoogleFonts.barlowSemiCondensedTextTheme(
                    Theme.of(context).textTheme)),
            fontFamily: GoogleFonts.barlowSemiCondensed().fontFamily),
        home: Builder(
            builder: (context) => Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.black,
                  brightness: Brightness.dark,
                ),
                backgroundColor: Colors.black,
                body: Column(children: [
                  Padding(
                      padding: EdgeInsets.all(16),
                      child: Text("APP CONCEPT",
                          style: GoogleFonts.barlowSemiCondensed(
                              textStyle: Theme.of(context).textTheme.bodyText1,
                              letterSpacing: 1.5,
                              color: Colors.white.withOpacity(0.8)))),
                  Padding(
                      padding: EdgeInsets.all(0),
                      child: Text("COMPLETR",
                          style: GoogleFonts.barlowSemiCondensed(
                              letterSpacing: 1.5,
                              textStyle: Theme.of(context).textTheme.headline3,
                              fontWeight: FontWeight.w800,
                              color: Colors.white))),
                  Padding(
                      padding: EdgeInsets.all(16),
                      child: Text("For the completionist",
                          style: GoogleFonts.barlowSemiCondensed(
                              textStyle: Theme.of(context).textTheme.bodyText1,
                              color: Colors.white.withOpacity(0.8)))),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                          autofocus: true,
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
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          leading: (suggestion.type == "tv")
                              ? Icon(Icons.tv)
                              : Icon(Icons.movie),
                          title: Text(suggestion.name),
                          subtitle: Text(suggestion.overview),
                        );
                      },
                      onSuggestionSelected: (suggestion) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Details(
                                      tmdbid: suggestion.tmdbid,
                                      type: suggestion.type,
                                    )));
                      },
                      hideSuggestionsOnKeyboardHide: false,
                      suggestionsBoxDecoration:
                          SuggestionsBoxDecoration(elevation: 0.0),
                      hideOnEmpty: true,
                    ),
                  )
                ]))));
  }
}
