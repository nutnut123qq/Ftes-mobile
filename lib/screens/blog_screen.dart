import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Blog',
          style: AppTextStyles.heading2.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Featured Blog Post
            _buildFeaturedPost(),
            const SizedBox(height: 24),
            
            // Categories Section
            _buildCategoriesSection(),
            const SizedBox(height: 24),
            
            // Recent Posts
            _buildRecentPostsSection(),
            const SizedBox(height: 24),
            
            // Popular Posts
            _buildPopularPostsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedPost() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.article,
                size: 60,
                color: AppColors.primary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Nổi bật',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Hướng dẫn học lập trình Flutter từ cơ bản đến nâng cao',
                  style: AppTextStyles.heading3.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Khám phá những bí quyết và kinh nghiệm học lập trình Flutter hiệu quả, từ những khái niệm cơ bản đến các kỹ thuật nâng cao...',
                  style: AppTextStyles.bodyText.copyWith(
                    color: AppColors.textLight,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 14,
                      color: AppColors.textLight,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '5 phút đọc',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textLight,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.visibility,
                      size: 14,
                      color: AppColors.textLight,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '1.2k lượt xem',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textLight,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Danh mục',
          style: AppTextStyles.heading3.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildCategoryChip('Lập trình', true),
              const SizedBox(width: 8),
              _buildCategoryChip('UI/UX Design', false),
              const SizedBox(width: 8),
              _buildCategoryChip('Marketing', false),
              const SizedBox(width: 8),
              _buildCategoryChip('Kinh doanh', false),
              const SizedBox(width: 8),
              _buildCategoryChip('Nghề nghiệp', false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.borderLight,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodyText.copyWith(
          color: isSelected ? Colors.white : AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildRecentPostsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Bài viết gần đây',
              style: AppTextStyles.heading3.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Xem tất cả',
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...List.generate(3, (index) => _buildBlogPostItem(index)),
      ],
    );
  }

  Widget _buildPopularPostsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Bài viết phổ biến',
              style: AppTextStyles.heading3.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Xem tất cả',
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...List.generate(2, (index) => _buildBlogPostItem(index + 3)),
      ],
    );
  }

  Widget _buildBlogPostItem(int index) {
    final titles = [
      '10 mẹo học lập trình hiệu quả cho người mới bắt đầu',
      'Thiết kế UI/UX: Những xu hướng mới nhất năm 2024',
      'Cách xây dựng portfolio ấn tượng cho developer',
      'Flutter vs React Native: So sánh chi tiết',
      'Lộ trình học lập trình web từ A đến Z',
    ];

    final categories = [
      'Lập trình',
      'UI/UX Design',
      'Nghề nghiệp',
      'Lập trình',
      'Lập trình',
    ];

    final readTimes = ['3 phút', '5 phút', '4 phút', '6 phút', '7 phút'];
    final views = ['856', '1.2k', '743', '2.1k', '1.5k'];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.lightBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.article,
              color: AppColors.primary,
              size: 32,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    categories[index],
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  titles[index],
                  style: AppTextStyles.bodyText.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 12,
                      color: AppColors.textLight,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      readTimes[index],
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textLight,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.visibility,
                      size: 12,
                      color: AppColors.textLight,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${views[index]} lượt xem',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textLight,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

