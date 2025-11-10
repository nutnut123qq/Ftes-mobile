import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/chart_data_point.dart';

part 'chart_data_point_model.g.dart';

@JsonSerializable()
class ChartDataPointModel extends ChartDataPoint {
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime? dateJson;

  const ChartDataPointModel({this.dateJson, int? points})
    : super(date: dateJson, points: points ?? 0);

  factory ChartDataPointModel.fromJson(Map<String, dynamic> json) =>
      _$ChartDataPointModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChartDataPointModelToJson(this);

  ChartDataPoint toEntity() => ChartDataPoint(date: date, points: points);

  static DateTime? _dateTimeFromJson(dynamic value) {
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  static String? _dateTimeToJson(DateTime? value) => value?.toIso8601String();
}
