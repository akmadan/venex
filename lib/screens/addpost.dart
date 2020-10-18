import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';


class AddPost extends StatefulWidget {
  final String uid;

  const AddPost({Key key, this.uid}) : super(key: key);
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  File image;
  TextEditingController descriptioncontroller = TextEditingController();

  //************************************************************* */
  picimage() async {
    File picked = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 60);
    setState(() {
      image = picked;
    });
  }

  //************************************************************* */

  uploadpost() async {
    DateTime date = DateTime.now(); //for time and docname

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
        .collection('users')
        .document(widget.uid)
        .updateData({'posts': variable.data['posts'] + 1});
// for user profile grid
    await Firestore.instance
        .collection('userposts')
        .document(widget.uid)
        .collection('pics')
        .document(date.toString()) // docname
        .setData({
      'url': url,
      'username': username,
      'time': date.toString(),
      'likes': '0',
      'dp': dp,
      'description': descriptioncontroller.text,
      'order': date
    });

    //all posts dashboard

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
      'description': descriptioncontroller.text,
      'order': date
    });
    descriptioncontroller.clear();
  }

  //************************************************************* */

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Center(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10.0),
                //height: 350,
                width: MediaQuery.of(context).size.width,
                child: image != null
                    ? Image.file(
                        image,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 300,
                        child:
                            Image.asset('assets/shoe.png', fit: BoxFit.cover)),
              ),
              Container(
                height: 70,
                padding: EdgeInsets.all(10.0),
                width: double.infinity,
                child: RaisedButton(
                  color: Colors.grey[900],
                  onPressed: () {
                    picimage();
                  },
                  child: Text(
                    'Upload Picture',
                    style: GoogleFonts.rubik(color: Colors.white),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: TextField(
                  maxLines: 5,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  controller: descriptioncontroller,
                  decoration: InputDecoration(
                      hintText: 'Write something about the Post',
                      border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide: new BorderSide(color: Color(0xffeb4a5f))),
                      labelStyle: GoogleFonts.mada()),
                ),
              ),
              Container(
                height: 70,
                padding: EdgeInsets.all(10.0),
                width: double.infinity,
                child: RaisedButton(
                  onPressed: () {
                    uploadpost();
                    Fluttertoast.showToast(msg: 'Adding your Post');
                  },
                  child: Text(
                    'Add Post',
                    style: GoogleFonts.rubik(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//************************************************************* */
