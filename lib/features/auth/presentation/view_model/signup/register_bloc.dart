import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikshalaya/core/common/common_snackbar.dart';
import 'package:shikshalaya/features/auth/domain/use_case/register_user_usecase.dart';

import '../../../../../app/di/di.dart';
import '../../view/login_view.dart';
import '../login/login_bloc.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase _registerUseCase;

  RegisterBloc({
    required RegisterUseCase registerUseCase,
  })  : _registerUseCase = registerUseCase,
        super(RegisterState.initial()) {
    on<RegisterStudent>(_onRegisterEvent);

  }


  void _onRegisterEvent(
    RegisterStudent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _registerUseCase.call(RegisterUserParams(
      fname: event.fName,
      phone: event.phone,
      email: event.email,
      password: event.password,
    ));

    result.fold(
          (l) => emit(state.copyWith(isLoading: false, isSuccess: false)),
          (r) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        showMySnackBar(
          context: event.context,
          message: "Registration Successful",
        );

        // Navigate to the login screen
        Navigator.pushReplacement(
          event.context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: getIt<LoginBloc>(), // Provide the LoginBloc instance here
              child: LoginView(),
            ),
          ),
        );
      },
    );

  }
}
