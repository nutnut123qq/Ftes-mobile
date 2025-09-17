import 'package:flutter/material.dart';
import '../models/transaction_item.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';
import '../utils/constants.dart';
import '../widgets/bottom_navigation_bar.dart';
import 'e_receipt_edit_screen.dart';

class EReceiptScreen extends StatefulWidget {
  final TransactionItem transaction;

  const EReceiptScreen({
    super.key,
    required this.transaction,
  });

  @override
  State<EReceiptScreen> createState() => _EReceiptScreenState();
}

class _EReceiptScreenState extends State<EReceiptScreen> {
  bool _showEditMenu = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Status Bar
                Container(
                  height: 44,
                  color: Colors.white,
                  child: Row(
                    children: [
                      const SizedBox(width: 21),
                      Text(
                        '9:41',
                        style: AppTextStyles.body1.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 22,
                        height: 11,
                        margin: const EdgeInsets.only(right: 16.67),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black.withOpacity(0.35)),
                          borderRadius: BorderRadius.circular(2.67),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              right: 2,
                              top: 1.5,
                              child: Container(
                                width: 18,
                                height: 7.33,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(1.33),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 2.5,
                              child: Container(
                                width: 1.33,
                                height: 4,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 25),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          size: 20,
                          color: Color(0xFF202244),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'E-Receipt',
                        style: AppTextStyles.h2.copyWith(
                          color: const Color(0xFF202244),
                          fontSize: 21,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showEditMenu = !_showEditMenu;
                          });
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F9FF),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.more_vert,
                            size: 20,
                            color: Color(0xFF202244),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Receipt Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 44),
                    child: Column(
                      children: [
                        // Receipt Icon
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(bottom: 30),
                          decoration: BoxDecoration(
                            color: const Color(0xFF167F71),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Icon(
                            Icons.receipt_long,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                        // Barcode
                        Container(
                          width: 270,
                          height: 103,
                          margin: const EdgeInsets.only(bottom: 30),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE2E6EA)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Barcode lines (simplified)
                              Container(
                                height: 40,
                                width: 200,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    '25234567',
                                    style: AppTextStyles.body1.copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '28646345',
                                    style: AppTextStyles.body1.copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Receipt Details
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildReceiptRow('Name', widget.transaction.studentName),
                              const SizedBox(height: 20),
                              _buildReceiptRow('Email ID', widget.transaction.email),
                              const SizedBox(height: 20),
                              _buildReceiptRow('Course', widget.transaction.courseTitle),
                              const SizedBox(height: 20),
                              _buildReceiptRow('Category', widget.transaction.category),
                              const SizedBox(height: 20),
                              _buildReceiptRow('TransactionID', widget.transaction.transactionId),
                              const SizedBox(height: 20),
                              _buildReceiptRow('Price', widget.transaction.price),
                              const SizedBox(height: 20),
                              _buildReceiptRow('Date', '${widget.transaction.date}   /   15:45'),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Status',
                                    style: AppTextStyles.body1.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF202244),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF167F71),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      widget.transaction.status,
                                      style: AppTextStyles.body1.copyWith(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Edit Menu Overlay
            if (_showEditMenu)
              Positioned(
                top: 100,
                right: 35,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showEditMenu = false;
                    });
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: const EReceiptEditScreen(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.body1.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF202244),
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: AppTextStyles.body1.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF545454),
            ),
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}