import 'package:Blog_app/CustomWidget/BlogCard.dart';
import 'package:Blog_app/Model/addBlogModel.dart';
import 'package:Blog_app/Model/superModel.dart';
import 'package:Blog_app/NetworkHandler.dart';
import 'package:flutter/material.dart';

import 'Blog.dart';

class Blogs extends StatefulWidget {
  Blogs({Key key, this.url}) : super(key: key);
  final String url;

  @override
  BlogsState createState() => BlogsState();
}

class BlogsState extends State<Blogs> {
  NetworkHandler networkHandler = new NetworkHandler();
  SuperModel superModel = new SuperModel();
  List<AddBlogModel> data = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var response = await networkHandler.get(widget.url);
    superModel = SuperModel.fromJson(response);
    setState(() {
      data = superModel.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return data.length > 0
        ? Column(
            children: data
                .map((item) => Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Blog(
                                          addBlogModel: item,
                                          networkHandler: networkHandler,
                                        )));
                          },
                          child: BlogCard(
                            addBlogModel: item,
                            networkHandler: networkHandler,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    ))
                .toList(),
          )
        : Center(
            child: Text("We don't have any blog yet"),
          );
  }
}
