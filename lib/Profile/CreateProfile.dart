import 'dart:io';
import "package:logger/logger.dart";
import 'package:Blog_app/Profile/MainProfile.dart';
import 'package:Blog_app/Screen/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

import '../NetworkHandler.dart';

class CreateProfile extends StatefulWidget {
  @override
  CreateProfileState createState() => CreateProfileState();
}

class CreateProfileState extends State<CreateProfile> {
  var log = Logger();
  DateTime pickedDate;
  TextEditingController dobController = TextEditingController();
  PickedFile imgFile;
  final ImagePicker picker = ImagePicker();
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController professionController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  final networkHandler = NetworkHandler();
  bool circular = false;

  @override
  void initState() {
    super.initState();
    pickedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
            children: [
              imgProfile(),
              SizedBox(height: 20),
              nameTextField(),
              SizedBox(height: 20),
              proTextField(),
              SizedBox(height: 20),
              dobTextField(),
              SizedBox(height: 20),
              titleTextField(),
              SizedBox(height: 20),
              aboutTextField(),
              SizedBox(height: 40),
              InkWell(
                onTap: () async {
                  setState(() {
                    circular = true;
                  });
                  if (formKey.currentState.validate()) {
                    Map<String, String> data = {
                      "name": nameController.text,
                      "profession": professionController.text,
                      "DOB": dobController.text,
                      "titleline": titleController.text,
                      "about": aboutController.text,
                    };
                    var response =
                        await networkHandler.post("/api/profile/add", data);
                    log.i(response.statusCode);
                    if (response.statusCode == 200 ||
                        response.statusCode == 201) {
                      if (imgFile != null) {
                        var imgResponse = await networkHandler.patchImage(
                            "/api/profile/add/image", imgFile.path);
                        if (imgResponse.statusCode == 200) {
                          setState(() {
                            circular = false;
                          });
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => MainProfile()),
                              (route) => false);
                        }
                      } else {
                        setState(() {
                          circular = false;
                        });
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => MainProfile()),
                            (route) => false);
                      }
                    }
                  }
                },
                child: Center(
                  child: Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.teal[400],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                        child: circular
                            ? CircularProgressIndicator()
                            : Text("Submit",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold))),
                  ),
                ),
              )
            ]),
      ),
    );
  }

  Widget imgProfile() {
    return Center(
      child: Stack(children: [
        CircleAvatar(
          radius: 80,
          backgroundColor: Colors.black,
          backgroundImage: imgFile == null
              ? AssetImage("images/profile.jpg")
              : FileImage(File(imgFile.path)),
        ),
        Positioned(
          bottom: 10,
          right: 5,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                  context: context, builder: ((builder) => bottomPop()));
            },
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage("images/camera.png"),
            ),
          ),
        )
      ]),
    );
  }

  Widget bottomPop() {
    return Container(
        height: 100,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(children: [
          Text("Choose profile photo", style: TextStyle(fontSize: 20)),
          SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            FlatButton.icon(
                icon: Icon(Icons.camera),
                onPressed: () {
                  pickImage(ImageSource.camera);
                },
                label: Text("Camera")),
            SizedBox(width: 100),
            FlatButton.icon(
                icon: Icon(Icons.image),
                onPressed: () {
                  pickImage(ImageSource.gallery);
                },
                label: Text("Gallery")),
          ])
        ]));
  }

  void pickImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    setState(() {
      imgFile = pickedFile;
    });
  }

  Widget nameTextField() {
    return TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return "Name cannot be empty";
          }
          return null;
        },
        controller: nameController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.teal[400],
          )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.green,
            width: 2,
          )),
          prefixIcon: Icon(Icons.person, color: Colors.teal[400]),
          labelText: "Name",
        ));
  }

  Widget proTextField() {
    return TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return "Profession cannot be empty";
          }
          return null;
        },
        controller: professionController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.teal[400],
          )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.green,
            width: 2,
          )),
          prefixIcon: Icon(Icons.person, color: Colors.teal[400]),
          labelText: "Profession",
        ));
  }

  Widget dobTextField() {
    return TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return "DOB cannot be empty";
          }
          return null;
        },
        controller: dobController,
        onTap: pickDate,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.teal[400],
          )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.green,
            width: 2,
          )),
          prefixIcon: Icon(Icons.person, color: Colors.teal[400]),
          labelText: "Date Of Birth",
        ));
  }

  Widget titleTextField() {
    return TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return "Title cannot be empty";
          }
          return null;
        },
        controller: titleController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.teal[400],
          )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.green,
            width: 2,
          )),
          prefixIcon: Icon(Icons.person, color: Colors.teal[400]),
          labelText: "Title",
        ));
  }

  Widget aboutTextField() {
    return TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return "Field cannot be empty";
          }
          return null;
        },
        controller: aboutController,
        maxLines: 4,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.teal[400],
          )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.green,
            width: 2,
          )),
          //prefixIcon: Icon(Icons.person, color: Colors.teal[400]),
          labelText: "About",
        ));
  }

  pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2040),
      initialDate: pickedDate,
    );
    if (date != null) {
      String formatDate = DateFormat('yyyy-MM-dd').format(date);
      dobController.text = formatDate;
    }
  }
}
//Icon(Icons.camera_alt, color: Colors.teal[400], size: 30)),
