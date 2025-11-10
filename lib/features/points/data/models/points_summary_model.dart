import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/points_summary.dart';

part 'points_summary_model.g.dart';

@JsonSerializable()
class PointsSummaryModel extends PointsSummary {
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime? lastUpdatedJson;

  const PointsSummaryModel({
    int? totalPoints,
    int? availablePoints,
    int? lockedPoints,
    int? withdrawnPoints,
    this.lastUpdatedJson,
  }) : super(
         totalPoints: totalPoints ?? 0,
         availablePoints: availablePoints ?? 0,
         lockedPoints: lockedPoints ?? 0,
         withdrawnPoints: withdrawnPoints ?? 0,
         lastUpdated: lastUpdatedJson,
       );

  factory PointsSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$PointsSummaryModelFromJson(json);

  Map<String, dynamic> toJson() => _$PointsSummaryModelToJson(this);

  PointsSummary toEntity() => PointsSummary(
    totalPoints: totalPoints,
    availablePoints: availablePoints,
    lockedPoints: lockedPoints,
    withdrawnPoints: withdrawnPoints,
    lastUpdated: lastUpdated,
  );

  static DateTime? _dateTimeFromJson(dynamic value) {
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  static String? _dateTimeToJson(DateTime? value) => value?.toIso8601String();
}
