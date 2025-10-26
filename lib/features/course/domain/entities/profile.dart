import 'package:equatable/equatable.dart';

/// Profile entity for domain layer
class Profile extends Equatable {
  final String id;
  final String username;
  final String name;
  final String email;
  final String? avatar;
  final String? description;
  final String? jobName;
  final String? facebook;
  final String? twitter;
  final String? youtube;

  const Profile({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
    this.avatar,
    this.description,
    this.jobName,
    this.facebook,
    this.twitter,
    this.youtube,
  });

  @override
  List<Object?> get props => [
        id,
        username,
        name,
        email,
        avatar,
        description,
        jobName,
        facebook,
        twitter,
        youtube,
      ];

  @override
  String toString() {
    return 'Profile(id: $id, username: $username, name: $name)';
  }
}
