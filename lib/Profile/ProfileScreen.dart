import 'package:Blog_app/NetworkHandler.dart';
import 'package:flutter/material.dart';

import 'CreateProfile.dart';
import 'MainProfile.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);
  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  Widget page = CircularProgressIndicator();
  NetworkHandler networkHandler = new NetworkHandler();
  @override
  void initState() {
    super.initState();
    checkProfile();
  }

  void checkProfile() async {
    var response = await networkHandler.get("/api/profile/checkProfile");

    if (response["status"] == true) {
      setState(() {
        page = MainProfile();
      });
    } else {
      setState(() {
        page = Button();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: page,
    );
  }

  Widget Button() {
    return Center(
      child: InkWell(
        onTap: () => {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateProfile()))
        },
        child: Container(
            height: 60,
            width: 200,
            decoration: BoxDecoration(
              color: Colors.teal[400],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
                child: Text("Create profile",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))),
      ),
    );
  }
}
