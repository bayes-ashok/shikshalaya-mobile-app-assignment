part of 'settings_bloc.dart';
// ✅ Base class for settings states
abstract class SettingsState extends Equatable {
  @override
  List<Object?> get props => [];
}

// ✅ Initial state
class SettingsInitial extends SettingsState {}

// ✅ Loading state when fetching/updating user profile
class SettingsLoading extends SettingsState {}

// ✅ Loaded state when profile is successfully fetched
class SettingsLoaded extends SettingsState {
  final UserProfileEntity userProfile;
  SettingsLoaded({required this.userProfile});

  @override
  List<Object?> get props => [userProfile];
}

// ✅ Profile update success state
class ProfileUpdateSuccess extends SettingsState {
  final String message;
  ProfileUpdateSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

// ✅ Error state
class SettingsError extends SettingsState {
  final String message;
  SettingsError({required this.message});

  @override
  List<Object?> get props => [message];
}
