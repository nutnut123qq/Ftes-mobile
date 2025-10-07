import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';
import '../utils/constants.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../providers/blog_provider.dart';
import '../models/blog_response.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  final ScrollController _scrollController = ScrollController();
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // Fetch blogs when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final blogProvider = Provider.of<BlogProvider>(context, listen: false);
      blogProvider.fetchBlogs();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final blogProvider = Provider.of<BlogProvider>(context, listen: false);
      blogProvider.loadMoreBlogs();
    }
  }

  void _onCategorySelected(String? category) {
    setState(() {
      _selectedCategory = category;
    });
    
    final blogProvider = Provider.of<BlogProvider>(context, listen: false);
    if (category == null || category.isEmpty) {
      blogProvider.refreshBlogs();
    } else {
      blogProvider.fetchBlogsByCategory(category: category);
    }
  }

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
      body: Consumer<BlogProvider>(
        builder: (context, blogProvider, child) {
          return RefreshIndicator(
            onRefresh: () => blogProvider.refreshBlogs(),
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Featured Blog Post (first blog)
                  if (blogProvider.blogs.isNotEmpty)
                    _buildFeaturedPost(blogProvider.blogs.first),
                  const SizedBox(height: 24),
                  
                  // Categories Section
                  _buildCategoriesSection(),
                  const SizedBox(height: 24),
                  
                  // Show loading or error
                  if (blogProvider.isLoading && blogProvider.blogs.isEmpty)
                    const Center(child: CircularProgressIndicator())
                  else if (blogProvider.errorMessage != null)
                    Center(
                      child: Column(
                        children: [
                          Text(
                            blogProvider.errorMessage!,
                            style: AppTextStyles.bodyText.copyWith(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => blogProvider.refreshBlogs(),
                            child: const Text('Thử lại'),
                          ),
                        ],
                      ),
                    )
                  else if (blogProvider.blogs.isEmpty)
                    const Center(child: Text('Không có bài viết nào'))
                  else
                    _buildBlogsList(blogProvider),
                  
                  // Loading more indicator
                  if (blogProvider.isLoading && blogProvider.blogs.isNotEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  
                  const SizedBox(height: 100), // Space for bottom navigation
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: AppBottomNavigationBar(selectedIndex: 3),
    );
  }

  Widget _buildFeaturedPost(BlogResponse blog) {
    return GestureDetector(
      onTap: () {
        if (blog.slugName != null && blog.slugName!.isNotEmpty) {
          Navigator.pushNamed(
            context,
            AppConstants.routeBlogDetail,
            arguments: {'slugName': blog.slugName},
          );
        }
      },
      child: Container(
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
            child: blog.image != null && blog.image!.isNotEmpty
                ? ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Image.network(
                      blog.image!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.broken_image,
                                size: 50,
                                color: AppColors.textLight.withOpacity(0.5),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Không thể tải ảnh',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textLight,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.article,
                          size: 60,
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Không có ảnh',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
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
                    blog.categoryName ?? 'Nổi bật',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  blog.title ?? 'Không có tiêu đề',
                  style: AppTextStyles.heading3.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  _stripHtmlTags(blog.content ?? ''),
                  style: AppTextStyles.bodyText.copyWith(
                    color: AppColors.textLight,
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: AppColors.textLight,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(blog.createdAt),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textLight,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.access_time,
                      size: 14,
                      color: AppColors.textLight,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _calculateReadTime(blog.content ?? ''),
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
    ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Không rõ';
    
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Vừa xong';
        }
        return '${difference.inMinutes} phút trước';
      }
      return '${difference.inHours} giờ trước';
    } else if (difference.inDays == 1) {
      return 'Hôm qua';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }

  String _calculateReadTime(String content) {
    final words = content.split(' ').length;
    final minutes = (words / 200).ceil(); // Average reading speed: 200 words/minute
    return '$minutes phút đọc';
  }

  String _stripHtmlTags(String htmlText) {
    final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '');
  }


  Widget _buildCategoriesSection() {
    final categories = ['Tất cả', 'Lập trình', 'UI/UX Design', 'Marketing', 'Kinh doanh', 'Nghề nghiệp'];
    
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
            children: categories.map((category) {
              final isSelected = _selectedCategory == null 
                  ? category == 'Tất cả' 
                  : _selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _buildCategoryChip(
                  category,
                  isSelected,
                  () => _onCategorySelected(category == 'Tất cả' ? null : category),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }

  Widget _buildBlogsList(BlogProvider blogProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Bài viết',
              style: AppTextStyles.heading3.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Tổng: ${blogProvider.totalCount}',
              style: AppTextStyles.bodyText.copyWith(
                color: AppColors.textLight,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Skip first blog if it's shown as featured
        ...blogProvider.blogs.skip(1).map((blog) => _buildBlogPostItem(blog)),
      ],
    );
  }

  Widget _buildBlogPostItem(BlogResponse blog) {
    return GestureDetector(
      onTap: () {
        if (blog.slugName != null && blog.slugName!.isNotEmpty) {
          Navigator.pushNamed(
            context,
            AppConstants.routeBlogDetail,
            arguments: {'slugName': blog.slugName},
          );
        }
      },
      child: Container(
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
            child: blog.image != null && blog.image!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      blog.image!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.broken_image,
                          color: AppColors.textLight,
                          size: 28,
                        );
                      },
                    ),
                  )
                : const Icon(
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
                if (blog.categoryName != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      blog.categoryName!,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                  ),
                const SizedBox(height: 6),
                Text(
                  blog.title ?? 'Không có tiêu đề',
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
                      Icons.calendar_today,
                      size: 12,
                      color: AppColors.textLight,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(blog.createdAt),
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
    ),
    );
  }
}

