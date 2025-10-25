import 'package:equatable/equatable.dart';

/// Category entity representing a course category in the domain layer
class Category extends Equatable {
  final String? id;
  final String? name;
  final String? slug;
  final String? description;
  final String? image;
  final bool? active;

  const Category({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.image,
    this.active,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        description,
        image,
        active,
      ];
}
