import 'package:intl/intl.dart';

class NumberUtils {
  static final NumberFormat _formatter = NumberFormat('#,##0', 'vi_VN');
  
  /// Format number with Vietnamese thousand separator
  static String formatNumber(int? number) {
    if (number == null) return '0';
    return _formatter.format(number);
  }
  
  /// Format points with suffix
  static String formatPoints(int? points) {
    if (points == null || points == 0) return '0 điểm';
    
    if (points >= 1000000) {
      final millions = points / 1000000;
      return '${millions.toStringAsFixed(1)}M điểm';
    } else if (points >= 1000) {
      final thousands = points / 1000;
      return '${thousands.toStringAsFixed(1)}K điểm';
    }
    
    return '$points điểm';
  }
  
  /// Format currency (VND)
  static String formatCurrency(int? amount) {
    if (amount == null) return '0 VND';
    return '${_formatter.format(amount)} VND';
  }
  
  /// Format percentage
  static String formatPercentage(double? percentage) {
    if (percentage == null) return '0%';
    return '${percentage.toStringAsFixed(1)}%';
  }
}

class DateUtils {
  /// Format date to Vietnamese format
  static String formatDate(String? dateStr) {
    if (dateStr == null) return '';
    
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }
  
  /// Format date to relative time (e.g., "2 ngày trước")
  static String formatRelativeTime(String? dateStr) {
    if (dateStr == null) return '';
    
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final difference = now.difference(date);
      
      if (difference.inDays > 0) {
        return '${difference.inDays} ngày trước';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} giờ trước';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} phút trước';
      } else {
        return 'Vừa xong';
      }
    } catch (e) {
      return dateStr;
    }
  }
  
  /// Format date and time
  static String formatDateTime(String? dateStr) {
    if (dateStr == null) return '';
    
    try {
      final date = DateTime.parse(dateStr);
      return '${formatDate(dateStr)} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateStr;
    }
  }
}