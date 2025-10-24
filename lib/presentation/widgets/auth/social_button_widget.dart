import 'package:flutter/material.dart';

/// Reusable social button widget for authentication
class SocialButtonWidget extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const SocialButtonWidget({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: const Color(0xFF545454),
          size: 24,
        ),
      ),
    );
  }
}
