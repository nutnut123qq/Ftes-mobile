import 'package:equatable/equatable.dart';
import 'feedback.dart';

/// Thực thể đại diện cho trang feedback kèm phân trang
class FeedbackPage extends Equatable {
  final List<FeedbackEntity> items;
  final int totalElements;
  final int totalPages;
  final int currentPage;
  final int pageSize;
  final bool isFirst;
  final bool isLast;

  const FeedbackPage({
    required this.items,
    required this.totalElements,
    required this.totalPages,
    required this.currentPage,
    required this.pageSize,
    required this.isFirst,
    required this.isLast,
  });

  @override
  List<Object?> get props => [
    items,
    totalElements,
    totalPages,
    currentPage,
    pageSize,
    isFirst,
    isLast,
  ];
}
