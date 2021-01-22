import 'package:json_annotation/json_annotation.dart';
part 'addBlogModel.g.dart';

@JsonSerializable()
class AddBlogModel {
  String coverImage;
  int count;
  int share;
  int comment;
  @JsonKey(name: "_id")
  String id;
  String username;
  String title;
  String body;
  AddBlogModel(
      {this.coverImage,
      this.count,
      this.share,
      this.comment,
      this.id,
      this.username,
      this.title,
      this.body});

  factory AddBlogModel.fromJson(Map<String, dynamic> json) =>
      _$AddBlogModelFromJson(json);
  Map<String, dynamic> toJson() => _$AddBlogModelToJson(this);
}
