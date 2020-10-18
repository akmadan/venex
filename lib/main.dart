import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yourconverse/home.dart';
import 'package:yourconverse/screens/authscreen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  gotohome(BuildContext ctx) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    Navigator.pushReplacement(
        ctx,
        MaterialPageRoute(
            builder: (context) => Home(
                  uid: user.uid,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: Color(
              0xff9052B5,
            ),
            buttonTheme: ButtonThemeData(
                buttonColor: Color(0xff9052B5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)))),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (context, userSnapshot) {
            if (userSnapshot.hasData) {
              gotohome(context);
              return Container();
            } else {
              return AuthScreen();
            }
          },
        ));
  }
}
