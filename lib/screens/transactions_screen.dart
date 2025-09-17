import 'package:flutter/material.dart';
import '../models/transaction_item.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';
import '../utils/constants.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../routes/app_routes.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final List<TransactionItem> _transactions = [
    TransactionItem(
      id: '1',
      courseTitle: 'Build Personal Branding',
      category: 'Web Designer',
      price: '799/-',
      status: 'Paid',
      date: 'Nov 20, 2023',
      imageUrl: 'https://via.placeholder.com/90x90/000000/FFFFFF?text=Course',
      studentName: 'Alex',
      email: 'alexreall@gmail.com',
      transactionId: 'SK345680976',
    ),
    TransactionItem(
      id: '2',
      courseTitle: 'Mastering Blender 3D',
      category: 'Ui/UX Designer',
      price: '599/-',
      status: 'Paid',
      date: 'Nov 18, 2023',
      imageUrl: 'https://via.placeholder.com/90x90/000000/FFFFFF?text=Course',
      studentName: 'Alex',
      email: 'alexreall@gmail.com',
      transactionId: 'SK345680977',
    ),
    TransactionItem(
      id: '3',
      courseTitle: 'Full Stack Web Development',
      category: 'Web Development',
      price: '999/-',
      status: 'Paid',
      date: 'Nov 15, 2023',
      imageUrl: 'https://via.placeholder.com/90x90/000000/FFFFFF?text=Course',
      studentName: 'Alex',
      email: 'alexreall@gmail.com',
      transactionId: 'SK345680978',
    ),
    TransactionItem(
      id: '4',
      courseTitle: 'Complete UI Designer',
      category: 'HR Management',
      price: '699/-',
      status: 'Paid',
      date: 'Nov 12, 2023',
      imageUrl: 'https://via.placeholder.com/90x90/000000/FFFFFF?text=Course',
      studentName: 'Alex',
      email: 'alexreall@gmail.com',
      transactionId: 'SK345680979',
    ),
    TransactionItem(
      id: '5',
      courseTitle: 'Sharing Work with Team',
      category: 'Finance & Accounting',
      price: '899/-',
      status: 'Paid',
      date: 'Nov 10, 2023',
      imageUrl: 'https://via.placeholder.com/90x90/000000/FFFFFF?text=Course',
      studentName: 'Alex',
      email: 'alexreall@gmail.com',
      transactionId: 'SK345680980',
    ),
    TransactionItem(
      id: '6',
      courseTitle: 'Exporting Assets',
      category: 'SEO & Marketing',
      price: '499/-',
      status: 'Paid',
      date: 'Nov 8, 2023',
      imageUrl: 'https://via.placeholder.com/90x90/000000/FFFFFF?text=Course',
      studentName: 'Alex',
      email: 'alexreall@gmail.com',
      transactionId: 'SK345680981',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: Column(
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
                    'Transactions',
                    style: AppTextStyles.h2.copyWith(
                      color: const Color(0xFF202244),
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.search,
                    size: 20,
                    color: Color(0xFF202244),
                  ),
                ],
              ),
            ),
            // Transactions List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 34),
                itemCount: _transactions.length,
                itemBuilder: (context, index) {
                  final transaction = _transactions[index];
                  return _buildTransactionItem(transaction);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(selectedIndex: 3),
    );
  }

  Widget _buildTransactionItem(TransactionItem transaction) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      child: Column(
        children: [
          Row(
            children: [
              // Course Image
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.network(
                    transaction.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.black,
                        child: const Icon(
                          Icons.image,
                          color: Colors.white,
                          size: 30,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // Course Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.courseTitle,
                      style: AppTextStyles.h3.copyWith(
                        color: const Color(0xFF202244),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      transaction.category,
                      style: AppTextStyles.body1.copyWith(
                        color: const Color(0xFF545454),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              // Status Badge
              GestureDetector(
                onTap: () {
                  AppRoutes.navigateToEReceipt(context, transaction: transaction);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF167F71),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    transaction.status,
                    style: AppTextStyles.body1.copyWith(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Divider
          Container(
            height: 1,
            color: const Color(0xFFE2E6EA),
          ),
        ],
      ),
    );
  }
}
