import 'package:safe_house/widgets/form_submission_status.dart';

class SignUpState {
  final String name;
  bool get isValidUserName => name.length > 3;

  final String surname;
  bool get isValidUserSurname => surname.length > 3;

  final String phone;
  bool get isValidUserPhone => phone.length > 3;

  final String email;
  bool get isValidEmail => email.contains('@');

  final String password;
  bool get isValidPassword => password.length > 6;

  final FormSubmissionStatus formStatus;

  final String username;
  bool get isValidUserUsername => surname.length > 3;

  SignUpState({
    this.name = '',
    this.surname = '',
    this.email = '',
    this.phone = '',
    this.password = '',
    this.formStatus = const InitialFormStatus(),
    this.username = '',
  });

  SignUpState copyWith({
    String? name,
    String? surname,
    String? phone,
    String? email,
    String? password,
    FormSubmissionStatus? formStatus,
    String? username,
  }) {
    return SignUpState(
      name: name ?? this.name,
      surname: surname ?? this.surname,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
      username: username ?? this.username,
    );
  }
}
