import 'package:flutter/foundation.dart';
import '../../data/repositories/roadmap_repository_impl.dart';
import '../../domain/entities/roadmap.dart';

class RoadmapResultViewModel extends ChangeNotifier {
  final _repo = RoadmapRepositoryImpl();

  Roadmap? roadmap;
  bool isLoading = false;

  Future<void> loadRoadmap() async {
    isLoading = true;
    notifyListeners();

    roadmap = await _repo.fetchRoadmapMock();

    isLoading = false;
    notifyListeners();
  }
}
