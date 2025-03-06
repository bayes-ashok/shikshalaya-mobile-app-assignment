import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:shikshalaya/core/error/failure.dart';
import 'package:shikshalaya/features/auth/data/data_source/local_data_source/auth_local_data_source.dart';
import 'package:shikshalaya/features/auth/domain/entity/auth_entity.dart';
import 'package:shikshalaya/features/auth/domain/repository/auth_repository.dart';

class AuthLocalRepository implements IAuthRepository {
  final AuthLocalDataSource _authLocalDataSource;

  AuthLocalRepository(this._authLocalDataSource);

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    try {
      final currentUser = await _authLocalDataSource.getCurrentUser();
      return Right(currentUser);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> loginStudent(
    String email,
    String password,
  ) async {
    try {
      final token = await _authLocalDataSource.loginStudent(email, password);
      return Right(token);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> registerStudent(AuthEntity student) async {
    try {
      return Right(_authLocalDataSource.registerStudent(student));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(File file) async {
    throw UnimplementedError();
  }
}
