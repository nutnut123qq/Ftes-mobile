/// Exercise entity for course detail
class Exercise {
  final String id;
  final String type;
  final String title;
  final String description;
  final String question;
  final String expectedOutput;
  final String criteria;
  final bool checkLogic;
  final bool checkPerform;
  final bool checkEdgeCase;
  final String fileExtension;
  final int order;
  final int? partOrder;
  final String? createdAt;
  final String? updatedAt;

  const Exercise({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.question,
    required this.expectedOutput,
    required this.criteria,
    required this.checkLogic,
    required this.checkPerform,
    required this.checkEdgeCase,
    required this.fileExtension,
    required this.order,
    this.partOrder,
    this.createdAt,
    this.updatedAt,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Exercise &&
        other.id == id &&
        other.type == type &&
        other.title == title &&
        other.description == description &&
        other.question == question &&
        other.expectedOutput == expectedOutput &&
        other.criteria == criteria &&
        other.checkLogic == checkLogic &&
        other.checkPerform == checkPerform &&
        other.checkEdgeCase == checkEdgeCase &&
        other.fileExtension == fileExtension &&
        other.order == order &&
        other.partOrder == partOrder &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        type.hashCode ^
        title.hashCode ^
        description.hashCode ^
        question.hashCode ^
        expectedOutput.hashCode ^
        criteria.hashCode ^
        checkLogic.hashCode ^
        checkPerform.hashCode ^
        checkEdgeCase.hashCode ^
        fileExtension.hashCode ^
        order.hashCode ^
        (partOrder?.hashCode ?? 0) ^
        (createdAt?.hashCode ?? 0) ^
        (updatedAt?.hashCode ?? 0);
  }

  @override
  String toString() {
    return 'Exercise(id: $id, title: $title, order: $order)';
  }
}
