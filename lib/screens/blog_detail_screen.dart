import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_html/flutter_html.dart';
import '../providers/blog_provider.dart';
import '../utils/colors.dart';

class BlogDetailScreen extends StatefulWidget {
  final String slugName;

  const BlogDetailScreen({Key? key, required this.slugName}) : super(key: key);

  @override
  State<BlogDetailScreen> createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends State<BlogDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BlogProvider>(context, listen: false)
          .fetchBlogBySlug(widget.slugName);
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Không rõ';
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
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

  int _calculateReadTime(String? content) {
    if (content == null || content.isEmpty) return 1;
    final wordCount = content.split(' ').length;
    return (wordCount / 200).ceil(); // Giả sử đọc 200 từ/phút
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Consumer<BlogProvider>(
        builder: (context, blogProvider, child) {
          if (blogProvider.isLoading && blogProvider.selectedBlog == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (blogProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Có lỗi xảy ra',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    blogProvider.errorMessage!,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      blogProvider.fetchBlogBySlug(widget.slugName);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Thử lại'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          final blog = blogProvider.selectedBlog;
          if (blog == null) {
            return const Center(
              child: Text('Không tìm thấy bài viết'),
            );
          }

          return CustomScrollView(
            slivers: [
              // App Bar với ảnh header
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: AppColors.primary,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (blog.image != null && blog.image!.isNotEmpty)
                        Image.network(
                          blog.image!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: Colors.grey[300],
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.broken_image,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Không thể tải ảnh',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      else
                        Container(
                          color: AppColors.primary,
                          child: const Icon(
                            Icons.article,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
                      // Gradient overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Nội dung bài viết
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header info
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Category chip
                            if (blog.categoryName != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  blog.categoryName!,
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 16),

                            // Title
                            Text(
                              blog.title ?? 'Không có tiêu đề',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Meta info
                            Row(
                              children: [
                                Icon(Icons.calendar_today,
                                    size: 16, color: Colors.grey[600]),
                                const SizedBox(width: 8),
                                Text(
                                  _formatDate(blog.createdAt),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Icon(Icons.access_time,
                                    size: 16, color: Colors.grey[600]),
                                const SizedBox(width: 8),
                                Text(
                                  '${_calculateReadTime(blog.content)} phút đọc',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Author
                            if (blog.fullname != null)
                              Row(
                                children: [
                                  Icon(Icons.person,
                                      size: 16, color: Colors.grey[600]),
                                  const SizedBox(width: 8),
                                  Text(
                                    blog.fullname!,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),

                      const Divider(height: 1),

                      // Content
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: _buildHtmlContent(blog.content ?? ''),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHtmlContent(String htmlContent) {
    if (htmlContent.isEmpty) {
      return const Text(
        'Không có nội dung',
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey,
        ),
      );
    }

    return Html(
      data: htmlContent,
      style: {
        // Body text styling
        "body": Style(
          fontSize: FontSize(16),
          lineHeight: const LineHeight(1.6),
          color: Colors.black87,
          padding: HtmlPaddings.zero,
          margin: Margins.zero,
        ),
        
        // Headings
        "h1": Style(
          fontSize: FontSize(28),
          fontWeight: FontWeight.bold,
          margin: Margins.only(top: 24, bottom: 16),
        ),
        "h2": Style(
          fontSize: FontSize(24),
          fontWeight: FontWeight.bold,
          margin: Margins.only(top: 20, bottom: 12),
        ),
        "h3": Style(
          fontSize: FontSize(20),
          fontWeight: FontWeight.bold,
          margin: Margins.only(top: 16, bottom: 8),
        ),
        
        // Paragraphs
        "p": Style(
          fontSize: FontSize(16),
          lineHeight: const LineHeight(1.6),
          margin: Margins.only(bottom: 16),
        ),
        
        // Code blocks
        "pre": Style(
          backgroundColor: const Color(0xFF1E1E1E),
          color: Colors.white,
          padding: HtmlPaddings.all(16),
          margin: Margins.only(top: 8, bottom: 16),
          border: Border.all(color: Colors.grey[800]!),
          display: Display.block,
        ),
        "code": Style(
          backgroundColor: const Color(0xFF1E1E1E),
          color: const Color(0xFFD4D4D4),
          fontFamily: 'monospace',
          fontSize: FontSize(14),
          padding: HtmlPaddings.symmetric(horizontal: 4, vertical: 2),
        ),
        
        // Lists
        "ul": Style(
          margin: Margins.only(bottom: 16),
          padding: HtmlPaddings.only(left: 20),
        ),
        "ol": Style(
          margin: Margins.only(bottom: 16),
          padding: HtmlPaddings.only(left: 20),
        ),
        "li": Style(
          margin: Margins.only(bottom: 8),
        ),
        
        // Links
        "a": Style(
          color: AppColors.primary,
          textDecoration: TextDecoration.underline,
        ),
        
        // Strong/Bold
        "strong": Style(
          fontWeight: FontWeight.bold,
        ),
        "b": Style(
          fontWeight: FontWeight.bold,
        ),
        
        // Emphasis/Italic
        "em": Style(
          fontStyle: FontStyle.italic,
        ),
        "i": Style(
          fontStyle: FontStyle.italic,
        ),
        
        // Blockquote
        "blockquote": Style(
          backgroundColor: Colors.grey[100],
          border: Border(left: BorderSide(color: AppColors.primary, width: 4)),
          padding: HtmlPaddings.all(12),
          margin: Margins.only(top: 8, bottom: 16),
          fontStyle: FontStyle.italic,
        ),
        
        // Images
        "img": Style(
          width: Width.auto(),
          height: Height.auto(),
        ),
      },
    );
  }
}
