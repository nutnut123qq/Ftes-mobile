import 'package:flutter/foundation.dart';
import '../../domain/entities/profile.dart';
import '../../domain/usecases/profile_usecases.dart';
import '../../../../core/error/failures.dart';

/// ViewModel for Profile operations
class ProfileViewModel extends ChangeNotifier {
  final GetProfileByIdUseCase _getProfileByIdUseCase;
  final GetProfileByUsernameUseCase _getProfileByUsernameUseCase;
  final CreateProfileUseCase _createProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final CreateProfileAutoUseCase _createProfileAutoUseCase;
  final GetParticipantsCountUseCase _getParticipantsCountUseCase;
  final CheckApplyCourseUseCase _checkApplyCourseUseCase;
  final UploadImageUseCase _uploadImageUseCase;

  ProfileViewModel({
    required GetProfileByIdUseCase getProfileByIdUseCase,
    required GetProfileByUsernameUseCase getProfileByUsernameUseCase,
    required CreateProfileUseCase createProfileUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
    required CreateProfileAutoUseCase createProfileAutoUseCase,
    required GetParticipantsCountUseCase getParticipantsCountUseCase,
    required CheckApplyCourseUseCase checkApplyCourseUseCase,
    required UploadImageUseCase uploadImageUseCase,
  })  : _getProfileByIdUseCase = getProfileByIdUseCase,
        _getProfileByUsernameUseCase = getProfileByUsernameUseCase,
        _createProfileUseCase = createProfileUseCase,
        _updateProfileUseCase = updateProfileUseCase,
        _createProfileAutoUseCase = createProfileAutoUseCase,
        _getParticipantsCountUseCase = getParticipantsCountUseCase,
        _checkApplyCourseUseCase = checkApplyCourseUseCase,
        _uploadImageUseCase = uploadImageUseCase;

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

  /// Get profile by user ID
  Future<void> getProfileById(String userId) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _getProfileByIdUseCase(userId);
      result.fold(
        (failure) => _setError(_mapFailureToMessage(failure)),
        (profile) {
          _currentProfile = profile;
          notifyListeners();
        },
      );
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Get profile by username
  Future<void> getProfileByUsername(String userName, {String? postId}) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _getProfileByUsernameUseCase(
        GetProfileByUsernameParams(userName: userName, postId: postId),
      );
      result.fold(
        (failure) => _setError(_mapFailureToMessage(failure)),
        (profile) {
          _currentProfile = profile;
          notifyListeners();
        },
      );
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Create new profile
  Future<bool> createProfile(String userId, Map<String, dynamic> requestData) async {
    _setCreating(true);
    _clearError();

    try {
      final result = await _createProfileUseCase(
        CreateProfileParams(userId: userId, requestData: requestData),
      );
      return result.fold(
        (failure) {
          _setError(_mapFailureToMessage(failure));
          return false;
        },
        (profile) {
          _currentProfile = profile;
          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setCreating(false);
    }
  }

  /// Update existing profile
  Future<bool> updateProfile(String userId, Map<String, dynamic> requestData) async {
    _setUpdating(true);
    _clearError();

    try {
      final result = await _updateProfileUseCase(
        UpdateProfileParams(userId: userId, requestData: requestData),
      );
      return result.fold(
        (failure) {
          _setError(_mapFailureToMessage(failure));
          return false;
        },
        (profile) {
          _currentProfile = profile;
          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setUpdating(false);
    }
  }

  /// Create profile automatically (for new users)
  Future<bool> createProfileAuto(String userId) async {
    _setCreating(true);
    _clearError();

    try {
      final result = await _createProfileAutoUseCase(userId);
      return result.fold(
        (failure) {
          _setError(_mapFailureToMessage(failure));
          return false;
        },
        (profile) {
          _currentProfile = profile;
          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setCreating(false);
    }
  }

  /// Get participants count for instructor
  Future<void> getParticipantsCount(String instructorId) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _getParticipantsCountUseCase(instructorId);
      result.fold(
        (failure) => _setError(_mapFailureToMessage(failure)),
        (count) {
          _participantsCount = count;
          notifyListeners();
        },
      );
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Check if user has applied to course
  Future<void> checkApplyCourse(String userId, String courseId) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _checkApplyCourseUseCase(
        CheckApplyCourseParams(userId: userId, courseId: courseId),
      );
      result.fold(
        (failure) => _setError(_mapFailureToMessage(failure)),
        (status) {
          _applyCourseStatus = status;
          notifyListeners();
        },
      );
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
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
    _setUploading(true);
    _clearError();

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
          _setError(_mapFailureToMessage(failure));
          return null;
        },
        (response) {
          if (response.success && response.result != null) {
            return response.result!.cdnUrl;
          } else {
            _setError('Upload failed');
            return null;
          }
        },
      );
    } catch (e) {
      _setError(e.toString());
      return null;
    } finally {
      _setUploading(false);
    }
  }

  /// Clear current profile
  void clearProfile() {
    _currentProfile = null;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _clearError();
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setCreating(bool creating) {
    _isCreating = creating;
    notifyListeners();
  }

  void _setUpdating(bool updating) {
    _isUpdating = updating;
    notifyListeners();
  }

  void _setUploading(bool uploading) {
    _isUploading = uploading;
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
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error: ${failure.message}';
      case NetworkFailure:
        return 'Network error: ${failure.message}';
      case CacheFailure:
        return 'Cache error: ${failure.message}';
      case AuthFailure:
        return 'Authentication error: ${failure.message}';
      case ValidationFailure:
        return 'Validation error: ${failure.message}';
      default:
        return failure.message;
    }
  }
}
