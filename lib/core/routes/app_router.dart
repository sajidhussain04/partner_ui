import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/overview/presentation/screens/overview_screen.dart';
import '../../features/appointments/presentation/screens/appointments_screen.dart';
import '../../features/services/presentation/screens/services_screen.dart';
import '../../features/feedback/presentation/screens/feedback_screen.dart';
import '../../features/profile/presentation/screens/shop_profile_screen.dart';
import '../../features/connect_us/presentation/screens/connect_us_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../shared/shell/app_shell.dart';

/// ---------------------------------------------------------------------------
/// UI-only authentication session
///
/// This is intentionally static for the current development phase.
///
/// Current behavior:
///   SIGN IN  -> isLoggedIn = true -> /overview
///
/// Later, this class can be replaced/connected to the real authentication
/// service without changing the application's route structure.
/// ---------------------------------------------------------------------------
class AuthSession {
  AuthSession._();

  static bool isLoggedIn = false;

  /// Marks the partner as logged in.
  static void login() {
    isLoggedIn = true;
  }

  /// Marks the partner as logged out.
  static void logout() {
    isLoggedIn = false;
  }
}

/// ---------------------------------------------------------------------------
/// Application routes
/// ---------------------------------------------------------------------------
class AppRoutes {
  AppRoutes._();

  // Authentication
  static const String login = '/login';
  static const String signup = '/signup';

  // Partner dashboard
  static const String overview = '/overview';
  static const String appointments = '/appointments';
  static const String services = '/services';
  static const String feedback = '/feedback';
  static const String profile = '/profile';
  static const String connectUs = '/connect-us';
}

/// ---------------------------------------------------------------------------
/// Global application router
/// ---------------------------------------------------------------------------
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.login,

  /// -------------------------------------------------------------------------
  /// Authentication redirect
  ///
  /// Rules:
  ///
  /// 1. User is NOT logged in
  ///    -> Only /login and /signup are allowed.
  ///    -> Any dashboard route redirects to /login.
  ///
  /// 2. User IS logged in
  ///    -> /login and /signup redirect to /overview.
  ///
  /// This allows us to keep authentication static now and replace it with
  /// real authentication later.
  /// -------------------------------------------------------------------------
  redirect: (context, state) {
    final String currentPath = state.uri.path;

    final bool isAuthPage =
        currentPath == AppRoutes.login ||
        currentPath == AppRoutes.signup;

    // User is not authenticated and is trying to access a protected page.
    if (!AuthSession.isLoggedIn && !isAuthPage) {
      return AppRoutes.login;
    }

    // User is already authenticated and tries to open login/signup.
    if (AuthSession.isLoggedIn && isAuthPage) {
      return AppRoutes.overview;
    }

    // No redirect required.
    return null;
  },

  routes: [
    // =========================================================================
    // AUTHENTICATION ROUTES
    // =========================================================================

    GoRoute(
      path: AppRoutes.login,
      pageBuilder: (context, state) {
        return _fadePage(
          key: state.pageKey,
          child: const LoginScreen(),
        );
      },
    ),

    GoRoute(
      path: AppRoutes.signup,
      pageBuilder: (context, state) {
        return _fadePage(
          key: state.pageKey,
          child: const SignupScreen(),
        );
      },
    ),

    // =========================================================================
    // PARTNER APPLICATION
    // =========================================================================

    ShellRoute(
      builder: (context, state, child) {
        return AppShell(child: child);
      },

      routes: [
        // ---------------------------------------------------------------------
        // Overview
        // ---------------------------------------------------------------------
        GoRoute(
          path: AppRoutes.overview,
          pageBuilder: (context, state) {
            return _fadePage(
              key: state.pageKey,
              child: const OverviewScreen(),
            );
          },
        ),

        // ---------------------------------------------------------------------
        // Appointments
        // ---------------------------------------------------------------------
        GoRoute(
          path: AppRoutes.appointments,
          pageBuilder: (context, state) {
            return _fadePage(
              key: state.pageKey,
              child: const AppointmentsScreen(),
            );
          },
        ),

        // ---------------------------------------------------------------------
        // Services
        // ---------------------------------------------------------------------
        GoRoute(
          path: AppRoutes.services,
          pageBuilder: (context, state) {
            return _fadePage(
              key: state.pageKey,
              child: const ServicesScreen(),
            );
          },
        ),

        // ---------------------------------------------------------------------
        // Feedback
        // ---------------------------------------------------------------------
        GoRoute(
          path: AppRoutes.feedback,
          pageBuilder: (context, state) {
            return _fadePage(
              key: state.pageKey,
              child: const FeedbackScreen(),
            );
          },
        ),

        // ---------------------------------------------------------------------
        // Shop Profile
        // ---------------------------------------------------------------------
        GoRoute(
          path: AppRoutes.profile,
          pageBuilder: (context, state) {
            return _fadePage(
              key: state.pageKey,
              child: const ShopProfileScreen(),
            );
          },
        ),

        // ---------------------------------------------------------------------
        // Connect Us
        // ---------------------------------------------------------------------
        GoRoute(
          path: AppRoutes.connectUs,
          pageBuilder: (context, state) {
            return _fadePage(
              key: state.pageKey,
              child: const ConnectUsScreen(),
            );
          },
        ),
      ],
    ),
  ],
);

/// ---------------------------------------------------------------------------
/// Standard fade transition used between application pages.
/// ---------------------------------------------------------------------------
CustomTransitionPage<void> _fadePage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (
      context,
      animation,
      secondaryAnimation,
      child,
    ) {
      return FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.easeIn,
        ),
        child: child,
      );
    },
  );
}