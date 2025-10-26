import 'package:json_annotation/json_annotation.dart';

part 'add_to_cart_request_model.g.dart';

/// Request model for adding course to cart
@JsonSerializable()
class AddToCartRequestModel {
  @JsonKey(name: 'courseId')
  final String courseId;

  const AddToCartRequestModel({
    required this.courseId,
  });

  factory AddToCartRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AddToCartRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddToCartRequestModelToJson(this);
}
