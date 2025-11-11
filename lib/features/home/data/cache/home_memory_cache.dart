import 'dart:collection';

class _CacheEntry<T> {
  final T data;
  final int createdAtMs;
  _CacheEntry(this.data) : createdAtMs = DateTime.now().millisecondsSinceEpoch;
  bool isExpired(Duration ttl) =>
      DateTime.now().millisecondsSinceEpoch - createdAtMs > ttl.inMilliseconds;
}

/// Simple in-memory LRU cache with TTL per get
class HomeMemoryCache<T> {
  final int maxEntries;
  final LinkedHashMap<String, _CacheEntry<T>> _map = LinkedHashMap();

  HomeMemoryCache({this.maxEntries = 50});

  T? get(String key, {Duration? ttl}) {
    final entry = _map.remove(key);
    if (entry == null) return null;
    if (ttl != null && entry.isExpired(ttl)) {
      return null;
    }
    // re-insert to mark as most recently used
    _map[key] = entry;
    return entry.data;
  }

  void set(String key, T value) {
    if (_map.length >= maxEntries) {
      // remove least recently used (first)
      _map.remove(_map.keys.first);
    }
    _map[key] = _CacheEntry(value);
  }

  void invalidate(String key) {
    _map.remove(key);
  }

  void clear() {
    _map.clear();
  }
}


