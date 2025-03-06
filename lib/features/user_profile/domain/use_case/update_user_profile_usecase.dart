import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:shikshalaya/app/usecase/usecase.dart';
import 'package:shikshalaya/core/error/failure.dart';
import 'package:shikshalaya/features/user_profile/domain/entity/user_profile_entity.dart';
import 'package:shikshalaya/features/user_profile/domain/repository/user_profile_repository.dart';
import 'package:shikshalaya/app/shared_prefs/token_shared_prefs.dart';

class UpdateUserProfileUseCase implements UsecaseWithParams<String, UpdateUserProfileParams> {
  final UserProfileRepository repository;
  final TokenSharedPrefs tokenSharedPrefs;

  UpdateUserProfileUseCase(this.repository, this.tokenSharedPrefs);

  @override
  Future<Either<Failure, String>> call(UpdateUserProfileParams params) async {
    final tokenResult = await tokenSharedPrefs.getToken();

    return tokenResult.fold(
          (failure) => Left(failure),
          (token) async => repository.updateUserProfile(
        token: token,
        user: params.user,
        currentPassword: params.currentPassword,
        newPassword: params.newPassword,
        image: params.image,
      ),
    );
  }
}

class UpdateUserProfileParams extends Equatable {
  final UserProfileEntity user;
  final String currentPassword;
  final String? newPassword;
  final File? image;

  const UpdateUserProfileParams({
    required this.user,
    required this.currentPassword,
    this.newPassword,
    this.image,
  });

  @override
  List<Object?> get props => [user, currentPassword, newPassword, image];
}
