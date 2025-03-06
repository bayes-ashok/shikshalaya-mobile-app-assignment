import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:shikshalaya/features/payment/domain/repository/payment_repository.dart';

import '../../../../app/shared_prefs/token_shared_prefs.dart';
import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../../../course/domain/entity/course_entity.dart';

class OnPaymentCompleteParams extends Equatable {
  final CourseEntity course;

  const OnPaymentCompleteParams({required this.course});

  @override
  List<Object?> get props => [course];
}

class OnPaymentCompleteUseCase implements UsecaseWithParams<bool, OnPaymentCompleteParams> {
  final IPaymentRepository repository;
  final TokenSharedPrefs tokenSharedPrefs;

  OnPaymentCompleteUseCase(this.repository, this.tokenSharedPrefs);

  @override
  Future<Either<Failure, bool>> call(OnPaymentCompleteParams params) async {
    final token = await tokenSharedPrefs.getToken();
    return token.fold(
          (failure) => Left(failure),
          (validToken) async {
        return repository.onPaymentComplete(params.course, validToken);
      },
    );
  }
}