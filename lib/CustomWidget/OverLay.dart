import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class OverLayCard extends StatelessWidget {
  const OverLayCard({Key key, this.imgFile, this.title}) : super(key: key);
  final PickedFile imgFile;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: Stack(children: [
        Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: FileImage(File(imgFile.path)),
              fit: BoxFit.fitWidth,
            ))),
        Positioned(
            bottom: 2,
            child: Container(
                padding: EdgeInsets.all(8),
                height: 55,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                child: Text(title,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)))),
      ]),
    );
  }
}
