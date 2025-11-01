import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/config/app_router.dart';

void main() {
  runApp(const WaylioApp());
}

class WaylioApp extends StatelessWidget {
  const WaylioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Waylio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}
