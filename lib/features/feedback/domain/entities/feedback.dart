import 'package:equatable/equatable.dart';

/// Thực thể feedback trong domain layer
class FeedbackEntity extends Equatable {
  final int id;
  final int userId;
  final int courseId;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? userName;
  final String? userAvatar;

  const FeedbackEntity({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
    this.userName,
    this.userAvatar,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    courseId,
    rating,
    comment,
    createdAt,
    updatedAt,
    userName,
    userAvatar,
  ];
}
