import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/blog.dart';

part 'blog_model.g.dart';

/// Blog model for JSON serialization
@JsonSerializable(explicitToJson: true)
class BlogModel {
  final String id;
  final String title;
  final String content;
  final String image;
  final String slugName;
  
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  
  @JsonKey(name: 'categoryName')
  final String categoryName;
  
  @JsonKey(name: 'emojis', fromJson: _intFromJson)
  final int emojis;
  
  @JsonKey(name: 'view', fromJson: _boolFromJson)
  final bool view;
  
  @JsonKey(name: 'userName', fromJson: _stringFromJson)
  final String userName;
  
  @JsonKey(name: 'fullname', fromJson: _stringFromJson)
  final String fullname;
  
  final String? technology;
  final String? comment;
  final String? des;

  const BlogModel({
    required this.id,
    required this.title,
    required this.content,
    required this.image,
    required this.slugName,
    required this.createdAt,
    required this.categoryName,
    required this.emojis,
    required this.view,
    required this.userName,
    required this.fullname,
    this.technology,
    this.comment,
    this.des,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) =>
      _$BlogModelFromJson(json);

  Map<String, dynamic> toJson() => _$BlogModelToJson(this);

  Blog toEntity() {
    return Blog(
      id: id,
      title: title,
      content: content,
      image: image,
      slugName: slugName,
      createdAt: createdAt,
      categoryName: categoryName,
      emojis: emojis,
      view: view,
      userName: userName,
      fullname: fullname,
      technology: technology,
      comment: comment,
      des: des,
    );
  }

  /// Helper function to safely convert dynamic to int, handling null values
  static int _intFromJson(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  /// Helper function to safely convert dynamic to bool, handling null values
  static bool _boolFromJson(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    if (value is int) return value != 0;
    return false;
  }

  /// Helper function to safely convert dynamic to string, handling null values
  static String _stringFromJson(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    return value.toString();
  }
}
