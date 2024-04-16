import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_house/logic/cubit/session_logic/session_cubit.dart';

enum AuthState { login, signUp, confirmSignUp }

class AuthCubit extends Cubit<AuthState> {
  final SessionCubit? sessionCubit;

  AuthCubit({this.sessionCubit}) : super(AuthState.login);

  void showLogin() => emit(AuthState.login);
  void showSignUp() => emit(AuthState.signUp);
  void showConfirmSignUp({
    String? username,
    String? email,
    String? password,
  }) {
    // credentials = AuthCredentials(
    //   username: username,
    //   email: email,
    //   password: password,
    // );
    emit(AuthState.confirmSignUp);
  }

  void launchSession() {
    sessionCubit!.attemptAutoLogin();
  }
  // sessionCubit.showSession(credentials);
}
