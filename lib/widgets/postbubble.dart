import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PostBubble extends StatefulWidget {
  final String url;
  final String username;
  final String dp;
  final String likes;
  final String docname;

  const PostBubble(
      {Key key, this.url, this.username, this.dp, this.likes, this.docname})
      : super(key: key);
  @override
  _PostBubbleState createState() => _PostBubbleState();
}

//**************************************************** */

class _PostBubbleState extends State<PostBubble> {
  var isliked=false;

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
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String id = user.uid;
    await Firestore.instance
        .collection('allposts')
        .document(widget.docname)
        .updateData({'likes': (int.parse(widget.likes) + 1).toString()});
    await Firestore.instance
        .collection('likes')
        .document(widget.docname)
        .collection('users')
        .document(id)
        .setData({'liked': 'yes'});
  }

  //**************************************************** */

  decreaselike() async {
    setState(() {
      isliked = false;
    });
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String id = user.uid;
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
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0)),
            ),
            child: Row(
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
                Text(widget.likes + '  Likes')
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//**************************************************** */
