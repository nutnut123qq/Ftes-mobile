/// Exercise entity for course detail
class Exercise {
  final String id;
  final String title;
  final String description;
  final int order;
  final int partOrder;
  final String createdAt;
  final String updatedAt;

  const Exercise({
    required this.id,
    required this.title,
    required this.description,
    required this.order,
    required this.partOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Exercise &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.order == order &&
        other.partOrder == partOrder &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        order.hashCode ^
        partOrder.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }

  @override
  String toString() {
    return 'Exercise(id: $id, title: $title, order: $order)';
  }
}
