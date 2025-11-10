import 'package:flutter/material.dart';

class CourseUiConstants {
  CourseUiConstants._();

  // Spacing
  static const double horizontalMargin = 34.0;
  static const double cardPadding = 20.0;
  static const double sectionSpacing = 16.0;

  // Colors
  static const Color primary = Color(0xFF0961F5);
  static const Color textSecondary = Color(0xFF666666);
  static const Color surface = Colors.white;

  // Shadows
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];
}




