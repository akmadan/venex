import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PostBubble extends StatefulWidget {
  final String url;
  final String username;
  final String dp;
  final String likes;
  final String docname;
  final String description;
  final String postuid; //uid of user who posted

  const PostBubble(
      {Key key,
      this.url,
      this.username,
      this.dp,
      this.likes,
      this.docname,
      this.postuid,
      this.description})
      : super(key: key);
  @override
  _PostBubbleState createState() => _PostBubbleState();
}

//**************************************************** */

class _PostBubbleState extends State<PostBubble> {
  var isliked = false;

  @override
  void initState() {
    checkliked();
    super.initState();
  }

  //**************************************************** */

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

  increaselike() async {
    setState(() {
      isliked = true;
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

    String totallikes = totallikessnapshot.data['likes'];
    String userpostlikes = userpostsnapshot.data['likes'];
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

  decreaselike() async {
    setState(() {
      isliked = false;
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

    String totallikes = totallikessnapshot.data['likes'];
    String userpostlikes = userpostsnapshot.data['likes'];
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
  @override
  Widget build(BuildContext context) {
    return Container(
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
              children: [
                Container(
                    padding: EdgeInsets.all(9.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: widget.dp == ""
                          ? AssetImage('assets/logo1.jpg')
                          : NetworkImage(widget.dp),
                      radius: 18,
                    )),
                Text(widget.username)
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
            padding: EdgeInsets.only(bottom: 10.0),
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
                              color: Colors.yellow,
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
                    Text(widget.likes + '  Likes', style: GoogleFonts.rubik())
                  ],
                ),
                Container(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      widget.description,
                      style: GoogleFonts.rubik(),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//**************************************************** */
