/// Temporary AppDataService for backward compatibility
/// TODO: Migrate to Clean Architecture
class AppDataService {
  /// Placeholder methods for backward compatibility
  Future<Map<String, dynamic>> fetchMyInfo() async {
    // TODO: Implement with new Clean Architecture
    return {};
  }

  Future<Map<String, dynamic>> introspectToken({required String token}) async {
    // TODO: Implement with new Clean Architecture
    return {};
  }

  Future<List<dynamic>> fetchBanners() async {
    // TODO: Implement with new Clean Architecture
    return [];
  }

  Future<List<dynamic>> fetchFeaturedCourses() async {
    // TODO: Implement with new Clean Architecture
    return [];
  }
}
