

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yourconverse/bubbles/postbubble.dart';

class SavedPosts extends StatefulWidget {
  final String uid;

  const SavedPosts({Key key, this.uid}) : super(key: key);
  @override
  _SavedPostsState createState() => _SavedPostsState();
}

class _SavedPostsState extends State<SavedPosts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff0F0F0F),
        appBar: AppBar(
          backgroundColor: Color(0xff1C1A1A),
          elevation: 8.0,
          title: Text('Saved Posts',
              style: GoogleFonts.rubik(fontWeight: FontWeight.bold)),
        ),
        body: StreamBuilder(
          stream: Firestore.instance
              .collection('userposts')
              .document(widget.uid)
              .collection('savedposts')
              .snapshots(),
          builder: (context, savesnapshot) {
            if (savesnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              final savedocs = savesnapshot.data.documents;
              return ListView.builder(
                itemCount: savedocs.length,
                itemBuilder: (context, index) {
                  return FutureBuilder(
                    future: Firestore.instance
                        .collection('allposts')
                        .document(savedocs[index]['docname'])
                        .get(),
                    builder: (context, allpostsnapshot) {
                      if (allpostsnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: Container());
                      } else {
                        return PostBubble(
                          url: allpostsnapshot.data['url'],
                          dp: allpostsnapshot.data['dp'],
                          description: allpostsnapshot.data['description'],
                          likes: allpostsnapshot.data['likes'],
                          username: allpostsnapshot.data['username'],
                          postuid: allpostsnapshot.data['uid'],
                          docname: allpostsnapshot.data['time'],
                        );
                      }
                    },
                  );
                },
              );
            }
          },
        ));
  }
}
