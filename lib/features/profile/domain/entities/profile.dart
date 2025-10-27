/// Profile entity representing user profile data
class Profile {
  final String id;
  final String username;
  final String name;
  final String email;
  final String phoneNumber;
  final String avatar;
  final String description;
  final String jobName;
  final String gender;
  final String dataOfBirth;
  final String facebook;
  final String twitter;
  final String youtube;
  final String role;
  final String userId;
  final String contentCourse;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Profile({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.avatar,
    required this.description,
    required this.jobName,
    required this.gender,
    required this.dataOfBirth,
    required this.facebook,
    required this.twitter,
    required this.youtube,
    required this.role,
    required this.userId,
    required this.contentCourse,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Profile && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Profile(id: $id, username: $username, name: $name, email: $email)';
  }
}

