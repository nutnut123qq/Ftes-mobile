import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ftes/utils/text_styles.dart';
import 'package:ftes/services/order_service.dart';
import 'package:ftes/models/order_response.dart';
import 'package:ftes/providers/enrollment_provider.dart';
import 'package:ftes/providers/course_provider.dart';
import 'package:ftes/providers/auth_provider.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:ftes/utils/api_constants.dart';
import 'package:ftes/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PaymentScreen extends StatefulWidget {
  final String orderId;
  final String? qrCodeUrl;
  final String? description;
  
  const PaymentScreen({
    super.key,
    required this.orderId,
    this.qrCodeUrl,
    this.description,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final OrderService _orderService = OrderService();
  OrderViewResponse? _order;
  bool _isLoading = true;
  String? _error;
  String? _qrCodeUrl;
  StompClient? _stompClient;

  @override
  void initState() {
    super.initState();
    _qrCodeUrl = widget.qrCodeUrl;
    _fetchOrderDetails();
  }

  @override
  void dispose() {
    _disconnectWebSocket();
    super.dispose();
  }

  void _connectWebSocket(String description) {
    // For SockJS, use HTTP URL instead of WS URL
    final baseUrl = ApiConstants.baseUrl;
    
    _stompClient = StompClient(
      config: StompConfig(
        url: '$baseUrl/ws',
        onConnect: (StompFrame frame) {
          // Subscribe to payment topic for this specific order
          _stompClient?.subscribe(
            destination: '/topic/payments/$description',
            callback: (StompFrame frame) {
              if (frame.body != null) {
                _handlePaymentNotification(frame.body!);
              }
            },
          );
        },
        onWebSocketError: (dynamic error) {
          // Handle WebSocket errors silently or log to monitoring service
        },
        onStompError: (StompFrame frame) {
          // Handle STOMP errors silently or log to monitoring service
        },
        onDisconnect: (StompFrame frame) {
          // Handle disconnection silently or log to monitoring service
        },
        // Enable SockJS for compatibility with Spring Boot backend
        useSockJS: true,
        // Connection timeout
        connectionTimeout: const Duration(seconds: 10),
        // Reconnect settings
        reconnectDelay: const Duration(seconds: 5),
      ),
    );
    
    _stompClient?.activate();
  }

  void _disconnectWebSocket() {
    _stompClient?.deactivate();
    _stompClient = null;
  }

  Future<void> _refreshUserCoursesAfterPayment() async {
    try {
      final courseProvider = Provider.of<CourseProvider>(context, listen: false);
      
      // Thử lấy userId từ authProvider trước
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      String? userId = authProvider.currentUser?.id;
      
      // Nếu không có, thử lấy từ JWT token
      if (userId == null || userId.isEmpty) {
        userId = await _getUserIdFromToken();
      }
      
      if (userId != null && userId.isNotEmpty) {
        await courseProvider.fetchUserCourses(userId);
      }
    } catch (e) {
      // Handle error silently
    }
  }
  
  Future<String?> _getUserIdFromToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      
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
      return null;
    }
  }

  void _handlePaymentNotification(String status) {
    if (!mounted) {
      return;
    }
    
    if (status == 'success') {
      // Payment successful - refresh enrollment status for all courses in order
      final enrollmentProvider = Provider.of<EnrollmentProvider>(context, listen: false);
      
      // Try courses first (new backend format), fallback to items (old format)
      if (_order?.courses != null && _order!.courses!.isNotEmpty) {
        for (final course in _order!.courses!) {
          if (course.courseId != null && course.courseId!.isNotEmpty) {
            enrollmentProvider.refreshEnrollmentStatus(course.courseId!);
          }
        }
      } else if (_order?.items != null && _order!.items!.isNotEmpty) {
        for (final item in _order!.items!) {
          if (item.courseId != null && item.courseId!.isNotEmpty) {
            enrollmentProvider.refreshEnrollmentStatus(item.courseId!);
          }
        }
      }
      
      // Refresh user courses list for My Courses screen
      _refreshUserCoursesAfterPayment();
      
      // Show success dialog then navigate to My Courses
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFF0961F5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Thanh toán thành công!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF202244),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Bạn đã đăng ký khóa học thành công',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF545454),
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Close dialog and navigate to My Courses
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppConstants.routeMyCourses,
                    (route) => route.settings.name == AppConstants.routeHome,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0961F5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Xem khóa học của tôi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (status == 'error_price') {
      // Price mismatch - show error dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Lỗi thanh toán'),
          content: const Text('Số tiền thanh toán không khớp. Bạn đã được cộng điểm bồi thường.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Go back to cart
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _fetchOrderDetails() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      
      final order = await _orderService.getOrderById(widget.orderId);
      
      // Use QR from backend if available, otherwise keep the one from navigation
      if (order.qrCode != null && order.qrCode!.isNotEmpty) {
        _qrCodeUrl = order.qrCode;
      }
      
      setState(() {
        _order = order;
        _isLoading = false;
      });
      
      // Connect to WebSocket to listen for payment notifications
      if (widget.description != null && widget.description!.isNotEmpty) {
        _connectWebSocket(widget.description!);
      } else if (order.description != null && order.description!.isNotEmpty) {
        _connectWebSocket(order.description!);
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // TODO: Remove auto-cancel in production
        // For development: don't cancel order when backing out
        // This allows testing with webhook after leaving screen
        
        // Uncomment below to enable auto-cancel:
        /*
        try {
          await _orderService.cancelPendingOrders();
        } catch (_) {}
        // Làm tươi trạng thái enroll để tránh cache cũ
        if (_order != null && _order!.items != null) {
          final enrollmentProvider = Provider.of<EnrollmentProvider>(context, listen: false);
          for (final item in _order!.items!) {
            if (item.courseId != null) {
              await enrollmentProvider.refreshEnrollmentStatus(item.courseId!);
            }
          }
        }
        */
        
        return true;
      },
      child: Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? _buildError()
                      : _buildQRCodeSection(),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Không thể tải thông tin thanh toán',
              style: AppTextStyles.body1.copyWith(
                color: const Color(0xFF202244),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _error ?? 'Lỗi không xác định',
              style: AppTextStyles.body1.copyWith(
                color: const Color(0xFF545454),
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _fetchOrderDetails,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(2, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(35, 25, 35, 20),
        child: Row(
          children: [
            // Back Button
            GestureDetector(
              onTap: () {
                // TODO: Remove in production - for dev testing only
                // Don't cancel order when manually clicking back button
                /*
                () async {
                  // Khi nhấn nút back trong UI, hủy đơn pending và làm tươi trạng thái enroll
                  try {
                    await _orderService.cancelPendingOrders();
                  } catch (_) {}
                  if (_order != null && _order!.items != null) {
                    final enrollmentProvider = Provider.of<EnrollmentProvider>(context, listen: false);
                    for (final item in _order!.items!) {
                      if (item.courseId != null) {
                        await enrollmentProvider.refreshEnrollmentStatus(item.courseId!);
                      }
                    }
                  }
                  if (mounted) {
                    Navigator.pop(context);
                  }
                }();
                */
                
                // For dev: just go back without cancelling
                Navigator.pop(context);
              },
              child: Container(
                width: 26,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Color(0xFF202244),
                  size: 16,
                ),
              ),
            ),
            
            const SizedBox(width: 20),
            
            // Title
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0961F5),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Thanh toán',
                    style: AppTextStyles.heading1.copyWith(
                      color: const Color(0xFF202244),
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQRCodeSection() {
    final order = _order;
    if (order == null) {
      return const Center(child: Text('Không tìm thấy thông tin đơn hàng'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(35, 30, 35, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Quét mã QR để thanh toán',
            style: AppTextStyles.body1.copyWith(
              color: const Color(0xFF202244),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // QR Code Container
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // QR Code Image - Display real QR from backend or placeholder
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFE8F1FF),
                      width: 2,
                    ),
                  ),
                  child: (_qrCodeUrl != null && _qrCodeUrl!.isNotEmpty)
                      ? Image.network(
                          _qrCodeUrl!,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.qr_code,
                                  size: 80,
                                  color: Color(0xFF0961F5),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Không thể tải mã QR',
                                  style: AppTextStyles.body1.copyWith(
                                    color: const Color(0xFF545454),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            );
                          },
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.qr_code,
                              size: 80,
                              color: Color(0xFF0961F5),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Mã QR',
                              style: AppTextStyles.body1.copyWith(
                                color: const Color(0xFF0961F5),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
                
                const SizedBox(height: 20),
                
                // Instructions
                Text(
                  'Quét mã QR bằng ứng dụng ngân hàng để hoàn tất thanh toán',
                  style: AppTextStyles.body1.copyWith(
                    color: const Color(0xFF545454),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 12),
                
                Text(
                  'Sau khi thanh toán thành công, đơn hàng sẽ được xử lý tự động',
                  style: AppTextStyles.body1.copyWith(
                    color: const Color(0xFF545454),
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
