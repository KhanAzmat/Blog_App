import 'package:Blog_app/Blog/addBlog.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../NetworkHandler.dart';
import '../Screen/HomeScreen.dart';
import '../Profile/ProfileScreen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'WelcomePage.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final storage = FlutterSecureStorage();
  int currentState = 0;
  List<Widget> widgets = [HomeScreen(), ProfileScreen()];
  List<String> titleString = ["Home Page", "Profile Page"];
  var networkHandler = new NetworkHandler();
  var log = new Logger();
  String user = "";

  void initState() {
    super.initState();
    checkProfile();
  }

  void checkProfile() async {
    var response = await networkHandler.get("/api/profile/checkProfile");
    setState(() {
      user = response['username'];
    });

    if (response["status"] == true) {
      log.i(response['username']);
      setState(() {
        profilePhoto = CircleAvatar(
          radius: 50,
          backgroundImage: NetworkHandler().getImage(response['username']),
        );
      });
    } else {
      setState(() {
        profilePhoto = Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/header.jpg"), fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(50)),
        );
      });
    }
  }

  Widget profilePhoto = Container(
    width: 100,
    height: 100,
    decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("images/header.jpg"), fit: BoxFit.cover),
        borderRadius: BorderRadius.circular(50)),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
            child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  profilePhoto,
                  SizedBox(height: 10),
                  Text('@$user'),
                ],
              ),
            ),
            ListTile(
              title: Text('All Posts'),
              trailing: Icon(Icons.launch, color: Colors.teal),
              onTap: () {},
            ),
            ListTile(
              title: Text('New Post'),
              trailing: Icon(Icons.add, color: Colors.teal),
              onTap: () {},
            ),
            ListTile(
              title: Text('Settings'),
              trailing: Icon(Icons.settings, color: Colors.teal),
              onTap: () {},
            ),
            ListTile(
              title: Text('Feedback'),
              trailing: Icon(Icons.feedback, color: Colors.teal),
              onTap: () {},
            ),
            ListTile(
              title: Text('Logout'),
              trailing:
                  Icon(Icons.power_settings_new_sharp, color: Colors.teal),
              onTap: () {
                logOut();
              },
            ),
          ],
        )),
        appBar: AppBar(
          backgroundColor: Colors.teal[300],
          title: Text(titleString[currentState]),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {},
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.teal[300],
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AddBlog()));
            },
            child: Text("+", style: TextStyle(fontSize: 40))),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
            color: Colors.teal[300],
            shape: CircularNotchedRectangle(),
            notchMargin: 12,
            child: Container(
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.home),
                        color: currentState == 0 ? Colors.black : Colors.grey,
                        onPressed: () {
                          setState(() {
                            currentState = 0;
                          });
                        },
                        iconSize: 35,
                      ),
                      IconButton(
                        icon: Icon(Icons.person),
                        color: currentState == 1 ? Colors.black : Colors.grey,
                        onPressed: () {
                          setState(() {
                            currentState = 1;
                          });
                        },
                        iconSize: 35,
                      ),
                    ],
                  ),
                ))),
        body: widgets[currentState]);
  }

  void logOut() async {
    await storage.delete(key: "token");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => WelcomePage()),
        (route) => false);
  }
}
