import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DatabaseHelper {
  static toggle_favourites(BuildContext context, String tmdbid) async {
    DatabaseReference db = FirebaseDatabase.instance
        .ref("users/${FirebaseAuth.instance.currentUser!.uid}/${tmdbid}");
    await db.get().then((snapshot) {
      String message = "Added to Favourites!";
      if (snapshot.child("favourite").exists) {
        db.child("favourite").remove();
        message = "Removed from Favourites!";
      } else {
        db.update({"favourite": true});
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(new SnackBar(content: Text(message)));
    });
  }

  static toggle_watchList(BuildContext context, String tmdbid) async {
    DatabaseReference db = FirebaseDatabase.instance
        .ref("users/${FirebaseAuth.instance.currentUser!.uid}/${tmdbid}");
    await db.get().then((snapshot) {
      String message = "Added to Watch List!";
      if (snapshot.child("watch_list").exists) {
        db.child("watch_list").remove();
        message = "Removed from Watch List!";
      } else {
        db.child("completed").remove();
        db.update({"watch_list": true});
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(new SnackBar(content: Text(message)));
    });
  }

  static toggle_completed(BuildContext context, String tmdbid) async {
    DatabaseReference db = FirebaseDatabase.instance
        .ref("users/${FirebaseAuth.instance.currentUser!.uid}/${tmdbid}");
    await db.get().then((snapshot) {
      String message = "Added to Completed!";
      if (snapshot.child("completed").exists) {
        db.child("completed").remove();
        message = "Removed from Completed!";
      } else {
        db.child("watch_list").remove();
        db.update({"completed": true});
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(new SnackBar(content: Text(message)));
    });
  }

  static DatabaseReference get_query() {
    return FirebaseDatabase.instance
        .ref("users/${FirebaseAuth.instance.currentUser!.uid}");
  }
}
