import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// Check authentication status
class CheckAuthStatus extends AuthEvent {}

// Sign up with email
class SignUpWithEmail extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final String userType;

  const SignUpWithEmail({
    required this.email,
    required this.password,
    required this.name,
    required this.userType,
  });

  @override
  List<Object?> get props => [email, password, name, userType];
}

// Sign in with email
class SignInWithEmail extends AuthEvent {
  final String email;
  final String password;

  const SignInWithEmail({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

// Sign in with Google
class SignInWithGoogle extends AuthEvent {}

// Continue as guest
class ContinueAsGuest extends AuthEvent {}

// Sign out
class SignOut extends AuthEvent {}

// Delete account
class DeleteAccount extends AuthEvent {}

// Update profile
class UpdateProfile extends AuthEvent {
  final String? name;
  final String? photoUrl;
  final String? userType;

  const UpdateProfile({
    this.name,
    this.photoUrl,
    this.userType,
  });

  @override
  List<Object?> get props => [name, photoUrl, userType];
}

// Send password reset email
class SendPasswordReset extends AuthEvent {
  final String email;

  const SendPasswordReset(this.email);

  @override
  List<Object?> get props => [email];
}

