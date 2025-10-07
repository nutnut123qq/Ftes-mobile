import 'dart:convert';
import '../models/blog_response.dart';
import '../utils/api_constants.dart';
import 'http_client.dart';

class BlogService {
  static final BlogService _instance = BlogService._internal();
  factory BlogService() => _instance;
  BlogService._internal() {
    _httpClient.initialize();
  }

  final HttpClient _httpClient = HttpClient();

  /// Initialize the service
  void initialize() {
    _httpClient.initialize();
  }

  /// Dispose the service
  void dispose() {
    _httpClient.dispose();
  }

  /// Get all blogs with pagination
  Future<PagingBlogResponse> getAllBlogs({
    int pageNumber = 1,
    int pageSize = 10,
    String sortField = 'createdAt',
    String sortOrder = 'desc',
    String? searchText,
  }) async {
    try {
      final queryParams = {
        'pageNumber': pageNumber.toString(),
        'pageSize': pageSize.toString(),
        'sortField': sortField,
        'sortOrder': sortOrder,
      };
      
      if (searchText != null && searchText.isNotEmpty) {
        queryParams['searchText'] = searchText;
      }

      final response = await _httpClient.get(
        ApiConstants.blogsEndpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PagingBlogResponse.fromJson(data['result']);
      } else {
        throw Exception('Failed to load blogs: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Get all blogs error: $e');
    }
  }

  /// Get blog detail by slug name
  Future<BlogResponse> getBlogBySlugName(String slugName) async {
    try {
      final response = await _httpClient.get(
        '${ApiConstants.blogsEndpoint}/$slugName',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return BlogResponse.fromJson(data['result']);
      } else {
        throw Exception('Failed to load blog detail: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Get blog by slug name error: $e');
    }
  }

  /// Get blogs by category
  Future<PagingBlogResponse> getBlogsByCategory({
    required String category,
    int pageNumber = 1,
    int pageSize = 10,
    String sortField = 'createdAt',
    String sortOrder = 'desc',
  }) async {
    try {
      final queryParams = {
        'pageNumber': pageNumber.toString(),
        'pageSize': pageSize.toString(),
        'sortField': sortField,
        'sortOrder': sortOrder,
        'category': category,
      };

      final response = await _httpClient.get(
        ApiConstants.blogsByCategoryEndpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PagingBlogResponse.fromJson(data['result']);
      } else {
        throw Exception('Failed to load blogs by category: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Get blogs by category error: $e');
    }
  }

  /// Search blogs
  Future<PagingBlogResponse> searchBlogs({
    int pageNumber = 1,
    int pageSize = 10,
    String sortField = 'createdAt',
    String sortOrder = 'desc',
    String? title,
    String? content,
    String? category,
  }) async {
    try {
      final queryParams = {
        'pageNumber': pageNumber.toString(),
        'pageSize': pageSize.toString(),
        'sortField': sortField,
        'sortOrder': sortOrder,
      };
      
      if (title != null && title.isNotEmpty) {
        queryParams['title'] = title;
      }
      if (content != null && content.isNotEmpty) {
        queryParams['content'] = content;
      }
      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }

      final response = await _httpClient.get(
        ApiConstants.blogsSearchEndpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PagingBlogResponse.fromJson(data['result']);
      } else {
        throw Exception('Failed to search blogs: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Search blogs error: $e');
    }
  }

  /// Get 5 interactive blogs by category
  Future<List<BlogResponse>> getInteractiveBlogs(String category) async {
    try {
      final response = await _httpClient.get(
        '${ApiConstants.blogsInteractiveEndpoint}/$category',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> blogsJson = data['result'];
        return blogsJson.map((json) => BlogResponse.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load interactive blogs: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Get interactive blogs error: $e');
    }
  }
}
