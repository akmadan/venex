import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yourconverse/widgets/postprofile.dart';

import 'editprofile.dart';

class Profile extends StatefulWidget {
  final String uid;

  const Profile({Key key, this.uid}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firestore.instance.collection('users').document(widget.uid).get(),
      builder: (context, usersnapshot) {
        if (usersnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(padding: EdgeInsets.only(left: 20.0)),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: usersnapshot.data['dp'] == ""
                            ? AssetImage('assets/logo1.jpg')
                            : NetworkImage(usersnapshot.data['dp']),
                        radius: 50,
                      ),
                      Container(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              usersnapshot.data['username'],
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
                Container(
                  padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfile(
                                    uid: widget.uid,
                                    dp: usersnapshot.data['dp'],
                                  )));
                    },
                    child: Center(
                      child: Text(
                        'Edit Profile',
                        style: GoogleFonts.rubik(
                            fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                ),
                Container(
                    padding: EdgeInsets.all(5.0),
                    //color: Colors.red,
                    height: MediaQuery.of(context).size.height / 2,
                    child: StreamBuilder(
                      stream: Firestore.instance
                          .collection('userposts')
                          .document(widget.uid)
                          .collection('pics')
                          .snapshots(),
                      builder: (context, postsnapshot) {
                        if (postsnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          final postdata = postsnapshot.data.documents;
                          return GridView.builder(
                              itemCount: postdata.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisSpacing: 5.0,
                                      mainAxisSpacing: 5.0,
                                      crossAxisCount: 3),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ProfilePost(
                                                  url: postdata[index]['url'],
                                                  username: postdata[index]
                                                      ['username'],
                                                )));
                                  },
                                  child: GridTile(
                                      child: Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                              postdata[index]['url'],
                                            ),
                                            fit: BoxFit.cover),
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    //child: Image.network(postdata[index]['url']),
                                  )),
                                );
                              });
                        }
                      },
                    ))
              ],
            ),
          );
        }
      },
    );
  }
}
