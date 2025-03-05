import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../auth/domain/entity/auth_entity.dart';
import '../entity/user_profile_entity.dart';

abstract class UserProfileRepository {
  Future<Either<Failure, UserProfileEntity>> getCurrentUser(String token);
  Future<UserProfileEntity> updateUserProfile(String token, UserProfileEntity user);
}
