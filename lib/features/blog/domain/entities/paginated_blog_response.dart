import 'blog.dart';

/// Paginated blog response entity
class PaginatedBlogResponse {
  final List<Blog> data;
  final int totalPages;
  final int totalElements;
  final int currentPage;

  const PaginatedBlogResponse({
    required this.data,
    required this.totalPages,
    required this.totalElements,
    required this.currentPage,
  });

  @override
  String toString() {
    return 'PaginatedBlogResponse(data: ${data.length} items, totalPages: $totalPages, currentPage: $currentPage)';
  }
}

