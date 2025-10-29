import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/database_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/course_detail_model.dart';
import 'course_local_datasource.dart';

/// Implementation of CourseLocalDataSource
class CourseLocalDataSourceImpl implements CourseLocalDataSource {
  final AppDatabase _database;

  CourseLocalDataSourceImpl({required AppDatabase database})
      : _database = database;

  @override
  Future<void> cacheCourseDetail(String courseId, CourseDetailModel courseDetail) async {
    try {
      final db = await _database.database;
      final now = DateTime.now().millisecondsSinceEpoch;
      final expiry = now + DatabaseConstants.cacheTTL;

      // Serialize to JSON in isolate for better performance
      final jsonString = await compute(_serializeCourseDetail, courseDetail);

      await db.insert(
        DatabaseConstants.tableCourseCache,
        {
          DatabaseConstants.columnId: courseId,
          DatabaseConstants.columnData: jsonString,
          DatabaseConstants.columnTimestamp: now,
          DatabaseConstants.columnExpiry: expiry,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      print('✅ Course cached: $courseId');
    } catch (e) {
      print('❌ Cache course error: $e');
      throw CacheException('Failed to cache course: $e');
    }
  }

  @override
  Future<CourseDetailModel?> getCachedCourseDetail(String courseId) async {
    try {
      final db = await _database.database;
      final List<Map<String, dynamic>> maps = await db.query(
        DatabaseConstants.tableCourseCache,
        where: '${DatabaseConstants.columnId} = ?',
        whereArgs: [courseId],
      );

      if (maps.isEmpty) {
        print('📦 Cache miss: $courseId');
        return null;
      }

      final cacheData = maps.first;
      final expiry = cacheData[DatabaseConstants.columnExpiry] as int;
      final now = DateTime.now().millisecondsSinceEpoch;

      // Check if cache is expired
      if (now > expiry) {
        print('⏰ Cache expired: $courseId');
        await clearCourseCache(courseId);
        return null;
      }

      print('✅ Cache hit: $courseId');
      final jsonString = cacheData[DatabaseConstants.columnData] as String;

      // Deserialize from JSON in isolate for better performance
      return await compute(_deserializeCourseDetail, jsonString);
    } catch (e) {
      print('❌ Get cached course error: $e');
      throw CacheException('Failed to get cached course: $e');
    }
  }

  @override
  Future<bool> isCacheValid(String courseId) async {
    try {
      final db = await _database.database;
      final List<Map<String, dynamic>> maps = await db.query(
        DatabaseConstants.tableCourseCache,
        columns: [DatabaseConstants.columnExpiry],
        where: '${DatabaseConstants.columnId} = ?',
        whereArgs: [courseId],
      );

      if (maps.isEmpty) return false;

      final expiry = maps.first[DatabaseConstants.columnExpiry] as int;
      final now = DateTime.now().millisecondsSinceEpoch;

      return now <= expiry;
    } catch (e) {
      print('❌ Check cache validity error: $e');
      return false;
    }
  }

  @override
  Future<void> clearCourseCache(String courseId) async {
    try {
      final db = await _database.database;
      await db.delete(
        DatabaseConstants.tableCourseCache,
        where: '${DatabaseConstants.columnId} = ?',
        whereArgs: [courseId],
      );
      print('🗑️ Cache cleared: $courseId');
    } catch (e) {
      print('❌ Clear course cache error: $e');
      throw CacheException('Failed to clear course cache: $e');
    }
  }

  @override
  Future<void> clearAllCache() async {
    try {
      await _database.clearAllCache();
      print('🗑️ All course cache cleared');
    } catch (e) {
      print('❌ Clear all cache error: $e');
      throw CacheException('Failed to clear all cache: $e');
    }
  }
}

// Top-level functions for compute isolate
String _serializeCourseDetail(CourseDetailModel courseDetail) {
  return jsonEncode(courseDetail.toJson());
}

CourseDetailModel _deserializeCourseDetail(String jsonString) {
  final json = jsonDecode(jsonString) as Map<String, dynamic>;
  return CourseDetailModel.fromJson(json);
}

