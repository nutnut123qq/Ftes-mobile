abstract class LessonLocalDataSource {
  Future<void> cacheLesson(String lessonId, Map<String, dynamic> json, Duration ttl);
  Future<Map<String, dynamic>?> getCachedLesson(String lessonId, Duration ttl);
  Future<void> invalidateLesson(String lessonId);
}




