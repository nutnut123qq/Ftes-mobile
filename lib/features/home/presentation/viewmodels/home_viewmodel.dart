import 'dart:async' show unawaited, Timer;
import 'package:flutter/foundation.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/banner.dart';
import '../../domain/entities/category.dart' as home_category;
import '../../domain/usecases/get_latest_courses_usecase.dart';
import '../../domain/usecases/get_featured_courses_usecase.dart';
import '../../domain/usecases/get_banners_usecase.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/search_courses_usecase.dart';
import '../../domain/constants/home_constants.dart';
import 'package:ftes/core/error/failures.dart';
import 'package:ftes/core/usecases/usecase.dart';

/// ViewModel for home operations
class HomeViewModel extends ChangeNotifier {
  final GetLatestCoursesUseCase _getLatestCoursesUseCase;
  final GetFeaturedCoursesUseCase _getFeaturedCoursesUseCase;
  final GetBannersUseCase _getBannersUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;
  final SearchCoursesUseCase _searchCoursesUseCase;

  HomeViewModel({
    required GetLatestCoursesUseCase getLatestCoursesUseCase,
    required GetFeaturedCoursesUseCase getFeaturedCoursesUseCase,
    required GetBannersUseCase getBannersUseCase,
    required GetCategoriesUseCase getCategoriesUseCase,
    required SearchCoursesUseCase searchCoursesUseCase,
  })  : _getLatestCoursesUseCase = getLatestCoursesUseCase,
        _getFeaturedCoursesUseCase = getFeaturedCoursesUseCase,
        _getBannersUseCase = getBannersUseCase,
        _getCategoriesUseCase = getCategoriesUseCase,
        _searchCoursesUseCase = searchCoursesUseCase;

  // State variables
  List<Course> _latestCourses = [];
  List<Course> _featuredCourses = [];
  List<Banner> _banners = [];
  List<home_category.Category> _categories = [];
  List<Course> _categoryCourses = [];
  bool _isLoadingLatestCourses = false;
  bool _isLoadingFeaturedCourses = false;
  bool _isLoadingBanners = false;
  bool _isLoadingCategories = false;
  bool _isLoadingCategoryCourses = false;
  String? _errorMessage;
  String? _selectedCategoryId;
  List<Course> _searchSuggestions = [];
  bool _isSearching = false;

  // Getters
  List<Course> get latestCourses => _latestCourses;
  List<Course> get featuredCourses => _featuredCourses;
  List<Banner> get banners => _banners;
  List<home_category.Category> get categories => _categories;
  List<Course> get categoryCourses => _categoryCourses;
  List<Course> get searchSuggestions => _searchSuggestions;
  bool get isLoadingLatestCourses => _isLoadingLatestCourses;
  bool get isLoadingFeaturedCourses => _isLoadingFeaturedCourses;
  bool get isLoadingBanners => _isLoadingBanners;
  bool get isLoadingCategories => _isLoadingCategories;
  bool get isLoadingCategoryCourses => _isLoadingCategoryCourses;
  String? get errorMessage => _errorMessage;
  String? get selectedCategoryId => _selectedCategoryId;
  bool get isLoading => _isLoadingLatestCourses || _isLoadingFeaturedCourses || _isLoadingBanners;
  bool get isSearching => _isSearching;

  // Search debounce state
  Timer? _searchDebounceTimer;
  String? _currentSearchQuery;

  /// Initialize the ViewModel - fetch all data
  /// Optimized to minimize notifyListeners() calls
  Future<void> initialize() async {
    // Progressive loading: load parts in parallel and notify as each completes
    unawaited(_fetchLatestCoursesInternal().then((_) {
      _selectedCategoryId ??= HomeConstants.defaultCategoryId;
      _categoryCourses = _latestCourses;
      notifyListeners();
    }));
    unawaited(_fetchFeaturedCoursesInternal().then((_) => notifyListeners()));
    unawaited(_fetchBannersInternal().then((_) => notifyListeners()));
  }

  /// Search courses to provide suggestions (debounced from UI)
  Future<void> searchCoursesSuggestions(String keyword) async {
    _currentSearchQuery = keyword.trim();
    _searchDebounceTimer?.cancel();

    if (_currentSearchQuery!.isEmpty) {
      _searchSuggestions = [];
      notifyListeners();
      return;
    }
    _isSearching = true;
    notifyListeners();

    _searchDebounceTimer = Timer(const Duration(milliseconds: 300), () async {
      final query = _currentSearchQuery;
      final result = await _searchCoursesUseCase(SearchCoursesParams(
        code: query,
        pageNumber: 1,
        pageSize: 10,
        sortField: 'title',
        sortOrder: 'ASC',
      ));

      // Only apply if query is still current
      if (_currentSearchQuery == query) {
        result.fold(
          (_) {
            _searchSuggestions = [];
            _isSearching = false;
            notifyListeners();
          },
          (courses) {
            _searchSuggestions = courses;
            _isSearching = false;
            notifyListeners();
          },
        );
      }
    });
  }
  
  /// Internal method to fetch latest courses without notifying listeners
  Future<void> _fetchLatestCoursesInternal() async {
    _isLoadingLatestCourses = true;

    final result = await _getLatestCoursesUseCase(
      GetLatestCoursesParams(limit: HomeConstants.defaultPageSize),
    );

    result.fold(
      (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        _isLoadingLatestCourses = false;
      },
      (courses) {
        _latestCourses = courses;
        _isLoadingLatestCourses = false;
      },
    );
  }
  
  /// Internal method to fetch featured courses without notifying listeners
  Future<void> _fetchFeaturedCoursesInternal() async {
    _isLoadingFeaturedCourses = true;

    final result = await _getFeaturedCoursesUseCase(const NoParams());

    result.fold(
      (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        _isLoadingFeaturedCourses = false;
      },
      (courses) {
        _featuredCourses = courses;
        _isLoadingFeaturedCourses = false;
      },
    );
  }
  
  /// Internal method to fetch banners without notifying listeners
  Future<void> _fetchBannersInternal() async {
    _isLoadingBanners = true;

    final result = await _getBannersUseCase(const NoParams());

    result.fold(
      (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        _isLoadingBanners = false;
      },
      (banners) {
        _banners = banners;
        _isLoadingBanners = false;
      },
    );
  }

  /// Fetch latest courses
  Future<void> fetchLatestCourses({int limit = 50}) async {
    _setLoadingLatestCourses(true);
    _clearError();

    final result = await _getLatestCoursesUseCase(GetLatestCoursesParams(limit: limit));

    result.fold(
      (failure) {
        _setError(_mapFailureToMessage(failure));
        _setLoadingLatestCourses(false);
      },
      (courses) {
        _latestCourses = courses;
        _setLoadingLatestCourses(false);
        notifyListeners();
      },
    );
  }

  /// Fetch featured courses
  Future<void> fetchFeaturedCourses() async {
    _setLoadingFeaturedCourses(true);
    _clearError();

    final result = await _getFeaturedCoursesUseCase(const NoParams());

    result.fold(
      (failure) {
        _setError(_mapFailureToMessage(failure));
        _setLoadingFeaturedCourses(false);
      },
      (courses) {
        _featuredCourses = courses;
        _setLoadingFeaturedCourses(false);
        notifyListeners();
      },
    );
  }

  /// Fetch banners
  Future<void> fetchBanners() async {
    _setLoadingBanners(true);
    _clearError();

    final result = await _getBannersUseCase(const NoParams());

    result.fold(
      (failure) {
        _setError(_mapFailureToMessage(failure));
        _setLoadingBanners(false);
      },
      (banners) {
        _banners = banners;
        _setLoadingBanners(false);
        notifyListeners();
      },
    );
  }

  /// Refresh all data
  Future<void> refreshData() async {
    await initialize();
  }

  /// Clear error message
  void clearError() {
    _clearError();
  }

  // Private helper methods
  void _setLoadingLatestCourses(bool loading) {
    _isLoadingLatestCourses = loading;
    notifyListeners();
  }

  void _setLoadingFeaturedCourses(bool loading) {
    _isLoadingFeaturedCourses = loading;
    notifyListeners();
  }

  void _setLoadingBanners(bool loading) {
    _isLoadingBanners = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
  }

  void _clearError() {
    _errorMessage = null;
  }

  /// Map failure to user-friendly message
  String _mapFailureToMessage(Failure failure) {
    return failure.message;
  }

  /// Fetch course categories from API
  Future<void> fetchCategories() async {
    _setLoadingCategories(true);
    _clearError();
    
    final result = await _getCategoriesUseCase(const NoParams());
    
    result.fold(
      (failure) {
        _setError(_mapFailureToMessage(failure));
        _setLoadingCategories(false);
      },
      (categories) {
        // Add "Tất cả" category at the beginning
        _categories = [
          const home_category.Category(
            id: HomeConstants.defaultCategoryId,
            name: HomeConstants.defaultCategoryName,
            slug: HomeConstants.defaultCategoryId,
            description: 'Tất cả khóa học',
            active: true,
          ),
          ...categories,
        ];
        
        // Set default selected category to "Tất cả" if not already set
        if (_selectedCategoryId == null) {
          _selectedCategoryId = HomeConstants.defaultCategoryId;
          _categoryCourses = _latestCourses;
        }
        
        _setLoadingCategories(false);
        notifyListeners();
      },
    );
  }

  /// Fetch courses by category
  Future<void> fetchCoursesByCategory(String categoryId) async {
    _isLoadingCategoryCourses = true;
    _selectedCategoryId = categoryId;
    _clearError();
    
    // Notify once at the start for loading state
    notifyListeners();
    
    // Filter existing courses by category
    // This avoids unnecessary API calls since we already have all courses
    if (categoryId == HomeConstants.defaultCategoryId) {
      _categoryCourses = _latestCourses;
    } else {
      _categoryCourses = _latestCourses
          .where((course) => course.categoryId == categoryId)
          .toList();
    }
    
    _isLoadingCategoryCourses = false;
    
    // Notify once at the end with the results
    notifyListeners();
  }

  void _setLoadingCategories(bool loading) {
    _isLoadingCategories = loading;
    notifyListeners();
  }
}
