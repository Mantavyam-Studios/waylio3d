import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../../core/constants/app_constants.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Initialize Firebase
  static Future<void> initialize() async {
    debugPrint('🔥 Initializing Firebase...');
    await Firebase.initializeApp();
    debugPrint('✅ Firebase initialized successfully');

    // Initialize Google Sign-In with server client ID
    debugPrint('🔐 Initializing Google Sign-In...');
    await GoogleSignIn.instance.initialize(
      // Web client ID from google-services.json (client_type: 3)
      serverClientId: '535833660625-0jv6onrffql2or97cfamnm9j8pe0mcc8.apps.googleusercontent.com',
    );
    debugPrint('✅ Google Sign-In initialized successfully');
  }

  // Sign up with email and password
  Future<UserModel?> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required String userType,
  }) async {
    try {
      debugPrint('📝 Creating account for: $email');

      final UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        debugPrint('✅ Account created successfully: ${credential.user!.uid}');

        // Update display name
        await credential.user!.updateDisplayName(name);
        debugPrint('✅ Display name updated: $name');

        // Create user document in Firestore
        final userModel = UserModel(
          uid: credential.user!.uid,
          email: email,
          name: name,
          photoUrl: null,
          userType: userType,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isGuest: false,
        );

        await _createUserDocument(userModel);
        debugPrint('✅ User document created in Firestore');

        return userModel;
      }

      debugPrint('❌ Account creation failed: no user returned');
      return null;
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ Firebase Auth error: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      debugPrint('❌ Sign up error: $e');
      throw Exception('Failed to sign up: $e');
    }
  }

  // Sign in with email and password
  Future<UserModel?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('🔐 Signing in with email: $email');

      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        debugPrint('✅ Sign in successful: ${credential.user!.uid}');
        final userModel = await _getUserDocument(credential.user!.uid);
        debugPrint('✅ User document loaded from Firestore');
        return userModel;
      }

      debugPrint('❌ Sign in failed: no user returned');
      return null;
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ Firebase Auth error: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      debugPrint('❌ Sign in error: $e');
      throw Exception('Failed to sign in: $e');
    }
  }

  // Sign in with Google
  Future<UserModel?> signInWithGoogle() async {
    try {
      debugPrint('🔐 Starting Google Sign-In...');

      // Trigger the authentication flow using the new API
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance.authenticate();

      debugPrint('✅ Google user authenticated: ${googleUser.email}');

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      debugPrint('🔑 Got Google auth tokens');

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      debugPrint('🔐 Signing in to Firebase with Google credential...');

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        debugPrint('✅ Firebase sign-in successful: ${userCredential.user!.email}');

        // Check if user document exists
        final userDoc = await _firestore
            .collection(AppConstants.usersCollection)
            .doc(userCredential.user!.uid)
            .get();

        if (!userDoc.exists) {
          debugPrint('📝 Creating new user document for Google user');
          // Create user document for new Google users
          final userModel = UserModel(
            uid: userCredential.user!.uid,
            email: userCredential.user!.email ?? '',
            name: userCredential.user!.displayName ?? 'User',
            photoUrl: userCredential.user!.photoURL,
            userType: AppConstants.userTypes[0], // Default to first user type
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            isGuest: false,
          );

          await _createUserDocument(userModel);
          return userModel;
        } else {
          debugPrint('📖 Loading existing user document');
          // Return existing user
          return await _getUserDocument(userCredential.user!.uid);
        }
      }

      debugPrint('❌ Firebase sign-in failed: no user returned');
      return null;
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ Firebase Auth error: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      debugPrint('❌ Google Sign-In error: $e');
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      debugPrint('🚪 Signing out...');
      await Future.wait([
        _auth.signOut(),
        GoogleSignIn.instance.signOut(),
      ]);
      debugPrint('✅ Sign out successful');
    } catch (e) {
      debugPrint('❌ Sign out error: $e');
      throw Exception('Failed to sign out: $e');
    }
  }

  // Delete account
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Delete user document from Firestore
        await _firestore.collection(AppConstants.usersCollection).doc(user.uid).delete();

        // Delete user from Firebase Auth
        await user.delete();
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    String? name,
    String? photoUrl,
    String? userType,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No user logged in');

      // Update Firebase Auth profile
      if (name != null) {
        await user.updateDisplayName(name);
      }
      if (photoUrl != null) {
        await user.updatePhotoURL(photoUrl);
      }

      // Update Firestore document
      final updates = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };
      if (name != null) updates['name'] = name;
      if (photoUrl != null) updates['photoUrl'] = photoUrl;
      if (userType != null) updates['userType'] = userType;

      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .update(updates);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  // Get user document from Firestore
  Future<UserModel?> _getUserDocument(String uid) async {
    try {
      debugPrint('📖 Fetching user document for UID: $uid');
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .get();

      if (doc.exists && doc.data() != null) {
        debugPrint('📄 User document data: ${doc.data()}');
        final data = doc.data()!;

        // Ensure required fields have default values if null
        final userModel = UserModel.fromJson({
          'uid': data['uid'] ?? uid,
          'email': data['email'] ?? '',
          'name': data['name'] ?? 'User',
          'photoUrl': data['photoUrl'],
          'userType': data['userType'] ?? AppConstants.userTypes[0],
          'createdAt': data['createdAt'] ?? DateTime.now().toIso8601String(),
          'updatedAt': data['updatedAt'],
          'isGuest': data['isGuest'] ?? false,
        });

        debugPrint('✅ User model created successfully');
        return userModel;
      }

      debugPrint('❌ User document does not exist');
      return null;
    } catch (e) {
      debugPrint('❌ Error getting user document: $e');
      throw Exception('Failed to get user document: $e');
    }
  }

  // Create user document in Firestore
  Future<void> _createUserDocument(UserModel user) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .set(user.toJson());
    } catch (e) {
      throw Exception('Failed to create user document: $e');
    }
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      case 'requires-recent-login':
        return 'Please log in again to perform this action.';
      default:
        return 'Authentication error: ${e.message}';
    }
  }

  // Get user stream
  Stream<UserModel?> getUserStream(String uid) {
    return _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .snapshots()
        .map((doc) {
      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data()!);
      }
      return null;
    });
  }

  // Check if email exists
  Future<bool> checkEmailExists(String email) async {
    try {
      // Try to create a user with a random password to check if email exists
      // This is a workaround since fetchSignInMethodsForEmail is deprecated
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: 'temp_password_${DateTime.now().millisecondsSinceEpoch}',
      );
      // If we get here, email doesn't exist, so delete the temp user
      await _auth.currentUser?.delete();
      return false;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Failed to send password reset email: $e');
    }
  }

  // Verify email
  Future<void> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      throw Exception('Failed to send verification email: $e');
    }
  }
}

