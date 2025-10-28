/// Instructor Course entity representing course created by instructor
class InstructorCourse {
  final String id;
  final String title;
  final String description;
  final double avgStar;
  final double totalPrice;
  final double salePrice;
  final int totalUser;
  final String imageHeader;
  final String slugName;
  final String courseCode;
  final int term;
  final String contentCourse;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String instructor;
  final String categoryId;
  final String categoryName;

  const InstructorCourse({
    required this.id,
    required this.title,
    required this.description,
    required this.avgStar,
    required this.totalPrice,
    required this.salePrice,
    required this.totalUser,
    required this.imageHeader,
    required this.slugName,
    required this.courseCode,
    required this.term,
    required this.contentCourse,
    required this.createdAt,
    required this.updatedAt,
    required this.instructor,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InstructorCourse && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'InstructorCourse(id: $id, title: $title, instructor: $instructor)';
  }
}
