import 'package:flutter/material.dart';
import 'package:yourconverse/widgets/postbubble.dart';

class ProfilePost extends StatelessWidget {
  final String url;
  final String username;

  const ProfilePost({Key key, this.url, this.username}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Post'),
      ),
      body: Container(
        child: PostBubble(
          url: url,
          username: username,
        ),
      ),
    );
  }
}
