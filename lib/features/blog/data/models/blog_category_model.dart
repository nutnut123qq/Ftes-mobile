import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/blog_category.dart';

part 'blog_category_model.g.dart';

/// Blog Category model for JSON serialization
@JsonSerializable(explicitToJson: true)
class BlogCategoryModel {
  final String id;
  final String name;

  const BlogCategoryModel({
    required this.id,
    required this.name,
  });

  factory BlogCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$BlogCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$BlogCategoryModelToJson(this);

  BlogCategory toEntity() {
    return BlogCategory(
      id: id,
      name: name,
    );
  }
}
