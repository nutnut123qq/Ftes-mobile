import 'package:dartz/dartz.dart';
import '../error/failures.dart';

/// Base use case interface
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// No parameters use case
class NoParams {
  const NoParams();
}
