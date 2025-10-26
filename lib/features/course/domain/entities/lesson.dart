/// Lesson entity for course detail
class Lesson {
  final String id;
  final String title;
  final String description;
  final String video;
  final int order;
  final int partOrder;
  final int duration;
  final bool isCompleted;

  const Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.video,
    required this.order,
    required this.partOrder,
    required this.duration,
    required this.isCompleted,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Lesson &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.video == video &&
        other.order == order &&
        other.partOrder == partOrder &&
        other.duration == duration &&
        other.isCompleted == isCompleted;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        video.hashCode ^
        order.hashCode ^
        partOrder.hashCode ^
        duration.hashCode ^
        isCompleted.hashCode;
  }

  @override
  String toString() {
    return 'Lesson(id: $id, title: $title, order: $order, duration: $duration)';
  }
}
