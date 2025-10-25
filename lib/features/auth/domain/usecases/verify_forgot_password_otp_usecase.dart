import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ftes/core/error/failures.dart';
import 'package:ftes/core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class VerifyForgotPasswordOTPUseCase implements UseCase<String, VerifyOTPParams> {
  final AuthRepository repository;

  VerifyForgotPasswordOTPUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(VerifyOTPParams params) async {
    return await repository.verifyForgotPasswordOTP(params.email, params.otp);
  }
}

class VerifyOTPParams extends Equatable {
  final String email;
  final int otp;

  const VerifyOTPParams({required this.email, required this.otp});

  @override
  List<Object> get props => [email, otp];
}
