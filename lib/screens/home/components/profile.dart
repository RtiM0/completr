import 'package:completr/models/tmdb.dart';
import 'package:completr/screens/home/components/item.dart';
import 'package:completr/screens/login/login_screen.dart';
import 'package:completr/utils/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final User user;
  Profile({required this.user});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isSigningOut = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        Center(
          child: Text(
            widget.user.displayName!,
            style: TextStyle(
              color: Colors.white,
              fontSize: 50.0,
            ),
          ),
        ),
        Center(
          child: Text(
            widget.user.email!,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(8),
          child: _isSigningOut
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _isSigningOut = true;
                    });
                    await FirebaseAuth.instance.signOut();
                    setState(() {
                      _isSigningOut = false;
                    });
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Sign Out",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(8),
          child: Text(
            "Favourites",
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
        ),
        SizedBox(
          height: 273,
          child: FirebaseAnimatedList(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            defaultChild: Text("NO DATA"),
            query: DatabaseHelper.get_query(),
            itemBuilder: (context, snapshot, animation, x) {
              var value = snapshot.value as Map<dynamic, dynamic>;
              if (value["favourite"] ?? false) {
                List<String> data = snapshot.key!.split("_");
                return FutureBuilder<tmdbItem>(
                  future: fetchItem(data[0], data[1]),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Item(tmdb: snapshot.data!);
                    }
                    return SizedBox.square(
                        dimension: 50.0, child: CircularProgressIndicator());
                  },
                );
              }
              return SizedBox.shrink();
            },
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(8),
          child: Text(
            "Completed",
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
        ),
        SizedBox(
          height: 273,
          child: FirebaseAnimatedList(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            defaultChild: Text("NO DATA"),
            query: DatabaseHelper.get_query(),
            itemBuilder: (context, snapshot, animation, x) {
              var value = snapshot.value as Map<dynamic, dynamic>;
              if (value["completed"] ?? false) {
                List<String> data = snapshot.key!.split("_");
                return FutureBuilder<tmdbItem>(
                  future: fetchItem(data[0], data[1]),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Item(tmdb: snapshot.data!);
                    }
                    return SizedBox.square(
                        dimension: 50.0, child: CircularProgressIndicator());
                  },
                );
              }
              return SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}
