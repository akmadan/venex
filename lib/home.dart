import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yourconverse/screens/addpost.dart';
import 'package:yourconverse/screens/dashboard.dart';
import 'package:yourconverse/screens/pathwall.dart';
import 'package:yourconverse/screens/profile.dart';


const String testDevice = '';

class Home extends StatefulWidget {
  final String uid;
  const Home({Key key, this.uid}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

//********************************************** */

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0F0F0F),
      appBar: AppBar(
        backgroundColor: Color(0xff1C1A1A),
        elevation: 8.0,
        actions: [
          IconButton(
              icon: Icon(Icons.dashboard_rounded),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PatchWall()));
              }),
        ],
        title: Text('Your Sneaker',
            style: GoogleFonts.rubik(fontWeight: FontWeight.bold)),
      ),

      //********************************************** */

      bottomNavigationBar: BottomNavigationBar(
        elevation: 8.0,
        backgroundColor: Color(0xff1C1A1A),
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white.withOpacity(.60),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        onTap: (value) {
          _onTappedBar(value);
        },
        items: [
          BottomNavigationBarItem(
            title: Text('Dashboard'),
            icon: Icon(Icons.home_rounded),
          ),
          BottomNavigationBarItem(
            title: Text('Add Post'),
            icon: Icon(Icons.add),
          ),
          BottomNavigationBarItem(
            title: Text('Profile'),
            icon: Icon(Icons.person),
          ),
        ],
      ),

      //********************************************** */

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
