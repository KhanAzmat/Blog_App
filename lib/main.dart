//import 'dart:html';
import 'package:Blog_app/Profile/ProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:Blog_app/pages/HomePage.dart';
import 'package:Blog_app/pages/WelcomePage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Blog/addBlog.dart';
import 'Profile/MainProfile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}
// This widget is the root of your application.

class MyAppState extends State<MyApp> {
  Widget page = WelcomePage();
  final storage = FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  checkLogin() async {
    String token = await storage.read(key: "token");
    if (token != null) {
      setState(() {
        page = HomePage();
      });
    } else {
      setState(() {
        page = WelcomePage();
      });
    }
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme:
              GoogleFonts.openSansTextTheme(Theme.of(context).textTheme)),
      home: page,
    );
  }
}
