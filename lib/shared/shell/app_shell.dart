import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/app_sidebar.dart';

/// Responsive application shell.
/// Desktop / Tablet → permanent sidebar + content.
/// Mobile → Drawer sidebar + content.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth >= 700;
        if (isWide) {
          return _DesktopShell(child: child);
        } else {
          return _MobileShell(child: child);
        }
      },
    );
  }
}

/// Desktop/Tablet: persistent sidebar on the left.
class _DesktopShell extends StatelessWidget {
  const _DesktopShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Row(
        children: [
          const AppSidebar(),
          // Vertical divider between sidebar and content
          Container(
            width: 1,
            color: AppColors.sidebarDivider,
          ),
          Expanded(
            child: ClipRect(child: child),
          ),
        ],
      ),
    );
  }
}

/// Mobile: Drawer-based sidebar.
class _MobileShell extends StatelessWidget {
  const _MobileShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      drawer: const Drawer(
        backgroundColor: AppColors.sidebarBackground,
        width: 220,
        child: AppSidebar(),
      ),
      appBar: AppBar(
        backgroundColor: AppColors.sidebarBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded,
                color: AppColors.textPrimary),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Image.asset(
          'assets/images/LOGO-c7veMtdM.png',
          height: 36,
          fit: BoxFit.contain,
        ),
      ),
      body: child,
    );
  }
}
