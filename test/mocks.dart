import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shikshalaya/app/shared_prefs/token_shared_prefs.dart';
import 'package:shikshalaya/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:shikshalaya/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:shikshalaya/features/course/domain/repository/course_repository.dart';
import 'package:shikshalaya/features/course/data/data_source/remote_datasource/course_remote_datasource.dart';
import 'package:shikshalaya/features/course/domain/use_case/get_course_by_id_usecase.dart';
import 'package:shikshalaya/features/course/domain/use_case/get_student_course_usecase.dart';
import 'package:shikshalaya/features/course/domain/use_case/is_enrolled_usecase.dart';
import 'package:shikshalaya/features/course/presentation/view_model/bloc/course_bloc.dart';
import 'package:shikshalaya/features/news/presentation/view/web_scraper.dart';
import 'package:shikshalaya/features/payment/data/data_source/remote_data_source/payment_remote_data_source.dart';
import 'package:shikshalaya/features/payment/domain/repository/payment_repository.dart';
import 'package:shikshalaya/features/payment/presentation/view_model/payment_bloc.dart';
import 'package:shikshalaya/features/test/data/data_source/remote_datasource/quiz_remote_data_source.dart';
import 'package:shikshalaya/features/test/domain/repository/quiz_repository.dart';
import 'package:shikshalaya/features/test/domain/use_case/get_questions_usecase.dart';
import 'package:shikshalaya/features/test/domain/use_case/get_quiz_sets_usecase.dart';
import 'package:shikshalaya/features/user_profile/domain/use_case/get_current_user_usecase.dart';
import 'package:shikshalaya/features/user_profile/domain/use_case/update_user_profile_usecase.dart';

// -----------------------FOR UNIT TESTING--------------------------------------//

class MockCourseRepository extends Mock implements ICourseRepository {}

class MockCourseRemoteDataSource extends Mock
    implements CourseRemoteDataSource {}

class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}

class MockPaymentRemoteDataSource extends Mock
    implements PaymentRemoteDataSource {}

class MockPaymentRepository extends Mock implements IPaymentRepository {}

class MockQuizRepository extends Mock implements QuizRepository {}

class MockQuizRemoteDataSource extends Mock implements QuizRemoteDataSource {}

// ----------------------FOR BLOC TESTING -----------------------------------------//

class MockBuildContext extends Mock implements BuildContext {}

class MockGetCourseByIdUseCase extends Mock implements GetCourseByIdUseCase {}

class MockIsEnrolledUseCase extends Mock implements IsEnrolledUseCase {}

class MockGetStudentCoursesUseCase extends Mock
    implements GetStudentCoursesUseCase {}

class MockPaymentBloc extends Mock implements PaymentBloc {}

class MockGetQuizSetsUseCase extends Mock implements GetQuizSetsUseCase {}

class MockGetQuestionsUseCase extends Mock implements GetQuestionsUseCase {}

class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}

class MockUpdateUserProfileUseCase extends Mock
    implements UpdateUserProfileUseCase {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

//----------------------------Widget Test------------------------//
class MockCourseBloc extends Mock implements CourseBloc {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockWebScraper extends Mock implements WebScraper {}

class MockLoginBloc extends Mock implements LoginBloc {}

class FakeNavigateRegisterScreenEvent extends Fake
    implements NavigateRegisterScreenEvent {}

class FakeNavigateHomeScreenEvent extends Fake
    implements NavigateHomeScreenEvent {}

class FakeLoginStudentEvent extends Fake implements LoginStudentEvent {}

class MockRegisterBloc extends Mock implements RegisterBloc {}

class FakeRegisterStudent extends Fake implements RegisterStudent {}

class FakeLoadImage extends Fake implements LoadImage {}
