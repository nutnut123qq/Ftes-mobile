import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/text_styles.dart';
import '../../domain/constants/order_constants.dart';
import '../viewmodels/payment_viewmodel.dart';

class PaymentPage extends StatefulWidget {
  final String orderId;
  final String? qrCodeUrl;
  final String? description;

  const PaymentPage({
    super.key,
    required this.orderId,
    this.qrCodeUrl,
    this.description,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final bool _hasShownSuccessDialog = false;

  @override
  void initState() {
    super.initState();
    // Initialize payment view model
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<PaymentViewModel>(context, listen: false);
      viewModel.initialize(
        orderId: widget.orderId,
        initialQrCodeUrl: widget.qrCodeUrl,
        description: widget.description,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F9FF),
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Consumer<PaymentViewModel>(
                  builder: (context, viewModel, child) {
                    // Listen to payment success from WebSocket
                    if (viewModel.order != null && !_hasShownSuccessDialog) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        // Check if order status is COMPLETED (payment successful via WebSocket)
                        // This will be triggered by handlePaymentNotification in viewModel
                        // For now, we'll show dialog only on WebSocket success event
                      });
                    }

                    return viewModel.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : viewModel.errorMessage != null
                            ? _buildError(viewModel)
                            : _buildQRCodeSection(viewModel);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(2, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(35, 25, 35, 20),
        child: Row(
          children: [
            // Back Button
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 26,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Color(0xFF202244),
                  size: 16,
                ),
              ),
            ),
            const SizedBox(width: 20),
            // Title
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0961F5),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Thanh toán',
                    style: AppTextStyles.heading1.copyWith(
                      color: const Color(0xFF202244),
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
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

  Widget _buildError(PaymentViewModel viewModel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Không thể tải thông tin thanh toán',
              style: AppTextStyles.body1.copyWith(
                color: const Color(0xFF202244),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              viewModel.errorMessage ?? 'Lỗi không xác định',
              style: AppTextStyles.body1.copyWith(
                color: const Color(0xFF545454),
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                viewModel.loadOrderDetails(widget.orderId);
              },
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQRCodeSection(PaymentViewModel viewModel) {
    final qrCodeUrl = viewModel.qrCodeUrl;

    if (qrCodeUrl == null || qrCodeUrl.isEmpty) {
      return Center(
        child: Text(
          'Không tìm thấy mã QR',
          style: AppTextStyles.body1.copyWith(
            color: const Color(0xFF545454),
            fontSize: 14,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(35, 30, 35, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            OrderConstants.qrCodeTitle,
            style: AppTextStyles.body1.copyWith(
              color: const Color(0xFF202244),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          // QR Code Container
          Container(
            width: double.infinity,
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
                // QR Code Image
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFE8F1FF),
                      width: 2,
                    ),
                  ),
                  child: Image.network(
                    qrCodeUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.qr_code,
                            size: 80,
                            color: Color(0xFF0961F5),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            OrderConstants.qrCodeLoadError,
                            style: AppTextStyles.body1.copyWith(
                              color: const Color(0xFF545454),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                // Instructions
                Text(
                  OrderConstants.qrCodeInstructions,
                  style: AppTextStyles.body1.copyWith(
                    color: const Color(0xFF545454),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  OrderConstants.qrCodeAutoProcess,
                  style: AppTextStyles.body1.copyWith(
                    color: const Color(0xFF545454),
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



