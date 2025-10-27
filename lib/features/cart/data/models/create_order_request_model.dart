import 'package:json_annotation/json_annotation.dart';

part 'create_order_request_model.g.dart';

/// Request model for creating order
@JsonSerializable()
class CreateOrderRequestModel {
  @JsonKey(name: 'courseIds')
  final List<String> courseIds;

  @JsonKey(name: 'couponName')
  final String? couponName;

  @JsonKey(name: 'usePoint')
  final bool usePoint;

  const CreateOrderRequestModel({
    required this.courseIds,
    this.couponName,
    this.usePoint = false,
  });

  factory CreateOrderRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateOrderRequestModelToJson(this);
}
