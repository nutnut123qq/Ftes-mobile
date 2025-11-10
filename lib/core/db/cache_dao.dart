import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'app_database.dart';

class CacheDao {
  Future<void> put(String key, Map<String, dynamic> json) async {
    final db = await AppDatabase().database;
    await db.insert(
      'cache',
      {
        'key': key,
        'value': jsonEncode(json),
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> get(String key, {Duration? ttl}) async {
    final db = await AppDatabase().database;
    final rows = await db.query(
      'cache',
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    final row = rows.first;
    final createdAt = row['created_at'] as int? ?? 0;
    if (ttl != null && DateTime.now().millisecondsSinceEpoch - createdAt > ttl.inMilliseconds) {
      await db.delete('cache', where: 'key = ?', whereArgs: [key]);
      return null;
    }
    try {
      return jsonDecode(row['value'] as String) as Map<String, dynamic>;
    } catch (_) {
      await db.delete('cache', where: 'key = ?', whereArgs: [key]);
      return null;
    }
  }

  Future<void> invalidate(String key) async {
    final db = await AppDatabase().database;
    await db.delete('cache', where: 'key = ?', whereArgs: [key]);
  }
}




