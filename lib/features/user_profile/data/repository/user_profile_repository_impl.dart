import 'package:dartz/dartz.dart';
import 'package:shikshalaya/core/error/failure.dart';
import 'package:shikshalaya/features/auth/domain/entity/auth_entity.dart';
import 'package:shikshalaya/features/user_profile/domain/entity/user_profile_entity.dart';

import '../../domain/repository/user_profile_repository.dart';
import '../data_source/user_profile_datasource.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileDataSource remoteDataSource;

  UserProfileRepositoryImpl({required this.remoteDataSource});


  @override
  Future<Either<Failure, UserProfileEntity>> getCurrentUser(String token) async {
    try {
      final userProfileApiModel = await remoteDataSource.getUserProfile(token);
      return Right(userProfileApiModel.toEntity());
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<UserProfileEntity> updateUserProfile(String token, UserProfileEntity user) {
    // TODO: implement updateUserProfile
    throw UnimplementedError();
  }
}
