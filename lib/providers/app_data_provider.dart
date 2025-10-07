import 'package:flutter/foundation.dart';
import '../services/app_data_service.dart';

class AppDataProvider extends ChangeNotifier {
  final AppDataService _service = AppDataService();

  Map<String, dynamic>? myInfo;
  Map<String, dynamic>? introspect;
  List<dynamic> banners = [];
  List<dynamic> featuredCourses = [];

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  void _setError(String? e) {
    _error = e;
    notifyListeners();
  }

  Future<void> loadAll(String? token) async {
    _setLoading(true);
    _setError(null);
    try {
      if (token != null) {
        introspect = await _service.introspectToken(token: token);
        myInfo = await _service.fetchMyInfo();
      }

      banners = await _service.fetchBanners();
      featuredCourses = await _service.fetchFeaturedCourses();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
}
