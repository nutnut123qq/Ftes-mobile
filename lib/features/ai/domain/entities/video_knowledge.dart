import 'package:equatable/equatable.dart';

/// Video Knowledge entity
class VideoKnowledge extends Equatable {
  final bool hasKnowledge;
  final String status;
  final String message;

  const VideoKnowledge({
    required this.hasKnowledge,
    required this.status,
    required this.message,
  });

  @override
  List<Object?> get props => [hasKnowledge, status, message];
}

