import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/point_transaction.dart';

part 'point_transaction_model.g.dart';

@JsonSerializable()
class PointTransactionModel extends PointTransaction {
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime? createdAtJson;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime? updatedAtJson;

  const PointTransactionModel({
    String? id,
    String? type,
    int? amount,
    String? description,
    String? status,
    this.createdAtJson,
    this.updatedAtJson,
  }) : super(
         id: id ?? '',
         type: type ?? '',
         amount: amount ?? 0,
         description: description ?? '',
         status: status ?? '',
         createdAt: createdAtJson,
         updatedAt: updatedAtJson,
       );

  factory PointTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$PointTransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$PointTransactionModelToJson(this);

  PointTransaction toEntity() => PointTransaction(
    id: id,
    type: type,
    amount: amount,
    description: description,
    status: status,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  static DateTime? _dateTimeFromJson(dynamic value) {
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  static String? _dateTimeToJson(DateTime? value) => value?.toIso8601String();
}
