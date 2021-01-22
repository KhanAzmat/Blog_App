// import 'dart:convert';

// import 'package:flutter/material.dart';

// import '../NetworkHandler.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
// //import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class SignUpPage extends StatefulWidget {
//   SignUpPage({Key key}) : super(key: key);
//   @override
//   SignUpPageState createState() => SignUpPageState();
// }

// class SignUpPageState extends State<SignUpPage> {
//   TextEditingController emailTextController = TextEditingController();
//   TextEditingController passwordTextController = TextEditingController();
//   TextEditingController usernameTextController = TextEditingController();
//   //final storage = new FlutterSecureStorage();
//   final formKey = GlobalKey<FormState>();
//   var passFlag = true;
//   NetworkHandler networkHandler = new NetworkHandler();
//   String errText;
//   bool validate = false;
//   bool circular = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Container(
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             decoration: BoxDecoration(
//                 gradient: LinearGradient(
//               begin: FractionalOffset(0.0, 1.0),
//               end: FractionalOffset(1.0, 0.0),
//               stops: [0.0, 1.0],
//               tileMode: TileMode.repeated,
//               colors: [Colors.cyan, Colors.orange],
//             )),
//             alignment: Alignment.center,
//             child: Center(
//               child: Form(
//                 key: formKey,
//                 child: ListView(
//                   children: <Widget>[
//                     SizedBox(
//                       height: 200,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Material(
//                         borderRadius: BorderRadius.circular(20.0),
//                         color: Colors.white.withOpacity(0.8),
//                         elevation: 0.0,
//                         child: Padding(
//                           padding: const EdgeInsets.all(4.0),
//                           child: TextFormField(
//                             controller: usernameTextController,
//                             decoration: InputDecoration(
//                               errorText: validate ? null : errText,
//                               border: InputBorder.none,
//                               hintText: "Username",
//                               icon: Icon(Icons.person),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Material(
//                         borderRadius: BorderRadius.circular(20.0),
//                         color: Colors.white.withOpacity(0.8),
//                         elevation: 0.0,
//                         child: Padding(
//                           padding: const EdgeInsets.all(4.0),
//                           child: TextFormField(
//                             controller: emailTextController,
//                             decoration: InputDecoration(
//                               border: InputBorder.none,
//                               hintText: "Email",
//                               icon: Icon(Icons.email),
//                             ),
//                             validator: (value) {
//                               if (value.isEmpty) {
//                                 Pattern pattern =
//                                     r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
//                                 RegExp regex = new RegExp(pattern);
//                                 if (!regex.hasMatch(value))
//                                   return 'Please make sure your email address is valid';
//                                 else
//                                   return null;
//                               }
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Material(
//                         borderRadius: BorderRadius.circular(20.0),
//                         color: Colors.white.withOpacity(0.8),
//                         elevation: 0.0,
//                         child: Padding(
//                           padding: const EdgeInsets.all(4.0),
//                           child: TextFormField(
//                             controller: passwordTextController,
//                             obscureText: passFlag,
//                             decoration: InputDecoration(
//                               suffixIcon: IconButton(
//                                   icon: Icon(passFlag
//                                       ? Icons.visibility_off
//                                       : Icons.visibility),
//                                   onPressed: () {
//                                     setState(() {
//                                       passFlag = !passFlag;
//                                     });
//                                   }),
//                               border: InputBorder.none,
//                               hintText: "Password",
//                               icon: Icon(Icons.lock),
//                             ),
//                             validator: (value) {
//                               if (value.isEmpty) {
//                                 return 'Password field cannot be empty';
//                               } else if (value.length < 6) {
//                                 return 'Password has to be at least 6 characters long ';
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 30,
//                     ),
//                     InkWell(
//                         onTap: () async {
//                           setState(() {
//                             circular = true;
//                           });
//                           await checkUser();
//                           if (formKey.currentState.validate() && validate) {
//                             Map<String, String> data = {
//                               "username": usernameTextController.text,
//                               "email": emailTextController.text,
//                               "password": passwordTextController.text
//                             };
//                             print(data);
//                             var responseRegister = await networkHandler.post(
//                                 "/api/users/register", data);
//                             //Login logic added here

//                             if (responseRegister.statusCode == 200 ||
//                                 responseRegister.statusCode == 201) {
//                               Map<String, String> data = {
//                                 "username": usernameTextController.text,
//                                 "password": passwordTextController.text,
//                               };
//                               var response = await networkHandler.post(
//                                   "/api/users/login", data);
//                               if (response.statusCode == 200 ||
//                                   response.statusCode == 201) {
//                                 Map<String, String> output =
//                                     json.decode(response.body);
//                                 print(output["token"]);
//                                 // await storage.write(
//                                 //     key: "token", value: output["token"]);
//                                 setState(() {
//                                   validate = true;
//                                   circular = false;
//                                 });
//                               }
//                             }
//                             setState(() {
//                               circular = false;
//                             });
//                           } else {
//                             setState(() {
//                               circular = false;
//                             });
//                           }
//                         },
//                         child: circular
//                             ? CircularProgressIndicator()
//                             : Container(
//                                 width: 150,
//                                 height: 50,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10),
//                                   color: Color(0xff00A86B),
//                                 ),
//                                 child: Center(
//                                     child: Text('Sign Up',
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 22.0))))),
//                   ],
//                 ),
//               ),
//             )));
//   }

//   checkUser() async {
//     if (usernameTextController.text.length == 0) {
//       setState(() {
//         // circular = false;
//         validate = false;
//         errText = 'Username can\'t be empty';
//       });
//     } else {
//       var response = await networkHandler
//           .get("/api/users/checkusername/${usernameTextController.text}");
//       if (response['Status']) {
//         setState(() {
//           //circular = false;
//           validate = false;
//           errText = "Username already entered";
//         });
//       } else {
//         setState(() {
//           validate = true;
//         });
//       }
//     }
//   }
// }
import 'dart:convert';

import "package:flutter/material.dart";
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../NetworkHandler.dart';

import 'HomePage.dart';
import 'WelcomePage.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool vis = true;
  final _globalkey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
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
                "Sign up with email",
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
              emailTextField(),
              passwordTextField(),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () async {
                  setState(() {
                    circular = true;
                  });
                  await checkUser();
                  if (_globalkey.currentState.validate() && validate) {
                    // we will send the data to rest server
                    Map<String, String> data = {
                      "username": _usernameController.text,
                      "email": _emailController.text,
                      "password": _passwordController.text,
                    };
                    print(data);
                    var responseRegister =
                        await networkHandler.post("/api/users/register", data);

                    //Login Logic added here
                    if (responseRegister.statusCode == 200 ||
                        responseRegister.statusCode == 201) {
                      Map<String, String> data = {
                        "username": _usernameController.text,
                        "password": _passwordController.text,
                      };
                      var response =
                          await networkHandler.post("/api/users/login", data);

                      if (response.statusCode == 200 ||
                          response.statusCode == 201) {
                        Map<String, dynamic> output =
                            json.decode(response.body);
                        print(output["token"]);
                        await storage.write(
                            key: "token", value: output["token"]);
                        setState(() {
                          validate = true;
                          circular = false;
                        });
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                            (route) => false);
                      } else {
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text("Netwok Error")));
                      }
                    }

                    //Login Logic end here

                    setState(() {
                      circular = false;
                    });
                  } else {
                    setState(() {
                      circular = false;
                    });
                  }
                },
                child: circular
                    ? CircularProgressIndicator()
                    : Container(
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xff00A86B),
                        ),
                        child: Center(
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
              )
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
          .get("/api/users/checkUsername/${_usernameController.text}");
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

  Widget emailTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10.0),
      child: Column(
        children: [
          Text("Email"),
          TextFormField(
            controller: _emailController,
            validator: (value) {
              if (value.isEmpty) return "Email can't be empty";
              if (!value.contains("@")) return "Email is Invalid";
              return null;
            },
            decoration: InputDecoration(
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
            validator: (value) {
              if (value.isEmpty) return "Password can't be empty";
              if (value.length < 8) return "Password lenght must have >=8";
              return null;
            },
            obscureText: vis,
            decoration: InputDecoration(
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
