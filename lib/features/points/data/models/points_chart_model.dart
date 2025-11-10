import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/points_chart.dart';
import 'chart_data_point_model.dart';

part 'points_chart_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PointsChartModel {
  final List<ChartDataPointModel>? dailyPointsJson;
  final List<ChartDataPointModel>? monthlyPointsJson;

  PointsChartModel({this.dailyPointsJson, this.monthlyPointsJson});

  factory PointsChartModel.fromJson(Map<String, dynamic> json) =>
      _$PointsChartModelFromJson(json);

  Map<String, dynamic> toJson() => _$PointsChartModelToJson(this);

  PointsChart toEntity() => PointsChart(
    dailyPoints: (dailyPointsJson ?? const [])
        .map((e) => e.toEntity())
        .toList(),
    monthlyPoints: (monthlyPointsJson ?? const [])
        .map((e) => e.toEntity())
        .toList(),
  );
}
