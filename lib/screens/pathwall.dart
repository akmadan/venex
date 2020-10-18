import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yourconverse/bubbles/singlepostbuble.dart';

class PatchWall extends StatefulWidget {
  @override
  _PatchWallState createState() => _PatchWallState();
}

class _PatchWallState extends State<PatchWall> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff0F0F0F),
        appBar: AppBar(
          backgroundColor: Color(0xff1C1A1A),
          title: Text('Patch Wall',
              style: GoogleFonts.rubik(fontWeight: FontWeight.bold)),
        ),
        body: StreamBuilder(
          stream: Firestore.instance
              .collection('allposts')
              .orderBy('order', descending: true)
              .snapshots(),
          builder: (context, allpostsnapshot) {
            if (allpostsnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final postdocs = allpostsnapshot.data.documents;
              return StaggeredGridView.countBuilder(
                crossAxisCount: 4,
                itemCount: postdocs.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SinglePost(
                                  url: postdocs[index]['url'],
                                  username: postdocs[index]['username'],
                                  dp: postdocs[index]['dp'],
                                  likes: postdocs[index]['likes'],
                                  docname: postdocs[index]['time'],
                                  description: postdocs[index]['description'],
                                  postuid: postdocs[index]['uid'],
                                )));
                  },
                  child: new Container(
                    color: Colors.transparent,
                    child: Material(
                      color: Colors.transparent,
                      elevation: 5.0,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            
                            image: DecorationImage(
                                image: NetworkImage(postdocs[index]['url']),
                                fit: BoxFit.cover)),
                      ),
                    ),
                  ),
                ),
                staggeredTileBuilder: (int index) =>
                    new StaggeredTile.count(2, index.isEven ? 2.5 : 1.5),
                mainAxisSpacing: 6.0,
                crossAxisSpacing: 6.0,
              );
             
            }
          },
        ));
  }
}
