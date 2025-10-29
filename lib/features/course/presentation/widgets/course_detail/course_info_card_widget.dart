import 'package:flutter/material.dart';
import '../../../../../utils/text_styles.dart';
import '../../../domain/constants/course_ui_constants.dart';
import '../../../domain/constants/course_constants.dart';

/// Widget for displaying course info card with title, stats, price, and tabs
class CourseInfoCardWidget extends StatelessWidget {
  final String title;
  final String category;
  final double avgStar;
  final int totalUser;
  final int totalLessons;
  final double? salePrice;
  final double? totalPrice;
  final int selectedTabIndex;
  final List<String> tabs;
  final Function(int) onTabSelected;

  const CourseInfoCardWidget({
    super.key,
    required this.title,
    required this.category,
    required this.avgStar,
    required this.totalUser,
    required this.totalLessons,
    this.salePrice,
    this.totalPrice,
    required this.selectedTabIndex,
    required this.tabs,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(CourseUIConstants.cardMargin),
      padding: const EdgeInsets.all(CourseUIConstants.cardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(CourseUIConstants.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(CourseUIConstants.shadowOpacity),
            blurRadius: CourseUIConstants.shadowBlurRadius,
            offset: const Offset(0, CourseUIConstants.shadowOffset),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          const SizedBox(height: CourseUIConstants.spacingSmall),
          _buildCategory(),
          const SizedBox(height: CourseUIConstants.spacingLarge),
          _buildStatsRow(),
          const SizedBox(height: CourseUIConstants.spacingXLarge),
          _buildPriceRow(),
          const SizedBox(height: CourseUIConstants.spacingXLarge),
          _buildTabSelector(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      title,
      style: AppTextStyles.heading2.copyWith(
        fontSize: CourseUIConstants.fontSizeHeading2,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildCategory() {
    return Text(
      category,
      style: AppTextStyles.bodyMedium.copyWith(
        color: const Color(0xFF0961F5),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatItem(
          Icons.star,
          avgStar.toStringAsFixed(1),
          const Color(0xFFFFB800),
        ),
        const SizedBox(width: CourseUIConstants.spacingXLarge),
        _buildStatItem(
          Icons.people,
          '$totalUser ${CourseConstants.labelStudents}',
          const Color(0xFF666666),
        ),
        const SizedBox(width: CourseUIConstants.spacingXLarge),
        _buildStatItem(
          Icons.play_circle_outline,
          '$totalLessons ${CourseConstants.labelLessons}',
          const Color(0xFF666666),
        ),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String text, Color iconColor) {
    return Row(
      children: [
        Icon(
          icon,
          color: iconColor,
          size: CourseUIConstants.iconSizeMedium,
        ),
        const SizedBox(width: CourseUIConstants.spacingTiny),
        Text(
          text,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: iconColor == const Color(0xFF666666)
                ? iconColor
                : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow() {
    final price = salePrice ?? totalPrice;

    return Row(
      children: [
        if (price != null && price > 0) ...[
          Text(
            '${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ',
            style: AppTextStyles.heading3.copyWith(
              color: const Color(0xFF0961F5),
              fontWeight: FontWeight.bold,
            ),
          ),
          if (totalPrice != null && totalPrice! > price) ...[
            const SizedBox(width: CourseUIConstants.spacingSmall),
            Text(
              '${totalPrice!.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ',
              style: AppTextStyles.bodyMedium.copyWith(
                color: const Color(0xFF999999),
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ],
        ] else ...[
          Text(
            CourseConstants.labelFree,
            style: AppTextStyles.heading3.copyWith(
              color: const Color(0xFF00C851),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTabSelector() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius:
            BorderRadius.circular(CourseUIConstants.borderRadiusMedium),
      ),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = selectedTabIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () => onTabSelected(index),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: CourseUIConstants.tabPaddingVertical,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(
                      CourseUIConstants.borderRadiusMedium),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(
                                0, CourseUIConstants.spacingTiny),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  tab,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? const Color(0xFF0961F5)
                        : const Color(0xFF666666),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

