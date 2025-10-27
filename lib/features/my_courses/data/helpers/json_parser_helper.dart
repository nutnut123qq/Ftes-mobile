import '../models/my_course_model.dart';

/// Top-level function for parsing MyCourse list JSON in compute isolate
/// This function must be top-level or static to work with compute()
List<MyCourseModel> parseMyCourseListJson(List<dynamic> jsonList) {
  return jsonList
      .map((json) => MyCourseModel.fromJson(json as Map<String, dynamic>))
      .toList();
}

/// Helper function to count total courses
/// Used to determine if compute isolate should be used
int countCourses(List<dynamic> coursesList) {
  return coursesList.length;
}

/// Data class for passing course list parsing parameters to compute isolate
class MyCourseListParseParams {
  final List<dynamic> jsonList;
  
  const MyCourseListParseParams(this.jsonList);
}

/// Top-level function with parameter wrapper for compute()
List<MyCourseModel> parseMyCourseListWithParams(MyCourseListParseParams params) {
  return parseMyCourseListJson(params.jsonList);
}

