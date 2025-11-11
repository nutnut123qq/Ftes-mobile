import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ftes/features/home/domain/entities/banner.dart' as home_banner;
import 'package:ftes/features/home/domain/repositories/home_repository.dart';
import 'package:ftes/features/home/domain/entities/course.dart' as home_course;
import 'package:ftes/features/home/domain/entities/category.dart' as home_category;
import 'package:ftes/features/home/domain/usecases/get_banners_usecase.dart';
import 'package:ftes/core/error/failures.dart';
import 'package:ftes/core/usecases/usecase.dart';

class _FakeRepo implements HomeRepository {
  final List<home_banner.Banner> banners;
  _FakeRepo(this.banners);

  @override
  Future<Either<Failure, List<home_banner.Banner>>> getBanners() async {
    return Right(banners);
  }

  @override
  Future<Either<Failure, List<home_category.Category>>> getCategories() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<home_course.Course>>> getFeaturedCourses() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<home_course.Course>>> getLatestCourses({int limit = 3}) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<home_course.Course>>> searchCourses({
    String? code,
    String? categoryId,
    String? level,
    double? avgStar,
    int pageNumber = 1,
    int pageSize = 10,
    String sortField = 'title',
    String sortOrder = 'ASC',
  }) {
    throw UnimplementedError();
  }
}

void main() {
  test('GetBannersUseCase filters inactive banners and sorts by title', () async {
    final repo = _FakeRepo([
      const home_banner.Banner(id: '1', title: 'Z', active: true),
      const home_banner.Banner(id: '2', title: 'A', active: true),
      const home_banner.Banner(id: '3', title: 'M', active: false),
    ]);
    final usecase = GetBannersUseCase(repo);
    final result = await usecase(const NoParams());
    result.fold(
      (l) => fail('Expected Right, got Left'),
      (r) {
        expect(r.length, 2);
        expect(r.first.title, 'A');
        expect(r.last.title, 'Z');
      },
    );
  });
}


