import 'dart:convert';

import '../utils/api_constants.dart';
import 'http_client.dart';

class AppDataService {
  final HttpClient _http = HttpClient();

  AppDataService() {
    _http.initialize();
  }

  Future<Map<String, dynamic>> fetchMyInfo() async {
    final resp = await _http.get(ApiConstants.myInfoEndpoint);
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      return jsonDecode(resp.body) as Map<String, dynamic>;
    }
    throw Exception('fetchMyInfo failed: ${resp.statusCode} ${resp.body}');
  }

  Future<Map<String, dynamic>> introspectToken({required String token}) async {
    final body = {'token': token};
    final resp = await _http.post(ApiConstants.introspectEndpoint, body: body);
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      return jsonDecode(resp.body) as Map<String, dynamic>;
    }
    throw Exception('introspectToken failed: ${resp.statusCode} ${resp.body}');
  }

  Future<List<dynamic>> fetchBanners() async {
    final resp = await _http.get(ApiConstants.bannerEndpoint);
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final data = jsonDecode(resp.body);
      if (data is List) return data;
      if (data is Map && data['result'] is List) return data['result'] as List<dynamic>;
      return [data];
    }
    throw Exception('fetchBanners failed: ${resp.statusCode} ${resp.body}');
  }

  Future<List<dynamic>> fetchFeaturedCourses() async {
    final resp = await _http.get(ApiConstants.featuredCoursesEndpoint);
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final data = jsonDecode(resp.body);
      if (data is List) return data;
      if (data is Map && data['result'] is List) return data['result'] as List<dynamic>;
      return [data];
    }
    throw Exception('fetchFeaturedCourses failed: ${resp.statusCode} ${resp.body}');
  }
}
