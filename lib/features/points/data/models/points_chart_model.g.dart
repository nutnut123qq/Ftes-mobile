// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'points_chart_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PointsChartModel _$PointsChartModelFromJson(Map<String, dynamic> json) =>
    PointsChartModel(
      dailyPointsJson: (json['dailyPointsJson'] as List<dynamic>?)
          ?.map((e) => ChartDataPointModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      monthlyPointsJson: (json['monthlyPointsJson'] as List<dynamic>?)
          ?.map((e) => ChartDataPointModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PointsChartModelToJson(
  PointsChartModel instance,
) => <String, dynamic>{
  'dailyPointsJson': instance.dailyPointsJson?.map((e) => e.toJson()).toList(),
  'monthlyPointsJson': instance.monthlyPointsJson
      ?.map((e) => e.toJson())
      .toList(),
};
