import 'package:dartz/dartz.dart';
import 'package:ftes/core/error/failures.dart';
import 'package:ftes/core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class SendForgotPasswordEmailUseCase implements UseCase<void, String> {
  final AuthRepository repository;

  SendForgotPasswordEmailUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String email) async {
    return await repository.sendForgotPasswordEmail(email);
  }
}
