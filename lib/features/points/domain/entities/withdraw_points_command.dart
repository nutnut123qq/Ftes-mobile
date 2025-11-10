import 'package:equatable/equatable.dart';

class WithdrawPointsCommand extends Equatable {
  final int amount;
  final String? bankAccount;
  final String? bankName;

  const WithdrawPointsCommand({
    required this.amount,
    this.bankAccount,
    this.bankName,
  });

  @override
  List<Object?> get props => [amount, bankAccount, bankName];
}
