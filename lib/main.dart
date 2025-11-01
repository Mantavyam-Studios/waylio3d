import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/config/app_router.dart';
import 'data/services/firebase_service.dart';
import 'features/auth/data/auth_bloc.dart';
import 'features/auth/data/auth_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await FirebaseService.initialize();
  } catch (e) {
    // Firebase not configured yet - continue without it
    debugPrint('Firebase initialization failed: $e');
  }

  runApp(const WaylioApp());
}

class WaylioApp extends StatelessWidget {
  const WaylioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc()..add(CheckAuthStatus()),
      child: MaterialApp.router(
        title: 'Waylio',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
