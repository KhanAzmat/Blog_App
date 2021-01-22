import 'package:Blog_app/Model/addBlogModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'superModel.g.dart';

@JsonSerializable()
class SuperModel {
  List<AddBlogModel> data;
  SuperModel({this.data});

  factory SuperModel.fromJson(Map<String, dynamic> json) =>
      _$SuperModelFromJson(json);
  Map<String, dynamic> toJson() => _$SuperModelToJson(this);
}
