import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/paginated_blog_response.dart';
import 'blog_model.dart';

part 'paginated_blog_response_model.g.dart';

/// Paginated blog response model for JSON serialization
@JsonSerializable(explicitToJson: true)
class PaginatedBlogResponseModel {
  @JsonKey(name: 'data')
  final List<BlogModel> data;
  
  @JsonKey(name: 'totalPages', fromJson: _intFromJson)
  final int totalPages;
  
  @JsonKey(name: 'totalElements', fromJson: _intFromJson)
  final int totalElements;
  
  @JsonKey(name: 'currentPage', fromJson: _intFromJson)
  final int currentPage;

  const PaginatedBlogResponseModel({
    required this.data,
    required this.totalPages,
    required this.totalElements,
    required this.currentPage,
  });

  factory PaginatedBlogResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PaginatedBlogResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaginatedBlogResponseModelToJson(this);

  PaginatedBlogResponse toEntity() {
    return PaginatedBlogResponse(
      data: data.map((blogModel) => blogModel.toEntity()).toList(),
      totalPages: totalPages,
      totalElements: totalElements,
      currentPage: currentPage,
    );
  }

  /// Helper function to safely convert dynamic to int, handling null values
  static int _intFromJson(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
