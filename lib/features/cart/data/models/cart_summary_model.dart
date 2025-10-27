import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/cart_summary.dart';
import 'cart_item_model.dart';

part 'cart_summary_model.g.dart';

/// Cart Summary model for data layer
@JsonSerializable(explicitToJson: true)
class CartSummaryModel {
  @JsonKey(name: 'totalElements')
  final int totalElements;
  
  @JsonKey(name: 'totalPages')
  final int totalPages;
  
  @JsonKey(name: 'currentPage')
  final int? currentPage;
  
  final List<CartItemModel> data;
  
  @JsonKey(name: 'paging')
  final PagingModel? paging;

  const CartSummaryModel({
    required this.totalElements,
    required this.totalPages,
    this.currentPage,
    required this.data,
    this.paging,
  });

  factory CartSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$CartSummaryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartSummaryModelToJson(this);

  /// Convert to domain entity
  CartSummary toEntity() {
    return CartSummary(
      totalElements: totalElements,
      totalPages: totalPages,
      currentPage: currentPage ?? paging?.currentPage ?? 1,
      items: data.map((item) => item.toEntity()).toList(),
    );
  }

  /// Create from domain entity
  factory CartSummaryModel.fromEntity(CartSummary cartSummary) {
    return CartSummaryModel(
      totalElements: cartSummary.totalElements,
      totalPages: cartSummary.totalPages,
      currentPage: cartSummary.currentPage,
      data: cartSummary.items.map((item) => CartItemModel.fromEntity(item)).toList(),
    );
  }

  /// Create from items list (for manual construction after parsing)
  factory CartSummaryModel.fromItems({
    required List<CartItemModel> items,
    int? currentPage,
    int? totalPages,
    int? totalElements,
  }) {
    return CartSummaryModel(
      totalElements: totalElements ?? items.length,
      totalPages: totalPages ?? 1,
      currentPage: currentPage,
      data: items,
    );
  }
}

/// Paging model for data layer
@JsonSerializable(explicitToJson: true)
class PagingModel {
  @JsonKey(name: 'currentPage')
  final int? currentPage;
  
  @JsonKey(name: 'pageSize')
  final int? pageSize;
  
  @JsonKey(name: 'sort')
  final SortModel? sort;

  const PagingModel({
    this.currentPage,
    this.pageSize,
    this.sort,
  });

  factory PagingModel.fromJson(Map<String, dynamic> json) =>
      _$PagingModelFromJson(json);

  Map<String, dynamic> toJson() => _$PagingModelToJson(this);
}

/// Sort model for data layer
@JsonSerializable(explicitToJson: true)
class SortModel {
  @JsonKey(name: 'sortField')
  final String? sortField;
  
  @JsonKey(name: 'sortOrder')
  final String? sortOrder;

  const SortModel({
    this.sortField,
    this.sortOrder,
  });

  factory SortModel.fromJson(Map<String, dynamic> json) =>
      _$SortModelFromJson(json);

  Map<String, dynamic> toJson() => _$SortModelToJson(this);
}
