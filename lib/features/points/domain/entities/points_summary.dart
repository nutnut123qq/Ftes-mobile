import 'package:equatable/equatable.dart';

class PointsSummary extends Equatable {
  final int totalPoints;
  final int availablePoints;
  final int lockedPoints;
  final int withdrawnPoints;
  final DateTime? lastUpdated;

  const PointsSummary({
    this.totalPoints = 0,
    this.availablePoints = 0,
    this.lockedPoints = 0,
    this.withdrawnPoints = 0,
    this.lastUpdated,
  });

  @override
  List<Object?> get props => [
    totalPoints,
    availablePoints,
    lockedPoints,
    withdrawnPoints,
    lastUpdated,
  ];
}
