import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yourconverse/bubbles/postbubble.dart';

import 'package:yourconverse/bubbles/postprofile.dart';
import 'package:yourconverse/bubbles/singlepostbuble.dart';

class OtherProfile extends StatefulWidget {
  final String uid;
  final String username;

  const OtherProfile({Key key, this.uid, this.username}) : super(key: key);
  @override
  _OtherProfileState createState() => _OtherProfileState();
}

class _OtherProfileState extends State<OtherProfile> {
  var postcount = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff0F0F0F),
        appBar: AppBar(
          title: Text(widget.username,
              style: GoogleFonts.rubik(fontWeight: FontWeight.bold)),
          backgroundColor: Color(0xff1C1A1A),
          elevation: 8.0,
        ),
        body: FutureBuilder(
          future:
              Firestore.instance.collection('users').document(widget.uid).get(),
          builder: (context, usersnapshot) {
            if (usersnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 16.0)),
                    Container(
                      height: 130,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 10.0),
                            width: MediaQuery.of(context).size.width / 3,
                            child: Center(
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                backgroundImage: usersnapshot.data['dp'] == ""
                                    ? AssetImage('assets/logo1.jpg')
                                    : NetworkImage(usersnapshot.data['dp']),
                                radius: 60,
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 2 / 3,
                            padding: EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'Likes',
                                      style: GoogleFonts.rubik(
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      usersnapshot.data['likes'],
                                      style: GoogleFonts.rubik(fontSize: 22.0),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'Posts',
                                      style: GoogleFonts.rubik(
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      usersnapshot.data['posts'].toString(),
                                      style: GoogleFonts.rubik(
                                        fontSize: 22.0,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10.0)),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 16),
                          width: MediaQuery.of(context).size.width,
                          child: Expanded(
                            child: Text(
                              usersnapshot.data['username'],
                              style: GoogleFonts.rubik(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 16),
                          width: MediaQuery.of(context).size.width,
                          child: Expanded(
                            child: Text(
                              usersnapshot.data['bio'],
                              style: GoogleFonts.rubik(fontSize: 18.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 16),
                          width: MediaQuery.of(context).size.width,
                          child: Expanded(
                            child: Row(
                              children: [
                                Text(
                                  'Contact - ',
                                  style: GoogleFonts.rubik(fontSize: 18.0),
                                ),
                                Text(
                                  usersnapshot.data['contact'],
                                  style: GoogleFonts.rubik(
                                      fontSize: 18.0,
                                      fontStyle: FontStyle.italic,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
                                                builder: (context) =>
                                                    SinglePost(
                                                      url: postdata[index]
                                                          ['url'],
                                                      username: postdata[index]
                                                          ['username'],
                                                      dp: postdata[index]['dp'],
                                                      likes: postdata[index]
                                                          ['likes'],
                                                      docname: postdata[index]
                                                          ['time'],
                                                      description:
                                                          postdata[index]
                                                              ['description'],
                                                      postuid: widget.uid,
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
        ));
  }
}
