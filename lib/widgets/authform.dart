import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();
  var isLoginpage = true;
  var email = '';
  var username = '';
  var password = '';

  void trysubmit() {
    final isValid = _formkey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formkey.currentState.save();
      _submitAuthForm(username, email, password, isLoginpage);
    }
  }

//-----------------------------------------------------------------------
// Firebase Authentication

  final _auth = FirebaseAuth.instance;
  void _submitAuthForm(
      String username, String email, String password, bool isLoginPage) async {
    AuthResult authresult;

    try {
      if (isLoginPage) {
        authresult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authresult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        await Firestore.instance
            .collection('users')
            .document(authresult.user.uid)
            .setData({
          'username': username,
          'email': email,
          'password': password,
          'uid': authresult.user.uid,
          'likes': '0',
          'dp': '',
          'bio': 'Describe Your Page in a Line',
          'posts': 0,
          'contact': ''
        });
      }
    } on PlatformException catch (err) {
      var message = 'An error occured';
      if (err.message != null) {
        message = err.message;
      }
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ));
    } catch (err) {
      print(err);
    }
  }

  //--------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(16.0),
            child: ListView(reverse: true, children: [
              Stack(children: [
                Positioned(
                    child: SizedBox(
                  height: 40.0,
                  width: double.infinity,
                  child: FlatButton(
                    onPressed: () {
                      setState(() {
                        isLoginpage = !isLoginpage;
                      });
                    },
                    child: Text(
                      isLoginpage
                          ? 'New to Venex ? Create account'
                          : 'Already have an account ? Login',
                      style: GoogleFonts.rubik(color: Colors.white),
                    ),
                  ),
                )),
              ]),
              Stack(
                children: [
                  Positioned(
                    child: SizedBox(
                      height: 50.0,
                      width: double.infinity,
                      child: RaisedButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          trysubmit();
                        },
                        child: Text(
                          isLoginpage ? "Login" : 'Sign Up',
                          style: GoogleFonts.rubik(
                              color: Colors.white, fontSize: 17.0),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 30.0)),
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    if (!isLoginpage)
                      TextFormField(
                        key: ValueKey('username'),
                        validator: (value) {
                          if (value.isEmpty || value.length < 5) {
                            return 'Username length should be more than 5';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(8.0),
                                borderSide: new BorderSide()),
                            labelText: "Enter Username",
                            labelStyle: GoogleFonts.mada()),
                        onSaved: (value) {
                          username = value;
                        },
                      ),
                    Padding(padding: EdgeInsets.only(top: 10.0)),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      key: ValueKey('email'),
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'Incorrect Email';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(8.0),
                              borderSide: new BorderSide()),
                          labelText: "Enter Email",
                          labelStyle: GoogleFonts.mada()),
                      onSaved: (value) {
                        email = value;
                      },
                    ),
                    Padding(padding: EdgeInsets.only(top: 10.0)),
                    TextFormField(
                      obscureText: true,
                      key: ValueKey('password'),
                      onSaved: (value) {
                        password = value;
                      },
                      validator: (value) {
                        if (value.isEmpty || value.length < 5) {
                          return 'Password length should be more than 5';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(8.0),
                              borderSide: new BorderSide()),
                          labelText: "Enter Password",
                          labelStyle: GoogleFonts.mada()),
                    ),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              Center(
                child: Container(
                    child: Text('Venex',
                        style: GoogleFonts.rubik(
                            fontSize: 24.0, fontWeight: FontWeight.bold))),
              )
            ])));
  }
}
