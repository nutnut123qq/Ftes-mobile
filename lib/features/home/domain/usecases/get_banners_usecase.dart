import 'package:dartz/dartz.dart';
import 'package:ftes/core/error/failures.dart';
import 'package:ftes/core/usecases/usecase.dart';
import '../entities/banner.dart';
import '../repositories/home_repository.dart';

/// Use case for getting banners
class GetBannersUseCase implements UseCase<List<Banner>, NoParams> {
  final HomeRepository repository;

  GetBannersUseCase(this.repository);

  @override
  Future<Either<Failure, List<Banner>>> call(NoParams params) async {
    return await repository.getBanners();
  }
}
