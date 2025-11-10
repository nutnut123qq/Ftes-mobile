// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_data_point_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChartDataPointModel _$ChartDataPointModelFromJson(Map<String, dynamic> json) =>
    ChartDataPointModel(
      dateJson: ChartDataPointModel._dateTimeFromJson(json['dateJson']),
      points: (json['points'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ChartDataPointModelToJson(
  ChartDataPointModel instance,
) => <String, dynamic>{
  'dateJson': ChartDataPointModel._dateTimeToJson(instance.dateJson),
  'points': instance.points,
};
