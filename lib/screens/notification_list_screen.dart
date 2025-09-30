import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: Column(
          children: [
            // Status Bar Space
            const SizedBox(height: 25),
            
            // Navigation Bar
            _buildNavigationBar(),
            
            const SizedBox(height: 20),
            
            // Notifications List
            Expanded(
              child: _buildNotificationsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Color(0xFF202244),
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Notifications',
            style: AppTextStyles.heading1.copyWith(
              color: const Color(0xFF202244),
              fontSize: 21,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 34),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Today Section
          _buildDateSection('Today', _getTodayNotifications()),
          const SizedBox(height: 30),
          
          // Yesterday Section
          _buildDateSection('Yesterday', _getYesterdayNotifications()),
          const SizedBox(height: 30),
          
          // Nov 20, 2022 Section
          _buildDateSection('Nov 20, 2022', _getOldNotifications()),
        ],
      ),
    );
  }

  Widget _buildDateSection(String date, List<NotificationItem> notifications) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          date,
          style: AppTextStyles.heading3.copyWith(
            color: const Color(0xFF202244),
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 20),
        ...notifications.map((notification) => _buildNotificationCard(notification)),
      ],
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F1FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFB4BDC4).withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          // Icon/Avatar
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: notification.iconColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              notification.icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 20),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: AppTextStyles.heading3.copyWith(
                    color: const Color(0xFF202244),
                    fontWeight: FontWeight.w600,
                    fontSize: 19,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  notification.description,
                  style: AppTextStyles.bodyText.copyWith(
                    color: const Color(0xFF545454),
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<NotificationItem> _getTodayNotifications() {
    return [
      NotificationItem(
        title: 'New Category Course.!',
        description: 'New the 3D Design Course is Available..',
        icon: Icons.book,
        iconColor: const Color(0xFF0961F5),
      ),
      NotificationItem(
        title: 'New Category Course.!',
        description: 'New the 3D Design Course is Available..',
        icon: Icons.school,
        iconColor: const Color(0xFF167F71),
      ),
      NotificationItem(
        title: 'Today\'s Special Offers',
        description: 'You Have made a Course Payment.',
        icon: Icons.local_offer,
        iconColor: const Color(0xFFFF6B00),
      ),
    ];
  }

  List<NotificationItem> _getYesterdayNotifications() {
    return [
      NotificationItem(
        title: 'Credit Card Connected.!',
        description: 'Credit Card has been Linked.!',
        icon: Icons.credit_card,
        iconColor: const Color(0xFF0961F5),
      ),
    ];
  }

  List<NotificationItem> _getOldNotifications() {
    return [
      NotificationItem(
        title: 'Account Setup Successful.!',
        description: 'Your Account has been Created.',
        icon: Icons.check_circle,
        iconColor: const Color(0xFF167F71),
      ),
    ];
  }
}

class NotificationItem {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;

  NotificationItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
  });
}
