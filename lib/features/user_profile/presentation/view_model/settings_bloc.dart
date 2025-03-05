import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikshalaya/features/auth/domain/entity/auth_entity.dart';
import 'package:shikshalaya/features/user_profile/domain/entity/user_profile_entity.dart';
import 'package:shikshalaya/features/user_profile/domain/use_case/get_current_user_usecase.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  SettingsBloc({required GetCurrentUserUseCase getCurrentUserUseCase})
      : _getCurrentUserUseCase = getCurrentUserUseCase,
        super(SettingsInitial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
  }

  void _onLoadUserProfile(
      LoadUserProfile event,
      Emitter<SettingsState> emit,
      ) async {
    print("check point 1");
    final result = await _getCurrentUserUseCase.call();

    result.fold(
          (failure) {
        print("Error fetching user: ${failure.toString()}");
        emit(SettingsError(message: failure.toString()));
      },
          (user) {
        print("User data fetched: ${user.fName}");
        emit(SettingsLoaded(userProfile: user));
      },
    );
  }

}
