import 'package:dartz/dartz.dart';
import 'package:ftes/core/error/failures.dart';
import 'package:ftes/core/usecases/usecase.dart';
import '../entities/invited_user.dart';
import '../repositories/points_repository.dart';

class GetInvitedUsersUseCase
    implements UseCase<List<InvitedUser>, GetInvitedUsersParams> {
  final PointsRepository repository;

  GetInvitedUsersUseCase(this.repository);

  @override
  Future<Either<Failure, List<InvitedUser>>> call(
    GetInvitedUsersParams params,
  ) {
    return repository.getInvitedUsers(page: params.page, size: params.size);
  }
}

class GetInvitedUsersParams {
  final int page;
  final int size;

  GetInvitedUsersParams({this.page = 0, this.size = 20});
}
