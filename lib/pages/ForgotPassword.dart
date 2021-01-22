import 'dart:convert';
import 'package:logger/logger.dart';
import "package:flutter/material.dart";
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../NetworkHandler.dart';

import 'HomePage.dart';
import 'WelcomePage.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  var log = Logger();
  bool vis = true;
  final _globalkey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String errorText;
  bool validate = false;
  bool circular = false;
  final storage = new FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // height: MediaQuery.of(context).size.height,
        // width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.green[200]],
            begin: const FractionalOffset(0.0, 1.0),
            end: const FractionalOffset(0.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.repeated,
          ),
        ),
        child: Form(
          key: _globalkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Update Password",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              usernameTextField(),
              passwordTextField(),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () async {
                  Map<String, String> data = {
                    "password": _passwordController.text
                  };
                  var response = await networkHandler.patch(
                      "/api/users/update/${_usernameController.text}", data);
                  if (response.statusCode == 200 ||
                      response.statusCode == 201) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => WelcomePage()),
                        (route) => false);
                  }
                },
                child: Container(
                  width: 150,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xff00A86B),
                  ),
                  child: Center(
                    child: circular
                        ? CircularProgressIndicator()
                        : Text(
                            "Update",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
              Divider(height: 30, thickness: 2)
            ],
          ),
        ),
      ),
    );
  }

  checkUser() async {
    if (_usernameController.text.length == 0) {
      setState(() {
        // circular = false;
        validate = false;
        errorText = "Username Can't be empty";
      });
    } else {
      var response = await networkHandler
          .get("/user/checkUsername/${_usernameController.text}");
      if (response['Status']) {
        setState(() {
          // circular = false;
          validate = false;
          errorText = "Username already taken";
        });
      } else {
        setState(() {
          // circular = false;
          validate = true;
        });
      }
    }
  }

  Widget usernameTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10.0),
      child: Column(
        children: [
          Text("Username"),
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              errorText: validate ? null : errorText,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 2,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget passwordTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10.0),
      child: Column(
        children: [
          Text("Password"),
          TextFormField(
            controller: _passwordController,
            obscureText: vis,
            decoration: InputDecoration(
              errorText: validate ? null : errorText,
              suffixIcon: IconButton(
                icon: Icon(vis ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    vis = !vis;
                  });
                },
              ),
              helperStyle: TextStyle(
                fontSize: 14,
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 2,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
