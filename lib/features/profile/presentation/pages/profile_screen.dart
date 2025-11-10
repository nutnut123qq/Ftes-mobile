import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ftes/utils/text_styles.dart';
import 'package:ftes/utils/constants.dart';
import 'package:ftes/widgets/bottom_navigation_bar.dart';
import 'package:ftes/features/profile/presentation/pages/edit_profile_screen.dart';
import 'package:ftes/features/profile/presentation/pages/notifications_screen.dart';
import 'package:ftes/features/points/presentation/pages/invite_friends_screen.dart';
import 'package:ftes/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:ftes/features/auth/domain/entities/user.dart';
import 'package:ftes/features/profile/presentation/viewmodels/profile_viewmodel.dart';
import 'package:ftes/features/profile/domain/entities/profile.dart';
import 'package:ftes/features/profile/presentation/pages/terms_conditions_page.dart';

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
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
      
      if (authViewModel.isLoggedIn && authViewModel.currentUser == null) {
        await authViewModel.refreshUserInfo();
      }
      
      // Load profile data if user is logged in
      if (authViewModel.isLoggedIn && authViewModel.currentUser != null) {
        await profileViewModel.getProfileById(authViewModel.currentUser!.id);
      }
    } catch (e) {
      debugPrint('Error loading user info: $e');
    }
  }

  String _getDisplayName(Profile? profile, User? user) {
    // Priority: Profile name > User fullName > User username
    if (profile != null && profile.name.isNotEmpty) {
      return profile.name;
    }
    
    if (user != null) {
      if (user.fullName != null && user.fullName!.isNotEmpty) {
        return user.fullName!;
      } else if (user.username != null && user.username!.isNotEmpty) {
        return user.username!;
      }
    }
    
    return 'Chưa có tên';
  }

  String _getDisplayEmail(Profile? profile, User? user) {
    // Priority: Profile email > User email
    if (profile != null && profile.email.isNotEmpty) {
      return profile.email;
    }
    
    return user?.email ?? 'Chưa có email';
  }

  String? _getDisplayAvatar(Profile? profile, User? user) {
    // Priority: Profile avatar > User avatar
    if (profile != null && profile.avatar.isNotEmpty) {
      return profile.avatar;
    }
    
    return user?.avatar;
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
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(selectedIndex: 4),
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
                    color: Colors.black.withValues(alpha: 0.1),
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
    return Consumer2<AuthViewModel, ProfileViewModel>(
      builder: (context, authViewModel, profileViewModel, child) {
        if (authViewModel.isLoading || profileViewModel.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        return SingleChildScrollView(
          child: Column(
            children: [
              // Profile Image and Info
              _buildProfileHeader(authViewModel, profileViewModel),
              
              const SizedBox(height: 20),
              
              // Profile Details Card
              _buildProfileDetailsCard(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(AuthViewModel authViewModel, ProfileViewModel profileViewModel) {
    final user = authViewModel.currentUser;
    final profile = profileViewModel.currentProfile;
    
    final displayName = _getDisplayName(profile, user);
    final displayEmail = _getDisplayEmail(profile, user);
    final displayAvatar = _getDisplayAvatar(profile, user);
    
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
          child: displayAvatar != null && displayAvatar.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(55),
                  child: Image.network(
                    displayAvatar,
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
          displayName,
          style: AppTextStyles.heading1.copyWith(
            color: const Color(0xFF202244),
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Email
        Text(
          displayEmail,
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
            color: Colors.black.withValues(alpha: 0.08),
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
            icon: Icons.description,
            title: 'Điều khoản & Điều kiện',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TermsConditionsPage(),
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
            SizedBox(
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
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      
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
      await authViewModel.logout();
      
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