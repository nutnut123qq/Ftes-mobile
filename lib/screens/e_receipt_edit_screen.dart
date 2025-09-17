import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';

class EReceiptEditScreen extends StatelessWidget {
  const EReceiptEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Share Option
          _buildMenuItem(
            icon: Icons.share,
            label: 'Share',
            onTap: () {
              Navigator.pop(context);
              // Share functionality will be implemented in future updates
            },
          ),
          const Divider(height: 1, color: Color(0xFFE2E6EA)),
          // Download Option
          _buildMenuItem(
            icon: Icons.download,
            label: 'Download',
            onTap: () {
              Navigator.pop(context);
              // Download functionality will be implemented in future updates
            },
          ),
          const Divider(height: 1, color: Color(0xFFE2E6EA)),
          // Print Option
          _buildMenuItem(
            icon: Icons.print,
            label: 'Print',
            onTap: () {
              Navigator.pop(context);
              // Print functionality will be implemented in future updates
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: const Color(0xFF545454),
            ),
            const SizedBox(width: 15),
            Text(
              label,
              style: AppTextStyles.body1.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF545454),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
