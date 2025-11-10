class MentorUiModel {
  final String name;
  final String specialization;
  final String avatarUrl;

  const MentorUiModel({
    required this.name,
    required this.specialization,
    required this.avatarUrl,
  });

  const MentorUiModel.fromTopMentor({
    required String name,
    required String specialty,
    required String imageUrl,
  })  : name = name,
        specialization = specialty,
        avatarUrl = imageUrl;
}

