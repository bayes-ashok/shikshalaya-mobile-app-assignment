import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:shikshalaya/core/error/failure.dart';
import 'package:shikshalaya/features/auth/domain/entity/auth_entity.dart';
import 'package:shikshalaya/features/user_profile/domain/entity/user_profile_entity.dart';

import '../../domain/repository/user_profile_repository.dart';
import '../data_source/user_profile_datasource.dart';
import '../model/user_profile_api_model.dart';

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
  Future<Either<Failure, String>> updateUserProfile({
    required String token,
    required UserProfileEntity user,
    required String currentPassword,
    String? newPassword,
    File? image,
  }) async {
    try {
      final userProfileApiModel = UserProfileApiModel.fromEntity(user);
      final message = await remoteDataSource.updateUserProfile(
        token: token,
        user: userProfileApiModel,
        currentPassword: currentPassword,
        newPassword: newPassword,
        image: image,
      );
      return Right(message);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
