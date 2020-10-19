import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yourconverse/screens/savedposts.dart';
import 'package:yourconverse/bubbles/postprofile.dart';

import 'editprofile.dart';

class Profile extends StatefulWidget {
  final String uid;

  const Profile({Key key, this.uid}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  //******************** AD ************************** */

  static final MobileAdTargetingInfo targetInfo = new MobileAdTargetingInfo(
    testDevices: <String>[],
    keywords: <String>['games', 'shoes', 'fashion', 'education', 'pubg'],
    birthday: new DateTime.now(),
    childDirected: true,
  );
  BannerAd _bannerAd;

  BannerAd createBannerAd() {
    return new BannerAd(
        adUnitId: "ca-app-pub-3937702122719326/1468700623",
        size: AdSize.banner,
        targetingInfo: targetInfo,
        listener: (MobileAdEvent event) {
          print("Banner event : $event");
        });
  }

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-3937702122719326~1324929071");
    _bannerAd = createBannerAd()
      ..load()
      ..show(
        anchorOffset: 55.0,
      );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  //********************** AD ************************ */
  var postcount = 0;
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
                            backgroundColor: Theme.of(context).primaryColor,
                            radius: 63,
                            child: CircleAvatar(
                              backgroundColor: Colors.grey[900],
                              backgroundImage: usersnapshot.data['dp'] == ""
                                  ? AssetImage('assets/logo1.jpg')
                                  : NetworkImage(usersnapshot.data['dp']),
                              radius: 60,
                            ),
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        child: Container(
                          child: Text(
                            usersnapshot.data['username'],
                            style: GoogleFonts.rubik(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
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
                        child: Container(
                          child: SelectableText(
                            usersnapshot.data['bio'],
                            style: GoogleFonts.rubik(fontSize: 18.0),
                          ),
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
                        child: Container(
                          child: Row(
                            children: [
                              Text(
                                'Contact - ',
                                style: GoogleFonts.rubik(fontSize: 18.0),
                              ),
                              SelectableText(
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
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 16.0)),
                Container(
                  padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfile(
                                    uid: widget.uid,
                                    dp: usersnapshot.data['dp'],
                                    username: usersnapshot.data['username'],
                                    bio: usersnapshot.data['bio'],
                                    contact: usersnapshot.data['contact'],
                                  )),
                          (route) => false);
                    },
                    child: Center(
                      child: Text(
                        'Edit Profile',
                        style: GoogleFonts.rubik(
                            fontSize: 16.0, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10.0)),
                Container(
                  padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    color: Colors.grey[900],
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SavedPosts(
                                    uid: widget.uid,
                                  )));
                    },
                    child: Center(
                      child: Text(
                        'Saved Posts',
                        style: GoogleFonts.rubik(
                            fontSize: 16.0, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
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
                                                  dp: postdata[index]['dp'],
                                                  likes: postdata[index]
                                                      ['likes'],
                                                  docname: postdata[index]
                                                      ['time'],
                                                  description: postdata[index]
                                                      ['description'],
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
    );
  }
}
