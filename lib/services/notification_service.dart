import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/notification_response.dart';
import 'http_client.dart';

class NotificationService {
  final HttpClient _httpClient = HttpClient();

  /// Get notifications by user ID
  /// GET /api/notification/{userId}
  Future<List<NotificationResponse>> getNotificationsByUserId(int userId) async {
    try {
      final response = await _httpClient.get(
        '/api/notification/$userId',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => NotificationResponse.fromJson(json)).toList();
      } else {
        throw HttpException(
          'Failed to get notifications: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error getting notifications: $e');
    }
  }

  /// Mark notification as read (if backend supports)
  /// This might need to be added to backend
  Future<void> markAsRead(int notificationId) async {
    try {
      final response = await _httpClient.put(
        '/api/notification/$notificationId/read',
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw HttpException(
          'Failed to mark notification as read: ${response.statusCode}',
        );
      }
    } catch (e) {
      // Silently fail if endpoint doesn't exist
      if (kDebugMode) {
        print('Error marking notification as read: $e');
      }
    }
  }
}
