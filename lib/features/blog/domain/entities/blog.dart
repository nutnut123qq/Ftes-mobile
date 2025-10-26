/// Blog entity
class Blog {
  final String id;
  final String title;
  final String content;
  final String image;
  final String slugName;
  final DateTime createdAt;
  final String categoryName;
  final int emojis;
  final bool view;
  final String userName;
  final String fullname;
  final String? technology;
  final String? comment;
  final String? des;

  const Blog({
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Blog && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Blog(id: $id, title: $title, slugName: $slugName)';
  }
}
