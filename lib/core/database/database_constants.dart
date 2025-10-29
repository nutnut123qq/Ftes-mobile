/// Database constants for the application
class DatabaseConstants {
  DatabaseConstants._();

  // Database info
  static const String databaseName = 'ftes_app.db';
  static const int databaseVersion = 1;

  // Table names
  static const String tableCourseCache = 'course_cache';

  // Common columns
  static const String columnId = 'id';
  static const String columnData = 'data';
  static const String columnTimestamp = 'timestamp';
  static const String columnExpiry = 'expiry';

  // Cache TTL (Time To Live) in milliseconds
  static const int cacheTTL = 3600000; // 1 hour

  // SQL Create statements
  static const String createCourseCache = '''
    CREATE TABLE $tableCourseCache (
      $columnId TEXT PRIMARY KEY,
      $columnData TEXT NOT NULL,
      $columnTimestamp INTEGER NOT NULL,
      $columnExpiry INTEGER NOT NULL
    )
  ''';
}

