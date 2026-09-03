import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/routes/app_router.dart';

// ─── Data model ────────────────────────────────────────────────────────────────
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
  _NavItem(label: 'OVERVIEW',     icon: Icons.pie_chart_outline_rounded,  route: AppRoutes.overview),
  _NavItem(label: 'APPOINTMENTS', icon: Icons.calendar_month_outlined,    route: AppRoutes.appointments),
  _NavItem(label: 'MY SERVICES',  icon: Icons.build_outlined,             route: AppRoutes.services),
  _NavItem(label: 'FEEDBACK',     icon: Icons.star_outline_rounded,       route: AppRoutes.feedback),
  _NavItem(label: 'SHOP PROFILE', icon: Icons.settings_outlined,          route: AppRoutes.profile),
  _NavItem(label: 'CONNECT US',   icon: Icons.mail_outline_rounded,       route: AppRoutes.connectUs),
];

/// Permanent sidebar matching the design screenshots exactly.
class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  static const double _width = 210;

  @override
  Widget build(BuildContext context) {
    final String currentRoute = GoRouterState.of(context).matchedLocation;

    return SizedBox(
      width: _width,
      child: ColoredBox(
        color: AppColors.sidebarBackground,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 28),
            _buildProfile(),
            const SizedBox(height: 28),
            const Divider(color: AppColors.sidebarDivider, height: 1, thickness: 1),
            const SizedBox(height: 12),
            Expanded(child: _buildNavItems(context, currentRoute)),
            _buildLogout(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Image.asset(
        'assets/images/LOGO-c7veMtdM.png',
        height: 48,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildNavItems(BuildContext context, String currentRoute) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _navItems.length,
      itemBuilder: (context, index) {
        final item = _navItems[index];
        final bool isActive = currentRoute == item.route;
        return _SidebarTile(
          item: item,
          isActive: isActive,
          onTap: () => context.go(item.route),
        ).animate().fadeIn(
              duration: const Duration(milliseconds: 200),
              delay: Duration(milliseconds: index * 40),
            );
      },
    );
  }

  Widget _buildLogout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: InkWell(
        onTap: () {
          AuthSession.isLoggedIn = false;
          context.go(AppRoutes.login);
        },
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Row(
            children: [
              const Icon(Icons.logout_rounded, size: 18, color: AppColors.logout),
              const SizedBox(width: 12),
              Text('LOGOUT', style: AppTypography.logoutText),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Sidebar tile with animated active state ───────────────────────────────────
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
    _bgAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  @override
  void didUpdateWidget(_SidebarTile old) {
    super.didUpdateWidget(old);
    if (widget.isActive != old.isActive) {
      widget.isActive ? _controller.forward() : _controller.reverse();
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: AnimatedBuilder(
        animation: _bgAnimation,
        builder: (context, child) {
          final Color bg = Color.lerp(
            Colors.transparent,
            AppColors.sidebarActive,
            _bgAnimation.value,
          )!;
          final Color iconAndText = Color.lerp(
            AppColors.sidebarInactiveText,
            AppColors.sidebarActiveText,
            _bgAnimation.value,
          )!;
          return Material(
            color: bg,
            borderRadius: BorderRadius.circular(6),
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(6),
              splashColor: Colors.white.withValues(alpha: 0.08),
              highlightColor: Colors.white.withValues(alpha: 0.04),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                child: Row(
                  children: [
                    Icon(widget.item.icon, size: 18, color: iconAndText),
                    const SizedBox(width: 12),
                    Text(
                      widget.item.label,
                      style: AppTypography.sidebarItem.copyWith(color: iconAndText),
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
