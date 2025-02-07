import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shikshalaya/core/error/failure.dart';
import 'package:shikshalaya/features/auth/domain/entity/auth_entity.dart';
import 'package:shikshalaya/features/auth/domain/use_case/register_user_usecase.dart';

import 'repository.mock.dart';

class FakeAuthEntity extends Fake implements AuthEntity {}

void main() {
  late MockAuthRepository repository;
  late RegisterUseCase usecase;

  setUpAll(() {
    registerFallbackValue(FakeAuthEntity());
  });

  setUp(() {
    repository = MockAuthRepository();
    usecase = RegisterUseCase(repository);
  });

  test('should register user and return void on success', () async {
    // Arrange
    when(() => repository.registerStudent(any())).thenAnswer(
      (_) async => const Right(null),
    );

    // Act
    final result = await usecase(const RegisterUserParams(
      fname: 'Ashok',
      phone: '1234567890',
      email: 'ashok@gmail.com',
      password: 'qwerty123',
    ));

    // Assert
    expect(result, const Right(null));

    // Verify
    verify(() => repository.registerStudent(any())).called(1);
    verifyNoMoreInteractions(repository);
  });

  test('should return [Failure] when repository fails', () async {
    // Arrange
    when(() => repository.registerStudent(any())).thenAnswer(
      (_) async => const Left(ApiFailure(message: "user already esists")),
    );

    // Act
    final result = await usecase(const RegisterUserParams(
      fname: 'Ashok',
      phone: '1234567890',
      email: 'ashok@gmail.com',
      password: 'qwerty123',
    ));

    // Assert
    expect(result, isA<Left<Failure, void>>());

    // Verify
    verify(() => repository.registerStudent(any())).called(1);
    verifyNoMoreInteractions(repository);
  });
}
