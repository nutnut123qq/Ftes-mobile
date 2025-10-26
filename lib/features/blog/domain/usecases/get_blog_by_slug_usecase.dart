import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/blog.dart';
import '../repositories/blog_repository.dart';

/// Use case for getting blog by slug name
class GetBlogBySlugUseCase implements UseCase<Blog, String> {
  final BlogRepository repository;

  GetBlogBySlugUseCase(this.repository);

  @override
  Future<Either<Failure, Blog>> call(String slugName) async {
    return await repository.getBlogBySlug(slugName);
  }
}
