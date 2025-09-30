import 'package:flutter/material.dart';
import 'package:ftes/utils/colors.dart';
import 'package:ftes/utils/text_styles.dart';
import 'package:ftes/utils/constants.dart';
import 'package:ftes/routes/app_routes.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              _buildCourseInfo(),
              _buildQRCodeSection(),
              _buildEnrollButton(),
              const SizedBox(height: 20),
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
            color: Colors.black.withOpacity(0.08),
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
              onTap: () => Navigator.pop(context),
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
                    'Phương thức thanh toán',
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

  Widget _buildCourseInfo() {
    return Container(
      margin: const EdgeInsets.fromLTRB(34, 20, 34, 0),
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
      child: Row(
        children: [
          // Course Image
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F1FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.play_circle_outline,
              color: Color(0xFF0961F5),
              size: 40,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Course Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category
                Text(
                  'Thiết kế đồ họa',
                  style: AppTextStyles.body1.copyWith(
                    color: const Color(0xFFFF6B00),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Title
                Text(
                  'Thiết lập Thiết kế đồ họa...',
                  style: AppTextStyles.body1.copyWith(
                    color: const Color(0xFF202244),
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

  Widget _buildQRCodeSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(35, 30, 35, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quét mã QR để thanh toán',
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
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // QR Code Placeholder
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F9FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFE8F1FF),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.qr_code,
                        size: 80,
                        color: const Color(0xFF0961F5),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Mã QR',
                        style: AppTextStyles.body1.copyWith(
                          color: const Color(0xFF0961F5),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Mẫu minh họa',
                        style: AppTextStyles.body1.copyWith(
                          color: const Color(0xFF545454),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Payment Info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F9FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Số tiền:',
                            style: AppTextStyles.body1.copyWith(
                              color: const Color(0xFF545454),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '\$55.00',
                            style: AppTextStyles.body1.copyWith(
                              color: const Color(0xFF202244),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Khóa học:',
                            style: AppTextStyles.body1.copyWith(
                              color: const Color(0xFF545454),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Thiết kế đồ họa nâng cao',
                              style: AppTextStyles.body1.copyWith(
                                color: const Color(0xFF202244),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Instructions
                Text(
                  'Quét mã QR bằng ứng dụng ngân hàng để hoàn tất thanh toán',
                  style: AppTextStyles.body1.copyWith(
                    color: const Color(0xFF545454),
                    fontSize: 12,
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

  Widget _buildEnrollButton() {
    return Container(
      margin: const EdgeInsets.fromLTRB(39, 30, 39, 0),
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF0961F5),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(1, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _enrollCourse,
          borderRadius: BorderRadius.circular(30),
          child: Row(
            children: [
              const SizedBox(width: 20),
              
              // Play Icon
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Color(0xFF0961F5),
                  size: 20,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Button Text
              Expanded(
                child: Text(
                  'Đăng ký khóa học - \$55',
                  style: AppTextStyles.buttonLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(width: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _enrollCourse() {
    // Navigate to success screen
    AppRoutes.navigateToEnrollSuccess(context);
  }
}
