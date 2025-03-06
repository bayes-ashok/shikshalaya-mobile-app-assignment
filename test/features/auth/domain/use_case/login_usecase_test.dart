import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shikshalaya/core/error/failure.dart';
import 'package:shikshalaya/features/auth/domain/use_case/login_usecase.dart';
import 'repository.mock.dart';

void main() {
  late MockAuthRepository repository;
  late LoginUseCase usecase;

  setUp(() {
    repository = MockAuthRepository();
    usecase = LoginUseCase(repository);
  });

  const email = "testing@gmai.com";
  const password = "password123";
  const loginParams = LoginParams(email: email, password: password);

  group('Login UseCase Tests', () {
    group('Successful login', () {
      test('should login user successfully', () async {
        // Arrange
        when(() => repository.loginStudent(any(), any())).thenAnswer(
          (_) async => const Right('token'),
        );

        // Act
        final result = await usecase(loginParams);

        // Assert
        expect(result, const Right('token'));

        // Verify repository interaction
        verify(() => repository.loginStudent(email, password)).called(1);
        verifyNoMoreInteractions(repository);
      });
    });

    group('Failed login', () {
      test('should return failure when login fails', () async {
        // Arrange
        when(() => repository.loginStudent(any(), any())).thenAnswer(
          (_) async =>
              const Left(ApiFailure(message: 'Incorrect login credentials')),
        );

        // Act
        final result = await usecase(loginParams);

        // Assert
        expect(
          result,
          const Left(ApiFailure(message: 'Incorrect login credentials')),
        );

        verify(() => repository.loginStudent(email, password)).called(1);
        verifyNoMoreInteractions(repository);
      });
    });
  });
}
