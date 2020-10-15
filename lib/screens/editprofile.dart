import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  final String uid;
  final String dp;

  const EditProfile({Key key, this.uid, this.dp}) : super(key: key);
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File dp;

  //*********************************************** */
  updatedp() async {
    File picked = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 30);
    setState(() {
      dp = picked;
    });
    final ref = FirebaseStorage().ref().child('dp').child(widget.uid + '.jpg');
    await ref.putFile(dp).onComplete;
    String url = await ref.getDownloadURL();
    await Firestore.instance
        .collection('users')
        .document(widget.uid)
        .updateData({'dp': url});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'),
        ),
        body: Container(
          padding: EdgeInsets.all(15.0),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              CircleAvatar(
                radius: 70,
                backgroundColor: Colors.white,
                backgroundImage: widget.dp == ""
                    ? AssetImage('assets/logo1.jpg')
                    : NetworkImage(widget.dp),
              ),
              Padding(padding: EdgeInsets.only(top: 15.0)),
              InkWell(
                  onTap: () {
                    updatedp();
                  },
                  child: Text('Edit Picture')),
              Padding(padding: EdgeInsets.only(top: 15.0)),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Enter Username', border: OutlineInputBorder()),
              ),
              Padding(padding: EdgeInsets.only(top: 15.0)),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Enter Bio', border: OutlineInputBorder()),
              ),
              Padding(padding: EdgeInsets.only(top: 15.0)),
              Container(
                height: 50,
                width: double.infinity,
                child: RaisedButton(
                  onPressed: () {},
                  child: Text(
                    'Update',
                    style: GoogleFonts.rubik(color: Colors.black),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
