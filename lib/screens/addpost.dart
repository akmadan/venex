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
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: RaisedButton(onPressed: () {
          uploadpost();
        }),
      ),
    );
  }
}
