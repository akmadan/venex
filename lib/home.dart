import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yourconverse/screens/addpost.dart';
import 'package:yourconverse/screens/dashboard.dart';
import 'package:yourconverse/screens/profile.dart';

import 'main.dart';

class Home extends StatefulWidget {
  final String uid;

  const Home({Key key, this.uid}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => MyApp()));
              })
        ],
        title: Text('YourConverse',
            style: GoogleFonts.rubik(fontWeight: FontWeight.bold)),
      ),
      bottomNavigationBar: BottomNavyBar(
        backgroundColor: Theme.of(context).primaryColor,
        currentIndex: _selectedIndex,
        onItemSelected: (index) => setState(() {
          _selectedIndex = index;
          _pageController.animateToPage(index,
              duration: Duration(milliseconds: 300), curve: Curves.ease);
        }),
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.dashboard),
            title: Text('Dashboard'),
            activeColor: Colors.white,
          ),
          BottomNavyBarItem(
              icon: Icon(Icons.add),
              title: Text('Add'),
              activeColor: Colors.white),
          BottomNavyBarItem(
              icon: Icon(Icons.person),
              title: Text('Profile'),
              activeColor: Colors.white),
        ],
      ),
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          Dashboard(),
          AddPost(
            uid: widget.uid,
          ),
          Profile(
            uid: widget.uid,
          )
        ],
        onPageChanged: (page) {
          setState(() {
            _selectedIndex = page;
          });
        },
      ),
    );
  }

  void _onTappedBar(int value) {
    setState(() {
      _selectedIndex = value;
    });
    _pageController.jumpToPage(value);
  }
}
