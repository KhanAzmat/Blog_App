import 'dart:convert';

import 'package:Blog_app/Screen/HomeScreen.dart';
import 'package:Blog_app/Screen/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import './SignUpPage.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;

import 'HomePage.dart';
import 'SignInPage.dart';

class WelcomePage extends StatefulWidget {
  @override
  WelcomePageState createState() => WelcomePageState();
}

class WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  AnimationController controller1;
  Animation<Offset> animation1;
  AnimationController controller2;
  Animation<Offset> animation2;
  bool isLogin = false;
  Map data;
  final FacebookLogin facebookLogin = new FacebookLogin();
  var log = new Logger();
  var storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    controller1 = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    animation1 = Tween<Offset>(begin: Offset(0.0, 8.0), end: Offset(0.0, 0.0))
        .animate(CurvedAnimation(parent: controller1, curve: Curves.easeIn));
    controller1.forward();

    controller2 = AnimationController(
        duration: Duration(milliseconds: 2500), vsync: this);
    animation2 = Tween<Offset>(begin: Offset(0.0, 8.0), end: Offset(0.0, 0.0))
        .animate(
            CurvedAnimation(parent: controller2, curve: Curves.elasticInOut));
    controller2.forward();
  }

  @override
  void dispose() {
    super.dispose();
    controller1.dispose();
    controller2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: FractionalOffset(0.0, 1.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.repeated,
              colors: [Colors.cyan, Colors.orange],
            )),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
              child: Column(children: <Widget>[
                SlideTransition(
                  position: animation1,
                  child: Text('My Blog',
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w600,
                      )),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 6,
                ),
                SlideTransition(
                  position: animation1,
                  child: Text('Great stories for great people',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 38,
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                BoxContainer('images/google.png', 'Sign up with Google', null),
                SizedBox(
                  height: 20,
                ),
                BoxContainer(
                    'images/facebook.png', 'Sign up with Facebook', onFBLogin),
                SizedBox(
                  height: 20,
                ),
                BoxContainer(
                    'images/email.png', 'Sign up with Email', onEmailClick),
                SizedBox(
                  height: 20,
                ),
                SlideTransition(
                  position: animation2,
                  child: Text('Already have an account ?',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ),
                BoxContainer('images/login.jpg', 'Sign In', callSignIn),
              ]),
            )));
  }

  callSignIn() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignInPage()));
  }

  onFBLogin() async {
    final result = await facebookLogin.logIn(['email']);
    log.i(result.status);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final response = await http.get(
            "https://graph.facebook.com/v8.0/me?fields=name,picture,email&access_token=${token}");
        final data1 = json.decode(response.body);
        print(data1);
        setState(() {
          isLogin = true;
          data = data1;
        });
        await storage.write(key: "token", value: token);
        break;
      case FacebookLoginStatus.cancelledByUser:
        setState(() {
          isLogin = false;
        });
        break;
      case FacebookLoginStatus.error:
        setState(() {
          isLogin = false;
        });
        break;
    }
    log.i(isLogin);
    log.i(result.accessToken.token);
    isLogin
        ? Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false)
        : Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => WelcomePage()),
            (route) => false);
  }

  onEmailClick() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignUpPage()));
  }

  Widget BoxContainer(String path, String text, onClick) {
    return SlideTransition(
      position: animation2,
      child: InkWell(
        onTap: onClick,
        child: Container(
            height: 60,
            width: MediaQuery.of(context).size.width - 140,
            child: Card(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
                  Image.asset(path, height: 20, width: 20),
                  SizedBox(width: 20),
                  Text(text,
                      style: TextStyle(fontSize: 16, color: Colors.black)),
                ],
              ),
            ))),
      ),
    );
  }
}
