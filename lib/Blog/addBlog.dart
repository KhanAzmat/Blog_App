import 'dart:convert';

import 'package:Blog_app/CustomWidget/OverLay.dart';
import 'package:Blog_app/Model/addBlogModel.dart';
import 'package:Blog_app/pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart';

import '../NetworkHandler.dart';

class AddBlog extends StatefulWidget {
  @override
  AddBlogState createState() => AddBlogState();
}

class AddBlogState extends State<AddBlog> {
  NetworkHandler networkHandler = new NetworkHandler();
  IconData coverPhoto = Icons.image;
  ImagePicker picker = new ImagePicker();
  PickedFile imgFile;
  final formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  Widget titleTextField() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: TextFormField(
            controller: titleController,
            validator: (value) {
              if (value.isEmpty) {
                return "Title can't be empty";
              } else if (value.length > 100) {
                return "Title length should not be more than 100";
              }
              return null;
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.green,
                    width: 2,
                  ),
                ),
                labelText: "Add Image n Title",
                prefixIcon: IconButton(
                  onPressed: () {
                    coverImage();
                  },
                  icon: Icon(coverPhoto, color: Colors.teal),
                )),
            maxLength: 100,
            maxLines: null));
  }

  void coverImage() async {
    final coverImg = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      imgFile = coverImg;
      coverPhoto = Icons.check_box;
    });
  }

  Widget bodyTextField() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: TextFormField(
            controller: bodyController,
            validator: (value) {
              if (value.isEmpty) {
                return "Body can't be empty";
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.green,
                  width: 2,
                ),
              ),
              labelText: "Provide Body for the blog",
            ),
            maxLines: null));
  }

  Widget addButton() {
    return InkWell(
      onTap: () async {
        if (imgFile != null && formKey.currentState.validate()) {
          AddBlogModel addBlogModel = new AddBlogModel(
              body: bodyController.text, title: titleController.text);
          var response = await networkHandler.post1(
              "/api/blogpost/Add", addBlogModel.toJson());
          print(response.body);

          if (response.statusCode == 200 || response.statusCode == 201) {
            String id = json.decode(response.body)["data"];
            var imgResponse = await networkHandler.patchImage(
                "/api/blogpost/add/coverImage/$id", imgFile.path);
            print(imgResponse.statusCode);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                (route) => false);
          }
        }
      },
      child: Center(
          child: Container(
        height: 60,
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.teal,
        ),
        child: Center(
          child: Text("Add Blog",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
        ),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white54,
            elevation: 0.0,
            leading: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.black,
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  if (imgFile.path != null && formKey.currentState.validate())
                    showModalBottomSheet(
                        context: context,
                        builder: ((builder) => OverLayCard(
                            imgFile: imgFile, title: titleController.text)));
                },
                child: Text("Preview",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.teal,
                        fontWeight: FontWeight.bold)),
              ),
            ]),
        body: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              titleTextField(),
              bodyTextField(),
              SizedBox(height: 20),
              addButton(),
            ],
          ),
        ));
  }
}
