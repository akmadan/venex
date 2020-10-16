import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  final _formkey = GlobalKey<FormState>();
  String username;
  String bio;

  void trysubmit() {
    final isValid = _formkey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formkey.currentState.save();
      _submitAuthForm(username, bio);
    }
  }

  _submitAuthForm(String username, String bio) async {
    await Firestore.instance
        .collection('users')
        .document(widget.uid)
        .updateData({'username': username, 'bio': bio});
        Fluttertoast.showToast(msg: 'Data Updated on Profile Page');
  }

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
    Fluttertoast.showToast(msg: 'Picture Updated on Profile Page');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'),
        ),
        body: SingleChildScrollView(
          child: Container(
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
                Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        key: ValueKey('username'),
                        validator: (value) {
                          if (value.isEmpty || value.length < 5) {
                            return 'Username length should be more than 5';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          username = value;
                        },
                        decoration: InputDecoration(
                            labelText: 'Enter Username',
                            border: OutlineInputBorder()),
                      ),
                      Padding(padding: EdgeInsets.only(top: 15.0)),
                      TextFormField(
                        key: ValueKey('bio'),
                        validator: (value) {
                          if (value.isEmpty || value.length < 5) {
                            return 'bio length should be more than 5';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          bio = value;
                        },
                        decoration: InputDecoration(
                            labelText: 'Enter Bio',
                            border: OutlineInputBorder()),
                      ),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 15.0)),
                Container(
                  height: 50,
                  width: double.infinity,
                  child: RaisedButton(
                    onPressed: () {
                      trysubmit();
                    },
                    child: Text(
                      'Update',
                      style: GoogleFonts.rubik(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
