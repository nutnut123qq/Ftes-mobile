/// Blog Category entity
class BlogCategory {
  final String id;
  final String name;

  const BlogCategory({
    required this.id,
    required this.name,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BlogCategory && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'BlogCategory(id: $id, name: $name)';
  }
}
