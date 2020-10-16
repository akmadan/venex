import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePost extends StatefulWidget {
  final String url;
  final String username;
  final String dp;
  final String likes;
  final String docname;
  final String description;

  const ProfilePost(
      {Key key,
      this.url,
      this.username,
      this.dp,
      this.likes,
      this.docname,
      this.description})
      : super(key: key);

  @override
  _ProfilePostState createState() => _ProfilePostState();
}

class _ProfilePostState extends State<ProfilePost> {
  deletepost() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot noofposts =
        await Firestore.instance.collection('users').document(user.uid).get();
    int noofpost = noofposts.data['posts'];
    await Firestore.instance
        .collection('userposts')
        .document(user.uid)
        .collection('pics')
        .document(widget.docname)
        .delete();
    await Firestore.instance
        .collection('allposts')
        .document(widget.docname)
        .delete();
    await Firestore.instance
        .collection('users')
        .document(user.uid)
        .updateData({'posts': noofpost - 1});
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Post'),
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
                    Row(
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
                    Container(
                      child: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          deletepost();
                        },
                      ),
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
                            image: NetworkImage(widget.url),
                            fit: BoxFit.cover)),
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
                        Container(
                            padding: EdgeInsets.all(10.0),
                            child: Text(widget.likes + '  Likes'))
                      ],
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(widget.description)),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
