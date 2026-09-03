import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class ConnectUsScreen extends StatelessWidget {
  const ConnectUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Connect Us', style: AppTypography.pageTitle)
                .animate()
                .fadeIn(duration: 300.ms),
            const SizedBox(height: 24),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: const _ConnectCard()
                    .animate()
                    .fadeIn(duration: 350.ms)
                    .slideY(begin: -0.05, end: 0, duration: 300.ms),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Connect With Us Card ──────────────────────────────────────────────────────
class _ConnectCard extends StatelessWidget {
  const _ConnectCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Connect With Us', style: AppTypography.connectTitle)
              .animate()
              .fadeIn(duration: 300.ms, delay: 100.ms),
          const SizedBox(height: 10),
          Text(
            'Need help with your shop, payouts, or service listings? Our partner team will respond within 24 hours.',
            style: AppTypography.connectSubtitle,
          ).animate().fadeIn(duration: 300.ms, delay: 150.ms),
          const SizedBox(height: 24),
          const _InfoTile(
            label: 'EMAIL',
            value: 'support@stylewow.app',
            icon: Icons.mail_outline_rounded,
            delay: 200,
          ),
          const SizedBox(height: 14),
          const _InfoTile(
            label: 'SUPPORT HOURS',
            value: 'Mon - Sat · 10:00 AM - 7:00 PM',
            icon: null,
            delay: 260,
          ),
          const SizedBox(height: 14),
          const _PriorityTipsTile(delay: 320),
        ],
      ),
    );
  }
}

// ─── Info Tile ─────────────────────────────────────────────────────────────────
class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.delay,
  });

  final String label;
  final String value;
  final IconData? icon;
  final int delay;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: 14),
          ],
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTypography.connectCardLabel),
              const SizedBox(height: 4),
              Text(value, style: AppTypography.connectCardValue),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms, delay: Duration(milliseconds: delay))
        .slideY(begin: 0.05, end: 0, duration: 280.ms);
  }
}

// ─── Priority Tips Tile ────────────────────────────────────────────────────────
class _PriorityTipsTile extends StatelessWidget {
  const _PriorityTipsTile({required this.delay});
  final int delay;

  @override
  Widget build(BuildContext context) {
    const tips = [
      'Include your shop name and registered email.',
      'Mention the service or booking ID if applicable.',
      'We reply within one business day.',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('PRIORITY TIPS', style: AppTypography.connectCardLabel),
          const SizedBox(height: 10),
          ...tips.map(
            (tip) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(tip, style: AppTypography.connectCardValue),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms, delay: Duration(milliseconds: delay))
        .slideY(begin: 0.05, end: 0, duration: 280.ms);
  }
}
