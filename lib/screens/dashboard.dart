import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yourconverse/widgets/postbubble.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('allposts').snapshots(),
      builder: (context, allpostsnapshot) {
        if (allpostsnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final postdocs = allpostsnapshot.data.documents;
          return ListView.builder(
            itemCount: postdocs.length,
            itemBuilder: (context, index) {
              return PostBubble(
                url: postdocs[index]['url'],
                username: postdocs[index]['username'],
                dp: postdocs[index]['dp'],
                likes: postdocs[index]['likes'],
                docname: postdocs[index]['time'],
              );
            },
          );
        }
      },
    );
  }
}
