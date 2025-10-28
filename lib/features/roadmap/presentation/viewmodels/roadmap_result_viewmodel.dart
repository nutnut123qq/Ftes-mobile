import 'package:flutter/foundation.dart';
import '../../domain/entities/roadmap.dart';

class RoadmapResultViewModel extends ChangeNotifier {
  final Roadmap roadmap;

  RoadmapResultViewModel({required this.roadmap});

  // Simple getters for display
  List<String> get currentSkills => roadmap.currentSkills;
  List<RoadmapSkill> get skillsRoadMap => roadmap.skillsRoadMap;
  int get term => roadmap.term;
  GenerationParams get generationParams => roadmap.generationParams;
}
