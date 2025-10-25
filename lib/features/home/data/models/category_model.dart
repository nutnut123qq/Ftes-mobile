import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/category.dart' as domain;

part 'category_model.g.dart';

/// Category model extending Category entity for data layer
@JsonSerializable(explicitToJson: true)
class CategoryModel extends domain.Category {
  const CategoryModel({
    super.id,
    super.name,
    super.slug,
    super.description,
    super.image,
    super.active,
  });

  /// Create CategoryModel from JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  /// Convert CategoryModel to JSON
  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  /// Convert to domain entity
  domain.Category toEntity() {
    return domain.Category(
      id: id,
      name: name,
      slug: slug,
      description: description,
      image: image,
      active: active,
    );
  }

  /// Create CategoryModel from domain entity
  factory CategoryModel.fromEntity(domain.Category category) {
    return CategoryModel(
      id: category.id,
      name: category.name,
      slug: category.slug,
      description: category.description,
      image: category.image,
      active: category.active,
    );
  }
}
