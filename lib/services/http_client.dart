import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api_constants.dart';

class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  factory HttpClient() => _instance;
  HttpClient._internal();

  late http.Client _client;
  String? _accessToken;

  void initialize() {
    _client = http.Client();
  }

  void dispose() {
    _client.close();
  }

  Future<void> setAccessToken(String token) async {
    _accessToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  Future<String?> getAccessToken() async {
    if (_accessToken != null) return _accessToken;
    
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('access_token');
    return _accessToken;
  }

  Future<void> clearTokens() async {
    _accessToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }

  Map<String, String> _getHeaders({Map<String, String>? additionalHeaders}) {
    final headers = Map<String, String>.from(ApiConstants.defaultHeaders);
    
    if (_accessToken != null) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }
    
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }
    
    return headers;
  }

  Future<http.Response> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final uriWithQuery = queryParameters != null 
          ? uri.replace(queryParameters: queryParameters.map((key, value) => MapEntry(key, value.toString())))
          : uri;

      final response = await _client
          .get(
            uriWithQuery,
            headers: _getHeaders(additionalHeaders: headers),
          )
          .timeout(ApiConstants.connectTimeout);

      return response;
    } catch (e) {
      throw HttpException('GET request failed: $e');
    }
  }

  Future<http.Response> post(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final uriWithQuery = queryParameters != null 
          ? uri.replace(queryParameters: queryParameters.map((key, value) => MapEntry(key, value.toString())))
          : uri;

      final response = await _client
          .post(
            uriWithQuery,
            headers: _getHeaders(additionalHeaders: headers),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConstants.connectTimeout);

      return response;
    } catch (e) {
      throw HttpException('POST request failed: $e');
    }
  }

  Future<http.Response> put(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final uriWithQuery = queryParameters != null 
          ? uri.replace(queryParameters: queryParameters.map((key, value) => MapEntry(key, value.toString())))
          : uri;

      final response = await _client
          .put(
            uriWithQuery,
            headers: _getHeaders(additionalHeaders: headers),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConstants.connectTimeout);

      return response;
    } catch (e) {
      throw HttpException('PUT request failed: $e');
    }
  }

  Future<http.Response> delete(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final uriWithQuery = queryParameters != null 
          ? uri.replace(queryParameters: queryParameters.map((key, value) => MapEntry(key, value.toString())))
          : uri;

      final response = await _client
          .delete(
            uriWithQuery,
            headers: _getHeaders(additionalHeaders: headers),
          )
          .timeout(ApiConstants.connectTimeout);

      return response;
    } catch (e) {
      throw HttpException('DELETE request failed: $e');
    }
  }

  bool _isSuccessResponse(int statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }

  void _handleErrorResponse(http.Response response) {
    if (!_isSuccessResponse(response.statusCode)) {
      throw HttpException(
        'HTTP ${response.statusCode}: ${response.body}',
      );
    }
  }
}
