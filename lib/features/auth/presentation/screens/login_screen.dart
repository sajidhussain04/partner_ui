// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/auth_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _loading = false;

  /// -------------------------------------------------------------------------
  /// STATIC LOGIN
  ///
  /// There is intentionally no email/password authentication at this stage.
  ///
  /// Clicking SIGN IN:
  ///   1. Marks the partner as logged in.
  ///   2. Navigates directly to the Overview screen.
  ///
  /// Real authentication can be connected later without changing the
  /// application's route structure.
  /// -------------------------------------------------------------------------
  void _handleLogin() {
    if (_loading) return;

    setState(() {
      _loading = true;
    });

    AuthSession.login();

    context.go(AppRoutes.overview);
  }

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: isWide ? _wideLayout() : _narrowLayout(),
    );
  }

  // ===========================================================================
  // DESKTOP / TABLET LAYOUT
  // ===========================================================================

  Widget _wideLayout() {
    return Row(
      children: [
        Expanded(
          child: _BrandPanel(),
        ),
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(48),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 420,
                ),
                child: _buildForm(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // MOBILE LAYOUT
  // ===========================================================================

  Widget _narrowLayout() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          _MobileHeader(),
          Padding(
            padding: const EdgeInsets.all(28),
            child: _buildForm(),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // LOGIN FORM
  // ===========================================================================

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back',
          style: AppTypography.pageTitle,
        ).animate().fadeIn(
              duration: 400.ms,
            ),

        const SizedBox(height: 6),

        Text(
          'Sign in to your partner account',
          style: AppTypography.bodySM.copyWith(
            color: AppColors.textSecondary,
          ),
        ).animate().fadeIn(
              duration: 400.ms,
              delay: 60.ms,
            ),

        const SizedBox(height: 36),

        // ---------------------------------------------------------------------
        // STATIC LOGIN INFORMATION
        // ---------------------------------------------------------------------

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.textHint.withValues(alpha: 0.18),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.sidebarActive.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.storefront_outlined,
                  size: 20,
                  color: AppColors.sidebarActive,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Partner Access',
                      style: AppTypography.cardTitle,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Continue directly to your partner dashboard.',
                      style: AppTypography.bodySM.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn(
              duration: 380.ms,
              delay: 100.ms,
            ),

        const SizedBox(height: 28),

        // ---------------------------------------------------------------------
        // SIGN IN BUTTON
        // ---------------------------------------------------------------------

        SizedBox(
          width: double.infinity,
          child: AuthButton(
            label: 'SIGN IN',
            loading: _loading,
            onTap: _handleLogin,
          ),
        ).animate().fadeIn(
              duration: 380.ms,
              delay: 160.ms,
            ),

        const SizedBox(height: 20),

        // ---------------------------------------------------------------------
        // SIGN UP
        // ---------------------------------------------------------------------

        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account?  ",
                style: AppTypography.bodySM.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              GestureDetector(
                onTap: () => context.go(AppRoutes.signup),
                child: Text(
                  'SIGN UP',
                  style: AppTypography.labelSM.copyWith(
                    color: AppColors.sidebarActive,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.sidebarActive,
                  ),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(
              duration: 380.ms,
              delay: 220.ms,
            ),
      ],
    );
  }
}

// =============================================================================
// DESKTOP BRAND PANEL
// =============================================================================

class _BrandPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.sidebarActive,
      padding: const EdgeInsets.all(52),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -------------------------------------------------------------------
          // STYLEWOW LOGO
          // -------------------------------------------------------------------

          Text(
            'STYLEWOW',
            style: AppTypography.pageTitle.copyWith(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ).animate().fadeIn(
                duration: 500.ms,
              ),

          const Spacer(),

          // -------------------------------------------------------------------
          // BRAND MESSAGE
          // -------------------------------------------------------------------

          Text(
            'Grow Your\nSalon Business.',
            style: AppTypography.displayLarge.copyWith(
              color: Colors.white,
              fontSize: 38,
              height: 1.15,
            ),
          )
              .animate()
              .fadeIn(
                duration: 600.ms,
                delay: 100.ms,
              )
              .slideY(
                begin: 0.1,
                end: 0,
              ),

          const SizedBox(height: 20),

          Text(
            'Manage appointments, track revenue, and\ndelight your clients — all in one place.',
            style: AppTypography.bodyLG.copyWith(
              color: Colors.white.withValues(alpha: 0.6),
              height: 1.6,
            ),
          ).animate().fadeIn(
                duration: 600.ms,
                delay: 200.ms,
              ),

          const SizedBox(height: 48),

          // -------------------------------------------------------------------
          // STAT 1
          // -------------------------------------------------------------------

          const _StatPill(
            icon: Icons.calendar_today_rounded,
            label: '12K+ Bookings Managed',
          ).animate().fadeIn(
                duration: 500.ms,
                delay: 300.ms,
              ),

          const SizedBox(height: 12),

          // -------------------------------------------------------------------
          // STAT 2
          // -------------------------------------------------------------------

          const _StatPill(
            icon: Icons.star_rounded,
            label: '4.9 Average Partner Rating',
          ).animate().fadeIn(
                duration: 500.ms,
                delay: 380.ms,
              ),

          const SizedBox(height: 12),

          // -------------------------------------------------------------------
          // STAT 3
          // -------------------------------------------------------------------

          const _StatPill(
            icon: Icons.store_rounded,
            label: '2,000+ Partner Salons',
          ).animate().fadeIn(
                duration: 500.ms,
                delay: 460.ms,
              ),

          const Spacer(),
        ],
      ),
    );
  }
}

// =============================================================================
// STAT PILL
// =============================================================================

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: AppColors.accentGold,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: AppTypography.labelMD.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// MOBILE HEADER
// =============================================================================

class _MobileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.sidebarActive,
      padding: const EdgeInsets.fromLTRB(
        28,
        56,
        28,
        36,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -------------------------------------------------------------------
          // STYLEWOW LOGO
          // -------------------------------------------------------------------

          Image.asset(
            'assets/images/LOGO-c7veMtdM.png',
            height: 40,
            fit: BoxFit.contain,
            color: Colors.white,
            colorBlendMode: BlendMode.srcIn,
          ),

          const SizedBox(height: 20),

          Text(
            'Grow Your Salon Business.',
            style: AppTypography.pageTitle.copyWith(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}
