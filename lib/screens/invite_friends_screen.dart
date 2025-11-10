import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ftes/features/points/domain/entities/invited_user.dart';
import 'package:ftes/features/points/presentation/viewmodels/points_viewmodel.dart';
import '../utils/colors.dart';
import '../utils/format_utils.dart' as FormatUtils;

class InviteFriendsScreen extends StatefulWidget {
  const InviteFriendsScreen({super.key});

  @override
  State<InviteFriendsScreen> createState() => _InviteFriendsScreenState();
}

class _InviteFriendsScreenState extends State<InviteFriendsScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize point data when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PointsViewModel>().initializeInviteFriendsData();
    });
  }

  void _copyReferralCode(String referralCode) {
    Clipboard.setData(ClipboardData(text: referralCode));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã sao chép mã giới thiệu!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareReferralCode(String referralCode) {
    final message =
        'Tham gia FunnyCodeEdu với mã giới thiệu của tôi: $referralCode\n'
        'Tải app tại: [Link download]';

    // For now, just copy to clipboard as we don't have share_plus
    Clipboard.setData(ClipboardData(text: message));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã sao chép tin nhắn giới thiệu!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F9FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Mời bạn bè & Kiếm điểm',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            fontFamily: 'Jost',
          ),
        ),
        centerTitle: false,
      ),
      body: Consumer<PointsViewModel>(
        builder: (context, pointProvider, child) {
          if (pointProvider.isLoadingReferral ||
              pointProvider.isLoadingPoints) {
            return const Center(child: CircularProgressIndicator());
          }

          if (pointProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    pointProvider.error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      pointProvider.initializeInviteFriendsData();
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => pointProvider.refreshAllData(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Points Overview Card
                    _buildPointsOverviewCard(pointProvider),

                    const SizedBox(height: 24),

                    // Referral Code Section
                    _buildReferralCodeSection(pointProvider),

                    const SizedBox(height: 24),

                    // Statistics Cards
                    _buildStatisticsRow(pointProvider),

                    const SizedBox(height: 24),

                    // Invited Users List
                    _buildInvitedUsersList(pointProvider),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPointsOverviewCard(PointsViewModel pointProvider) {
    final userPoints = pointProvider.userPoints;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            offset: const Offset(0, 8),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Điểm của bạn',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            FormatUtils.NumberUtils.formatPoints(userPoints?.totalPoints),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildPointDetail(
                  'Khả dụng',
                  FormatUtils.NumberUtils.formatNumber(
                    userPoints?.availablePoints,
                  ),
                  Icons.account_balance_wallet,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildPointDetail(
                  'Đã rút',
                  FormatUtils.NumberUtils.formatNumber(
                    userPoints?.withdrawnPoints,
                  ),
                  Icons.money_off,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPointDetail(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
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

  Widget _buildReferralCodeSection(PointsViewModel pointProvider) {
    final referralInfo = pointProvider.referralInfo;
    final referralCode = referralInfo?.referralCode ?? 'Chưa có mã';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mã giới thiệu của bạn',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    referralCode,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _copyReferralCode(referralCode),
                      icon: const Icon(Icons.copy, color: AppColors.primary),
                      tooltip: 'Sao chép',
                    ),
                    IconButton(
                      onPressed: () => _shareReferralCode(referralCode),
                      icon: const Icon(Icons.share, color: AppColors.primary),
                      tooltip: 'Chia sẻ',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Chia sẻ mã này để bạn bè đăng ký và nhận điểm thưởng!',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsRow(PointsViewModel pointProvider) {
    final referralCount = pointProvider.referralCount;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Tổng mời',
            FormatUtils.NumberUtils.formatNumber(referralCount?.totalInvited),
            Icons.people,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Đã kích hoạt',
            FormatUtils.NumberUtils.formatNumber(referralCount?.totalActive),
            Icons.check_circle,
            Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Tổng thu nhập',
            FormatUtils.NumberUtils.formatPoints(referralCount?.totalEarnings),
            Icons.monetization_on,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInvitedUsersList(PointsViewModel pointProvider) {
    final invitedUsers = pointProvider.invitedUsers;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Người đã mời',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              if (pointProvider.isLoadingInvitedUsers)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
          const SizedBox(height: 16),

          if (invitedUsers.isEmpty)
            const Center(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Icon(
                    Icons.people_outline,
                    size: 48,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Chưa có ai được mời',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Hãy chia sẻ mã giới thiệu để bắt đầu kiếm điểm!',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: invitedUsers.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return _buildInvitedUserItem(invitedUsers[index]);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildInvitedUserItem(InvitedUser user) {
    final isActive = user.status.toLowerCase() == 'active';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive
                  ? Colors.green.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
            ),
            child: Icon(
              Icons.person,
              color: isActive ? Colors.green : Colors.grey,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName.isNotEmpty
                      ? user.fullName
                      : (user.username.isNotEmpty ? user.username : 'Ẩn danh'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (user.email.isNotEmpty)
                  Text(
                    user.email,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                if (user.invitedAt != null)
                  Text(
                    'Tham gia: ${FormatUtils.DateUtils.formatDate(user.invitedAt!.toIso8601String())}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.green.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isActive ? 'Kích hoạt' : 'Chờ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.green : Colors.grey,
                  ),
                ),
              ),
              if (user.earnedPoints > 0)
                Text(
                  '+${FormatUtils.NumberUtils.formatNumber(user.earnedPoints)} điểm',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
