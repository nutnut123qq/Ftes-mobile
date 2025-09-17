class MentorItem {
  final String name;
  final String specialization;
  final String avatarUrl;

  MentorItem({
    required this.name,
    required this.specialization,
    required this.avatarUrl,
  });

  // Constructor for backward compatibility with top_mentors_screen
  MentorItem.fromTopMentors({
    required String name,
    required String specialty,
    required String imageUrl,
  }) : name = name,
       specialization = specialty,
       avatarUrl = imageUrl;
}
