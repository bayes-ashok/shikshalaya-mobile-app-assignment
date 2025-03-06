import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shikshalaya/core/common/common_snackbar.dart';
import 'package:shikshalaya/features/auth/domain/entity/auth_entity.dart';
import 'package:shikshalaya/features/user_profile/domain/entity/user_profile_entity.dart';
import 'package:shikshalaya/features/user_profile/domain/use_case/get_current_user_usecase.dart';

import '../../domain/use_case/update_user_profile_usecase.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final UpdateUserProfileUseCase _updateUserProfileUseCase;

  SettingsBloc({
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required UpdateUserProfileUseCase updateUserProfileUseCase,
  })  : _getCurrentUserUseCase = getCurrentUserUseCase,
        _updateUserProfileUseCase = updateUserProfileUseCase,
        super(SettingsInitial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<UpdateUserProfile>(_onUpdateUserProfile);
    on<LogoutEvent>(_onLogout);

  }

  void _onLoadUserProfile(
    LoadUserProfile event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());

    final result = await _getCurrentUserUseCase.call();

    result.fold(
      (failure) => emit(SettingsError(message: failure.toString())),
      (user) {
        emit(SettingsLoaded(
            userProfile: UserProfileEntity(
          fName: user.fName,
          phone: user.phone,
          email: user.email, // ✅ FIX: Assign Email properly
          role: user.role,
        )));
      },
    );
  }

  void _onUpdateUserProfile(
    UpdateUserProfile event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading()); // 🔹 Start loading

    final result = await _updateUserProfileUseCase.call(
      UpdateUserProfileParams(
        user: UserProfileEntity(
          fName: event.fullName,
          phone: event.phone,
          email: "", // Not updating email
          role: '', // No role update
        ),
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
        image: null,
      ),
    );

    result.fold(
      (failure) {
        emit(SettingsLoaded(
            userProfile: UserProfileEntity(
          fName: event.fullName,
          phone: event.phone,
          email: "",
          role: '',
        ))); // 🔹 Instead of staying in loading, go back to normal

        // 🔹 Show Snackbar Error
        addError(failure.toString());
        showMySnackBar(
            context: event.context,
            message: "Please enter correct password",
            color: Colors.red);
      },
      (successMessage) {
        emit(SettingsLoaded(
            userProfile: UserProfileEntity(
          fName: event.fullName,
          phone: event.phone,
          email: "",
          role: '',
        ))); // 🔹 Update state so UI updates

        // 🔹 Show Snackbar Success
        addError(successMessage);
        showMySnackBar(
            context: event.context,
            message: "Successfully Updated",
            color: Colors.green);
      },
    );
  }


  void _onLogout(LogoutEvent event, Emitter<SettingsState> emit) async {
    emit(LoggingOutState()); // 🔹 Emit logging out state

    await Future.delayed(const Duration(seconds: 2)); // Simulate logout process

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear session data

    emit(LoggedOutState()); // 🔹 Emit logged out state
  }
}
