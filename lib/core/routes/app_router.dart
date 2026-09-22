import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/partner_session.dart';
import '../../features/overview/presentation/screens/overview_screen.dart';
import '../../features/appointments/presentation/screens/appointments_screen.dart';
import '../../features/services/presentation/screens/services_screen.dart';
import '../../features/feedback/presentation/screens/feedback_screen.dart';
import '../../features/profile/presentation/screens/shop_profile_screen.dart';
import '../../features/connect_us/presentation/screens/connect_us_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/screens/approval_status_screen.dart';
import '../../shared/shell/app_shell.dart';

class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String signup = '/signup';
  static const String approval = '/approval';
  static const String overview = '/overview';
  static const String appointments = '/appointments';
  static const String services = '/services';
  static const String feedback = '/feedback';
  static const String profile = '/profile';
  static const String connectUs = '/connect-us';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.login,

  redirect: (context, state) {
    final String currentPath = state.uri.path;

    final bool isAuthPage =
        currentPath == AppRoutes.login ||
        currentPath == AppRoutes.signup;

    final bool isApprovalPage = currentPath == AppRoutes.approval;

    final bool isLoggedIn = PartnerSession.isLoggedIn;
    final bool isApproved = PartnerSession.isApproved;

    // No active partner session.
    if (!isLoggedIn && !isAuthPage) {
      return AppRoutes.login;
    }

    // Logged-in vendor is not approved.
    // Block every live dashboard route.
    if (isLoggedIn && !isApproved && !isApprovalPage) {
      return AppRoutes.approval;
    }

    // Approved partner should go to the live dashboard.
    if (isLoggedIn && isApproved && (isAuthPage || isApprovalPage)) {
      return AppRoutes.overview;
    }

    return null;
  },

  routes: [
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

    GoRoute(
      path: AppRoutes.approval,
      pageBuilder: (context, state) {
        return _fadePage(
          key: state.pageKey,
          child: const ApprovalStatusScreen(),
        );
      },
    ),

    ShellRoute(
      builder: (context, state, child) {
        return AppShell(child: child);
      },
      routes: [
        GoRoute(
          path: AppRoutes.overview,
          pageBuilder: (context, state) {
            return _fadePage(
              key: state.pageKey,
              child: const OverviewScreen(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.appointments,
          pageBuilder: (context, state) {
            return _fadePage(
              key: state.pageKey,
              child: const AppointmentsScreen(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.services,
          pageBuilder: (context, state) {
            return _fadePage(
              key: state.pageKey,
              child: const ServicesScreen(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.feedback,
          pageBuilder: (context, state) {
            return _fadePage(
              key: state.pageKey,
              child: const FeedbackScreen(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.profile,
          pageBuilder: (context, state) {
            return _fadePage(
              key: state.pageKey,
              child: const ShopProfileScreen(),
            );
          },
        ),
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
