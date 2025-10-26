import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/paginated_blog_response.dart';
import '../repositories/blog_repository.dart';

/// Use case for searching blogs
class SearchBlogsUseCase implements UseCase<PaginatedBlogResponse, SearchBlogsParams> {
  final BlogRepository repository;

  SearchBlogsUseCase(this.repository);

  @override
  Future<Either<Failure, PaginatedBlogResponse>> call(SearchBlogsParams params) async {
    return await repository.searchBlogs(
      pageNumber: params.pageNumber,
      pageSize: params.pageSize,
      sortField: params.sortField,
      sortOrder: params.sortOrder,
      title: params.title,
      category: params.category,
    );
  }
}

/// Parameters for SearchBlogsUseCase
class SearchBlogsParams {
  final int pageNumber;
  final int pageSize;
  final String sortField;
  final String sortOrder;
  final String? title;
  final String? category;

  const SearchBlogsParams({
    this.pageNumber = 1,
    this.pageSize = 10,
    this.sortField = 'createdAt',
    this.sortOrder = 'desc',
    this.title,
    this.category,
  });
}
