part of 'profile_page_bloc.dart';

sealed class ProfilePageState extends Equatable {
  const ProfilePageState();
  
  @override
  List<Object> get props => [];
}

final class ProfilePageInitial extends ProfilePageState {}
