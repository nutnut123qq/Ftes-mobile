import '../../domain/entities/video_knowledge.dart';

/// Model for Video Knowledge (extends domain entity)
class VideoKnowledgeModel extends VideoKnowledge {
  const VideoKnowledgeModel({
    required super.hasKnowledge,
    required super.status,
    required super.message,
  });

  /// Convert from JSON
  factory VideoKnowledgeModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    
    if (data != null) {
      return VideoKnowledgeModel(
        hasKnowledge: data['has_knowledge'] as bool? ?? false,
        status: data['status'] as String? ?? '',
        message: data['message'] as String? ?? '',
      );
    }
    
    return const VideoKnowledgeModel(
      hasKnowledge: false,
      status: '',
      message: '',
    );
  }

  /// Convert to domain entity
  VideoKnowledge toEntity() {
    return VideoKnowledge(
      hasKnowledge: hasKnowledge,
      status: status,
      message: message,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'has_knowledge': hasKnowledge,
        'status': status,
        'message': message,
      },
    };
  }
}

