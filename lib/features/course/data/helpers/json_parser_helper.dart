import '../models/course_detail_model.dart';
import '../models/part_model.dart';
import '../models/lesson_model.dart';
import '../models/profile_model.dart';

/// Top-level function for parsing CourseDetail JSON in compute isolate
/// This function must be top-level or static to work with compute()
CourseDetailModel parseCourseDetailJson(Map<String, dynamic> json) {
  return CourseDetailModel.fromJson(json);
}

/// Top-level function for parsing Part list JSON
/// Used when parts are received separately
List<PartModel> parsePartListJson(List<dynamic> jsonList) {
  return jsonList
      .map((json) => PartModel.fromJson(json as Map<String, dynamic>))
      .toList();
}

/// Top-level function for parsing Lesson list JSON
/// Used when lessons are received separately
List<LessonModel> parseLessonListJson(List<dynamic> jsonList) {
  return jsonList
      .map((json) => LessonModel.fromJson(json as Map<String, dynamic>))
      .toList();
}

/// Top-level function for parsing Profile JSON
/// Note: Profile is lightweight, compute() may not be needed
/// but keeping consistent interface for flexibility
ProfileModel parseProfileJson(Map<String, dynamic> json) {
  return ProfileModel.fromJson(json);
}

/// Helper function to calculate total lessons count
/// Used to determine if compute isolate should be used
int calculateTotalLessons(Map<String, dynamic> courseDetailJson) {
  final parts = courseDetailJson['parts'] as List<dynamic>?;
  if (parts == null || parts.isEmpty) return 0;
  
  int total = 0;
  for (final part in parts) {
    final lessons = (part as Map<String, dynamic>)['lessons'] as List<dynamic>?;
    if (lessons != null) {
      total += lessons.length;
    }
  }
  return total;
}

/// Helper function to count parts
int countParts(Map<String, dynamic> courseDetailJson) {
  final parts = courseDetailJson['parts'] as List<dynamic>?;
  return parts?.length ?? 0;
}

/// Data class for passing course detail parsing parameters to compute isolate
class CourseDetailParseParams {
  final Map<String, dynamic> json;
  
  const CourseDetailParseParams(this.json);
}

/// Top-level function with parameter wrapper for compute()
CourseDetailModel parseCourseDetailWithParams(CourseDetailParseParams params) {
  return parseCourseDetailJson(params.json);
}

/// Data class for passing profile parsing parameters to compute isolate
class ProfileParseParams {
  final Map<String, dynamic> json;
  
  const ProfileParseParams(this.json);
}

/// Top-level function with parameter wrapper for compute()
ProfileModel parseProfileWithParams(ProfileParseParams params) {
  return parseProfileJson(params.json);
}

