import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/feedback_page.dart';
import 'feedback_model.dart';

part 'paginated_feedback_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PaginatedFeedbackModel {
  final List<FeedbackModel> content;
  final int totalElements;
  final int totalPages;
  @JsonKey(name: 'number')
  final int currentPage;
  @JsonKey(name: 'size')
  final int pageSize;
  @JsonKey(name: 'first')
  final bool isFirst;
  @JsonKey(name: 'last')
  final bool isLast;

  const PaginatedFeedbackModel({
    required this.content,
    required this.totalElements,
    required this.totalPages,
    required this.currentPage,
    required this.pageSize,
    required this.isFirst,
    required this.isLast,
  });

  factory PaginatedFeedbackModel.fromJson(Map<String, dynamic> json) =>
      _$PaginatedFeedbackModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaginatedFeedbackModelToJson(this);

  FeedbackPage toEntity() => FeedbackPage(
    items: content.map((model) => model.toEntity()).toList(),
    totalElements: totalElements,
    totalPages: totalPages,
    currentPage: currentPage,
    pageSize: pageSize,
    isFirst: isFirst,
    isLast: isLast,
  );
}
