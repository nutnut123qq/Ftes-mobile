import 'package:flutter/foundation.dart';
import '../models/exercise_response.dart';
import '../models/save_user_exercise_request.dart';
import '../models/user_exercise_response.dart';
import '../services/exercise_service.dart';

class ExerciseProvider with ChangeNotifier {
  final ExerciseService _exerciseService = ExerciseService();

  // Current exercise
  ExerciseResponse? _currentExercise;
  ExerciseResponse? get currentExercise => _currentExercise;

  // Last submission result
  UserExerciseResponse? _lastSubmission;
  UserExerciseResponse? get lastSubmission => _lastSubmission;

  // Loading states
  bool _isLoading = false;
  bool _isSubmitting = false;

  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;

  // Error state
  String? _error;
  String? get error => _error;

  /// Load exercise by ID
  Future<void> loadExercise(int exerciseId) async {
    try {
      _isLoading = true;
      _error = null;
      _currentExercise = null;
      _lastSubmission = null;
      notifyListeners();

      _currentExercise = await _exerciseService.getExerciseById(exerciseId);
      _error = null;
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) {
        print('Error loading exercise: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Submit user exercise answer
  Future<bool> submitAnswer(SaveUserExerciseRequest request) async {
    try {
      _isSubmitting = true;
      _error = null;
      notifyListeners();

      _lastSubmission = await _exerciseService.saveUserExercise(request);
      
      _isSubmitting = false;
      notifyListeners();
      
      return true;
    } catch (e) {
      _error = e.toString();
      _isSubmitting = false;
      notifyListeners();
      
      if (kDebugMode) {
        print('Error submitting answer: $e');
      }
      return false;
    }
  }

  /// Clear exercise data
  void clear() {
    _currentExercise = null;
    _lastSubmission = null;
    _isLoading = false;
    _isSubmitting = false;
    _error = null;
    notifyListeners();
  }
}
