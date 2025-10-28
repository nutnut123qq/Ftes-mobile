import 'package:flutter/material.dart';
import '../../domain/entities/skills.dart';

class RoadmapViewModel extends ChangeNotifier {
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

  // --- thêm state loading như team ---
  bool _isBusy = false;
  String? _errorMessage;

  bool get isBusy => _isBusy;
  String? get errorMessage => _errorMessage;

  void _setBusy(bool value) {
    _isBusy = value;
    notifyListeners();
  }

  void _setError(String? msg) {
    _errorMessage = msg;
    notifyListeners();
  }

  // -------------------------------

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

  Future<void> submit(BuildContext context) async {
    _setBusy(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 400));

      final snack = SnackBar(
        content: Text(
          'Học kỳ: ${semester?.name.toUpperCase() ?? '-'}, '
              'Ngành: ${target?.name ?? '-'}, '
              'Skills: ${selectedSkillIds.length}',
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snack);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setBusy(false);
    }
  }
}
