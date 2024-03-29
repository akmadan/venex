import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:yourconverse/screens/otherprofile.dart';

class SinglePost extends StatefulWidget {
  final String url;
  final String username;
  final String dp;
  final String likes;
  final String docname;
  final String description;
  final String postuid; //uid of user who posted

  const SinglePost({
    Key key,
    this.url,
    this.username,
    this.dp,
    this.docname,
    this.postuid,
    this.description,
    this.likes,
  }) : super(key: key);
  @override
  _SinglePostState createState() => _SinglePostState();
}

class _SinglePostState extends State<SinglePost> {
  var isliked = false;
  var issaved = false;
  String likes;

  @override
  void initState() {
    checkliked();
    likes = widget.likes;
    checksaved();
    super.initState();
  }

  //*********************  AD    **************************** */
  static final MobileAdTargetingInfo targetInfo = new MobileAdTargetingInfo(
    testDevices: <String>[],
    keywords: <String>['games', 'shoes', 'fashion', 'education', 'pubg'],
    birthday: new DateTime.now(),
    childDirected: true,
  );

  InterstitialAd myInterstitial = InterstitialAd(
    adUnitId: "ca-app-pub-3937702122719326/7341147865",
    targetingInfo: targetInfo,
    listener: (MobileAdEvent event) {
      print("InterstitialAd event is $event");
    },
  );
  //*********************  AD    **************************** */

  checkliked() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String id = user.uid;
    var liked = await Firestore.instance
        .collection('likes')
        .document(widget.docname)
        .collection('users')
        .document(id)
        .get();
    if (liked.exists) {
      setState(() {
        isliked = true;
      });
    } else {
      setState(() {
        isliked = false;
      });
    }
  }

  //**************************************************** */

  checksaved() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String id = user.uid;
    var liked = await Firestore.instance
        .collection('saved')
        .document(widget.docname)
        .collection('users')
        .document(id)
        .get();
    if (liked.exists) {
      setState(() {
        issaved = true;
      });
    } else {
      setState(() {
        issaved = false;
      });
    }
  }

  //**************************************************** */
  //**************************************************** */
  //**************************************************** */

  increaselike() async {
    setState(() {
      isliked = true;
      likes = (int.parse(likes) + 1).toString();
    });
    //current user id
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String id = user.uid;

    // increase like in allposts
    await Firestore.instance
        .collection('allposts')
        .document(widget.docname)
        .updateData({'likes': (int.parse(widget.likes) + 1).toString()});
    // change the data of people who have liked in likes collection
    await Firestore.instance
        .collection('likes')
        .document(widget.docname)
        .collection('users')
        .document(id)
        .setData({'liked': 'yes'});
    // get reference of user total likes and grid post likes

    DocumentSnapshot totallikessnapshot = await Firestore.instance
        .collection('users')
        .document(widget.postuid)
        .get();
    DocumentSnapshot userpostsnapshot = await Firestore.instance
        .collection('userposts')
        .document(widget.postuid)
        .collection('pics')
        .document(widget.docname)
        .get();

    String totallikes = await totallikessnapshot.data['likes'];
    String userpostlikes = await userpostsnapshot.data['likes'];
    // increase like in profile grid picture
    await Firestore.instance
        .collection('userposts')
        .document(widget.postuid)
        .collection('pics')
        .document(widget.docname)
        .updateData({'likes': (int.parse(userpostlikes) + 1).toString()});

    // increase total likes of user
    await Firestore.instance
        .collection('users')
        .document(widget.postuid)
        .updateData({'likes': (int.parse(totallikes) + 1).toString()});
  }

  //**************************************************** */
  //**************************************************** */
  //**************************************************** */
  //**************************************************** */

  decreaselike() async {
    setState(() {
      isliked = false;
      likes = (int.parse(likes) - 1).toString();
    });
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String id = user.uid;

    //start decreasing likes

    await Firestore.instance
        .collection('allposts')
        .document(widget.docname)
        .updateData({'likes': (int.parse(widget.likes) - 1).toString()});

    await Firestore.instance
        .collection('likes')
        .document(widget.docname)
        .collection('users')
        .document(id)
        .delete();
    // get reference of user total likes and grid post likes

    DocumentSnapshot totallikessnapshot = await Firestore.instance
        .collection('users')
        .document(widget.postuid)
        .get();
    DocumentSnapshot userpostsnapshot = await Firestore.instance
        .collection('userposts')
        .document(widget.postuid)
        .collection('pics')
        .document(widget.docname)
        .get();

    String totallikes = await totallikessnapshot.data['likes'];
    String userpostlikes = await userpostsnapshot.data['likes'];
    await Firestore.instance
        .collection('userposts')
        .document(widget.postuid)
        .collection('pics')
        .document(widget.docname)
        .updateData({'likes': (int.parse(userpostlikes) - 1).toString()});
    await Firestore.instance
        .collection('users')
        .document(widget.postuid)
        .updateData({'likes': (int.parse(totallikes) - 1).toString()});
  }

  //************************************************** */

  savepost() async {
    setState(() {
      issaved = true;
    });

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String id = user.uid;
    await Firestore.instance
        .collection('userposts')
        .document(id)
        .collection('savedposts')
        .document(widget.docname)
        .setData({
      'docname': widget.docname,
    });
    await Firestore.instance
        .collection('saved')
        .document(widget.docname)
        .collection('users')
        .document(id)
        .setData({'saved': 'yes'});
  }

  //************************************************** */

  unsavepost() async {
    setState(() {
      issaved = false;
    });
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String id = user.uid;
    await Firestore.instance
        .collection('userposts')
        .document(id)
        .collection('savedposts')
        .document(widget.docname)
        .delete();
    await Firestore.instance
        .collection('saved')
        .document(widget.docname)
        .collection('users')
        .document(id)
        .delete();
  }

  //************************************************** */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0F0F0F),
      appBar: AppBar(
        backgroundColor: Color(0xff1C1A1A),
        elevation: 8.0,
        title:
            Text('Post', style: GoogleFonts.rubik(fontWeight: FontWeight.bold)),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OtherProfile(
                                    uid: widget.postuid,
                                    username: widget.username,
                                  )));
                    },
                    child: Row(
                      children: [
                        Container(
                            padding: EdgeInsets.all(9.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: widget.dp == ""
                                  ? AssetImage('assets/logo1.jpg')
                                  : NetworkImage(widget.dp),
                              radius: 17,
                            )),
                        Text(widget.username)
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      issaved
                          ? IconButton(
                              icon: Icon(Icons.bookmark),
                              onPressed: () {
                                unsavepost();
                              })
                          : IconButton(
                              icon: Icon(Icons.bookmark_border),
                              onPressed: () {
                                savepost();
                              }),
                      IconButton(
                          icon: Icon(Icons.save_alt),
                          onPressed: () async {
                            Fluttertoast.showToast(
                                msg: 'Check Downloads Folder');
                            await ImageDownloader.downloadImage(
                              widget.url,
                              destination:
                                  AndroidDestinationType.directoryDownloads
                                    ..inExternalFilesDir()
                                    ..subDirectory("sneeker.jpg"),
                            );
                            myInterstitial
                              ..load()
                              ..show(
                                anchorType: AnchorType.bottom,
                                anchorOffset: 0.0,
                              );
                          })
                    ],
                  )
                ],
              ),
            ),
            Container(
              height: 300,
              child: Material(
                elevation: 5.0,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(widget.url), fit: BoxFit.cover)),
                ),
              ),
            ),
            Container(
              padding: widget.description == ''
                  ? EdgeInsets.only(bottom: 0.0)
                  : EdgeInsets.only(bottom: 10.0),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      isliked
                          ? IconButton(
                              icon: Icon(
                                Icons.favorite,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: () {
                                decreaselike();
                              })
                          : IconButton(
                              icon: Icon(
                                Icons.favorite,
                              ),
                              onPressed: () {
                                increaselike();
                              }),
                      Text(likes + '  Likes', style: GoogleFonts.rubik())
                    ],
                  ),
                  widget.description == ''
                      ? Container()
                      : Container(
                          padding: EdgeInsets.only(left: 10.0),
                          child: SelectableText(
                            widget.description,
                            style: GoogleFonts.rubik(),
                          )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//**************************************************** */
