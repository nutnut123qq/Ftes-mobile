import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ftes/features/points/presentation/viewmodels/points_viewmodel.dart';
import 'package:ftes/core/utils/colors.dart';
import 'package:ftes/core/utils/format_utils.dart' as format_utils;

class PointManagementScreen extends StatefulWidget {
  const PointManagementScreen({super.key});

  @override
  State<PointManagementScreen> createState() => _PointManagementScreenState();
}

class _PointManagementScreenState extends State<PointManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _withdrawAmountController =
      TextEditingController();
  final TextEditingController _bankAccountController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _referralCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // Initialize data when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PointsViewModel>().refreshAllData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _withdrawAmountController.dispose();
    _bankAccountController.dispose();
    _bankNameController.dispose();
    _referralCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Quản lý điểm & Affiliate',
          style: TextStyle(color: Colors.white),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Điểm', icon: Icon(Icons.account_balance_wallet)),
            Tab(text: 'Giao dịch', icon: Icon(Icons.history)),
            Tab(text: 'Affiliate', icon: Icon(Icons.people)),
            Tab(text: 'Rút điểm', icon: Icon(Icons.money_off)),
          ],
        ),
      ),
      body: Consumer<PointsViewModel>(
        builder: (context, pointProvider, child) {
          return TabBarView(
            controller: _tabController,
            children: [
              _buildPointsTab(pointProvider),
              _buildTransactionsTab(pointProvider),
              _buildAffiliateTab(pointProvider),
              _buildWithdrawTab(pointProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPointsTab(PointsViewModel pointProvider) {
    if (pointProvider.isLoadingPoints) {
      return const Center(child: CircularProgressIndicator());
    }

    final userPoints = pointProvider.userPoints;

    return RefreshIndicator(
      onRefresh: () => pointProvider.refreshAllData(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Points Overview
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withValues(alpha: 0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tổng điểm của bạn',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    format_utils.NumberUtils.formatPoints(
                      userPoints?.totalPoints,
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Points Breakdown
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Khả dụng',
                    format_utils.NumberUtils.formatNumber(
                      userPoints?.availablePoints,
                    ),
                    Colors.green,
                    Icons.account_balance_wallet,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Bị khóa',
                    format_utils.NumberUtils.formatNumber(
                      userPoints?.lockedPoints,
                    ),
                    Colors.orange,
                    Icons.lock,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Đã rút',
                    format_utils.NumberUtils.formatNumber(
                      userPoints?.withdrawnPoints,
                    ),
                    Colors.blue,
                    Icons.money_off,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Last Updated
            if (userPoints?.lastUpdated != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.update, color: AppColors.textSecondary),
                    const SizedBox(width: 8),
                    Text(
                      'Cập nhật lần cuối: ${format_utils.DateUtils.formatDateTimeFromDate(userPoints!.lastUpdated)}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsTab(PointsViewModel pointProvider) {
    if (pointProvider.isLoadingTransactions) {
      return const Center(child: CircularProgressIndicator());
    }

    final transactions = pointProvider.pointTransactions;

    return RefreshIndicator(
      onRefresh: () => pointProvider.fetchPointTransactions(),
      child: transactions.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: AppColors.textSecondary),
                  SizedBox(height: 16),
                  Text('Chưa có giao dịch nào'),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                final isPositive = transaction.amount > 0;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: (isPositive ? Colors.green : Colors.red)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          isPositive ? Icons.add : Icons.remove,
                          color: isPositive ? Colors.green : Colors.red,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              transaction.description ?? 'Giao dịch',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              format_utils.DateUtils.formatDateTimeFromDate(
                                transaction.createdAt,
                              ),
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${isPositive ? '+' : ''}${format_utils.NumberUtils.formatNumber(transaction.amount)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isPositive ? Colors.green : Colors.red,
                            ),
                          ),
                          if (transaction.status.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(
                                  transaction.status,
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                transaction.status.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _getStatusColor(transaction.status),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildAffiliateTab(PointsViewModel pointProvider) {
    if (pointProvider.isLoadingReferral) {
      return const Center(child: CircularProgressIndicator());
    }

    final referralInfo = pointProvider.referralInfo;
    final referralCount = pointProvider.referralCount;
    final invitedUsers = pointProvider.invitedUsers;

    return RefreshIndicator(
      onRefresh: () => pointProvider.fetchReferralInfo(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Referral Code Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mã giới thiệu của bạn',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          referralInfo?.referralCode ?? 'Chưa có mã',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // Copy referral code functionality
                          },
                          icon: const Icon(
                            Icons.copy,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Statistics Row
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Tổng mời',
                    format_utils.NumberUtils.formatNumber(
                      referralCount?.totalInvited,
                    ),
                    Colors.blue,
                    Icons.people,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Đã kích hoạt',
                    format_utils.NumberUtils.formatNumber(
                      referralCount?.totalActive,
                    ),
                    Colors.green,
                    Icons.check_circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Thu nhập',
                    format_utils.NumberUtils.formatPoints(
                      referralCount?.totalEarnings,
                    ),
                    Colors.orange,
                    Icons.monetization_on,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Set New Referral Code
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thiết lập mã giới thiệu mới',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _referralCodeController,
                    decoration: const InputDecoration(
                      labelText: 'Mã giới thiệu mới',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _setReferralCode(pointProvider),
                      child: const Text('Cập nhật mã'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Invited Users List
            if (invitedUsers.isNotEmpty) ...[
              const Text(
                'Người đã mời',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              ...invitedUsers.map(
                (user) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                        child: const Icon(
                          Icons.person,
                          color: AppColors.primary,
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
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (user.email.isNotEmpty)
                              Text(
                                user.email,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (user.earnedPoints > 0)
                        Text(
                          '+${format_utils.NumberUtils.formatNumber(user.earnedPoints)}',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWithdrawTab(PointsViewModel pointProvider) {
    final userPoints = pointProvider.userPoints;
    final availablePoints = userPoints?.availablePoints ?? 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Available Points
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Điểm khả dụng',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  format_utils.NumberUtils.formatPoints(availablePoints),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Withdraw Form
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Yêu cầu rút điểm',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: _withdrawAmountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Số điểm muốn rút',
                    border: OutlineInputBorder(),
                    suffixText: 'điểm',
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _bankAccountController,
                  decoration: const InputDecoration(
                    labelText: 'Số tài khoản ngân hàng',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _bankNameController,
                  decoration: const InputDecoration(
                    labelText: 'Tên ngân hàng',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: availablePoints > 0
                        ? () => _withdrawPoints(pointProvider)
                        : null,
                    child: const Text('Yêu cầu rút điểm'),
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Lưu ý: Yêu cầu rút điểm sẽ được xử lý trong vòng 24-48 giờ làm việc.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'success':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
      case 'cancelled':
        return Colors.red;
      default:
        return AppColors.textSecondary;
    }
  }

  void _withdrawPoints(PointsViewModel pointProvider) async {
    final amount = int.tryParse(_withdrawAmountController.text);
    if (amount == null || amount <= 0) {
      _showErrorDialog('Vui lòng nhập số điểm hợp lệ');
      return;
    }

    final bankAccount = _bankAccountController.text.trim();
    final bankName = _bankNameController.text.trim();

    if (bankAccount.isEmpty || bankName.isEmpty) {
      _showErrorDialog('Vui lòng nhập đầy đủ thông tin ngân hàng');
      return;
    }

    final success = await pointProvider.withdrawPoints(
      amount: amount,
      bankAccount: bankAccount,
      bankName: bankName,
    );

    if (success) {
      _showSuccessDialog('Yêu cầu rút điểm đã được gửi thành công!');
      _withdrawAmountController.clear();
      _bankAccountController.clear();
      _bankNameController.clear();
    } else {
      _showErrorDialog(pointProvider.error ?? 'Có lỗi xảy ra khi rút điểm');
    }
  }

  void _setReferralCode(PointsViewModel pointProvider) async {
    final referralCode = _referralCodeController.text.trim();
    if (referralCode.isEmpty) {
      _showErrorDialog('Vui lòng nhập mã giới thiệu');
      return;
    }

    final success = await pointProvider.setReferral(referralCode);

    if (success) {
      _showSuccessDialog('Mã giới thiệu đã được cập nhật!');
      _referralCodeController.clear();
    } else {
      _showErrorDialog(
        pointProvider.error ?? 'Có lỗi xảy ra khi cập nhật mã giới thiệu',
      );
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lỗi'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thành công'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
