import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ftes/utils/colors.dart';
import 'package:ftes/utils/text_styles.dart';
import 'package:ftes/utils/constants.dart';
import 'package:ftes/widgets/bottom_navigation_bar.dart';
import 'package:ftes/routes/app_routes.dart';
import 'package:ftes/screens/edit_profile_screen.dart';
import 'package:ftes/screens/notifications_screen.dart';
import 'package:ftes/screens/security_screen.dart';
import 'package:ftes/screens/terms_conditions_screen.dart';
import 'package:ftes/screens/invite_friends_screen.dart';
import 'package:ftes/providers/auth_provider.dart';
import 'package:ftes/models/auth_response.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Load user info when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserInfo();
    });
  }

  void _loadUserInfo() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      if (authProvider.isLoggedIn && authProvider.currentUser == null) {
        await authProvider.refreshUserInfo();
      } else if (authProvider.isLoggedIn && authProvider.currentUser != null) {
      } else {
      }
    } catch (e) {
    }
  }

  String _getDisplayName(UserInfo? user) {
    if (user == null) return 'Chưa có tên';
    
    if (user.fullName != null && user.fullName!.isNotEmpty) {
      return user.fullName!;
    } else if (user.username != null && user.username!.isNotEmpty) {
      return user.username!;
    } else {
      return 'Chưa có tên';
    }
  }

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
            
            // Profile Content
            Expanded(
              child: _buildProfileContent(),
            ),
            
            // Bottom Navigation Bar
            AppBottomNavigationBar(selectedIndex: 4),
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
            'Hồ sơ',
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

  Widget _buildProfileContent() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        return SingleChildScrollView(
          child: Column(
            children: [
              // Profile Image and Info
              _buildProfileHeader(authProvider),
              
              const SizedBox(height: 20),
              
              // Profile Details Card
              _buildProfileDetailsCard(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(AuthProvider authProvider) {
    final user = authProvider.currentUser;
    
    // Debug logging
    if (user != null) {
    }
    
    return Column(
      children: [
        // Profile Image
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F1FF),
            borderRadius: BorderRadius.circular(55),
            border: Border.all(
              color: const Color(0xFF167F71),
              width: 3,
            ),
          ),
          child: user?.avatar != null && user!.avatar!.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(55),
                  child: Image.network(
                    user.avatar!,
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.person,
                        size: 60,
                        color: Color(0xFF0961F5),
                      );
                    },
                  ),
                )
              : const Icon(
                  Icons.person,
                  size: 60,
                  color: Color(0xFF0961F5),
                ),
        ),
        
        const SizedBox(height: 20),
        
        // Name
        Text(
          _getDisplayName(user),
          style: AppTextStyles.heading1.copyWith(
            color: const Color(0xFF202244),
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Email
        Text(
          user?.email ?? 'Chưa có email',
          style: AppTextStyles.body1.copyWith(
            color: const Color(0xFF545454),
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileDetailsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 34),
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
          _buildProfileItem(
            icon: Icons.edit,
            title: 'Chỉnh sửa hồ sơ',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfileScreen(),
                ),
              );
            },
          ),
          _buildDivider(),
          _buildProfileItem(
            icon: Icons.notifications,
            title: 'Thông báo',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
          ),
          _buildDivider(),
          _buildProfileItem(
            icon: Icons.security,
            title: 'Bảo mật',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SecurityScreen(),
                ),
              );
            },
          ),
          _buildDivider(),
          _buildProfileItem(
            icon: Icons.dark_mode,
            title: 'Chế độ tối',
            onTap: () {
              // Toggle Dark Mode
            },
          ),
          _buildDivider(),
          _buildProfileItem(
            icon: Icons.description,
            title: 'Điều khoản & Điều kiện',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TermsConditionsScreen(),
                ),
              );
            },
          ),
          _buildDivider(),
          _buildProfileItem(
            icon: Icons.help_center,
            title: 'Trung tâm trợ giúp',
            onTap: () {
              // Navigate to Help Center
            },
          ),
          _buildDivider(),
          _buildProfileItem(
            icon: Icons.person_add,
            title: 'Mời bạn bè',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InviteFriendsScreen(),
                ),
              );
            },
          ),
          _buildDivider(),
          _buildProfileItem(
            icon: Icons.logout,
            title: 'Đăng xuất',
            isLogout: true,
            onTap: () {
              // Show logout confirmation
              _showLogoutDialog();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            // Icon
            Container(
              width: 20,
              height: 20,
              child: Icon(
                icon,
                color: isLogout ? const Color(0xFF202244) : const Color(0xFF0961F5),
                size: 20,
              ),
            ),
            
            const SizedBox(width: 15),
            
            // Title and Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.body1.copyWith(
                      color: const Color(0xFF202244),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyles.body1.copyWith(
                        color: const Color(0xFF0961F5),
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // Arrow Icon
            Icon(
              Icons.arrow_forward_ios,
              color: const Color(0xFFB4BDC4),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: const Color(0xFFE8F1FF),
      margin: const EdgeInsets.symmetric(vertical: 8),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Đăng xuất',
            style: AppTextStyles.heading1.copyWith(
              color: const Color(0xFF202244),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Bạn có chắc chắn muốn đăng xuất?',
            style: AppTextStyles.body1.copyWith(
              color: const Color(0xFF545454),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Hủy',
                style: AppTextStyles.body1.copyWith(
                  color: const Color(0xFF545454),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _handleLogout();
              },
              child: Text(
                'Đăng xuất',
                style: AppTextStyles.body1.copyWith(
                  color: const Color(0xFF0961F5),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleLogout() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      
      // Call logout API
      await authProvider.logout();
      
      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
        
        // Navigate to login screen
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppConstants.routeSignIn,
          (route) => false,
        );
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng xuất thành công!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
        
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đăng xuất thất bại: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}