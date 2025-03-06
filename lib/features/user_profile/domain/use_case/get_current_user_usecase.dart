import 'package:dartz/dartz.dart';
import 'package:shikshalaya/core/error/failure.dart';
import 'package:shikshalaya/features/user_profile/domain/entity/user_profile_entity.dart';

import '../../../../app/shared_prefs/token_shared_prefs.dart';
import '../../../../app/usecase/usecase.dart';
import '../repository/user_profile_repository.dart';


class GetCurrentUserUseCase implements UsecaseWithoutParams<UserProfileEntity> {
  final UserProfileRepository repository;
  final TokenSharedPrefs tokenSharedPrefs;

  GetCurrentUserUseCase(this.repository, this.tokenSharedPrefs);

  @override
  Future<Either<Failure, UserProfileEntity>> call() async {
    final tokenResult = await tokenSharedPrefs.getToken();

    return tokenResult.fold(
          (failure) => Left(failure), // If token retrieval fails
          (token) async => repository.getCurrentUser(token), // If token exists, fetch user profile
    );
  }
}
