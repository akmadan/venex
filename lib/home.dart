import 'package:convex_bottom_bar/convex_bottom_bar.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yourconverse/screens/addpost.dart';
import 'package:yourconverse/screens/dashboard.dart';
import 'package:yourconverse/screens/profile.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YourConverse',
            style: GoogleFonts.rubik(fontWeight: FontWeight.bold)),
      ),
      bottomNavigationBar: ConvexAppBar(
        height: 50,
        activeColor: Colors.black,
        color: Colors.black,
        backgroundColor: Theme.of(context).primaryColor,
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.add, title: 'Add'),
          TabItem(icon: Icons.people, title: 'Profile'),
        ],
        initialActiveIndex: 1,
        onTap: _onTappedBar,
      ),

      //
      body: PageView(
        controller: _pageController,
        children: <Widget>[Dashboard(), AddPost(), Profile()],
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
