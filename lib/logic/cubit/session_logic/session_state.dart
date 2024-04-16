import 'package:flutter/foundation.dart';

abstract class SessionState {}

class UnknownSessionState extends SessionState {}

class Unauthenticated extends SessionState {}

class Guest extends SessionState {}

class Authenticated extends SessionState {
  final String? userToken;

  Authenticated({@required this.userToken});
}
