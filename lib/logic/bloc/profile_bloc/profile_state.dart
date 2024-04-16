part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class ProfileInitialState extends ProfileState {
  ProfileInitialState();
}

class ProfileLoadingState extends ProfileState {
  ProfileLoadingState();
}

class ProfileSuccessState extends ProfileState {
  final ProfileModel profile;

  ProfileSuccessState({
    required this.profile,
  });
}

class ProfileErrorState extends ProfileState {
  final String error;

  ProfileErrorState({
    required this.error,
  });
}
