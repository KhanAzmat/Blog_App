import 'dart:io';

import 'package:Blog_app/Model/addBlogModel.dart';
import 'package:Blog_app/NetworkHandler.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BlogCard extends StatelessWidget {
  const BlogCard({Key key, this.addBlogModel, this.networkHandler})
      : super(key: key);
  final AddBlogModel addBlogModel;
  final NetworkHandler networkHandler;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      height: 300,
      width: MediaQuery.of(context).size.width,
      child: Card(
        child: Stack(children: [
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: networkHandler.getImage(addBlogModel.id),
                fit: BoxFit.fitWidth,
              ))),
          Positioned(
              bottom: 2,
              child: Container(
                  padding: EdgeInsets.all(8),
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(addBlogModel.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)))),
        ]),
      ),
    );
  }
}
