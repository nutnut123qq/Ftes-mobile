import 'package:flutter/foundation.dart';
import '../../domain/entities/blog.dart';
import '../../domain/entities/blog_category.dart';
import '../../domain/usecases/get_all_blogs_usecase.dart';
import '../../domain/usecases/get_blog_by_slug_usecase.dart';
import '../../domain/usecases/search_blogs_usecase.dart';
import '../../domain/usecases/get_blog_categories_usecase.dart';
import '../../domain/constants/blog_constants.dart';
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
  final int _pageSize = BlogConstants.defaultPageSize;
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
  /// Optimized to minimize notifyListeners() calls
  Future<void> initialize() async {
    // Set loading state and notify listeners immediately
    _isLoading = true;
    _isLoadingCategories = true;
    notifyListeners();
    
    // Fetch all data in parallel
    await Future.wait([
      _fetchBlogsInternal(),
      _fetchBlogCategoriesInternal(),
    ]);
    
    // Notify listeners only once after all data is loaded
    notifyListeners();
  }
  
  /// Internal method to fetch blogs without notifying listeners
  Future<void> _fetchBlogsInternal() async {
    final result = await _getAllBlogsUseCase(GetAllBlogsParams(
      pageNumber: BlogConstants.defaultPageNumber,
      pageSize: _pageSize,
      sortField: BlogConstants.defaultSortField,
      sortOrder: BlogConstants.defaultSortOrder,
    ));

    result.fold(
      (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        _isLoading = false;
        _isLoadingCategories = false;
      },
      (paginatedResponse) {
        _currentPage = paginatedResponse.currentPage;
        _totalPages = paginatedResponse.totalPages;
        _totalElements = paginatedResponse.totalElements;
        _blogs = paginatedResponse.data;
        _isLoading = false;
        _isLoadingCategories = false;
      },
    );
  }
  
  /// Internal method to fetch blog categories without notifying listeners
  Future<void> _fetchBlogCategoriesInternal() async {
    final result = await _getBlogCategoriesUseCase(const NoParams());

    result.fold(
      (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        debugPrint('❌ Failed to fetch blog categories: ${failure.message}');
      },
      (categories) {
        _categories = categories;
        debugPrint('✅ Loaded ${categories.length} blog categories');
      },
    );
  }
  
  /// Expose method to manually refresh categories if needed
  Future<void> refreshCategories() async {
    _isLoadingCategories = true;
    notifyListeners();
    
    final result = await _getBlogCategoriesUseCase(const NoParams());

    result.fold(
      (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        _isLoadingCategories = false;
        notifyListeners();
      },
      (categories) {
        _categories = categories;
        _isLoadingCategories = false;
        notifyListeners();
      },
    );
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

    // Set loading state
    if (loadMore) {
      _isLoadingMore = true;
    } else {
      _isLoading = true;
    }
    _errorMessage = null;
    notifyListeners();

    final result = await _getAllBlogsUseCase(GetAllBlogsParams(
      pageNumber: pageNumber,
      pageSize: pageSize,
      sortField: sortField,
      sortOrder: sortOrder,
    ));

    result.fold(
      (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        if (loadMore) {
          _isLoadingMore = false;
        } else {
          _isLoading = false;
        }
        notifyListeners();
      },
      (paginatedResponse) {
        _currentPage = paginatedResponse.currentPage;
        _totalPages = paginatedResponse.totalPages;
        _totalElements = paginatedResponse.totalElements;
        
        if (loadMore) {
          _blogs.addAll(paginatedResponse.data);
          _isLoadingMore = false;
        } else {
          _blogs = paginatedResponse.data;
          _isLoading = false;
        }
        
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
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _getBlogBySlugUseCase(slugName);

    result.fold(
      (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        _isLoading = false;
        notifyListeners();
      },
      (blog) {
        _selectedBlog = blog;
        _isLoading = false;
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

    // Set loading state
    if (loadMore) {
      _isLoadingMore = true;
    } else {
      _isLoading = true;
    }
    _errorMessage = null;
    notifyListeners();

    final result = await _searchBlogsUseCase(SearchBlogsParams(
      pageNumber: pageNumber,
      pageSize: pageSize,
      title: title,
      category: category,
    ));

    result.fold(
      (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        if (loadMore) {
          _isLoadingMore = false;
        } else {
          _isLoading = false;
        }
        notifyListeners();
      },
      (paginatedResponse) {
        _currentPage = paginatedResponse.currentPage;
        _totalPages = paginatedResponse.totalPages;
        _totalElements = paginatedResponse.totalElements;
        _searchText = title;
        _selectedCategory = category;
        
        if (loadMore) {
          _blogs.addAll(paginatedResponse.data);
          _isLoadingMore = false;
        } else {
          _blogs = paginatedResponse.data;
          _isLoading = false;
        }
        
        notifyListeners();
      },
    );
  }

  /// Fetch blog categories
  Future<void> fetchBlogCategories() async {
    _isLoadingCategories = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _getBlogCategoriesUseCase(const NoParams());

    result.fold(
      (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        _isLoadingCategories = false;
        notifyListeners();
      },
      (categories) {
        _categories = categories;
        _isLoadingCategories = false;
        notifyListeners();
      },
    );
  }

  /// Set selected category filter
  Future<void> setCategory(String? category) async {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      if (category != null && category.isNotEmpty) {
        await searchBlogs(category: category);
      } else {
        await fetchBlogs();
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
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  /// Map failure to user-friendly message
  String _mapFailureToMessage(Failure failure) {
    return failure.message;
  }
}
