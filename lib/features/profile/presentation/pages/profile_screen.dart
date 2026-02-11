import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ftes/core/utils/text_styles.dart';
import 'package:ftes/core/constants/app_constants.dart';
import 'package:ftes/core/widgets/bottom_navigation_bar.dart';
import 'package:ftes/features/profile/presentation/pages/edit_profile_screen.dart';
import 'package:ftes/features/profile/presentation/pages/notifications_screen.dart';
import 'package:ftes/features/points/presentation/pages/invite_friends_screen.dart';
import 'package:ftes/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:ftes/features/auth/domain/entities/user.dart';
import 'package:ftes/features/profile/presentation/viewmodels/profile_viewmodel.dart';
import 'package:ftes/features/profile/domain/entities/profile.dart';
import 'package:ftes/features/profile/presentation/pages/terms_conditions_page.dart';
import 'package:ftes/core/utils/image_cache_helper.dart';
import 'package:ftes/core/utils/url_helper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isInitializing = true;

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
      final profileViewModel = Provider.of<ProfileViewModel>(
        context,
        listen: false,
      );

      if (authViewModel.isLoggedIn && authViewModel.currentUser == null) {
        await authViewModel.refreshUserInfo();
      }

      // Load profile data if user is logged in
      if (authViewModel.isLoggedIn && authViewModel.currentUser != null) {
        final userId = authViewModel.currentUser!.id;

        // First, load from cache immediately to show data instantly
        await profileViewModel.loadProfileFromCache(userId);

        // Set initializing to false after cache is loaded
        if (mounted) {
          setState(() {
            _isInitializing = false;
          });
        }

        // Then, refresh from network (will use cache if available, then update)
        await profileViewModel.getProfileById(userId);
      } else {
        if (mounted) {
          setState(() {
            _isInitializing = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading user info: $e');
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
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
      backgroundColor: const Color(0xFFF3F6FF),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 220,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0F6FFF), Color(0xFF7C3AED)],
                  ),
                ),
              ),
            ),
            Column(
              children: [
                _buildHeaderActions(context),
                Expanded(child: _buildProfileContent()),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(selectedIndex: 4),
    );
  }

  Widget _buildHeaderActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hồ sơ cá nhân',
                style: AppTextStyles.h2.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Cập nhật thông tin của bạn',
                style: AppTextStyles.body1.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Row(
            children: [
              _HeaderIconButton(
                icon: Icons.notifications_none_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationsScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              _HeaderIconButton(
                icon: Icons.edit_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    return Consumer2<AuthViewModel, ProfileViewModel>(
      builder: (context, authViewModel, profileViewModel, child) {
        final isLoadingInitial =
            _isInitializing ||
            (authViewModel.isLoading &&
                profileViewModel.currentProfile == null) ||
            (profileViewModel.isLoading &&
                profileViewModel.currentProfile == null);

        if (isLoadingInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () async {
            final userId = authViewModel.currentUser?.id;
            if (userId != null && userId.isNotEmpty) {
              await profileViewModel.getProfileById(userId);
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
            child: Column(
              children: [
                const SizedBox(height: 12),
                _buildProfileHero(authViewModel, profileViewModel),
                const SizedBox(height: 16),
                _buildStatsSection(authViewModel, profileViewModel),
                const SizedBox(height: 16),
                _buildQuickActions(),
                const SizedBox(height: 16),
                _buildInfoSection(authViewModel, profileViewModel),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHero(
    AuthViewModel authViewModel,
    ProfileViewModel profileViewModel,
  ) {
    final user = authViewModel.currentUser;
    final profile = profileViewModel.currentProfile;

    final displayName = _getDisplayName(profile, user);
    final displayEmail = _getDisplayEmail(profile, user);
    final displayAvatar = _getDisplayAvatar(profile, user);
    final role = (profile != null && profile.role.isNotEmpty)
        ? profile.role
        : (user?.role ?? '');

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.25),
                Colors.white.withValues(alpha: 0.05),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.8),
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: SizedBox(
                        width: 92,
                        height: 92,
                        child: displayAvatar != null && displayAvatar.isNotEmpty
                            ? ImageCacheHelper.cached(
                                displayAvatar,
                                fit: BoxFit.cover,
                                placeholder: Container(
                                  color: const Color(0xFFE8F1FF),
                                  child: const Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                ),
                                error: const Icon(
                                  Icons.person,
                                  size: 52,
                                  color: Color(0xFF0961F5),
                                ),
                              )
                            : const Icon(
                                Icons.person,
                                size: 52,
                                color: Color(0xFF0961F5),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: AppTextStyles.h2.copyWith(
                            color: const Color(0xFF0E1236),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            if (role.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF0F6FFF,
                                  ).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  role,
                                  style: AppTextStyles.body1.copyWith(
                                    color: const Color(0xFF0F6FFF),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            if (displayEmail.isNotEmpty) ...[
                              if (role.isNotEmpty) const SizedBox(width: 8),
                              Icon(
                                Icons.mail_outline,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  displayEmail,
                                  style: AppTextStyles.body1.copyWith(
                                    color: Colors.grey[700],
                                    fontSize: 12,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _buildSocialBadges(profile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBadges(Profile? profile) {
    final socials = <_SocialLink>[
      if (profile != null && profile.facebook.isNotEmpty)
        _SocialLink(
          label: 'Facebook',
          icon: Icons.facebook,
          url: profile.facebook,
        ),
      if (profile != null && profile.youtube.isNotEmpty)
        _SocialLink(
          label: 'YouTube',
          icon: Icons.play_circle_outline,
          url: profile.youtube,
        ),
      if (profile != null && profile.twitter.isNotEmpty)
        _SocialLink(
          label: 'Twitter/X',
          icon: Icons.alternate_email,
          url: profile.twitter,
        ),
    ];

    if (socials.isEmpty) {
      return Container();
    }

    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children: socials
          .map(
            (social) => GestureDetector(
              onTap: () {
                UrlHelper.openExternalUrl(context, url: social.url);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(social.icon, size: 16, color: Colors.grey[800]),
                    const SizedBox(width: 6),
                    Text(
                      social.label,
                      style: AppTextStyles.body1.copyWith(
                        color: Colors.grey[900],
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildStatsSection(
    AuthViewModel authViewModel,
    ProfileViewModel profileViewModel,
  ) {
    final profileRole = profileViewModel.currentProfile?.role ?? '';
    final stats = [
      _ProfileStat(
        label: 'Học viên',
        value: profileViewModel.participantsCount.toString(),
      ),
      _ProfileStat(
        label: 'Vai trò',
        value: profileRole.isNotEmpty
            ? profileRole
            : (authViewModel.currentUser?.role ?? 'Chưa phân loại'),
      ),
      _ProfileStat(
        label: 'Email',
        value: authViewModel.currentUser?.email == null
            ? 'Chưa xác thực'
            : 'Đã cập nhật',
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      child: Row(
        children: stats
            .map(
              (stat) => Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      stat.value,
                      style: AppTextStyles.h4.copyWith(
                        color: const Color(0xFF0E1236),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      stat.label,
                      style: AppTextStyles.body1.copyWith(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      _ProfileAction(
        icon: Icons.person_outline,
        label: 'Chỉnh sửa',
        gradient: const [Color(0xFF8B5CF6), Color(0xFF6366F1)],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EditProfileScreen()),
          );
        },
      ),
      _ProfileAction(
        icon: Icons.notifications_none_rounded,
        label: 'Thông báo',
        gradient: const [Color(0xFF22D3EE), Color(0xFF1E3A8A)],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NotificationsScreen(),
            ),
          );
        },
      ),
      _ProfileAction(
        icon: Icons.card_giftcard,
        label: 'Mời bạn bè',
        gradient: const [Color(0xFF6EE7B7), Color(0xFF16A34A)],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const InviteFriendsScreen(),
            ),
          );
        },
      ),
      _ProfileAction(
        icon: Icons.lock_outline,
        label: 'Điều khoản',
        gradient: const [Color(0xFFFDE68A), Color(0xFFF59E0B)],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TermsConditionsPage(),
            ),
          );
        },
      ),
      _ProfileAction(
        icon: Icons.help_outline,
        label: 'Trợ giúp',
        gradient: const [Color(0xFFFFA7C4), Color(0xFFE11D48)],
        onTap: () {
          // TODO: Navigate to help center
        },
      ),
      _ProfileAction(
        icon: Icons.logout,
        label: 'Đăng xuất',
        gradient: const [Color(0xFF94A3B8), Color(0xFF1F2937)],
        onTap: _showLogoutDialog,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: actions
            .map((action) => _QuickActionButton(action: action))
            .toList(),
      ),
    );
  }

  Widget _buildInfoSection(
    AuthViewModel authViewModel,
    ProfileViewModel profileViewModel,
  ) {
    final profile = profileViewModel.currentProfile;
    final user = authViewModel.currentUser;

    final infoItems = <_InfoItem>[
      if (profile != null && profile.phoneNumber.isNotEmpty)
        _InfoItem(
          icon: Icons.phone_rounded,
          label: 'Số điện thoại',
          value: profile.phoneNumber,
        ),
      if (profile != null && profile.dataOfBirth.isNotEmpty)
        _InfoItem(
          icon: Icons.cake_outlined,
          label: 'Sinh nhật',
          value: profile.dataOfBirth.split('T').first,
        ),
      if (profile != null && profile.description.isNotEmpty)
        _InfoItem(
          icon: Icons.auto_stories_outlined,
          label: 'Giới thiệu',
          value: profile.description,
        ),
      if (profile != null && profile.jobName.isNotEmpty)
        _InfoItem(
          icon: Icons.work_outline,
          label: 'Công việc',
          value: profile.jobName,
        ),
      if (user != null && user.email.isNotEmpty)
        _InfoItem(
          icon: Icons.mail_outline,
          label: 'Email đăng nhập',
          value: user.email,
        ),
    ];

    if (infoItems.isEmpty) {
      infoItems.add(
        _InfoItem(
          icon: Icons.info_outline,
          label: 'Thông tin bổ sung',
          value: 'Chưa có thông tin chi tiết. Hãy cập nhật hồ sơ của bạn!',
        ),
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thông tin chi tiết',
            style: AppTextStyles.h4.copyWith(
              color: const Color(0xFF0E1236),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          ...infoItems.map((item) => _InfoRow(item: item)).toList(),
        ],
      ),
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
          return const Center(child: CircularProgressIndicator());
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

class _ProfileStat {
  final String label;
  final String value;

  const _ProfileStat({required this.label, required this.value});
}

class _ProfileAction {
  final IconData icon;
  final String label;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _ProfileAction({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });
}

class _SocialLink {
  final String label;
  final IconData icon;
  final String url;

  const _SocialLink({
    required this.label,
    required this.icon,
    required this.url,
  });
}

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });
}

class _QuickActionButton extends StatelessWidget {
  final _ProfileAction action;

  const _QuickActionButton({required this.action});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action.onTap,
      child: Container(
        width: (MediaQuery.of(context).size.width - 24 * 2 - 12 * 2) / 2,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: action.gradient,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: action.gradient.last.withValues(alpha: 0.24),
              blurRadius: 16,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(action.icon, color: Colors.white, size: 20),
            ),
            const SizedBox(height: 14),
            Text(
              action.label,
              style: AppTextStyles.body1.copyWith(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final _InfoItem item;

  const _InfoRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF0F6FFF).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon, color: const Color(0xFF0F6FFF), size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: AppTextStyles.body1.copyWith(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.value,
                  style: AppTextStyles.body1.copyWith(
                    color: const Color(0xFF0E1236),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}
