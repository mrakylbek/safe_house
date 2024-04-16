abstract class SignUpEvent {}

class SignUpNameChanged extends SignUpEvent {
  final String? name;

  SignUpNameChanged({this.name});
}

class SignUpSurnameChanged extends SignUpEvent {
  final String? surname;

  SignUpSurnameChanged({this.surname});
}

class SignUpEmailChanged extends SignUpEvent {
  final String? email;

  SignUpEmailChanged({this.email});
}

class SignUpUsernameChanged extends SignUpEvent {
  final String? username;

  SignUpUsernameChanged({this.username});
}

class SignUpPhoneChanged extends SignUpEvent {
  final String? phone;

  SignUpPhoneChanged({this.phone});
}

class SignUpPasswordChanged extends SignUpEvent {
  final String? password;

  SignUpPasswordChanged({this.password});
}

class SignUpSubmitted extends SignUpEvent {}
