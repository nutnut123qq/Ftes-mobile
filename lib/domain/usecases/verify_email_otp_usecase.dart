import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class VerifyEmailOTPUseCase implements UseCase<String, VerifyOTPParams> {
  final AuthRepository repository;

  VerifyEmailOTPUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(VerifyOTPParams params) async {
    return await repository.verifyEmailOTP(params.email, params.otp);
  }
}

class VerifyOTPParams extends Equatable {
  final String email;
  final int otp;

  const VerifyOTPParams({
    required this.email,
    required this.otp,
  });

  @override
  List<Object> get props => [email, otp];
}
