import 'dart:convert';
import 'dart:io';
import '../models/exercise_response.dart';
import '../models/save_user_exercise_request.dart';
import '../models/user_exercise_response.dart';
import 'http_client.dart';

class ExerciseService {
  final HttpClient _httpClient = HttpClient();

  /// Get exercise by ID
  /// GET /api/exercises/{id}
  Future<ExerciseResponse> getExerciseById(int exerciseId) async {
    try {
      final response = await _httpClient.get(
        '/api/exercises/$exerciseId',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ExerciseResponse.fromJson(data);
      } else {
        throw HttpException(
          'Failed to get exercise: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error getting exercise: $e');
    }
  }

  /// Save/Submit user exercise answer
  /// POST /api/exercises/save-user-exercise
  Future<UserExerciseResponse> saveUserExercise(
    SaveUserExerciseRequest request,
  ) async {
    try {
      final response = await _httpClient.post(
        '/api/exercises/save-user-exercise',
        body: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return UserExerciseResponse.fromJson(data);
      } else {
        throw HttpException(
          'Failed to save user exercise: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error saving user exercise: $e');
    }
  }
}
