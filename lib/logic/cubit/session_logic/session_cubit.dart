import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_house/repositories/auth_repository.dart';
import 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  final AuthRepository? authRepo;
  // final DataRepository dataRepo;

  SessionCubit({
    @required this.authRepo,
  }) : super(UnknownSessionState()) {
    attemptAutoLogin();
  }

  void attemptAutoLogin() async {
    try {
      final userToken = await authRepo!.attemptAutoLogin();
      if (userToken == null) {
        throw Exception('User not logged in');
      }

      // User user = await dataRepo.getUserById(userId);
      // if (user == null) {
      //   user = await dataRepo.createUser(
      //     userId: userId,
      //     username: 'User-${UUID()}',
      //   );
      // }
      emit(Authenticated(userToken: userToken));
      // final User profile = await profileRepo!.fetchProfile();
      // emit();
    } on Exception {
      emit(Unauthenticated());
    }
  }

  void showAuth() => emit(Unauthenticated());

  void logAsGuest() => emit(Guest());

  // void showSession(AuthCredentials credentials) async {
  //   try {
  //     String userToken = await dataRepo.getUserById(credentials.userId);

  //     // if (user == null) {
  //     //   user = await dataRepo.createUser(
  //     //     userId: credentials.userId,
  //     //     username: credentials.username,
  //     //     email: credentials.email,
  //     //   );
  //     // }

  //     emit(Authenticated(user: user));
  //   } catch (e) {
  //     emit(Unauthenticated());
  //   }
  // }

  void signOut() {
    authRepo!.signOut();
    emit(Unauthenticated());
  }
}
