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
    final result = await repository.getBanners();
    return result.fold(
      (failure) => Left(failure),
      (banners) {
        // Filter only active banners
        final active = banners.where((b) => b.active == true).toList();
        // Stable sort by title as a proxy for priority if available
        active.sort((a, b) {
          final at = a.title ?? '';
          final bt = b.title ?? '';
          return at.compareTo(bt);
        });
        return Right(active);
      },
    );
  }
}
