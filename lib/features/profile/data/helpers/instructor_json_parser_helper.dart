import '../models/instructor_course_model.dart';

/// Top-level function for parsing instructor courses JSON in compute isolate
/// This function must be top-level or static to work with compute()
List<InstructorCourseModel> parseInstructorCoursesJson(List<dynamic> jsonList) {
  return jsonList
      .map((json) => InstructorCourseModel.fromJson(json as Map<String, dynamic>))
      .toList();
}
