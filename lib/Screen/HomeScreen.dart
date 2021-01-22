import 'package:Blog_app/Blog/Blogs.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Blogs(url: "/api/blogpost/getOtherBlog"),
      ),
    );
  }
}
