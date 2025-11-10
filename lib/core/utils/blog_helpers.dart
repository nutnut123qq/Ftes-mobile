import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../../features/blog/domain/constants/blog_constants.dart';

/// Helper functions for blog operations
/// Heavy computations are moved to isolate to avoid blocking UI thread
class BlogHelpers {
  /// Strip HTML tags from text (runs in isolate)
  static Future<String> stripHtmlTagsAsync(String htmlText) async {
    if (htmlText.isEmpty) return '';
    
    // Use compute for heavy regex operations
    return await compute(_stripHtmlTagsIsolate, htmlText);
  }

  /// Format date (runs in isolate for consistency)
  static Future<String> formatDateAsync(DateTime? date) async {
    if (date == null) return BlogConstants.unknownDate;
    
    return await compute(_formatDateIsolate, date);
  }

  /// Calculate read time (runs in isolate)
  static Future<String> calculateReadTimeAsync(String content) async {
    if (content.isEmpty) return '1 ${BlogConstants.readTimeLabel}';
    
    return await compute(_calculateReadTimeIsolate, content);
  }

  // Isolate functions (must be top-level or static)
  static String _stripHtmlTagsIsolate(String htmlText) {
    final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '').trim();
  }

  static String _formatDateIsolate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return BlogConstants.justNow;
        }
        return '${difference.inMinutes} ${BlogConstants.minutesAgo}';
      }
      return '${difference.inHours} ${BlogConstants.hoursAgo}';
    } else if (difference.inDays == 1) {
      return BlogConstants.yesterday;
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${BlogConstants.daysAgo}';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }

  static String _calculateReadTimeIsolate(String content) {
    // Strip HTML first
    final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    final plainText = content.replaceAll(exp, ' ').trim();
    
    if (plainText.isEmpty) return '1 ${BlogConstants.readTimeLabel}';
    
    final words = plainText.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
    final minutes = (words / BlogConstants.averageReadingSpeed).ceil();
    return '$minutes ${BlogConstants.readTimeLabel}';
  }
}

