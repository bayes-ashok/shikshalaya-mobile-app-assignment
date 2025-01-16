part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class LoadCoursesAndBatches extends RegisterEvent {}

class RegisterStudent extends RegisterEvent {
  final BuildContext context;
  final String fName;
  final String phone;
  final String email;
  final String password;

  const RegisterStudent({
    required this.context,
    required this.fName,
    required this.phone,
    required this.email,
    required this.password,
  });
}
