import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/blog_category.dart';
import '../repositories/blog_repository.dart';

/// Use case for getting blog categories
class GetBlogCategoriesUseCase implements UseCase<List<BlogCategory>, NoParams> {
  final BlogRepository repository;

  GetBlogCategoriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<BlogCategory>>> call(NoParams params) async {
    return await repository.getBlogCategories();
  }
}
