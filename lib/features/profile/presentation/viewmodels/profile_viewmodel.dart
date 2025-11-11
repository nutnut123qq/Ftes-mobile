import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/profile.dart';
import '../../domain/usecases/profile_usecases.dart';
import '../../domain/constants/profile_constants.dart';
import '../../data/datasources/profile_local_datasource.dart';
import '../../../../core/error/failures.dart';

/// ViewModel for Profile operations
/// Optimized with minimal notifyListeners calls and parallel loading
class ProfileViewModel extends ChangeNotifier {
  final GetProfileByIdUseCase _getProfileByIdUseCase;
  final GetProfileByUsernameUseCase _getProfileByUsernameUseCase;
  final CreateProfileUseCase _createProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final CreateProfileAutoUseCase _createProfileAutoUseCase;
  final GetParticipantsCountUseCase _getParticipantsCountUseCase;
  final CheckApplyCourseUseCase _checkApplyCourseUseCase;
  final UploadImageUseCase _uploadImageUseCase;
  final ProfileLocalDataSource? _localDataSource;
  final SharedPreferences? _sharedPreferences;

  ProfileViewModel({
    required GetProfileByIdUseCase getProfileByIdUseCase,
    required GetProfileByUsernameUseCase getProfileByUsernameUseCase,
    required CreateProfileUseCase createProfileUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
    required CreateProfileAutoUseCase createProfileAutoUseCase,
    required GetParticipantsCountUseCase getParticipantsCountUseCase,
    required CheckApplyCourseUseCase checkApplyCourseUseCase,
    required UploadImageUseCase uploadImageUseCase,
    ProfileLocalDataSource? localDataSource,
    SharedPreferences? sharedPreferences,
  })  : _getProfileByIdUseCase = getProfileByIdUseCase,
        _getProfileByUsernameUseCase = getProfileByUsernameUseCase,
        _createProfileUseCase = createProfileUseCase,
        _updateProfileUseCase = updateProfileUseCase,
        _createProfileAutoUseCase = createProfileAutoUseCase,
        _getParticipantsCountUseCase = getParticipantsCountUseCase,
        _checkApplyCourseUseCase = checkApplyCourseUseCase,
        _uploadImageUseCase = uploadImageUseCase,
        _localDataSource = localDataSource,
        _sharedPreferences = sharedPreferences;

  // State variables
  Profile? _currentProfile;
  bool _isLoading = false;
  bool _isCreating = false;
  bool _isUpdating = false;
  bool _isUploading = false;
  String? _errorMessage;
  int _participantsCount = 0;
  int _applyCourseStatus = 0;

  // Getters
  Profile? get currentProfile => _currentProfile;
  bool get isLoading => _isLoading;
  bool get isCreating => _isCreating;
  bool get isUpdating => _isUpdating;
  bool get isUploading => _isUploading;
  String? get errorMessage => _errorMessage;
  int get participantsCount => _participantsCount;
  int get applyCourseStatus => _applyCourseStatus;

  /// Initialize ViewModel - load profile from cache if available
  /// This is called when ViewModel is created to restore cached data
  Future<void> initialize() async {
    if (_sharedPreferences == null || _localDataSource == null) return;
    
    try {
      final userId = _sharedPreferences!.getString(AppConstants.keyUserId);
      if (userId != null && userId.isNotEmpty) {
        await loadProfileFromCache(userId);
      }
    } catch (e) {
      debugPrint('Error initializing ProfileViewModel: $e');
    }
  }

  /// Load profile from cache immediately (without loading state)
  /// This is called first to show cached data instantly
  Future<void> loadProfileFromCache(String userId) async {
    final localDataSource = _localDataSource;
    if (localDataSource == null) return;
    
    try {
      final cached = await localDataSource
          .getCachedProfile(userId, ProfileConstants.profileCacheTTL);
      if (cached != null) {
        _currentProfile = cached.toEntity();
        notifyListeners();
      }
      
      // Also try to load participants count from cache
      final cachedCount = await localDataSource
          .getCachedParticipantsCount(userId, ProfileConstants.participantsCountCacheTTL);
      if (cachedCount != null) {
        _participantsCount = cachedCount;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading profile from cache: $e');
    }
  }

  /// Get profile by user ID with parallel loading of participants count
  /// This will load from cache first (via repository), then refresh from network
  Future<void> getProfileById(String userId) async {
    // If we already have profile from cache, don't show loading immediately
    final hasCachedProfile = _currentProfile != null;
    
    _isLoading = true;
    _errorMessage = null;
    if (!hasCachedProfile) {
      notifyListeners(); // Only notify if we don't have cached data
    }

    try {
      // Load profile and participants count in parallel
      final results = await Future.wait([
        _getProfileByIdUseCase(userId),
        _getParticipantsCountUseCase(userId),
      ]);

      // Handle profile result
      final profileResult = results[0] as Either<Failure, Profile>;
      profileResult.fold(
        (failure) => _errorMessage = _mapFailureToMessage(failure),
        (profile) => _currentProfile = profile,
      );

      // Handle participants count result
      final countResult = results[1] as Either<Failure, int>;
      countResult.fold(
        (failure) {
          // Don't set error if participants count fails, just log it
          debugPrint('Failed to get participants count: ${_mapFailureToMessage(failure)}');
        },
        (count) => _participantsCount = count,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners(); // Always notify at end
    }
  }

  /// Get profile by username
  Future<void> getProfileByUsername(String userName, {String? postId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Only once at start

    try {
      final result = await _getProfileByUsernameUseCase(
        GetProfileByUsernameParams(userName: userName, postId: postId),
      );
      result.fold(
        (failure) => _errorMessage = _mapFailureToMessage(failure),
        (profile) => _currentProfile = profile,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners(); // Only once at end
    }
  }

  /// Create new profile
  Future<bool> createProfile(String userId, Map<String, dynamic> requestData) async {
    _isCreating = true;
    _errorMessage = null;
    notifyListeners(); // Only once at start

    try {
      final result = await _createProfileUseCase(
        CreateProfileParams(userId: userId, requestData: requestData),
      );
      return result.fold(
        (failure) {
          _errorMessage = _mapFailureToMessage(failure);
          return false;
        },
        (profile) {
          _currentProfile = profile;
          return true;
        },
      );
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isCreating = false;
      notifyListeners(); // Only once at end
    }
  }

  /// Update existing profile
  Future<bool> updateProfile(String userId, Map<String, dynamic> requestData) async {
    _isUpdating = true;
    _errorMessage = null;
    notifyListeners(); // Only once at start

    try {
      final result = await _updateProfileUseCase(
        UpdateProfileParams(userId: userId, requestData: requestData),
      );
      return result.fold(
        (failure) {
          _errorMessage = _mapFailureToMessage(failure);
          return false;
        },
        (profile) {
          _currentProfile = profile;
          return true;
        },
      );
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isUpdating = false;
      notifyListeners(); // Only once at end
    }
  }

  /// Create profile automatically (for new users)
  Future<bool> createProfileAuto(String userId) async {
    _isCreating = true;
    _errorMessage = null;
    notifyListeners(); // Only once at start

    try {
      final result = await _createProfileAutoUseCase(userId);
      return result.fold(
        (failure) {
          _errorMessage = _mapFailureToMessage(failure);
          return false;
        },
        (profile) {
          _currentProfile = profile;
          return true;
        },
      );
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isCreating = false;
      notifyListeners(); // Only once at end
    }
  }

  /// Get participants count for instructor
  Future<void> getParticipantsCount(String instructorId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Only once at start

    try {
      final result = await _getParticipantsCountUseCase(instructorId);
      result.fold(
        (failure) => _errorMessage = _mapFailureToMessage(failure),
        (count) => _participantsCount = count,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners(); // Only once at end
    }
  }

  /// Check if user has applied to course
  Future<void> checkApplyCourse(String userId, String courseId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Only once at start

    try {
      final result = await _checkApplyCourseUseCase(
        CheckApplyCourseParams(userId: userId, courseId: courseId),
      );
      result.fold(
        (failure) => _errorMessage = _mapFailureToMessage(failure),
        (status) => _applyCourseStatus = status,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners(); // Only once at end
    }
  }

  /// Upload image
  Future<String?> uploadImage({
    required String filePath,
    String? fileName,
    String? description,
    String? allText,
    String? folderPath,
  }) async {
    _isUploading = true;
    _errorMessage = null;
    notifyListeners(); // Only once at start

    try {
      final result = await _uploadImageUseCase(
        UploadImageParams(
          filePath: filePath,
          fileName: fileName,
          description: description,
          allText: allText,
          folderPath: folderPath,
        ),
      );

      return result.fold(
        (failure) {
          _errorMessage = _mapFailureToMessage(failure);
          return null;
        },
        (response) {
          if (response.success && response.result != null) {
            return response.result!.cdnUrl;
          } else {
            _errorMessage = 'Upload failed';
            return null;
          }
        },
      );
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _isUploading = false;
      notifyListeners(); // Only once at end
    }
  }

  /// Clear current profile
  void clearProfile() {
    _currentProfile = null;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Map failure to user-friendly message
  String _mapFailureToMessage(Failure failure) {
    switch (failure) {
      case ServerFailure _:
        return 'Server error: ${failure.message}';
      case NetworkFailure _:
        return 'Network error: ${failure.message}';
      case CacheFailure _:
        return 'Cache error: ${failure.message}';
      case AuthFailure _:
        return 'Authentication error: ${failure.message}';
      case ValidationFailure _:
        return 'Validation error: ${failure.message}';
      default:
        return failure.message;
    }
  }
}
