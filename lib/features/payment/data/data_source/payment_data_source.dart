
import 'package:shikshalaya/features/course/domain/entity/course_entity.dart';

abstract interface class IPayment{
  Future<bool> onPaymentComplete(CourseEntity course, String studentId);
}