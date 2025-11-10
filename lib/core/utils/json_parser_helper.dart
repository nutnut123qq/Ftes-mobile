import 'package:ftes/features/blog/data/models/blog_model.dart';
import 'package:ftes/features/blog/data/models/blog_category_model.dart';

/// Top-level function for parsing blog list JSON in compute isolate
/// This function must be top-level or static to work with compute()
List<BlogModel> parseBlogListJson(List<dynamic> jsonList) {
  return jsonList
      .map((json) => BlogModel.fromJson(json as Map<String, dynamic>))
      .toList();
}

/// Top-level function for parsing blog category list JSON in compute isolate
/// This function must be top-level or static to work with compute()
List<BlogCategoryModel> parseBlogCategoryListJson(List<dynamic> jsonList) {
  return jsonList
      .map((json) => BlogCategoryModel.fromJson(json as Map<String, dynamic>))
      .toList();
}

/// Data class for passing blog parsing parameters to compute isolate
class BlogParseParams {
  final List<dynamic> jsonList;
  
  const BlogParseParams(this.jsonList);
}

/// Top-level function with parameter wrapper for compute()
List<BlogModel> parseBlogListWithParams(BlogParseParams params) {
  return parseBlogListJson(params.jsonList);
}

/// Data class for passing blog category parsing parameters to compute isolate
class BlogCategoryParseParams {
  final List<dynamic> jsonList;
  
  const BlogCategoryParseParams(this.jsonList);
}

/// Top-level function with parameter wrapper for compute()
List<BlogCategoryModel> parseBlogCategoryListWithParams(BlogCategoryParseParams params) {
  return parseBlogCategoryListJson(params.jsonList);
}

/// Top-level function for parsing single blog JSON in compute isolate
/// This function must be top-level or static to work with compute()
BlogModel parseBlogModelJson(Map<String, dynamic> json) {
  return BlogModel.fromJson(json);
}


