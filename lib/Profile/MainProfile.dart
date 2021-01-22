import 'dart:convert';

import 'package:Blog_app/Blog/Blogs.dart';
import 'package:Blog_app/Model/profileModel.dart';
import "package:flutter/material.dart";
import '../Model/profileModel.dart';
import '../NetworkHandler.dart';
import 'package:logger/logger.dart';

class MainProfile extends StatefulWidget {
  @override
  MainProfileState createState() => MainProfileState();
}

class MainProfileState extends State<MainProfile> {
  bool circular = true;
  NetworkHandler networkHandler = NetworkHandler();
  ProfileModel profilemodel = new ProfileModel();
  var log = Logger();
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var response = await networkHandler.get("/api/profile/getData");

    log.i(response);
    setState(() {
      profilemodel = ProfileModel.fromJson(response["data"]);
      circular = false;
      log.i(profilemodel.username);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white10,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
          color: Colors.black,
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.edit), onPressed: () {}, color: Colors.black),
        ],
      ),
      body: circular
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                head(),
                Divider(
                  thickness: 0.8,
                ),
                otherDetails(
                    "About",
                    profilemodel.about != null
                        ? profilemodel.about
                        : 'Default Value'),
                otherDetails(
                    "Name",
                    profilemodel.name != null
                        ? profilemodel.name
                        : 'Default Value'),
                otherDetails(
                    "Profession",
                    profilemodel.profession != null
                        ? profilemodel.profession
                        : 'Default Value'),
                otherDetails(
                    "DOB",
                    profilemodel.DOB != null
                        ? profilemodel.DOB
                        : 'Default Value'),
                Divider(
                  thickness: 0.8,
                ),
                SizedBox(height: 20),
                Blogs(url: "/api/blogpost/getOwnBlog"),
              ],
            ),
    );
  }

  Widget head() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Center(
          child: CircleAvatar(
            radius: 50,
            backgroundImage: NetworkHandler().getImage(profilemodel.username),
          ),
        ),
        Text(
          profilemodel.username != null
              ? profilemodel.username
              : 'Default Value',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Text(profilemodel.titleline != null
            ? profilemodel.titleline
            : 'Default Value'),
      ]),
    );
  }

  Widget otherDetails(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "$label : ",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text(value, style: TextStyle(fontSize: 16))
      ]),
    );
  }
}
