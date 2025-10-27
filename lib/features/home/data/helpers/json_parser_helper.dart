import '../models/course_model.dart';
import '../models/banner_model.dart';

/// Top-level function for parsing course list JSON in compute isolate
/// This function must be top-level or static to work with compute()
List<CourseModel> parseCourseListJson(List<dynamic> jsonList) {
  return jsonList
      .map((json) => CourseModel.fromJson(json as Map<String, dynamic>))
      .toList();
}

/// Top-level function for parsing banner list JSON
/// Note: Banners typically <20 items, so compute() may not be needed
/// but keeping consistent interface for flexibility
List<BannerModel> parseBannerListJson(List<dynamic> jsonList) {
  return jsonList
      .map((json) => BannerModel.fromJson(json as Map<String, dynamic>))
      .toList();
}

/// Data class for passing course parsing parameters to compute isolate
class CourseParseParams {
  final List<dynamic> jsonList;
  
  const CourseParseParams(this.jsonList);
}

/// Top-level function with parameter wrapper for compute()
List<CourseModel> parseCourseListWithParams(CourseParseParams params) {
  return parseCourseListJson(params.jsonList);
}

