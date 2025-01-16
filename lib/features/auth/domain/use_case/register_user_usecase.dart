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

  const RegisterUserParams({
    required this.fname,
    required this.phone,
    required this.email,
    required this.password,
  });

  const RegisterUserParams.initial({
    required this.fname,
    required this.phone,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [fname, phone, email, password];
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
    );
    return repository.registerStudent(authEntity);
  }
}
