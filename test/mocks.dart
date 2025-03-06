import 'package:mocktail/mocktail.dart';
import 'package:shikshalaya/app/shared_prefs/token_shared_prefs.dart';
import 'package:shikshalaya/features/course/domain/repository/course_repository.dart';
import 'package:shikshalaya/features/course/data/data_source/remote_datasource/course_remote_datasource.dart';
import 'package:shikshalaya/features/payment/data/data_source/remote_data_source/payment_remote_data_source.dart';
import 'package:shikshalaya/features/payment/domain/repository/payment_repository.dart';
import 'package:shikshalaya/features/test/data/data_source/remote_datasource/quiz_remote_data_source.dart';
import 'package:shikshalaya/features/test/domain/repository/quiz_repository.dart';

class MockCourseRepository extends Mock implements ICourseRepository {}

class MockCourseRemoteDataSource extends Mock
    implements CourseRemoteDataSource {}

class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}

class MockPaymentRemoteDataSource extends Mock
    implements PaymentRemoteDataSource {}

class MockPaymentRepository extends Mock implements IPaymentRepository {}

class MockQuizRepository extends Mock implements QuizRepository {}

class MockQuizRemoteDataSource extends Mock implements QuizRemoteDataSource {}
