import 'package:dartz/dartz.dart';
import 'package:shikshalaya/core/error/failure.dart';
import 'package:shikshalaya/features/course/domain/entity/course_entity.dart';
import 'package:shikshalaya/features/payment/data/data_source/remote_data_source/payment_remote_data_source.dart';
import 'package:shikshalaya/features/payment/domain/repository/payment_repository.dart';

class PaymentRepository implements IPaymentRepository{
  final PaymentRemoteDataSource _paymentRemoteDataSource;

  PaymentRepository(this._paymentRemoteDataSource);

  @override
  Future<Either<Failure, bool>> onPaymentComplete(CourseEntity courses, String token) async {
    try {
      final course = await _paymentRemoteDataSource.onPaymentComplete(courses, token);
      return Right(course);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

}