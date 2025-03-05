part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
  @override
  List<Object> get props => [];
}

class LoadSettings extends SettingsEvent {}
class UpdateSetting extends SettingsEvent {
  final String settingKey;
  final dynamic settingValue;

  const UpdateSetting(this.settingKey, this.settingValue);

  @override
  List<Object> get props => [settingKey, settingValue];
}