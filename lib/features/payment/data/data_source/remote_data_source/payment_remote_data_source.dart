import 'package:dio/dio.dart';
import 'package:shikshalaya/features/course/domain/entity/course_entity.dart';
import 'package:shikshalaya/features/payment/data/data_source/payment_data_source.dart';

class PaymentRemoteDataSource implements IPayment{
  final Dio _dio;

  PaymentRemoteDataSource(this._dio);

  @override
  Future<bool> onPaymentComplete(CourseEntity course, String token) async {
    print("Course ID: ${course.courseId}");
    print("Payment verification in progress...");

    try {
      final authResponse = await _dio.get(
        "http://10.0.2.2:8000/auth/check-auth",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (authResponse.statusCode == 200) {
        var userData = authResponse.data['data']['user'];

        if (userData != null && userData is Map<String, dynamic>) {
          String studentId = userData['_id'];
          print("Authenticated Student ID: $studentId");

          final enrollResponse = await _dio.post(
            "http://10.0.2.2:8000/student/courses-bought/enroll",
            data: {
              "studentId": studentId,
              "courseId": course.courseId,
            },
          );

          if (enrollResponse.statusCode == 200) {
            print("✅ Enrollment successful!");
            return true;
          } else {
            print("❌ Enrollment failed: ${enrollResponse.statusMessage}");
            return false;
          }
        } else {
          throw Exception("Invalid user data format");
        }
      } else {
        throw Exception("Failed to authenticate user: ${authResponse.statusMessage}");
      }
    } on DioException catch (e) {
      print("🚨 Dio error: $e");
      return false;
    } catch (e) {
      print("🚨 Unexpected error: $e");
      return false;
    }
  }

}