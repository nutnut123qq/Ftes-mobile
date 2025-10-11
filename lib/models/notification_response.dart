import 'package:json_annotation/json_annotation.dart';

part 'notification_response.g.dart';

@JsonSerializable()
class NotificationResponse {
  final int id;
  final int userId;
  final String title;
  final String message;
  final String type; // COURSE, COMMENT, POST, SYSTEM, etc.
  final bool isRead;
  final DateTime createdAt;
  final int? relatedId; // ID of related course, post, comment, etc.

  NotificationResponse({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.relatedId,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationResponseToJson(this);
}
