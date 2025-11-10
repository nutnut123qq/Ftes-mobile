import 'package:equatable/equatable.dart';

class PointTransaction extends Equatable {
  final String id;
  final String type;
  final int amount;
  final String description;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PointTransaction({
    this.id = '',
    this.type = '',
    this.amount = 0,
    this.description = '',
    this.status = '',
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    type,
    amount,
    description,
    status,
    createdAt,
    updatedAt,
  ];
}
