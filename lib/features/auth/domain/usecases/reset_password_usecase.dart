import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ftes/core/error/failures.dart';
import 'package:ftes/core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class ResetPasswordUseCase implements UseCase<void, ResetPasswordParams> {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ResetPasswordParams params) async {
    return await repository.resetPassword(params.password, params.accessToken);
  }
}

class ResetPasswordParams extends Equatable {
  final String password;
  final String accessToken;

  const ResetPasswordParams({
    required this.password,
    required this.accessToken,
  });

  @override
  List<Object> get props => [password, accessToken];
}
