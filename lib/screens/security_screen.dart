import 'package:flutter/material.dart';
import 'package:ftes/utils/colors.dart';
import 'package:ftes/utils/text_styles.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _rememberMe = true;
  bool _biometricId = true;
  bool _faceId = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // Navigation Bar
            _buildNavigationBar(),
            
            const SizedBox(height: 20),
            
            // Content
            Expanded(
              child: _buildContent(),
            ),
            
            // Home Indicator
            Container(
              height: 34,
              width: double.infinity,
              child: Center(
                child: Container(
                  width: 134,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 19),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E6EA),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
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
            'Bảo mật',
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

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          
          // Remember Me Toggle
          _buildToggleItem(
            title: 'Ghi nhớ đăng nhập',
            value: _rememberMe,
            onChanged: (value) {
              setState(() {
                _rememberMe = value;
              });
            },
          ),
          
          const SizedBox(height: 40),
          
          // Biometric ID Toggle
          _buildToggleItem(
            title: 'ID Sinh trắc học',
            value: _biometricId,
            onChanged: (value) {
              setState(() {
                _biometricId = value;
              });
            },
          ),
          
          const SizedBox(height: 40),
          
          // Face ID Toggle
          _buildToggleItem(
            title: 'Face ID',
            value: _faceId,
            onChanged: (value) {
              setState(() {
                _faceId = value;
              });
            },
          ),
          
          const SizedBox(height: 40),
          
          // Google Authenticator
          _buildGoogleAuthenticator(),
          
          const SizedBox(height: 200),
          
          // Change PIN Button
          _buildChangePINButton(),
          
          const SizedBox(height: 30),
          
          // Change Password Button
          _buildChangePasswordButton(),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildToggleItem({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.body1.copyWith(
            color: const Color(0xFF202244),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        GestureDetector(
          onTap: () => onChanged(!value),
          child: Container(
            width: 50,
            height: 30,
            decoration: BoxDecoration(
              color: value ? const Color(0xFF0961F5) : const Color(0xFFE8F1FF),
              borderRadius: BorderRadius.circular(15),
              border: value ? null : Border.all(
                color: const Color(0xFFB4BDC4).withOpacity(0.4),
                width: 2,
              ),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleAuthenticator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Google Authenticator',
          style: AppTextStyles.body1.copyWith(
            color: const Color(0xFF202244),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: const Color(0xFF0961F5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
            size: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildChangePINButton() {
    return GestureDetector(
      onTap: () {
        // Handle Change PIN
      },
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F9FF),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: const Color(0xFFB4BDC4).withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            'Đổi PIN',
            style: AppTextStyles.body1.copyWith(
              color: const Color(0xFF202244),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChangePasswordButton() {
    return GestureDetector(
      onTap: () {
        // Handle Change Password
      },
      child: Container(
        width: double.infinity,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.lock,
                color: Color(0xFF0961F5),
                size: 12,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Đổi mật khẩu',
              style: AppTextStyles.body1.copyWith(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
