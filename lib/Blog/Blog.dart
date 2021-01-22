import 'package:Blog_app/Model/addBlogModel.dart';
import 'package:Blog_app/NetworkHandler.dart';
import 'package:flutter/material.dart';

class Blog extends StatelessWidget {
  const Blog({Key key, this.addBlogModel, this.networkHandler})
      : super(key: key);
  final AddBlogModel addBlogModel;
  final NetworkHandler networkHandler;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: [
      Container(
          height: 340,
          width: MediaQuery.of(context).size.width,
          child: Card(
              elevation: 8,
              child: Column(children: [
                Container(
                    height: 230,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: networkHandler.getImage(addBlogModel.id),
                      fit: BoxFit.fill,
                    ))),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: Text(addBlogModel.title,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: Row(children: [
                    Icon(Icons.chat, size: 20),
                    SizedBox(width: 8),
                    Text(addBlogModel.comment.toString()),
                    SizedBox(width: 15),
                    Icon(Icons.thumb_up, size: 20),
                    SizedBox(width: 8),
                    Text(addBlogModel.count.toString()),
                    SizedBox(width: 15),
                    Icon(Icons.share, size: 20),
                    SizedBox(width: 8),
                    Text(addBlogModel.share.toString()),
                  ]),
                )
              ]))),
      SizedBox(height: 10),
      Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Card(
            elevation: 15,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
              child: Text(addBlogModel.body),
            ),
          ),
        ),
      ),
    ]));
  }
}
