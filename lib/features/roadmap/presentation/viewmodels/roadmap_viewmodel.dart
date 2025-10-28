import 'package:flutter/material.dart';
import '../../domain/entities/skills.dart';
import '../../domain/entities/roadmap.dart';
import '../../domain/usecases/generate_roadmap_usecase.dart';
import '../../domain/repositories/roadmap_repository.dart';
import '../../domain/constants/roadmap_constants.dart';
import '../../../../core/error/failures.dart';

class RoadmapViewModel extends ChangeNotifier {
  final GenerateRoadmapUseCase _generateRoadmapUseCase;
  
  RoadmapViewModel({required GenerateRoadmapUseCase generateRoadmapUseCase})
      : _generateRoadmapUseCase = generateRoadmapUseCase;

  Semester? semester;
  TargetMajor? target;
  final List<Skill> allSkills = const [
    Skill('c', 'C programming'),
    Skill('java_oop', 'Java OOP'),
    Skill('py', 'Python'),
    Skill('js', 'JavaScript'),
    Skill('htmlcss', 'HTML & CSS'),
    Skill('sql', 'SQL'),
    Skill('ds', 'Data Structures'),
    Skill('algo', 'Algorithms'),
    Skill('web', 'Web Development'),
    Skill('mobile', 'Mobile Development'),
    Skill('ml', 'Machine Learning'),
    Skill('dbdesign', 'Database Design'),
    Skill('git', 'Git'),
    Skill('docker', 'Docker'),
    Skill('cicd', 'CI/CD'),
  ];

  final Set<String> selectedSkillIds = {};

  // State management
  bool _isGenerating = false;
  String? _errorMessage;
  Roadmap? _generatedRoadmap;

  bool get isGenerating => _isGenerating;
  String? get errorMessage => _errorMessage;
  Roadmap? get generatedRoadmap => _generatedRoadmap;

  void _setGenerating(bool value) {
    _isGenerating = value;
    notifyListeners();
  }

  void _setError(String? msg) {
    _errorMessage = msg;
    notifyListeners();
  }

  void _setRoadmap(Roadmap? roadmap) {
    _generatedRoadmap = roadmap;
    notifyListeners();
  }

  void setSemester(Semester? v) {
    semester = v;
    notifyListeners();
  }

  void setTarget(TargetMajor? v) {
    target = v;
    notifyListeners();
  }

  void toggleSkill(String id) {
    if (selectedSkillIds.contains(id)) {
      selectedSkillIds.remove(id);
    } else {
      selectedSkillIds.add(id);
    }
    notifyListeners();
  }

  String get selectedCountLabel => 'Kỹ năng đã có (${selectedSkillIds.length})';

  Future<Roadmap?> submit(BuildContext context) async {
    _setGenerating(true);
    _setError(null);
    _setRoadmap(null);

    try {
      // Validate inputs
      if (semester == null) {
        _setError('Vui lòng chọn học kỳ');
        return null;
      }
      
      if (target == null) {
        _setError('Vui lòng chọn chuyên ngành');
        return null;
      }

      if (selectedSkillIds.isEmpty) {
        _setError('Vui lòng chọn ít nhất một kỹ năng');
        return null;
      }

      // Map enum to string
      final specialization = RoadmapConstants.getSpecializationString(target!.name);
      final currentSkills = selectedSkillIds.map((id) {
        return allSkills.firstWhere((skill) => skill.id == id).label;
      }).toList();

      // Create params
      final params = GenerateRoadmapParams(
        specialization: specialization,
        currentSkills: currentSkills,
        term: semester!.index + 1,
      );

      // Call use case
      final result = await _generateRoadmapUseCase(params);
      
      return result.fold(
        (failure) {
          String errorMsg;
          if (failure is ServerFailure) {
            errorMsg = failure.message;
          } else if (failure is NetworkFailure) {
            errorMsg = failure.message;
          } else if (failure is ValidationFailure) {
            errorMsg = failure.message;
          } else {
            errorMsg = RoadmapConstants.errorGeneratingRoadmap;
          }
          _setError(errorMsg);
          return null;
        },
        (roadmap) {
          _setRoadmap(roadmap);
          return roadmap;
        },
      );
    } catch (e) {
      _setError('${RoadmapConstants.errorGeneratingRoadmap}: $e');
      return null;
    } finally {
      _setGenerating(false);
    }
  }
}
