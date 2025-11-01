import 'dart:async';
import 'package:flutter/foundation.dart';
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
    debugPrint('🔐 AuthBloc initialized');

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
      debugPrint('🔄 Auth state changed: ${user?.email ?? "null"}');
      if (user != null) {
        debugPrint('👤 User signed in, checking auth status');
        add(CheckAuthStatus());
      } else {
        if (state is! GuestMode) {
          debugPrint('👤 User signed out, checking auth status');
          add(CheckAuthStatus());
        }
      }
    });
  }

  @override
  void onChange(Change<AuthState> change) {
    super.onChange(change);
    debugPrint('🔄 AuthBloc state changed: ${change.currentState.runtimeType} → ${change.nextState.runtimeType}');
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    try {
      debugPrint('🔍 Checking auth status...');
      emit(AuthLoading());

      // Check if in guest mode
      final prefs = await SharedPreferences.getInstance();
      final isGuest = prefs.getBool('is_guest') ?? false;

      if (isGuest) {
        debugPrint('👤 User is in guest mode');
        emit(GuestMode(UserModel.guest()));
        return;
      }

      // Check Firebase auth
      final user = _firebaseService.currentUser;
      if (user != null) {
        debugPrint('👤 Firebase user found: ${user.email}');
        // Listen to user stream to get user data
        final userStream = _firebaseService.getUserStream(user.uid);
        final userModel = await userStream.first;
        if (userModel != null) {
          debugPrint('✅ User authenticated: ${userModel.email}');
          emit(Authenticated(userModel));
        } else {
          debugPrint('❌ User document not found in Firestore');
          emit(Unauthenticated());
        }
      } else {
        debugPrint('❌ No Firebase user found');
        emit(Unauthenticated());
      }
    } catch (e) {
      debugPrint('❌ Error checking auth status: $e');
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignUpWithEmail(
    SignUpWithEmail event,
    Emitter<AuthState> emit,
  ) async {
    try {
      debugPrint('📝 Sign up event received for: ${event.email}');
      emit(AuthLoading());

      final user = await _firebaseService.signUpWithEmail(
        email: event.email,
        password: event.password,
        name: event.name,
        userType: event.userType,
      );

      if (user != null) {
        debugPrint('✅ Sign up successful, clearing guest mode');
        // Clear guest mode
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_guest', false);

        debugPrint('✅ Emitting Authenticated state');
        emit(Authenticated(user));
      } else {
        debugPrint('❌ Sign up failed: no user returned');
        emit(const AuthError('Failed to create account'));
      }
    } catch (e) {
      debugPrint('❌ Sign up error: $e');
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignInWithEmail(
    SignInWithEmail event,
    Emitter<AuthState> emit,
  ) async {
    try {
      debugPrint('🔐 Sign in event received for: ${event.email}');
      emit(AuthLoading());

      final user = await _firebaseService.signInWithEmail(
        email: event.email,
        password: event.password,
      );

      if (user != null) {
        debugPrint('✅ Sign in successful, clearing guest mode');
        // Clear guest mode
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_guest', false);

        debugPrint('✅ Emitting Authenticated state');
        emit(Authenticated(user));
      } else {
        debugPrint('❌ Sign in failed: no user returned');
        emit(const AuthError('Failed to sign in'));
      }
    } catch (e) {
      debugPrint('❌ Sign in error: $e');
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignInWithGoogle(
    SignInWithGoogle event,
    Emitter<AuthState> emit,
  ) async {
    try {
      debugPrint('🔐 Google sign in event received');
      emit(AuthLoading());

      final user = await _firebaseService.signInWithGoogle();

      if (user != null) {
        debugPrint('✅ Google sign in successful, clearing guest mode');
        // Clear guest mode
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_guest', false);

        debugPrint('✅ Emitting Authenticated state');
        emit(Authenticated(user));
      } else {
        debugPrint('❌ Google sign in cancelled by user');
        // User cancelled
        emit(Unauthenticated());
      }
    } catch (e) {
      debugPrint('❌ Google sign in error: $e');
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onContinueAsGuest(
    ContinueAsGuest event,
    Emitter<AuthState> emit,
  ) async {
    try {
      debugPrint('👤 Continue as guest event received');
      emit(AuthLoading());

      // Set guest mode flag
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_guest', true);

      debugPrint('✅ Guest mode enabled');
      emit(GuestMode(UserModel.guest()));
    } catch (e) {
      debugPrint('❌ Guest mode error: $e');
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignOut(
    SignOut event,
    Emitter<AuthState> emit,
  ) async {
    try {
      debugPrint('🚪 Sign out event received');
      emit(AuthLoading());

      // Clear guest mode
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_guest', false);

      // Sign out from Firebase
      await _firebaseService.signOut();

      debugPrint('✅ Sign out successful, emitting Unauthenticated');
      emit(Unauthenticated());
    } catch (e) {
      debugPrint('❌ Sign out error: $e');
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

