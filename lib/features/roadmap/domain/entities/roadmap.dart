class RoadmapStep {
  final String title;
  final String description;
  final bool hasCourse;
  final String? buttonLabel;

  RoadmapStep({
    required this.title,
    required this.description,
    this.hasCourse = false,
    this.buttonLabel,
  });
}

class Roadmap {
  final List<String> skills;
  final List<RoadmapStep> steps;

  Roadmap({
    required this.skills,
    required this.steps,
  });
}
