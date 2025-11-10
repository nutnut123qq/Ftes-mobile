import 'package:equatable/equatable.dart';
import 'chart_data_point.dart';

class PointsChart extends Equatable {
  final List<ChartDataPoint> dailyPoints;
  final List<ChartDataPoint> monthlyPoints;

  const PointsChart({
    this.dailyPoints = const [],
    this.monthlyPoints = const [],
  });

  @override
  List<Object?> get props => [dailyPoints, monthlyPoints];
}
