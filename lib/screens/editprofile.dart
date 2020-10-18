import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';

class EditProfile extends StatefulWidget {
  final String uid;
  final String dp;
  final String username;
  final String bio;
  final String contact;

  const EditProfile(
      {Key key, this.uid, this.dp, this.username, this.bio, this.contact})
      : super(key: key);
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File dp;
  bool dpfile = false;
  final _formkey = GlobalKey<FormState>();
  String username;
  String bio;
  TextEditingController contactcontroller = TextEditingController();

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
        .updateData({
      'username': username,
      'bio': bio,
      'contact': contactcontroller.text
    });
    Fluttertoast.showToast(msg: 'Data Updated on Profile Page');
  }

  //*********************************************** */
  updatedp() async {
    File picked = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 30);
    setState(() {
      dp = picked;
      dpfile = true;
    });
    Fluttertoast.showToast(msg: 'Updating Profile Picture');
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
        backgroundColor: Color(0xff0F0F0F),
        appBar: AppBar(
          backgroundColor: Color(0xff1C1A1A),
          title: Text('Edit Profile',
              style: GoogleFonts.rubik(fontWeight: FontWeight.bold)),
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
                  backgroundImage: dpfile
                      ? FileImage(dp)
                      : widget.dp == ""
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
                      Padding(padding: EdgeInsets.only(top: 15.0)),
                      TextFormField(
                        controller: contactcontroller,
                        decoration: InputDecoration(
                            labelText:
                                'Enter Contact eg. Email, Instagram ID etc.',
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
                ),
                Padding(padding: EdgeInsets.only(top: 15.0)),
                Container(
                  height: 50,
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.grey[900],
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => MyApp()));
                    },
                    child: Text(
                      'Logout',
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
