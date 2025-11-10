import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/withdraw_points_command.dart';

part 'withdraw_points_request_model.g.dart';

@JsonSerializable()
class WithdrawPointsRequestModel extends WithdrawPointsCommand {
  const WithdrawPointsRequestModel({
    required super.amount,
    super.bankAccount,
    super.bankName,
  });

  factory WithdrawPointsRequestModel.fromJson(Map<String, dynamic> json) =>
      _$WithdrawPointsRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$WithdrawPointsRequestModelToJson(this);
}
