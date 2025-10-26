import 'part.dart';
import 'exercise.dart';

/// Course Detail entity
class CourseDetail {
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
  final String level;
  final String userId;
  final String userName;
  final String categoryId;
  final String categoryName;
  final Map<String, dynamic> infoCourse;
  final List<Part> parts;
  final List<Exercise> exercises;

  const CourseDetail({
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
    required this.level,
    required this.userId,
    required this.userName,
    required this.categoryId,
    required this.categoryName,
    required this.infoCourse,
    required this.parts,
    required this.exercises,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CourseDetail &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.avgStar == avgStar &&
        other.totalPrice == totalPrice &&
        other.salePrice == salePrice &&
        other.totalUser == totalUser &&
        other.imageHeader == imageHeader &&
        other.slugName == slugName &&
        other.courseCode == courseCode &&
        other.term == term &&
        other.contentCourse == contentCourse &&
        other.level == level &&
        other.userId == userId &&
        other.userName == userName &&
        other.categoryId == categoryId &&
        other.categoryName == categoryName &&
        other.infoCourse == infoCourse &&
        other.parts == parts &&
        other.exercises == exercises;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        avgStar.hashCode ^
        totalPrice.hashCode ^
        salePrice.hashCode ^
        totalUser.hashCode ^
        imageHeader.hashCode ^
        slugName.hashCode ^
        courseCode.hashCode ^
        term.hashCode ^
        contentCourse.hashCode ^
        level.hashCode ^
        userId.hashCode ^
        userName.hashCode ^
        categoryId.hashCode ^
        categoryName.hashCode ^
        infoCourse.hashCode ^
        parts.hashCode ^
        exercises.hashCode;
  }

  @override
  String toString() {
    return 'CourseDetail(id: $id, title: $title, slugName: $slugName, parts: ${parts.length})';
  }
}
