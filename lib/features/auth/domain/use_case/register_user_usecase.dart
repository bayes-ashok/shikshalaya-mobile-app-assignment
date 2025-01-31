import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:shikshalaya/app/usecase/usecase.dart';
import 'package:shikshalaya/core/error/failure.dart';
import 'package:shikshalaya/features/auth/domain/entity/auth_entity.dart';
import 'package:shikshalaya/features/auth/domain/repository/auth_repository.dart';

class RegisterUserParams extends Equatable {
  final String fname;
  final String phone;
  final String email;
  final String password;
  final String? image;

  const RegisterUserParams({
    required this.fname,
    required this.phone,
    required this.email,
    required this.password,
    this.image,
  });

  const RegisterUserParams.initial(
      {required this.fname,
      required this.phone,
      required this.email,
      required this.password,
      this.image});

  @override
  List<Object?> get props => [fname, phone, email, password, image];
}

class RegisterUseCase implements UsecaseWithParams<void, RegisterUserParams> {
  final IAuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(RegisterUserParams params) {
    final authEntity = AuthEntity(
      fName: params.fname,
      phone: params.phone,
      email: params.email,
      password: params.password,
      image: params.image,
    );
    return repository.registerStudent(authEntity);
  }
}

class UploadImageParams {
  final File file;

  const UploadImageParams({
    required this.file,
  });
}

class UploadImageUsecase
    implements UsecaseWithParams<String, UploadImageParams> {
  final IAuthRepository _repository;

  UploadImageUsecase(this._repository);

  @override
  Future<Either<Failure, String>> call(UploadImageParams params) {
    return _repository.uploadProfilePicture(params.file);
  }
}
