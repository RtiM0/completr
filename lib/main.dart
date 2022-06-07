// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:completr/firebase_options.dart';
import 'package:completr/screens/home/home_screen.dart';
import 'package:completr/screens/login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    if (user.emailVerified) {
      runApp(MyApp(
        user: user,
      ));
    } else {
      runApp(MyApp());
    }
  } else {
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget {
  final User? user;

  const MyApp({Key? key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = ThemeData(
        textTheme: GoogleFonts.barlowSemiCondensedTextTheme(
            Theme.of(context).textTheme),
        appBarTheme: AppBarTheme(
            toolbarTextStyle: GoogleFonts.barlowSemiCondensedTextTheme(
                    Theme.of(context).textTheme)
                .bodyText2,
            titleTextStyle: GoogleFonts.barlowSemiCondensedTextTheme(
                    Theme.of(context).textTheme)
                .headline6),
        fontFamily: GoogleFonts.barlowSemiCondensed().fontFamily);
    return user != null
        ? MaterialApp(
            title: 'Completr',
            theme: themeData,
            themeMode: ThemeMode.dark,
            home: Home(user: user!),
          )
        : MaterialApp(
            title: 'Completr',
            theme: themeData,
            home: Login(),
          );
  }
}
