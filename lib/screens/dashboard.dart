import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:yourconverse/bubbles/postbubble.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {



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
        adUnitId: "ca-app-pub-3937702122719326/6048441010",
        size: AdSize.banner,
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





  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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
          return ListView.builder(
            itemCount: postdocs.length,
            itemBuilder: (context, index) {
              return PostBubble(
                url: postdocs[index]['url'],
                username: postdocs[index]['username'],
                dp: postdocs[index]['dp'],
                likes: postdocs[index]['likes'],
                docname: postdocs[index]['time'],
                description: postdocs[index]['description'],
                postuid: postdocs[index]['uid'],
              );
            },
          );
        }
      },
    );
  }
}
