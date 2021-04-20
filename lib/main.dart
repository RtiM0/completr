// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
                  title: Text("COMPLETR"),
                  centerTitle: true,
                ),
                body: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter a search term'),
                  keyboardType: TextInputType.number,
                  onSubmitted: (value) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Details(
                                  tmdbid: int.parse(value),
                                )));
                  },
                ))));
  }
}
