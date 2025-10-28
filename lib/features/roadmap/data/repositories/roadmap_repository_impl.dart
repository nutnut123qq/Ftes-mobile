import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/roadmap.dart';
import '../../domain/repositories/roadmap_repository.dart';
import '../../domain/constants/roadmap_constants.dart';
import '../datasources/roadmap_remote_datasource.dart';
import '../models/generate_roadmap_request_model.dart';

/// Repository implementation for Roadmap feature
class RoadmapRepositoryImpl implements RoadmapRepository {
  final RoadmapRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  RoadmapRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Roadmap>> generateRoadmap({
    required GenerateRoadmapParams params,
  }) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure(RoadmapConstants.errorNoInternet));
      }

      final request = GenerateRoadmapRequestModel(
        specialization: params.specialization,
        currentSkills: params.currentSkills,
        term: params.term,
      );

      final responseModel = await remoteDataSource.generateRoadmap(request: request);
      return Right(responseModel.toEntity(
        currentSkills: params.currentSkills,
        specialization: params.specialization,
      ));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('${RoadmapConstants.errorGeneratingRoadmap}: $e'));
    }
  }
}
