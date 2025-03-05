import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:shikshalaya/core/error/failure.dart';
import 'package:shikshalaya/features/user_profile/domain/entity/user_profile_entity.dart';

abstract class UserProfileRepository {
  Future<Either<Failure, UserProfileEntity>> getCurrentUser(String token);
  Future<Either<Failure, String>> updateUserProfile({
    required String token,
    required UserProfileEntity user,
    required String currentPassword,
    String? newPassword,
    File? image,
  });
}
