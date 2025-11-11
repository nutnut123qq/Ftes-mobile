import '../models/profile_model.dart';

/// Top-level function for parsing profile JSON in compute isolate
/// This function must be top-level or static to work with compute()
ProfileModel parseProfileJson(Map<String, dynamic> json) {
  return ProfileModel.fromJson(json);
}

/// Top-level function for parsing profile list JSON in compute isolate
/// This function must be top-level or static to work with compute()
List<ProfileModel> parseProfileListJson(List<dynamic> jsonList) {
  return jsonList
      .map((json) => ProfileModel.fromJson(json as Map<String, dynamic>))
      .toList();
}

