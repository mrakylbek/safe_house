import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_house/logic/cubit/auth_logic/auth_cubit.dart';
import 'package:safe_house/repositories/auth_repository.dart';
import 'package:safe_house/widgets/form_submission_status.dart';

import 'sign_up_event.dart';
import 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository? authRepo;
  final AuthCubit? authCubit;

  SignUpBloc({this.authRepo, this.authCubit}) : super(SignUpState()) {
    on<SignUpEvent>((event, emit) async {
      if (event is SignUpNameChanged) {
        emit(state.copyWith(name: event.name));

        //Surname updated
      } else if (event is SignUpSurnameChanged) {
        emit(state.copyWith(surname: event.surname));

        // Email updated
      } else if (event is SignUpEmailChanged) {
        emit(state.copyWith(email: event.email));

        // Role updated
      } else if (event is SignUpUsernameChanged) {
        emit(state.copyWith(username: event.username));
//Phone updated
      } else if (event is SignUpPhoneChanged) {
        emit(state.copyWith(phone: event.phone));

        // Password updated
      } else if (event is SignUpPasswordChanged) {
        emit(state.copyWith(password: event.password));

        // Form submitted
      } else if (event is SignUpSubmitted) {
        emit(state.copyWith(formStatus: FormSubmitting()));

        try {
          // await APIRepository().signUp(
          //   email: state.email,
          //   name: state.name,
          //   surname: state.surname,
          //   password: state.password,
          //   phone: state.phone,
          // );
          final isSignUped = await authRepo!.signUp(
            username: state.username,
            email: state.email,
            password: state.password,
            name: state.name,
            surname: state.surname,
          );

          if (!isSignUped) {
            throw Exception('Error log in: token is empty');
          }

          await authRepo!
              .login(username: state.username, password: state.password);

          emit(state.copyWith(formStatus: SubmissionSuccess()));
          authCubit!.launchSession();

          // authCubit.showConfirmSignUp(
          //   username: state.username,
          //   email: state.email,
          //   password: state.password,
          // );
        } on Exception catch (e) {
          emit(state.copyWith(formStatus: SubmissionFailed(e)));
        }
      }
    });
  }

//   @override
//   Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
//     // Name updated
//     if (event is SignUpNameChanged) {
//       yield state.copyWith(name: event.name);

//       //Surname updated
//     } else if (event is SignUpSurnameChanged) {
//       yield state.copyWith(surname: event.surname);

//       // Email updated
//     } else if (event is SignUpEmailChanged) {
//       yield state.copyWith(email: event.email);
// //Phone updated
//     } else if (event is SignUpPhoneChanged) {
//       yield state.copyWith(phone: event.phone);

//       // Password updated
//     } else if (event is SignUpPasswordChanged) {
//       yield state.copyWith(password: event.password);

//       // Form submitted
//     } else if (event is SignUpSubmitted) {
//       yield state.copyWith(formStatus: FormSubmitting());

//       try {
//         await APIRepository().signUp(
//           email: state.email,
//           name: state.name,
//           surname: state.surname,
//           password: state.password,
//           phone: state.phone,
//         );
//         // await authRepo.signUp(
//         //   username: state.username,
//         //   email: state.email,
//         //   password: state.password,
//         // );
//         yield state.copyWith(formStatus: SubmissionSuccess());

//         // authCubit.showConfirmSignUp(
//         //   username: state.username,
//         //   email: state.email,
//         //   password: state.password,
//         // );
//       } catch (e) {
//         yield state.copyWith(formStatus: SubmissionFailed(e));
//       }
//     }
//   }
}
