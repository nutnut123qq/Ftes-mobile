import 'package:dartz/dartz.dart';
import '../error/failures.dart';

/// Base use case interface
abstract class UseCase<ReturnType, Params> {
  Future<Either<Failure, ReturnType>> call(Params params);
}

/// No parameters use case
class NoParams {
  const NoParams();
}
