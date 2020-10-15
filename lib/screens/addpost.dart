import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPost extends StatefulWidget {
  final String uid;

  const AddPost({Key key, this.uid}) : super(key: key);
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  File image;
  uploadpost() async {
    DateTime date = DateTime.now();
    File picked = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 30);
    setState(() {
      image = picked;
    });
    DocumentSnapshot variable =
        await Firestore.instance.collection('users').document(widget.uid).get();
    String username = variable.data['username'];
    String uid = variable.data['uid'];
    String dp = variable.data['dp'];
    final ref = FirebaseStorage.instance
        .ref()
        .child('posts')
        .child(widget.uid)
        .child(date.toString() + '.jpg');
    await ref.putFile(image).onComplete;
    final url = await ref.getDownloadURL();
    await Firestore.instance
        .collection('userposts')
        .document(widget.uid)
        .collection('pics')
        .document(date.toString())
        .setData({
      'url': url,
      'username': username,
      'time': date,
      'likes': '0',
      'dp': dp
    });
    await Firestore.instance
        .collection('allposts')
        .document(date.toString())
        .setData({
      'url': url,
      'username': username,
      'time': date.toString(),
      'likes': '0',
      'dp': dp,
      'uid': uid,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: RaisedButton(onPressed: () {
          uploadpost();
        }),
      ),
    );
  }
}
