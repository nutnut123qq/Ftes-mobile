import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/paginated_blog_response.dart';
import '../repositories/blog_repository.dart';

/// Use case for getting all blogs
class GetAllBlogsUseCase implements UseCase<PaginatedBlogResponse, GetAllBlogsParams> {
  final BlogRepository repository;

  GetAllBlogsUseCase(this.repository);

  @override
  Future<Either<Failure, PaginatedBlogResponse>> call(GetAllBlogsParams params) async {
    // Validate input parameters
    if (params.pageNumber < 1) {
      return const Left(ValidationFailure('Page number must be >= 1'));
    }
    if (params.pageSize < 1 || params.pageSize > 100) {
      return const Left(ValidationFailure('Page size must be between 1 and 100'));
    }

    return await repository.getAllBlogs(
      pageNumber: params.pageNumber,
      pageSize: params.pageSize,
      sortField: params.sortField,
      sortOrder: params.sortOrder,
    );
  }
}

/// Parameters for GetAllBlogsUseCase
class GetAllBlogsParams {
  final int pageNumber;
  final int pageSize;
  final String sortField;
  final String sortOrder;

  const GetAllBlogsParams({
    this.pageNumber = 1,
    this.pageSize = 10,
    this.sortField = 'createdAt',
    this.sortOrder = 'desc',
  });
}
