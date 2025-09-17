import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';
import '../utils/constants.dart';
import '../routes/app_routes.dart';

class CertificateScreen extends StatefulWidget {
  final String courseTitle;
  final String studentName;
  final String completionDate;
  final String certificateId;
  
  const CertificateScreen({
    Key? key,
    required this.courseTitle,
    required this.studentName,
    required this.completionDate,
    required this.certificateId,
  }) : super(key: key);

  @override
  State<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildCertificateCard(),
            _buildDownloadButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(35, 25, 35, 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 26,
              height: 20,
              decoration: BoxDecoration(
                color: const Color(0xFF202244),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.courseTitle,
              style: AppTextStyles.heading1.copyWith(
                color: const Color(0xFF202244),
                fontSize: 21,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(34, 0, 34, 20),
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 21),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: widget.courseTitle,
                  hintStyle: AppTextStyles.body1.copyWith(
                    color: const Color(0xFFB4BDC4),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  border: InputBorder.none,
                ),
                style: AppTextStyles.body1.copyWith(
                  color: const Color(0xFF202244),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Container(
            width: 38,
            height: 38,
            margin: const EdgeInsets.only(right: 13),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F9FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.search,
              color: Color(0xFF0961F5),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificateCard() {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(34, 0, 34, 20),
        child: Container(
          constraints: BoxConstraints(
            minHeight: 400,
          ),
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
        child: Stack(
          children: [
            // Decorative background elements
            _buildDecorativeElements(),
            
            // Certificate content
            Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  // Logo/Icon
                  Container(
                    width: 54,
                    height: 59,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0961F5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.workspace_premium,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Certificate Title
                  Text(
                    'Certificate of Completion',
                    style: AppTextStyles.heading1.copyWith(
                      color: const Color(0xFF202244),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 15),
                  
                  // "This Certifies that" text
                  Text(
                    'This Certifies that',
                    style: AppTextStyles.body1.copyWith(
                      color: const Color(0xFF545454),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 15),
                  
                  // Student Name
                  Text(
                    widget.studentName,
                    style: AppTextStyles.body1.copyWith(
                      color: const Color(0xFF332DA1),
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Completion text
                  Text(
                    'Has Successfully Completed the Wallace Training Program, Entitled.',
                    style: AppTextStyles.body1.copyWith(
                      color: const Color(0xFF545454),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 15),
                  
                  // Course Title
                  Text(
                    widget.courseTitle,
                    style: AppTextStyles.body1.copyWith(
                      color: const Color(0xFF202244),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 15),
                  
                  // Issue Date
                  Text(
                    'Issued on ${widget.completionDate}',
                    style: AppTextStyles.body1.copyWith(
                      color: const Color(0xFF545454),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Certificate ID
                  Text(
                    'ID: ${widget.certificateId}',
                    style: AppTextStyles.body1.copyWith(
                      color: const Color(0xFF472D2D),
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 30),
                  
                    // Signatures
                    _buildSignatures(),
                  ],
                ),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildDecorativeElements() {
    return SizedBox(
      width: double.infinity,
      height: 400, // Fixed height for Stack
      child: Stack(
        children: [
          // Top right decorative element
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 172,
              height: 226,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    const Color(0xFF0961F5).withOpacity(0.1),
                    const Color(0xFF0961F5).withOpacity(0.05),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(50),
                ),
              ),
            ),
          ),
          
          // Bottom left decorative element
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: 114,
              height: 169,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    const Color(0xFF0961F5).withOpacity(0.1),
                    const Color(0xFF0961F5).withOpacity(0.05),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  topRight: Radius.circular(50),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignatures() {
    return Column(
      children: [
        // First signature
        Text(
          'Calvin E. McGinnis',
          style: AppTextStyles.body1.copyWith(
            color: const Color(0xFF202244),
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 20),
        
        // Second signature
        Text(
          'Virginia M. Patterson',
          style: AppTextStyles.body1.copyWith(
            color: const Color(0xFF505050),
            fontSize: 25,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 5),
        
        // Title
        Text(
          'Virginia M. Patterson',
          style: AppTextStyles.body1.copyWith(
            color: const Color(0xFF202244),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 10),
        
        // Date
        Text(
          'Issued on ${widget.completionDate}',
          style: AppTextStyles.body1.copyWith(
            color: const Color(0xFF545454),
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDownloadButton() {
    return Container(
      margin: const EdgeInsets.fromLTRB(39, 0, 39, 20),
      height: 60,
      child: GestureDetector(
        onTap: () {
          _downloadCertificate();
        },
        child: Container(
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
              Text(
                'Download Certificate',
                style: AppTextStyles.body1.copyWith(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.download,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _downloadCertificate() {
    // Handle download certificate action
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Downloading certificate...'),
        backgroundColor: Color(0xFF0961F5),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
