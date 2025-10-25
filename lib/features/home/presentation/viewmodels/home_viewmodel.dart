import 'package:flutter/foundation.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/banner.dart';
import '../../domain/entities/category.dart' as home_category;
import '../../domain/usecases/get_latest_courses_usecase.dart';
import '../../domain/usecases/get_featured_courses_usecase.dart';
import '../../domain/usecases/get_banners_usecase.dart';
import 'package:ftes/core/error/failures.dart';
import 'package:ftes/core/usecases/usecase.dart';

/// ViewModel for home operations
class HomeViewModel extends ChangeNotifier {
  final GetLatestCoursesUseCase _getLatestCoursesUseCase;
  final GetFeaturedCoursesUseCase _getFeaturedCoursesUseCase;
  final GetBannersUseCase _getBannersUseCase;

  HomeViewModel({
    required GetLatestCoursesUseCase getLatestCoursesUseCase,
    required GetFeaturedCoursesUseCase getFeaturedCoursesUseCase,
    required GetBannersUseCase getBannersUseCase,
  })  : _getLatestCoursesUseCase = getLatestCoursesUseCase,
        _getFeaturedCoursesUseCase = getFeaturedCoursesUseCase,
        _getBannersUseCase = getBannersUseCase;

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

  // Getters
  List<Course> get latestCourses => _latestCourses;
  List<Course> get featuredCourses => _featuredCourses;
  List<Banner> get banners => _banners;
  List<home_category.Category> get categories => _categories;
  List<Course> get categoryCourses => _categoryCourses;
  bool get isLoadingLatestCourses => _isLoadingLatestCourses;
  bool get isLoadingFeaturedCourses => _isLoadingFeaturedCourses;
  bool get isLoadingBanners => _isLoadingBanners;
  bool get isLoadingCategories => _isLoadingCategories;
  bool get isLoadingCategoryCourses => _isLoadingCategoryCourses;
  String? get errorMessage => _errorMessage;
  String? get selectedCategoryId => _selectedCategoryId;
  bool get isLoading => _isLoadingLatestCourses || _isLoadingFeaturedCourses || _isLoadingBanners;

  /// Initialize the ViewModel - fetch all data
  Future<void> initialize() async {
    await Future.wait([
      fetchLatestCourses(),
      fetchFeaturedCourses(),
      fetchBanners(),
    ]);
    
    // Set default selected category to "Tất cả"
    _selectedCategoryId = 'all';
    _categoryCourses = _latestCourses;
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

  /// Fetch course categories
  Future<void> fetchCategories() async {
    _setLoadingCategories(true);
    _clearError();
    
    // TODO: Implement with use case
    // For now, we'll use hardcoded categories
    _categories = [
      const home_category.Category(
        id: 'all',
        name: 'Tất cả',
        slug: 'all',
        description: 'Tất cả khóa học',
        active: true,
      ),
      const home_category.Category(
        id: '2837e815-2ed8-49af-b0c3-6d3d8d883640',
        name: 'Kỹ Thuật Phần Mềm',
        slug: 'ky-thuat-phan-mem',
        description: 'Khóa học lập trình và phát triển phần mềm',
        active: true,
      ),
      const home_category.Category(
        id: '2bbb2eed-d14d-43f2-b4a9-28fe867d49cb',
        name: 'Toán Học',
        slug: 'toan-hoc',
        description: 'Khóa học toán học và thống kê',
        active: true,
      ),
      const home_category.Category(
        id: 'bc669cc6-a425-4af3-93b7-7eb66f666649',
        name: 'Ngoại Ngữ',
        slug: 'ngoai-ngu',
        description: 'Khóa học ngoại ngữ',
        active: true,
      ),
    ];
    
    _setLoadingCategories(false);
    
    // Set default selected category to "Tất cả" if not already set
    if (_selectedCategoryId == null) {
      _selectedCategoryId = 'all';
      _categoryCourses = _latestCourses;
    }
    
    notifyListeners();
  }

  /// Fetch courses by category
  Future<void> fetchCoursesByCategory(String categoryId) async {
    _setLoadingCategoryCourses(true);
    _clearError();
    _selectedCategoryId = categoryId;
    
    // TODO: Implement with use case
    // For now, filter existing courses by category
    if (categoryId == 'all') {
      _categoryCourses = _latestCourses;
    } else {
      _categoryCourses = _latestCourses.where((course) => course.categoryId == categoryId).toList();
    }
    
    _setLoadingCategoryCourses(false);
    notifyListeners();
  }

  void _setLoadingCategories(bool loading) {
    _isLoadingCategories = loading;
    notifyListeners();
  }

  void _setLoadingCategoryCourses(bool loading) {
    _isLoadingCategoryCourses = loading;
    notifyListeners();
  }
}
