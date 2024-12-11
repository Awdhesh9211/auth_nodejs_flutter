import 'package:flutter_frontend/model/user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoggedIn extends AuthState {
  final User user;
  final String token;
  AuthLoggedIn(this.user, this.token);
}

class AuthError extends AuthState {
  final String error;
  AuthError(this.error);
}

class AuthLoggedOut extends AuthState {}