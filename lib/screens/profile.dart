import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            //color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.only(left: 20.0)),
                CircleAvatar(
                  backgroundImage: AssetImage('assets/logo.jpg'),
                  radius: 50,
                ),
                Container(
                  padding: EdgeInsets.all(20.0),
                  //color: Colors.amber,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CheemsConverse',
                        style: GoogleFonts.rubik(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Text(
                            'Likes  789 ',
                            style: GoogleFonts.rubik(fontSize: 20.0),
                          ),
                          Icon(Icons.favorite_rounded)
                        ],
                      ),
                      Container(
                        height: 50,
                        width: 240,
                        child: Expanded(
                          child: Text(
                            'I love Converse because they are cool ',
                            style: GoogleFonts.rubik(fontSize: 20.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          //GridView.builder(gridDelegate: null, itemBuilder: null)
        ],
      ),
    );
  }
}
