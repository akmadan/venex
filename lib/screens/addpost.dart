import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
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
  //******************** AD ************************** */

  static final MobileAdTargetingInfo targetInfo = new MobileAdTargetingInfo(
    testDevices: <String>[],
    keywords: <String>['games', 'shoes', 'fashion', 'education', 'pubg'],
    birthday: new DateTime.now(),
    childDirected: true,
  );
  BannerAd _bannerAd;

  BannerAd createBannerAd() {
    return new BannerAd(
        adUnitId: "ca-app-pub-3937702122719326/3057114465",
        size: AdSize.smartBanner,
        targetingInfo: targetInfo,
        listener: (MobileAdEvent event) {
          print("Banner event : $event");
        });
  }

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-3937702122719326~1324929071");
    _bannerAd = createBannerAd()
      ..load()
      ..show(
        anchorOffset: 55.0,
      );
    // _currentScreen();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  //********************** AD ************************ */
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
                height: 350,
                padding: EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width,
                child: image != null
                    ? Image.file(
                        image,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 220,
                        child:
                            Image.asset('assets/shoe.png', fit: BoxFit.cover)),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: TextField(
                  maxLines: 5,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  controller: descriptioncontroller,
                  decoration: InputDecoration(
                      hintText: 'Description or Link of your Store/Blog',
                      border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide: new BorderSide(color: Color(0xffeb4a5f))),
                      labelStyle: GoogleFonts.mada()),
                ),
              ),
              Container(
                height: 50,
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
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
              Padding(padding: EdgeInsets.only(top: 10.0)),
              Container(
                height: 50,
                padding: EdgeInsets.only(left: 10, right: 10),
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

              Padding(padding: EdgeInsets.only(bottom: 240.0)),
            ],
          ),
        ),
      ),
    );
  }
}

//************************************************************* */
