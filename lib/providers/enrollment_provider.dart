import 'package:flutter/foundation.dart';
import '../services/course_service.dart';

/// Provider to manage enrollment status for courses
class EnrollmentProvider extends ChangeNotifier {
  final CourseService _courseService = CourseService();
  
  // Map to store enrollment status by course ID
  final Map<String, bool> _enrollmentStatus = {};
  
  // Set to track courses being checked
  final Set<String> _checkingCourses = {};
  
  /// Get enrollment status for a course
  bool isEnrolled(String courseId) {
    return _enrollmentStatus[courseId] ?? false;
  }
  
  /// Check if we're currently checking enrollment for a course
  bool isCheckingEnrollment(String courseId) {
    return _checkingCourses.contains(courseId);
  }
  
  /// Check enrollment status for a course
  Future<bool> checkEnrollment(String courseId) async {
    if (courseId.isEmpty) return false;
    
    // If we already have the status, return it
    if (_enrollmentStatus.containsKey(courseId)) {
      return _enrollmentStatus[courseId]!;
    }
    
    // If already checking this course, return current status
    if (_checkingCourses.contains(courseId)) {
      return _enrollmentStatus[courseId] ?? false;
    }
    
    try {
      _checkingCourses.add(courseId);
      notifyListeners();
      
      final isEnrolled = await _courseService.checkEnrollment(courseId);
      
      _enrollmentStatus[courseId] = isEnrolled;
      _checkingCourses.remove(courseId);
      notifyListeners();
      
      return isEnrolled;
    } catch (e) {
      _checkingCourses.remove(courseId);
      _enrollmentStatus[courseId] = false;
      notifyListeners();
      return false;
    }
  }
  
  /// Check enrollment for multiple courses
  Future<void> checkEnrollmentForCourses(List<String> courseIds) async {
    // Start all checks concurrently
    final futures = courseIds
        .where((id) => id.isNotEmpty && !_enrollmentStatus.containsKey(id))
        .map((id) => checkEnrollment(id))
        .toList();
    
    if (futures.isNotEmpty) {
      await Future.wait(futures);
    }
  }
  
  /// Enroll in a course and update local status
  Future<bool> enrollCourse(String courseId) async {
    if (courseId.isEmpty) return false;
    
    try {
      await _courseService.enrollCourse(courseId);
      
      // Update local status
      _enrollmentStatus[courseId] = true;
      notifyListeners();
      
      return true;
    } catch (e) {
      return false;
    }
  }
  
  /// Refresh enrollment status for a specific course
  Future<void> refreshEnrollmentStatus(String courseId) async {
    if (courseId.isEmpty) {
      return;
    }
    
    // Remove from cache and check again
    _enrollmentStatus.remove(courseId);
    
    await checkEnrollment(courseId);
  }
  
  /// Refresh enrollment status for all cached courses
  Future<void> refreshAllEnrollmentStatus() async {
    final courseIds = _enrollmentStatus.keys.toList();
    
    // Clear cache
    _enrollmentStatus.clear();
    notifyListeners();
    
    // Re-check all courses
    await checkEnrollmentForCourses(courseIds);
  }
  
  /// Clear all enrollment status (e.g., on logout)
  void clearEnrollmentStatus() {
    _enrollmentStatus.clear();
    _checkingCourses.clear();
    notifyListeners();
  }
  
  /// Get enrollment status map (for debugging)
  Map<String, bool> get enrollmentStatusMap => Map.unmodifiable(_enrollmentStatus);
}