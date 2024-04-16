import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:safe_house/api/api.dart';
import 'package:safe_house/models/profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final APIRepository repository;

  ProfileBloc({required this.repository}) : super(ProfileInitialState()) {
    on<ProfileEvent>((event, emit) async {
      if (event is ProfileFetchEvent) {
        emit(ProfileLoadingState());
        final response = await repository.fetchProfile();

        if (response.statusCode == 200) {
          final profile = ProfileModel.fromMap(response.data['data']);

          emit(ProfileSuccessState(profile: profile));
        } else {
          emit(ProfileErrorState(error: '${response.statusMessage}'));
        }
      }
    });
  }
}
