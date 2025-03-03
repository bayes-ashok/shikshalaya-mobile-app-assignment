import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:shikshalaya/core/error/failure.dart';
import 'package:shikshalaya/features/course/domain/entity/course_entity.dart';

abstract interface class IPaymentRepository {

  Future<Either<Failure, bool>> onPaymentComplete(CourseEntity course, String token);

}
