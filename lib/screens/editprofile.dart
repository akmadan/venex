import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  final String uid;

  const EditProfile({Key key, this.uid}) : super(key: key);
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
    );
  }
}
