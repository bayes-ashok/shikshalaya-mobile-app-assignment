part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();
  @override
  List<Object> get props => [];
}

class SettingsInitial extends SettingsState {}
class SettingsLoaded extends SettingsState {
  final Map<String, dynamic> settings;

  const SettingsLoaded(this.settings);

  @override
  List<Object> get props => [settings];
}

class SettingsUpdated extends SettingsState {
  final Map<String, dynamic> updatedSettings;

  const SettingsUpdated(this.updatedSettings);

  @override
  List<Object> get props => [updatedSettings];
}
