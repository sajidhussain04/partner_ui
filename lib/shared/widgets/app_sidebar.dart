import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/routes/app_router.dart';
import '../../core/config/partner_session.dart';

class _NavItem {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.route,
  });

  final String label;
  final IconData icon;
  final String route;
}

const List<_NavItem> _navItems = [
  _NavItem(
    label: 'OVERVIEW',
    icon: Icons.pie_chart_outline_rounded,
    route: AppRoutes.overview,
  ),
  _NavItem(
    label: 'APPOINTMENTS',
    icon: Icons.calendar_month_outlined,
    route: AppRoutes.appointments,
  ),
  _NavItem(
    label: 'MY SERVICES',
    icon: Icons.content_cut_outlined,
    route: AppRoutes.services,
  ),
  _NavItem(
    label: 'FEEDBACK',
    icon: Icons.star_outline_rounded,
    route: AppRoutes.feedback,
  ),
  _NavItem(
    label: 'SHOP PROFILE',
    icon: Icons.settings_outlined,
    route: AppRoutes.profile,
  ),
  _NavItem(
    label: 'CONNECT US',
    icon: Icons.mail_outline_rounded,
    route: AppRoutes.connectUs,
  ),
];

/// Partner dashboard sidebar.
/// Designed to match the official StyleWow vendor dashboard.
class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  static const double width = 256;

  @override
  Widget build(BuildContext context) {
    final String currentRoute = GoRouterState.of(context).matchedLocation;

    return SizedBox(
      width: width,
      child: ColoredBox(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),

            // ==============================
            // WELCOME / PARTNER INFORMATION
            // ==============================
            _buildWelcomeSection(),

            const Divider(
              color: AppColors.sidebarDivider,
              height: 1,
              thickness: 1,
            ),

            // ==============================
            // NAVIGATION
            // ==============================
            Expanded(
              child: _buildNavItems(
                context,
                currentRoute,
              ),
            ),

            // ==============================
            // LOGOUT
            // ==============================
            _buildLogout(context),

            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    final user = Supabase.instance.client.auth.currentUser;

    final metadata = user?.userMetadata ?? {};

    final String name = (metadata['name'] ??
            metadata['full_name'] ??
            metadata['display_name'] ??
            'StyleWow Partner')
        .toString()
        .trim();

    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 4, 24, 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.account_circle_outlined,
            size: 36,
            color: AppColors.textPrimary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WELCOME',
                  style: AppTypography.sidebarItem.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.4,
                    color: Colors.grey.shade400,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  name.isEmpty ? 'StyleWow Partner' : name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.sidebarItem.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItems(
    BuildContext context,
    String currentRoute,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      itemCount: _navItems.length,
      itemBuilder: (context, index) {
        final item = _navItems[index];

        final bool isActive = currentRoute == item.route;

        return _SidebarTile(
          item: item,
          isActive: isActive,
          onTap: () {
            // On mobile, close the Drawer before changing the route.
            // On desktop/tablet there is no open Drawer, so this is a no-op.
            final scaffold = Scaffold.maybeOf(context);

            if (scaffold?.isDrawerOpen ?? false) {
              scaffold!.closeDrawer();
            }

            context.go(item.route);
          },
        ).animate().fadeIn(
              duration: const Duration(milliseconds: 200),
              delay: Duration(
                milliseconds: index * 40,
              ),
            );
      },
    );
  }

  Widget _buildLogout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: InkWell(
        onTap: () async {
          await PartnerSession.signOut();

          if (!context.mounted) return;

          context.go(AppRoutes.login);
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.logout_rounded,
                size: 20,
                color: Colors.redAccent,
              ),
              const SizedBox(width: 16),
              Text(
                'LOGOUT',
                style: AppTypography.logoutText.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SidebarTile extends StatefulWidget {
  const _SidebarTile({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  State<_SidebarTile> createState() => _SidebarTileState();
}

class _SidebarTileState extends State<_SidebarTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bgAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      value: widget.isActive ? 1.0 : 0.0,
    );

    _bgAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
  }

  @override
  void didUpdateWidget(
    _SidebarTile oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 2,
      ),
      child: AnimatedBuilder(
        animation: _bgAnimation,
        builder: (context, child) {
          final Color background = Color.lerp(
            Colors.transparent,
            const Color(0xFF3A3430),
            _bgAnimation.value,
          )!;

          final Color foreground = Color.lerp(
            Colors.grey.shade400,
            Colors.white,
            _bgAnimation.value,
          )!;

          return Material(
            color: background,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(8),
              splashColor: Colors.white.withValues(alpha: 0.08),
              highlightColor: Colors.white.withValues(alpha: 0.04),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    Icon(
                      widget.item.icon,
                      size: 19,
                      color: foreground,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        widget.item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.sidebarItem.copyWith(
                          color: foreground,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

