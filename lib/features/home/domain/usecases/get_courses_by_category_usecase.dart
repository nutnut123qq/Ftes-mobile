import 'package:dartz/dartz.dart';
import 'package:ftes/core/error/failures.dart';
import '../entities/course.dart';
import '../repositories/home_repository.dart';

class GetCoursesByCategoryParams {
  final String categoryId;
  final int limit;
  const GetCoursesByCategoryParams({
    required this.categoryId,
    this.limit = 10,
  });
}

class GetCoursesByCategoryUseCase {
  final HomeRepository _repository;
  // Default category id is handled by caller via constants; here we only compare if provided as empty.
  GetCoursesByCategoryUseCase(this._repository);

  Future<Either<Failure, List<Course>>> call(GetCoursesByCategoryParams params, {String? defaultCategoryId}) async {
    final isDefault = defaultCategoryId != null && params.categoryId == defaultCategoryId;
    if (isDefault) {
      return _repository.getLatestCourses(limit: params.limit);
    }
    // Fallback: use search with category filter to avoid expanding repository interface.
    return _repository.searchCourses(
      categoryId: params.categoryId,
      pageNumber: 1,
      pageSize: params.limit,
      sortField: 'createdAt',
      sortOrder: 'DESC',
    );
  }
}


