import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/onboarding/presentation/pages/splash_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/explore/presentation/pages/explore_page.dart';
import '../../features/explore/presentation/pages/destination_details_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/navigation/presentation/pages/ar_camera_view.dart';
import '../../shared/widgets/main_navigation.dart';

class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String main = '/main';
  static const String home = '/home';
  static const String explore = '/explore';
  static const String profile = '/profile';
  static const String arNavigation = '/ar-navigation';
  static const String destinationDetails = '/destination-details';
  static const String settings = '/settings';
  static const String favorites = '/favorites';
  static const String history = '/history';
  static const String help = '/help';
  static const String feedback = '/feedback';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      // Splash Screen
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashPage(),
      ),

      // Onboarding
      GoRoute(
        path: onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),

      // Authentication
      GoRoute(
        path: login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: signup,
        builder: (context, state) => const SignupPage(),
      ),

      // Main Navigation with Bottom Nav
      GoRoute(
        path: main,
        builder: (context, state) => const MainNavigation(),
      ),

      // Individual Pages (accessed via bottom nav)
      GoRoute(
        path: home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: explore,
        builder: (context, state) => const ExplorePage(),
      ),
      GoRoute(
        path: profile,
        builder: (context, state) => const ProfilePage(),
      ),

      // AR Navigation
      GoRoute(
        path: arNavigation,
        builder: (context, state) {
          final destinationName = state.uri.queryParameters['destination'];
          return ARCameraView(destinationName: destinationName);
        },
      ),

      // Destination Details
      GoRoute(
        path: destinationDetails,
        builder: (context, state) {
          final name = state.uri.queryParameters['name'] ?? 'Unknown';
          final floor = state.uri.queryParameters['floor'];
          final description = state.uri.queryParameters['description'];
          final category = state.uri.queryParameters['category'];
          return DestinationDetailsPage(
            destinationName: name,
            floor: floor,
            description: description,
            category: category,
          );
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
}

