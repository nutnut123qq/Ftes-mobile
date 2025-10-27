import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/blog.dart';
import '../repositories/blog_repository.dart';

/// Use case for getting blog by ID
class GetBlogByIdUseCase implements UseCase<Blog, String> {
  final BlogRepository repository;

  GetBlogByIdUseCase(this.repository);

  @override
  Future<Either<Failure, Blog>> call(String blogId) async {
    return await repository.getBlogById(blogId);
  }
}

