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
              icon: Icon(Icons.time_to_leave),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => MyApp()));
              })
        ],
        title: Text('YourConverse',
            style: GoogleFonts.rubik(fontWeight: FontWeight.bold)),
      ),
      bottomNavigationBar: ConvexAppBar(
        height: 50,
        activeColor: Colors.black,
        color: Colors.black,
        backgroundColor: Theme.of(context).primaryColor,
        items: [
          TabItem(icon: Icons.dashboard, title: 'Dashboard'),
          TabItem(icon: Icons.add, title: 'Add'),
          TabItem(icon: Icons.people, title: 'Profile'),
        ],
        initialActiveIndex: 0,
        onTap: _onTappedBar,
      ),

      //
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
