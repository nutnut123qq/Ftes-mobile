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
    _updateState(isLoadingCategories: true);

    final result = await _getBlogCategoriesUseCase(const NoParams());

    result.fold(
      (failure) {
        _updateState(
          isLoadingCategories: false,
          errorMessage: _mapFailureToMessage(failure),
        );
      },
      (categories) {
        _updateState(
          isLoadingCategories: false,
          categories: categories,
        );
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
    _updateState(
      isLoading: loadMore ? null : true,
      isLoadingMore: loadMore ? true : null,
      errorMessage: '',
    );

    final result = await _getAllBlogsUseCase(GetAllBlogsParams(
      pageNumber: pageNumber,
      pageSize: pageSize,
      sortField: sortField,
      sortOrder: sortOrder,
    ));

    result.fold(
      (failure) {
        _updateState(
          isLoading: loadMore ? null : false,
          isLoadingMore: loadMore ? false : null,
          errorMessage: _mapFailureToMessage(failure),
        );
      },
      (paginatedResponse) {
        if (loadMore) {
          _blogs.addAll(paginatedResponse.data);
        }
        _updateState(
          isLoading: loadMore ? null : false,
          isLoadingMore: loadMore ? false : null,
          blogs: loadMore ? null : paginatedResponse.data,
          currentPage: paginatedResponse.currentPage,
          totalPages: paginatedResponse.totalPages,
          totalElements: paginatedResponse.totalElements,
        );
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
    _updateState(
      isLoading: true,
      errorMessage: '',
    );

    final result = await _getBlogBySlugUseCase(slugName);

    result.fold(
      (failure) {
        _updateState(
          isLoading: false,
          errorMessage: _mapFailureToMessage(failure),
        );
      },
      (blog) {
        _updateState(
          isLoading: false,
          selectedBlog: blog,
        );
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
    _updateState(
      isLoading: loadMore ? null : true,
      isLoadingMore: loadMore ? true : null,
      errorMessage: '',
    );

    final result = await _searchBlogsUseCase(SearchBlogsParams(
      pageNumber: pageNumber,
      pageSize: pageSize,
      title: title,
      category: category,
    ));

    result.fold(
      (failure) {
        _updateState(
          isLoading: loadMore ? null : false,
          isLoadingMore: loadMore ? false : null,
          errorMessage: _mapFailureToMessage(failure),
        );
      },
      (paginatedResponse) {
        if (loadMore) {
          _blogs.addAll(paginatedResponse.data);
        }
        _updateState(
          isLoading: loadMore ? null : false,
          isLoadingMore: loadMore ? false : null,
          blogs: loadMore ? null : paginatedResponse.data,
          currentPage: paginatedResponse.currentPage,
          totalPages: paginatedResponse.totalPages,
          totalElements: paginatedResponse.totalElements,
          searchText: title,
          selectedCategory: category,
        );
      },
    );
  }

  /// Fetch blog categories
  Future<void> fetchBlogCategories() async {
    _updateState(
      isLoadingCategories: true,
      errorMessage: '',
    );

    final result = await _getBlogCategoriesUseCase(const NoParams());

    result.fold(
      (failure) {
        _updateState(
          isLoadingCategories: false,
          errorMessage: _mapFailureToMessage(failure),
        );
      },
      (categories) {
        _updateState(
          isLoadingCategories: false,
          categories: categories,
        );
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
    _updateState(selectedBlog: null);
  }

  /// Refresh blogs
  Future<void> refreshBlogs() async {
    _currentPage = 1;
    await fetchBlogs(pageNumber: 1);
  }

  /// Clear error message
  void clearError() {
    _updateState(errorMessage: '');
  }

  /// Batch state updates to minimize notifyListeners() calls
  void _updateState({
    bool? isLoading,
    bool? isLoadingMore,
    bool? isLoadingCategories,
    List<Blog>? blogs,
    List<BlogCategory>? categories,
    Blog? selectedBlog,
    String? errorMessage,
    int? currentPage,
    int? totalPages,
    int? totalElements,
    String? selectedCategory,
    String? searchText,
  }) {
    bool hasChanges = false;

    if (isLoading != null && _isLoading != isLoading) {
      _isLoading = isLoading;
      hasChanges = true;
    }
    if (isLoadingMore != null && _isLoadingMore != isLoadingMore) {
      _isLoadingMore = isLoadingMore;
      hasChanges = true;
    }
    if (isLoadingCategories != null &&
        _isLoadingCategories != isLoadingCategories) {
      _isLoadingCategories = isLoadingCategories;
      hasChanges = true;
    }
    if (blogs != null && _blogs != blogs) {
      _blogs = blogs;
      hasChanges = true;
    }
    if (categories != null && _categories != categories) {
      _categories = categories;
      hasChanges = true;
    }
    if (selectedBlog != _selectedBlog) {
      _selectedBlog = selectedBlog;
      hasChanges = true;
    }
    if (errorMessage != _errorMessage) {
      _errorMessage = errorMessage;
      hasChanges = true;
    }
    if (currentPage != null && _currentPage != currentPage) {
      _currentPage = currentPage;
      hasChanges = true;
    }
    if (totalPages != null && _totalPages != totalPages) {
      _totalPages = totalPages;
      hasChanges = true;
    }
    if (totalElements != null && _totalElements != totalElements) {
      _totalElements = totalElements;
      hasChanges = true;
    }
    if (selectedCategory != _selectedCategory) {
      _selectedCategory = selectedCategory;
      hasChanges = true;
    }
    if (searchText != _searchText) {
      _searchText = searchText;
      hasChanges = true;
    }

    if (hasChanges) {
      notifyListeners();
    }
  }

  /// Map failure to user-friendly message
  String _mapFailureToMessage(Failure failure) {
    return failure.message;
  }
}
