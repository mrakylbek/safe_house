import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_house/logic/cubit/auth_logic/auth_cubit.dart';
import 'package:safe_house/repositories/auth_repository.dart';
import 'package:safe_house/widgets/form_submission_status.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository? authRepo;
  final AuthCubit? authCubit;

  // LoginBloc({this.authRepo, this.authCubit}) : super(LoginState());

  LoginBloc({this.authRepo, this.authCubit}) : super(LoginState()) {
    on<LoginEvent>((event, emit) async {
      // if (event is LoadLocalization) {
      //   emit(LoginState(locale: event.locale));
      // }
      if (event is LoginUsernameChanged) {
        emit(state.copyWith(username: event.username));
        // yield state.copyWith(username: event.username);

        // Password updated
      } else if (event is LoginPasswordChanged) {
        emit(state.copyWith(password: event.password));

        // yield state.copyWith(password: event.password);

        // Form submitted
      } else if (event is LoginSubmitted) {
        emit(state.copyWith(formStatus: FormSubmitting()));

        // yield state.copyWith(formStatus: FormSubmitting());

        try {
          final userToken = await authRepo!.login(
            username: state.username,
            password: state.password,
          );
          // print(userToken);
          if (userToken == null) {
            throw Exception('Error log in: token is empty');
          }

          emit(state.copyWith(formStatus: SubmissionSuccess()));
          // emit(LoginState(formStatus: SubmissionSuccess()));

          // yield state.copyWith(formStatus: SubmissionSuccess());
          authCubit!.launchSession();
        } on Exception catch (e) {
          emit(state.copyWith(formStatus: SubmissionFailed(e)));

          // yield state.copyWith(formStatus: SubmissionFailed(e));
        }
      }
    });
  }

  // @override
  // Stream<LoginState> mapEventToState(LoginEvent event) async* {
  //   // Username updated
  //   if (event is LoginUsernameChanged) {
  //     yield state.copyWith(username: event.username);

  //     // Password updated
  //   } else if (event is LoginPasswordChanged) {
  //     yield state.copyWith(password: event.password);

  //     // Form submitted
  //   } else if (event is LoginSubmitted) {
  //     yield state.copyWith(formStatus: FormSubmitting());

  //     try {
  //       final userId = await authRepo.login(
  //         username: state.username,
  //         password: state.password,
  //       );
  //       yield state.copyWith(formStatus: SubmissionSuccess());

  //       authCubit.launchSession(AuthCredentials(
  //         username: state.username,
  //         userId: userId,
  //       ));
  //     } catch (e) {
  //       yield state.copyWith(formStatus: SubmissionFailed(e));
  //     }
  //   }
  // }
}
