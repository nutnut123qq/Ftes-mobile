import 'package:dartz/dartz.dart';
import 'package:ftes/core/error/failures.dart';
import 'package:ftes/core/usecases/usecase.dart';
import '../entities/course.dart';
import '../repositories/home_repository.dart';

class SearchCoursesUseCase implements UseCase<List<Course>, SearchCoursesParams> {
  final HomeRepository repository;

  SearchCoursesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Course>>> call(SearchCoursesParams params) {
    return repository.searchCourses(
      code: params.code,
      categoryId: params.categoryId,
      level: params.level,
      avgStar: params.avgStar,
      pageNumber: params.pageNumber,
      pageSize: params.pageSize,
      sortField: params.sortField,
      sortOrder: params.sortOrder,
    );
  }
}

class SearchCoursesParams {
  final String? code;
  final String? categoryId;
  final String? level;
  final double? avgStar;
  final int pageNumber;
  final int pageSize;
  final String sortField;
  final String sortOrder;

  const SearchCoursesParams({
    this.code,
    this.categoryId,
    this.level,
    this.avgStar,
    this.pageNumber = 1,
    this.pageSize = 10,
    this.sortField = 'title',
    this.sortOrder = 'ASC',
  });
}


