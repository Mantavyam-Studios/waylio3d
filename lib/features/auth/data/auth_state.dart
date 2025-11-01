import 'package:equatable/equatable.dart';
import '../../../data/models/user_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// Initial state
class AuthInitial extends AuthState {}

// Loading state
class AuthLoading extends AuthState {}

// Authenticated state
class Authenticated extends AuthState {
  final UserModel user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

// Unauthenticated state
class Unauthenticated extends AuthState {}

// Guest mode state
class GuestMode extends AuthState {
  final UserModel guestUser;

  const GuestMode(this.guestUser);

  @override
  List<Object?> get props => [guestUser];
}

// Error state
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

