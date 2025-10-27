import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/order_summary.dart';
import '../../domain/usecases/get_order_by_id_usecase.dart';
import '../../domain/constants/order_constants.dart';

/// ViewModel for Payment feature
class PaymentViewModel extends ChangeNotifier {
  final GetOrderByIdUseCase _getOrderByIdUseCase;
  final SharedPreferences _sharedPreferences;

  PaymentViewModel({
    required GetOrderByIdUseCase getOrderByIdUseCase,
    required SharedPreferences sharedPreferences,
  })  : _getOrderByIdUseCase = getOrderByIdUseCase,
        _sharedPreferences = sharedPreferences;

  // State
  OrderSummary? _order;
  String? _qrCodeUrl;
  bool _isLoading = true;
  String? _errorMessage;
  StompClient? _stompClient;
  String? _orderDescription;

  // Getters
  OrderSummary? get order => _order;
  String? get qrCodeUrl => _qrCodeUrl;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Initialize payment view model
  Future<void> initialize({
    required String orderId,
    String? initialQrCodeUrl,
    String? description,
  }) async {
    _qrCodeUrl = initialQrCodeUrl;
    _orderDescription = description;

    await loadOrderDetails(orderId);

    // Connect to WebSocket if description is available
    if (_orderDescription != null && _orderDescription!.isNotEmpty) {
      connectWebSocket(_orderDescription!);
    } else if (_order?.description != null && _order!.description!.isNotEmpty) {
      connectWebSocket(_order!.description!);
    }
  }

  /// Load order details
  Future<void> loadOrderDetails(String orderId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final params = GetOrderByIdParams(orderId);
      final result = await _getOrderByIdUseCase(params);

      result.fold(
        (failure) {
          _errorMessage = failure.message;
        },
        (orderSummary) {
          _order = orderSummary;

          // Use QR from backend if available, otherwise keep the one from initialization
          if (orderSummary.qrCodeUrl != null &&
              orderSummary.qrCodeUrl!.isNotEmpty) {
            _qrCodeUrl = orderSummary.qrCodeUrl;
          }
        },
      );
    } catch (e) {
      _errorMessage = 'Failed to load order: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Connect to WebSocket for payment notifications
  void connectWebSocket(String description) {
    // Use correct baseUrl from AppConstants
    final baseUrl = AppConstants.baseUrl;

    _stompClient = StompClient(
      config: StompConfig(
        url: '$baseUrl${OrderConstants.wsEndpoint}',
        onConnect: (StompFrame frame) {
          // Subscribe to payment topic for this specific order
          _stompClient?.subscribe(
            destination: '${OrderConstants.paymentTopicPrefix}$description',
            callback: (StompFrame frame) {
              if (frame.body != null) {
                handlePaymentNotification(frame.body!);
              }
            },
          );
        },
        onWebSocketError: (dynamic error) {
          // Handle WebSocket errors silently or log to monitoring service
          print('WebSocket error: $error');
        },
        onStompError: (StompFrame frame) {
          // Handle STOMP errors silently or log to monitoring service
          print('STOMP error: ${frame.body}');
        },
        onDisconnect: (StompFrame frame) {
          // Handle disconnection silently or log to monitoring service
          print('WebSocket disconnected');
        },
        // Enable SockJS for compatibility with Spring Boot backend
        useSockJS: true,
        // Connection timeout
        connectionTimeout: OrderConstants.wsConnectionTimeout,
        // Reconnect settings
        reconnectDelay: OrderConstants.wsReconnectDelay,
      ),
    );

    _stompClient?.activate();
  }

  /// Disconnect WebSocket
  void disconnectWebSocket() {
    _stompClient?.deactivate();
    _stompClient = null;
  }

  /// Handle payment notification from WebSocket
  void handlePaymentNotification(String status) {
    if (status == OrderConstants.wsSuccessStatus) {
      // Payment successful
      notifyListeners(); // Notify UI to show success dialog
    } else if (status == OrderConstants.wsErrorPriceStatus) {
      // Price mismatch
      _errorMessage = OrderConstants.paymentErrorPrice;
      notifyListeners();
    }
  }

  /// Get course IDs from order for enrollment refresh
  List<String> getCourseIdsFromOrder() {
    if (_order == null) return [];

    final courseIds = <String>[];

    // Try courses first (new backend format)
    if (_order!.courses != null && _order!.courses!.isNotEmpty) {
      for (final course in _order!.courses!) {
        if (course.courseId != null && course.courseId!.isNotEmpty) {
          courseIds.add(course.courseId!);
        }
      }
    }
    // Fallback to items (old format)
    else if (_order!.items != null && _order!.items!.isNotEmpty) {
      for (final item in _order!.items!) {
        if (item.courseId != null && item.courseId!.isNotEmpty) {
          courseIds.add(item.courseId!);
        }
      }
    }

    return courseIds;
  }

  /// Get user ID from JWT token
  Future<String?> getUserIdFromToken() async {
    try {
      final token = _sharedPreferences.getString(AppConstants.keyAccessToken);

      if (token == null || token.isEmpty) {
        return null;
      }

      // Decode JWT token (format: header.payload.signature)
      final parts = token.split('.');
      if (parts.length != 3) {
        return null;
      }

      // Decode payload (base64)
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final Map<String, dynamic> payloadMap = jsonDecode(decoded);

      // JWT thường có field 'sub' (subject) hoặc 'userId'
      final userId = payloadMap['sub'] ?? payloadMap['userId'] ?? payloadMap['id'];

      return userId?.toString();
    } catch (e) {
      print('Error getting user ID from token: $e');
      return null;
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    disconnectWebSocket();
    super.dispose();
  }
}
