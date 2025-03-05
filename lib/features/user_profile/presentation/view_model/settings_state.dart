part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final UserProfileEntity userProfile;

  SettingsLoaded({required this.userProfile});

  @override
  List<Object?> get props => [userProfile];
}

class SettingsError extends SettingsState {
  final String message;

  SettingsError({required this.message});

  @override
  List<Object?> get props => [message];
}
