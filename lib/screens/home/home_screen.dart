import 'package:completr/screens/home/components/explore.dart';
import 'package:completr/screens/home/components/library.dart';
import 'package:completr/screens/home/components/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  final User user;
  final List<Widget> _pages;

  Home({required this.user})
      : _pages = [
          Library(),
          Explore(),
          Profile(user: user),
        ];

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("COMPLETR",
            style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 1.5,
                fontSize: 16)),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: DefaultTextStyle(
          style: GoogleFonts.barlowSemiCondensed(
              textStyle: Theme.of(context).textTheme.bodyText1,
              color: Colors.white.withOpacity(0.8)),
          child: IndexedStack(
            index: _selectedIndex,
            children: widget._pages,
          )),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.density_medium_outlined), label: "Library"),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined), label: "Profile"),
        ],
      ),
    );
  }
}
