import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../utils/api_constants.dart';
import 'http_client.dart';

/// Service để xử lý upload images
class ImageService {
  static final ImageService _instance = ImageService._internal();
  factory ImageService() => _instance;
  ImageService._internal();

  final HttpClient _httpClient = HttpClient();

  void initialize() {
    _httpClient.initialize();
  }

  void dispose() {
    _httpClient.dispose();
  }

  /// Upload image
  Future<String> uploadImage(File imageFile) async {
    try {
      final token = await _httpClient.getAccessToken();
      if (token == null) {
        throw Exception('No access token available');
      }

      final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.uploadImageEndpoint}');
      final request = http.MultipartRequest('POST', uri);
      
      // Add authorization header
      request.headers['Authorization'] = 'Bearer $token';
      
      // Add image file
      request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));
      
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['result']['url'] ?? data['result']['imageUrl'] ?? '';
      } else {
        throw Exception('Upload image failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Upload image error: $e');
    }
  }
}
