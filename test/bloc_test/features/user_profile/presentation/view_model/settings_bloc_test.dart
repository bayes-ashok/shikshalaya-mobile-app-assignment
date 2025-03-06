import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shikshalaya/features/user_profile/domain/entity/user_profile_entity.dart';
import 'package:shikshalaya/features/user_profile/domain/use_case/update_user_profile_usecase.dart';
import 'package:shikshalaya/features/user_profile/presentation/view_model/settings_bloc.dart';

import '../../../../../mocks.dart';

void main() {
  late SettingsBloc settingsBloc;
  late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;
  late MockUpdateUserProfileUseCase mockUpdateUserProfileUseCase;

  setUp(() {
    mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();
    mockUpdateUserProfileUseCase = MockUpdateUserProfileUseCase();

    settingsBloc = SettingsBloc(
      getCurrentUserUseCase: mockGetCurrentUserUseCase,
      updateUserProfileUseCase: mockUpdateUserProfileUseCase,
    );

    registerFallbackValue(
      UserProfileEntity(
        fName: "Test User",
        phone: "1234567890",
        email: "test@gmail.com",
        role: "Student",
      ),
    );

    registerFallbackValue(
      UpdateUserProfileParams(
        user: UserProfileEntity(
          fName: "Updated User",
          phone: "0987654321",
          email: "updated@gmail.com",
          role: "Student",
        ),
        currentPassword: "oldPassword",
        newPassword: "newPassword",
        image: null,
      ),
    );
  });

  test('initial state should be SettingsInitial', () {
    expect(settingsBloc.state, SettingsInitial());
  });

  final mockUser = UserProfileEntity(
    fName: "Test User",
    phone: "1234567890",
    email: "test@gmail.com",
    role: "Student",
  );

  blocTest<SettingsBloc, SettingsState>(
    'emits [SettingsLoading, SettingsLoaded] when LoadUserProfile is successful',
    build: () {
      when(() => mockGetCurrentUserUseCase())
          .thenAnswer((_) async => Right(mockUser));
      return settingsBloc;
    },
    act: (bloc) => bloc.add(LoadUserProfile()),
    expect: () => [
      SettingsLoading(),
      SettingsLoaded(userProfile: mockUser),
    ],
  );
}
