import 'package:flutter/foundation.dart';
import '../../domain/entities/blog.dart';
import '../../domain/entities/blog_category.dart';
import '../../domain/usecases/get_all_blogs_usecase.dart';
import '../../domain/usecases/get_blog_by_slug_usecase.dart';
import '../../domain/usecases/search_blogs_usecase.dart';
import '../../domain/usecases/get_blog_categories_usecase.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

/// ViewModel for blog operations
class BlogViewModel extends ChangeNotifier {
  final GetAllBlogsUseCase _getAllBlogsUseCase;
  final GetBlogBySlugUseCase _getBlogBySlugUseCase;
  final SearchBlogsUseCase _searchBlogsUseCase;
  final GetBlogCategoriesUseCase _getBlogCategoriesUseCase;

  BlogViewModel({
    required GetAllBlogsUseCase getAllBlogsUseCase,
    required GetBlogBySlugUseCase getBlogBySlugUseCase,
    required SearchBlogsUseCase searchBlogsUseCase,
    required GetBlogCategoriesUseCase getBlogCategoriesUseCase,
  })  : _getAllBlogsUseCase = getAllBlogsUseCase,
        _getBlogBySlugUseCase = getBlogBySlugUseCase,
        _searchBlogsUseCase = searchBlogsUseCase,
        _getBlogCategoriesUseCase = getBlogCategoriesUseCase;

  // State variables
  List<Blog> _blogs = [];
  List<BlogCategory> _categories = [];
  Blog? _selectedBlog;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _isLoadingCategories = false;
  String? _errorMessage;
  
  // Pagination
  int _currentPage = 1;
  int _totalPages = 1;
  final int _pageSize = 10;
  int _totalElements = 0;
  
  // Filter
  String? _selectedCategory;
  String? _searchText;

  // Getters
  List<Blog> get blogs => _blogs;
  List<BlogCategory> get categories => _categories;
  Blog? get selectedBlog => _selectedBlog;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get isLoadingCategories => _isLoadingCategories;
  String? get errorMessage => _errorMessage;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get totalElements => _totalElements;
  String? get selectedCategory => _selectedCategory;
  String? get searchText => _searchText;
  bool get hasMore => _currentPage < _totalPages;

  /// Initialize the ViewModel - fetch initial data
  Future<void> initialize() async {
    await Future.wait([
      fetchBlogs(),
      fetchBlogCategories(),
    ]);
  }

  /// Fetch all blogs with pagination
  Future<void> fetchBlogs({
    int pageNumber = 1,
    int pageSize = 10,
    String sortField = 'createdAt',
    String sortOrder = 'desc',
    bool loadMore = false,
  }) async {
    if (_isLoading && !loadMore) return;

    _setLoading(true, loadMore);
    _clearError();

    final result = await _getAllBlogsUseCase(GetAllBlogsParams(
      pageNumber: pageNumber,
      pageSize: pageSize,
      sortField: sortField,
      sortOrder: sortOrder,
    ));

    result.fold(
      (failure) {
        _setError(_mapFailureToMessage(failure));
        _setLoading(false, loadMore);
      },
      (paginatedResponse) {
        _currentPage = paginatedResponse.currentPage;
        _totalPages = paginatedResponse.totalPages;
        _totalElements = paginatedResponse.totalElements;
        
        if (loadMore) {
          _blogs.addAll(paginatedResponse.data);
        } else {
          _blogs = paginatedResponse.data;
        }
        
        _setLoading(false, loadMore);
        notifyListeners();
      },
    );
  }

  /// Load more blogs (pagination)
  Future<void> loadMoreBlogs() async {
    if (!hasMore || _isLoadingMore) return;
    
    await fetchBlogs(
      pageNumber: _currentPage + 1,
      pageSize: _pageSize,
      loadMore: true,
    );
  }

  /// Fetch blog detail by slug
  Future<void> fetchBlogBySlug(String slugName) async {
    _setLoading(true, false);
    _clearError();

    final result = await _getBlogBySlugUseCase(slugName);

    result.fold(
      (failure) {
        _setError(_mapFailureToMessage(failure));
        _setLoading(false, false);
      },
      (blog) {
        _selectedBlog = blog;
        _setLoading(false, false);
        notifyListeners();
      },
    );
  }

  /// Search blogs with filters
  Future<void> searchBlogs({
    String? title,
    String? category,
    int pageNumber = 1,
    int pageSize = 10,
    bool loadMore = false,
  }) async {
    if (_isLoading && !loadMore) return;

    _setLoading(true, loadMore);
    _clearError();

    final result = await _searchBlogsUseCase(SearchBlogsParams(
      pageNumber: pageNumber,
      pageSize: pageSize,
      title: title,
      category: category,
    ));

    result.fold(
      (failure) {
        _setError(_mapFailureToMessage(failure));
        _setLoading(false, loadMore);
      },
      (paginatedResponse) {
        _currentPage = paginatedResponse.currentPage;
        _totalPages = paginatedResponse.totalPages;
        _totalElements = paginatedResponse.totalElements;
        _searchText = title;
        _selectedCategory = category;
        
        if (loadMore) {
          _blogs.addAll(paginatedResponse.data);
        } else {
          _blogs = paginatedResponse.data;
        }
        
        _setLoading(false, loadMore);
        notifyListeners();
      },
    );
  }

  /// Fetch blog categories
  Future<void> fetchBlogCategories() async {
    _setLoadingCategories(true);
    _clearError();

    final result = await _getBlogCategoriesUseCase(const NoParams());

    result.fold(
      (failure) {
        _setError(_mapFailureToMessage(failure));
        _setLoadingCategories(false);
      },
      (categories) {
        _categories = categories;
        _setLoadingCategories(false);
        notifyListeners();
      },
    );
  }

  /// Set selected category filter
  void setCategory(String? category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      if (category != null && category.isNotEmpty) {
        searchBlogs(category: category);
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

  /// Clear error message
  void clearError() {
    _clearError();
  }

  // Private helper methods
  void _setLoading(bool loading, bool loadMore) {
    if (loadMore) {
      _isLoadingMore = loading;
    } else {
      _isLoading = loading;
    }
    notifyListeners();
  }

  void _setLoadingCategories(bool loading) {
    _isLoadingCategories = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Map failure to user-friendly message
  String _mapFailureToMessage(Failure failure) {
    return failure.message;
  }
}
