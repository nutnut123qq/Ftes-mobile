import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'database_constants.dart';

/// Singleton Database manager for the application
class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  static Database? _database;

  factory AppDatabase() => _instance;

  AppDatabase._internal();

  /// Get database instance (singleton)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize database
  Future<Database> _initDatabase() async {
    try {
      // Get the application documents directory
      final Directory documentsDirectory = await getApplicationDocumentsDirectory();
      final String path = join(documentsDirectory.path, DatabaseConstants.databaseName);

      // Open the database
      return await openDatabase(
        path,
        version: DatabaseConstants.databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    } catch (e) {
      throw Exception('Failed to initialize database: $e');
    }
  }

  /// Create tables
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(DatabaseConstants.createCourseCache);
  }

  /// Upgrade database schema
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database migrations here if needed
    if (oldVersion < newVersion) {
      // Example: Add new tables or columns
    }
  }

  /// Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  /// Clear all cache (utility method)
  Future<void> clearAllCache() async {
    final db = await database;
    await db.delete(DatabaseConstants.tableCourseCache);
  }

  /// Clean expired cache
  Future<void> cleanExpiredCache() async {
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;
    await db.delete(
      DatabaseConstants.tableCourseCache,
      where: '${DatabaseConstants.columnExpiry} < ?',
      whereArgs: [now],
    );
  }
}

