import 'package:dartz/dartz.dart';
import 'package:ftes/core/error/exceptions.dart';
import 'package:ftes/core/error/failures.dart';
import 'package:ftes/core/network/network_info.dart';
import '../../domain/constants/feedback_constants.dart';
import '../../domain/entities/feedback.dart';
import '../../domain/entities/feedback_page.dart';
import '../../domain/repositories/feedback_repository.dart';
import '../datasources/feedback_remote_datasource.dart';
import '../models/create_feedback_request_model.dart';
import '../models/update_feedback_request_model.dart';

class FeedbackRepositoryImpl implements FeedbackRepository {
  final FeedbackRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  FeedbackRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, FeedbackPage>> getFeedbacks({
    required int courseId,
    int page = FeedbackConstants.defaultPageNumber,
    int size = FeedbackConstants.defaultPageSize,
  }) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure(FeedbackConstants.errorLoadFeedbacks));
      }

      final model = await remoteDataSource.getFeedbacksByCourse(
        courseId: courseId,
        page: page,
        size: size,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('${FeedbackConstants.errorLoadFeedbacks}: $e'));
    }
  }

  @override
  Future<Either<Failure, FeedbackEntity>> createFeedback({
    required int userId,
    required int courseId,
    required int rating,
    required String comment,
  }) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(
          NetworkFailure(FeedbackConstants.errorCreateFeedback),
        );
      }

      final model = await remoteDataSource.createFeedback(
        CreateFeedbackRequestModel(
          userId: userId,
          courseId: courseId,
          rating: rating,
          comment: comment,
        ),
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(
        ServerFailure('${FeedbackConstants.errorCreateFeedback}: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, FeedbackEntity>> updateFeedback({
    required int feedbackId,
    required int rating,
    required String comment,
  }) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(
          NetworkFailure(FeedbackConstants.errorUpdateFeedback),
        );
      }

      final model = await remoteDataSource.updateFeedback(
        feedbackId,
        UpdateFeedbackRequestModel(rating: rating, comment: comment),
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(
        ServerFailure('${FeedbackConstants.errorUpdateFeedback}: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> deleteFeedback({
    required int feedbackId,
  }) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(
          NetworkFailure(FeedbackConstants.errorDeleteFeedback),
        );
      }

      await remoteDataSource.deleteFeedback(feedbackId);
      return const Right(true);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(
        ServerFailure('${FeedbackConstants.errorDeleteFeedback}: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, double>> getAverageRating({
    required int courseId,
    int sampleSize = 100,
  }) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure(FeedbackConstants.errorAverageRating));
      }

      final model = await remoteDataSource.getFeedbacksByCourse(
        courseId: courseId,
        page: FeedbackConstants.defaultPageNumber,
        size: sampleSize,
      );
      final page = model.toEntity();
      final feedbacks = page.items;
      if (feedbacks.isEmpty) {
        return const Right(0.0);
      }

      final totalRating = feedbacks.fold<int>(
        0,
        (sum, item) => sum + item.rating,
      );
      final average = totalRating / feedbacks.length;
      return Right(double.parse(average.toStringAsFixed(2)));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('${FeedbackConstants.errorAverageRating}: $e'));
    }
  }
}
