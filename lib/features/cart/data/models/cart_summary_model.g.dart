// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartSummaryModel _$CartSummaryModelFromJson(Map<String, dynamic> json) =>
    CartSummaryModel(
      totalElements: (json['totalElements'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      currentPage: (json['currentPage'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      paging: json['paging'] == null
          ? null
          : PagingModel.fromJson(json['paging'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CartSummaryModelToJson(CartSummaryModel instance) =>
    <String, dynamic>{
      'totalElements': instance.totalElements,
      'totalPages': instance.totalPages,
      'currentPage': instance.currentPage,
      'data': instance.data.map((e) => e.toJson()).toList(),
      'paging': instance.paging?.toJson(),
    };

PagingModel _$PagingModelFromJson(Map<String, dynamic> json) => PagingModel(
  currentPage: (json['currentPage'] as num?)?.toInt(),
  pageSize: (json['pageSize'] as num?)?.toInt(),
  sort: json['sort'] == null
      ? null
      : SortModel.fromJson(json['sort'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PagingModelToJson(PagingModel instance) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'pageSize': instance.pageSize,
      'sort': instance.sort?.toJson(),
    };

SortModel _$SortModelFromJson(Map<String, dynamic> json) => SortModel(
  sortField: json['sortField'] as String?,
  sortOrder: json['sortOrder'] as String?,
);

Map<String, dynamic> _$SortModelToJson(SortModel instance) => <String, dynamic>{
  'sortField': instance.sortField,
  'sortOrder': instance.sortOrder,
};
