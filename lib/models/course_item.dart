class CourseItem {
  final String category;
  final String title;
  final String price;
  final String? originalPrice;
  final String rating;
  final String students;
  final String imageUrl;

  CourseItem({
    required this.category,
    required this.title,
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.students,
    required this.imageUrl,
  });
}
