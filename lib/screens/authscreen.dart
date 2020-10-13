

import 'package:flutter/material.dart';
import 'package:yourconverse/widgets/authform.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Color(0xff101a16),
        body: AuthForm());
  }
}