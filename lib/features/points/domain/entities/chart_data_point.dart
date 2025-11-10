import 'package:equatable/equatable.dart';

class ChartDataPoint extends Equatable {
  final DateTime? date;
  final int points;

  const ChartDataPoint({this.date, this.points = 0});

  @override
  List<Object?> get props => [date, points];
}
