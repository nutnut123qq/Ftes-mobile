// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'points_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PointsSummaryModel _$PointsSummaryModelFromJson(Map<String, dynamic> json) =>
    PointsSummaryModel(
      totalPoints: (json['totalPoints'] as num?)?.toInt(),
      availablePoints: (json['availablePoints'] as num?)?.toInt(),
      lockedPoints: (json['lockedPoints'] as num?)?.toInt(),
      withdrawnPoints: (json['withdrawnPoints'] as num?)?.toInt(),
      lastUpdatedJson: PointsSummaryModel._dateTimeFromJson(
        json['lastUpdatedJson'],
      ),
    );

Map<String, dynamic> _$PointsSummaryModelToJson(PointsSummaryModel instance) =>
    <String, dynamic>{
      'totalPoints': instance.totalPoints,
      'availablePoints': instance.availablePoints,
      'lockedPoints': instance.lockedPoints,
      'withdrawnPoints': instance.withdrawnPoints,
      'lastUpdatedJson': PointsSummaryModel._dateTimeToJson(
        instance.lastUpdatedJson,
      ),
    };
