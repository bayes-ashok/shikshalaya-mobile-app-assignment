part of 'settings_bloc.dart';
abstract class SettingsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// ✅ Load user profile event
class LoadUserProfile extends SettingsEvent {}

// ✅ Update user profile event
class UpdateUserProfile extends SettingsEvent {
  final BuildContext context;
  final String fullName;
  final String phone;
  final File? image;
  final String currentPassword;
  final String? newPassword;

  UpdateUserProfile({
    required this.context,
    required this.fullName,
    required this.phone,
    this.image,
    required this.currentPassword,
    this.newPassword,
  });

  @override
  List<Object?> get props => [fullName, phone, image, currentPassword, newPassword];
}
class LogoutEvent extends SettingsEvent {}


