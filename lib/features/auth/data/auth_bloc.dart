import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/services/firebase_service.dart';
import '../../../data/models/user_model.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseService _firebaseService;
  StreamSubscription? _authSubscription;

  AuthBloc({FirebaseService? firebaseService})
      : _firebaseService = firebaseService ?? FirebaseService(),
        super(AuthInitial()) {
    // Register event handlers
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<SignUpWithEmail>(_onSignUpWithEmail);
    on<SignInWithEmail>(_onSignInWithEmail);
    on<SignInWithGoogle>(_onSignInWithGoogle);
    on<ContinueAsGuest>(_onContinueAsGuest);
    on<SignOut>(_onSignOut);
    on<DeleteAccount>(_onDeleteAccount);
    on<UpdateProfile>(_onUpdateProfile);
    on<SendPasswordReset>(_onSendPasswordReset);

    // Listen to auth state changes
    _authSubscription = _firebaseService.authStateChanges.listen((user) {
      if (user != null) {
        add(CheckAuthStatus());
      } else {
        if (state is! GuestMode) {
          emit(Unauthenticated());
        }
      }
    });
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());

      // Check if in guest mode
      final prefs = await SharedPreferences.getInstance();
      final isGuest = prefs.getBool('is_guest') ?? false;

      if (isGuest) {
        emit(GuestMode(UserModel.guest()));
        return;
      }

      // Check Firebase auth
      final user = _firebaseService.currentUser;
      if (user != null) {
        // Listen to user stream to get user data
        final userStream = _firebaseService.getUserStream(user.uid);
        final userModel = await userStream.first;
        if (userModel != null) {
          emit(Authenticated(userModel));
        } else {
          emit(Unauthenticated());
        }
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignUpWithEmail(
    SignUpWithEmail event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());

      final user = await _firebaseService.signUpWithEmail(
        email: event.email,
        password: event.password,
        name: event.name,
        userType: event.userType,
      );

      if (user != null) {
        // Clear guest mode
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_guest', false);

        emit(Authenticated(user));
      } else {
        emit(const AuthError('Failed to create account'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignInWithEmail(
    SignInWithEmail event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());

      final user = await _firebaseService.signInWithEmail(
        email: event.email,
        password: event.password,
      );

      if (user != null) {
        // Clear guest mode
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_guest', false);

        emit(Authenticated(user));
      } else {
        emit(const AuthError('Failed to sign in'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignInWithGoogle(
    SignInWithGoogle event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());

      final user = await _firebaseService.signInWithGoogle();

      if (user != null) {
        // Clear guest mode
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_guest', false);

        emit(Authenticated(user));
      } else {
        // User cancelled
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onContinueAsGuest(
    ContinueAsGuest event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());

      // Set guest mode flag
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_guest', true);

      emit(GuestMode(UserModel.guest()));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignOut(
    SignOut event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());

      // Clear guest mode
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_guest', false);

      // Sign out from Firebase
      await _firebaseService.signOut();

      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onDeleteAccount(
    DeleteAccount event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());

      await _firebaseService.deleteAccount();

      // Clear guest mode
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_guest', false);

      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final currentState = state;
      emit(AuthLoading());

      await _firebaseService.updateUserProfile(
        name: event.name,
        photoUrl: event.photoUrl,
        userType: event.userType,
      );

      // Refresh user data
      final user = _firebaseService.currentUser;
      if (user != null) {
        final userStream = _firebaseService.getUserStream(user.uid);
        final userModel = await userStream.first;
        if (userModel != null) {
          emit(Authenticated(userModel));
        } else {
          emit(currentState);
        }
      } else {
        emit(currentState);
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSendPasswordReset(
    SendPasswordReset event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _firebaseService.sendPasswordResetEmail(event.email);
      // Don't change state, just send the email
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}

