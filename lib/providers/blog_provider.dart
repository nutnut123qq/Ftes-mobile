import 'package:flutter/material.dart';
import '../models/blog_response.dart';
import '../services/blog_service.dart';

class BlogProvider extends ChangeNotifier {
  final BlogService _blogService = BlogService();

  // State variables
  List<BlogResponse> _blogs = [];
  BlogResponse? _selectedBlog;
  bool _isLoading = false;
  String? _errorMessage;
  
  // Pagination
  int _currentPage = 1;
  int _totalPages = 1;
  int _pageSize = 10;
  int _totalCount = 0;
  
  // Filter
  String? _selectedCategory;
  String? _searchText;

  // Getters
  List<BlogResponse> get blogs => _blogs;
  BlogResponse? get selectedBlog => _selectedBlog;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get totalCount => _totalCount;
  String? get selectedCategory => _selectedCategory;
  bool get hasMore => _currentPage < _totalPages;

  /// Initialize the provider
  void initialize() {
    _blogService.initialize();
  }

  /// Dispose the provider
  @override
  void dispose() {
    _blogService.dispose();
    super.dispose();
  }

  // Private helper methods
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  /// Fetch all blogs with pagination
  Future<void> fetchBlogs({
    int pageNumber = 1,
    int pageSize = 10,
    String sortField = 'createdAt',
    String sortOrder = 'desc',
    String? searchText,
    bool loadMore = false,
  }) async {
    if (_isLoading) return;

    _setLoading(true);
    _clearError();

    try {
      final response = await _blogService.getAllBlogs(
        pageNumber: pageNumber,
        pageSize: pageSize,
        sortField: sortField,
        sortOrder: sortOrder,
        searchText: searchText,
      );

      _currentPage = response.currentPage ?? pageNumber;
      _totalPages = response.totalPage ?? 1;
      _pageSize = response.pageSize ?? pageSize;
      _totalCount = response.totalCount ?? 0;
      _searchText = searchText;

      if (loadMore) {
        _blogs.addAll(response.data ?? []);
      } else {
        _blogs = response.data ?? [];
      }

      notifyListeners();
    } catch (e) {
      _setError('Không thể tải danh sách blog: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Load more blogs (pagination)
  Future<void> loadMoreBlogs() async {
    if (!hasMore || _isLoading) return;
    
    await fetchBlogs(
      pageNumber: _currentPage + 1,
      pageSize: _pageSize,
      searchText: _searchText,
      loadMore: true,
    );
  }

  /// Fetch blog detail by slug
  Future<void> fetchBlogBySlug(String slugName) async {
    _setLoading(true);
    _clearError();

    try {
      _selectedBlog = await _blogService.getBlogBySlugName(slugName);
      notifyListeners();
    } catch (e) {
      _setError('Không thể tải chi tiết blog: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Fetch blogs by category
  Future<void> fetchBlogsByCategory({
    required String category,
    int pageNumber = 1,
    int pageSize = 10,
    bool loadMore = false,
  }) async {
    if (_isLoading) return;

    _setLoading(true);
    _clearError();

    try {
      final response = await _blogService.getBlogsByCategory(
        category: category,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );

      _currentPage = response.currentPage ?? pageNumber;
      _totalPages = response.totalPage ?? 1;
      _pageSize = response.pageSize ?? pageSize;
      _totalCount = response.totalCount ?? 0;
      _selectedCategory = category;

      if (loadMore) {
        _blogs.addAll(response.data ?? []);
      } else {
        _blogs = response.data ?? [];
      }

      notifyListeners();
    } catch (e) {
      _setError('Không thể tải blog theo danh mục: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Search blogs
  Future<void> searchBlogs({
    String? title,
    String? content,
    String? category,
    int pageNumber = 1,
    int pageSize = 10,
    bool loadMore = false,
  }) async {
    if (_isLoading) return;

    _setLoading(true);
    _clearError();

    try {
      final response = await _blogService.searchBlogs(
        title: title,
        content: content,
        category: category,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );

      _currentPage = response.currentPage ?? pageNumber;
      _totalPages = response.totalPage ?? 1;
      _pageSize = response.pageSize ?? pageSize;
      _totalCount = response.totalCount ?? 0;

      if (loadMore) {
        _blogs.addAll(response.data ?? []);
      } else {
        _blogs = response.data ?? [];
      }

      notifyListeners();
    } catch (e) {
      _setError('Không thể tìm kiếm blog: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Set selected category filter
  void setCategory(String? category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      if (category != null && category.isNotEmpty) {
        fetchBlogsByCategory(category: category);
      } else {
        fetchBlogs();
      }
    }
  }

  /// Clear selected blog
  void clearSelectedBlog() {
    _selectedBlog = null;
    notifyListeners();
  }

  /// Refresh blogs
  Future<void> refreshBlogs() async {
    _currentPage = 1;
    await fetchBlogs(pageNumber: 1);
  }
}
