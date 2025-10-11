import 'package:flutter/foundation.dart';
import '../models/notification_response.dart';
import '../services/notification_service.dart';

class NotificationProvider with ChangeNotifier {
  final NotificationService _notificationService = NotificationService();

  List<NotificationResponse> _notifications = [];
  List<NotificationResponse> get notifications => _notifications;

  // Unread count
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  // Loading states
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Error state
  String? _error;
  String? get error => _error;

  /// Load notifications for a user
  Future<void> loadNotifications(int userId, {bool refresh = false}) async {
    if (refresh) {
      _notifications.clear();
    }

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _notifications = await _notificationService.getNotificationsByUserId(userId);
      
      // Sort by createdAt descending (newest first)
      _notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      _error = null;
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) {
        print('Error loading notifications: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Mark notification as read
  Future<void> markAsRead(int notificationId) async {
    try {
      await _notificationService.markAsRead(notificationId);
      
      // Update local state
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        final notification = _notifications[index];
        _notifications[index] = NotificationResponse(
          id: notification.id,
          userId: notification.userId,
          title: notification.title,
          message: notification.message,
          type: notification.type,
          isRead: true, // Mark as read
          createdAt: notification.createdAt,
          relatedId: notification.relatedId,
        );
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error marking notification as read: $e');
      }
    }
  }

  /// Mark all as read
  Future<void> markAllAsRead(int userId) async {
    final unreadNotifications = _notifications.where((n) => !n.isRead).toList();
    
    for (var notification in unreadNotifications) {
      await markAsRead(notification.id);
    }
  }

  /// Clear all notifications
  void clear() {
    _notifications.clear();
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}
