import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/utils/text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/bottom_navigation_bar.dart';
import '../../domain/constants/blog_constants.dart';
import '../viewmodels/blog_viewmodel.dart';
import '../widgets/blog_featured_post_card.dart';
import '../widgets/blog_post_item.dart';
import '../widgets/blog_categories_section.dart';

class BlogListPage extends StatefulWidget {
  const BlogListPage({super.key});

  @override
  State<BlogListPage> createState() => _BlogListPageState();
}

class _BlogListPageState extends State<BlogListPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String? _selectedCategory;
  bool _isLoadingMore = false; // Prevent duplicate API calls

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // BlogViewModel.initialize() is called when Provider is created in main.dart
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final scrollPercentage = maxScroll > 0 ? currentScroll / maxScroll : 0.0;

    // Prefetch when user scrolls to 80% (instead of 200px from bottom)
    if (scrollPercentage >= 0.8) {
      final blogViewModel = Provider.of<BlogViewModel>(context, listen: false);
      // Only load more if there are more pages and not currently loading and haven't triggered a load
      if (blogViewModel.hasMore &&
          !blogViewModel.isLoadingMore &&
          !blogViewModel.isLoading &&
          !_isLoadingMore) {
        setState(() {
          _isLoadingMore = true;
        });
        blogViewModel.loadMoreBlogs().then((_) {
          setState(() {
            _isLoadingMore = false;
          });
        });
      }
    }
  }

  Future<void> _onCategorySelected(String? category) async {
    setState(() {
      _selectedCategory = category;
    });
    
    final blogViewModel = Provider.of<BlogViewModel>(context, listen: false);
    await blogViewModel.setCategory(category);
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
          BlogConstants.blogListTitle,
          style: AppTextStyles.heading2.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<BlogViewModel>(
        builder: (context, blogViewModel, child) {
          return SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search input
                  _buildSearchBar(context),
                  const SizedBox(height: 16),
                  // Featured Blog Post (first blog)
                  if (blogViewModel.blogs.isNotEmpty)
                    BlogFeaturedPostCard(
                      blog: blogViewModel.blogs.first,
                      onTap: () {
                        if (blogViewModel.blogs.first.slugName.isNotEmpty) {
                          Navigator.pushNamed(
                            context,
                            AppConstants.routeBlogDetail,
                            arguments: {'slugName': blogViewModel.blogs.first.slugName},
                          );
                        }
                      },
                    ),
                  const SizedBox(height: 24),
                  
                  // Categories Section
                  BlogCategoriesSection(
                    categories: blogViewModel.categories,
                    selectedCategory: _selectedCategory,
                    onCategorySelected: _onCategorySelected,
                  ),
                  const SizedBox(height: 24),
                  
                  // Show loading or error
                  if (blogViewModel.isLoading && blogViewModel.blogs.isEmpty)
                    const Center(child: CircularProgressIndicator())
                  else if (blogViewModel.errorMessage != null)
                    Center(
                      child: Column(
                        children: [
                          Text(
                            blogViewModel.errorMessage!,
                            style: AppTextStyles.bodyText.copyWith(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => blogViewModel.refreshBlogs(),
                            child: const Text(BlogConstants.retryLabel),
                          ),
                        ],
                      ),
                    )
                  else if (blogViewModel.blogs.isEmpty)
                    const Center(child: Text(BlogConstants.noBlogsAvailable))
                  else
                    _buildBlogsList(blogViewModel),
                  
                  // Loading more indicator
                  if (blogViewModel.isLoadingMore && blogViewModel.blogs.isNotEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  
                  const SizedBox(height: 100), // Space for bottom navigation
                ],
              ),
          );
        },
      ),
      bottomNavigationBar: AppBottomNavigationBar(selectedIndex: 3),
    );
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      Provider.of<BlogViewModel>(context, listen: false).searchBlogs(
        title: value.isEmpty ? null : value,
        pageNumber: 1,
        pageSize: BlogConstants.defaultPageSize,
      );
    });
  }

  Widget _buildSearchBar(BuildContext context) {
    return TextField(
      controller: _searchController,
      onChanged: _onSearchChanged,
      onSubmitted: (value) {
        // Gửi request ngay lập tức khi bấm Enter
        _debounce?.cancel();
        Provider.of<BlogViewModel>(context, listen: false).searchBlogs(
          title: value.isEmpty ? null : value,
          pageNumber: 1,
          pageSize: BlogConstants.defaultPageSize,
        );
      },
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: BlogConstants.searchPlaceholder,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  _onSearchChanged('');
                },
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildBlogsList(BlogViewModel blogViewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              BlogConstants.blogPostsLabel,
              style: AppTextStyles.heading3.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${BlogConstants.totalLabel}: ${blogViewModel.totalElements}',
              style: AppTextStyles.bodyText.copyWith(
                color: AppColors.textLight,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Skip first blog if it's shown as featured
        ...blogViewModel.blogs.skip(1).map((blog) => BlogPostItem(
              blog: blog,
              onTap: () {
                if (blog.slugName.isNotEmpty) {
                  Navigator.pushNamed(
                    context,
                    AppConstants.routeBlogDetail,
                    arguments: {'slugName': blog.slugName},
                  );
                }
              },
            )),
      ],
    );
  }

}
