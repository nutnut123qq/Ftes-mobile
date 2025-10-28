class RoadmapSkill {
  final String skill;
  final String slugName;
  final String description;
  final int term;

  const RoadmapSkill({
    required this.skill,
    required this.slugName,
    required this.description,
    required this.term,
  });
}

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

class GenerationParams {
  final String specialization;
  final List<String> currentSkills;
  final int term;

  const GenerationParams({
    required this.specialization,
    required this.currentSkills,
    required this.term,
  });
}

class Roadmap {
  final List<String> currentSkills;
  final List<RoadmapSkill> skillsRoadMap;
  final int term;
  final GenerationParams generationParams;

  const Roadmap({
    required this.currentSkills,
    required this.skillsRoadMap,
    required this.term,
    required this.generationParams,
  });
}
