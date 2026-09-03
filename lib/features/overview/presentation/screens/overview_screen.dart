// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Partner Dashboard — Overview screen.
class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isMobile = constraints.maxWidth < 600;

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 28,
              vertical: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Do NOT make this const because flutter_animate
                // modifies the widget with an animation extension.
                _PageHeader()
                    .animate()
                    .fadeIn(duration: 350.ms)
                    .slideY(
                      begin: -0.08,
                      end: 0,
                    ),

                const SizedBox(height: 24),

                const _RevenueSection(),

                const SizedBox(height: 24),

                const _OverviewMainGrid(),

                const SizedBox(height: 24),

                const _RecentBookingsCard(),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─── Page Header ──────────────────────────────────────────────────────────────

class _PageHeader extends StatelessWidget {
  const _PageHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: AppTypography.pageTitle,
        ),
        const SizedBox(height: 5),
        Text(
          'Welcome back, StyleWow Partner',
          style: AppTypography.bodySM,
        ),
      ],
    );
  }
}

// ─── Revenue Section ──────────────────────────────────────────────────────────

class _RevenueSection extends StatelessWidget {
  const _RevenueSection();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final int crossAxisCount = constraints.maxWidth >= 900 ? 3 : 1;

        const List<_RevenueData> revenueItems = [
          _RevenueData(
            title: "TODAY'S REVENUE",
            value: '₹ 0',
            icon: Icons.payments_outlined,
          ),
          _RevenueData(
            title: 'WEEKLY REVENUE',
            value: '₹ 300',
            icon: Icons.trending_up_rounded,
          ),
          _RevenueData(
            title: 'MONTHLY REVENUE',
            value: '₹ 300',
            icon: Icons.bar_chart_rounded,
          ),
        ];

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: revenueItems.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 112,
          ),
          itemBuilder: (context, index) {
            final item = revenueItems[index];

            return _RevenueCard(
              title: item.title,
              value: item.value,
              icon: item.icon,
              index: index,
            );
          },
        );
      },
    );
  }
}

class _RevenueData {
  const _RevenueData({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;
}

class _RevenueCard extends StatelessWidget {
  const _RevenueCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.index,
  });

  final String title;
  final String value;
  final IconData icon;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.categoryBadgeBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelXS,
                ),
                const SizedBox(height: 7),
                Text(
                  value,
                  style: AppTypography.priceLG.copyWith(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(
          duration: 300.ms,
          delay: Duration(
            milliseconds: index * 70,
          ),
        )
        .slideY(
          begin: 0.08,
          end: 0,
        );
  }
}

// ─── Main Overview Grid ───────────────────────────────────────────────────────

class _OverviewMainGrid extends StatelessWidget {
  const _OverviewMainGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth >= 800;

        if (!isWide) {
          return const Column(
            children: [
              _BookingStatisticsCard(),
              SizedBox(height: 16),
              _ActiveServicesCard(),
            ],
          );
        }

        return const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: _BookingStatisticsCard(),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _ActiveServicesCard(),
            ),
          ],
        );
      },
    );
  }
}

// ─── Booking Statistics ───────────────────────────────────────────────────────

class _BookingStatisticsCard extends StatelessWidget {
  const _BookingStatisticsCard();

  @override
  Widget build(BuildContext context) {
    const List<(String, String, Color)> stats = [
      (
        'TOTAL',
        '6',
        AppColors.textPrimary,
      ),
      (
        'CONFIRMED',
        '1',
        AppColors.confirmedText,
      ),
      (
        'COMPLETED',
        '4',
        AppColors.completedText,
      ),
      (
        'CANCELLED',
        '1',
        AppColors.cancelledText,
      ),
    ];

    return _DashboardCard(
      title: 'Booking Statistics',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool isSmall = constraints.maxWidth < 360;

          if (!isSmall) {
            return Row(
              children: stats.map((stat) {
                return Expanded(
                  child: _StatItem(
                    value: stat.$2,
                    label: stat.$1,
                    color: stat.$3,
                  ),
                );
              }).toList(),
            );
          }

          return Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 20,
            children: stats.map((stat) {
              return SizedBox(
                width: (constraints.maxWidth - 20) / 2,
                child: _StatItem(
                  value: stat.$2,
                  label: stat.$1,
                  color: stat.$3,
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          textAlign: TextAlign.center,
          style: AppTypography.priceLG.copyWith(
            fontSize: 22,
            color: color,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.labelXS,
        ),
      ],
    );
  }
}

// ─── Active Services ──────────────────────────────────────────────────────────

class _ActiveServicesCard extends StatelessWidget {
  const _ActiveServicesCard();

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      title: 'Active Services',
      trailing: Text(
        '2 ACTIVE',
        style: AppTypography.labelXS.copyWith(
          color: AppColors.confirmedText,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _ServicePreview(
            name: 'Royal Beard Trim',
            price: '₹ 150',
            duration: '30 min',
          ),
          const SizedBox(height: 10),
          const _ServicePreview(
            name: 'Balayage Highlights',
            price: '₹ 1,200',
            duration: '120 min',
          ),
        ],
      ),
    );
  }
}

class _ServicePreview extends StatelessWidget {
  const _ServicePreview({
    required this.name,
    required this.price,
    required this.duration,
  });

  final String name;
  final String price;
  final String duration;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.categoryBadgeBg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelMD,
                ),
                const SizedBox(height: 4),
                Text(
                  duration,
                  style: AppTypography.bodyXS,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            price,
            style: AppTypography.priceLG,
          ),
        ],
      ),
    );
  }
}

// ─── Recent Bookings ──────────────────────────────────────────────────────────

class _RecentBookingsCard extends StatelessWidget {
  const _RecentBookingsCard();

  @override
  Widget build(BuildContext context) {
    const List<(String, String, String, String)> recentBookings = [
      (
        'Arjun Sharma',
        'Royal Beard Trim',
        '2026-08-05',
        'CONFIRMED',
      ),
      (
        'Priya Mehta',
        'Balayage Highlights',
        '2026-08-05',
        'CONFIRMED',
      ),
      (
        'Rohit Verma',
        'Classic Haircut',
        '2026-08-04',
        'COMPLETED',
      ),
      (
        'Deepak Kumar',
        'Royal Beard Trim',
        '2026-08-03',
        'CANCELLED',
      ),
    ];

    return _DashboardCard(
      title: 'Recent Bookings',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool isMobile = constraints.maxWidth < 600;

          if (isMobile) {
            return Column(
              children: recentBookings.asMap().entries.map((entry) {
                final booking = entry.value;

                return _MobileBookingCard(
                  client: booking.$1,
                  service: booking.$2,
                  date: booking.$3,
                  status: booking.$4,
                  index: entry.key,
                );
              }).toList(),
            );
          }

          return _DesktopBookingsTable(
            bookings: recentBookings,
          );
        },
      ),
    );
  }
}

// ─── Desktop Bookings Table ───────────────────────────────────────────────────

class _DesktopBookingsTable extends StatelessWidget {
  const _DesktopBookingsTable({
    required this.bookings,
  });

  final List<(String, String, String, String)> bookings;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // NOT const:
        // AppTypography.tableHeader is a runtime getter.
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'CLIENT',
                  style: AppTypography.tableHeader,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'SERVICE',
                  style: AppTypography.tableHeader,
                ),
              ),
              Expanded(
                child: Text(
                  'DATE',
                  style: AppTypography.tableHeader,
                ),
              ),
              SizedBox(
                width: 110,
                child: Text(
                  'STATUS',
                  style: AppTypography.tableHeader,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),

        const Divider(
          height: 1,
          color: AppColors.divider,
        ),

        ...bookings.asMap().entries.map((entry) {
          final booking = entry.value;

          return _BookingRow(
            client: booking.$1,
            service: booking.$2,
            date: booking.$3,
            status: booking.$4,
            index: entry.key,
          );
        }),
      ],
    );
  }
}

// ─── Desktop Booking Row ──────────────────────────────────────────────────────

class _BookingRow extends StatelessWidget {
  const _BookingRow({
    required this.client,
    required this.service,
    required this.date,
    required this.status,
    required this.index,
  });

  final String client;
  final String service;
  final String date;
  final String status;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 14,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              client,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.tableCell,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              service,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.tableCellSub,
            ),
          ),
          Expanded(
            child: Text(
              date,
              style: AppTypography.tableCellSub,
            ),
          ),
          SizedBox(
            width: 110,
            child: Align(
              alignment: Alignment.centerRight,
              child: _StatusChip(
                status: status,
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(
          duration: 280.ms,
          delay: Duration(
            milliseconds: 380 + index * 60,
          ),
        );
  }
}

// ─── Mobile Booking Card ──────────────────────────────────────────────────────

class _MobileBookingCard extends StatelessWidget {
  const _MobileBookingCard({
    required this.client,
    required this.service,
    required this.date,
    required this.status,
    required this.index,
  });

  final String client;
  final String service;
  final String date;
  final String status;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.categoryBadgeBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  client,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.tableCell.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _StatusChip(
                status: status,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            service,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodySM,
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: AppTypography.tableCellSub,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(
          duration: 280.ms,
          delay: Duration(
            milliseconds: 380 + index * 60,
          ),
        );
  }
}

// ─── Status Chip ──────────────────────────────────────────────────────────────

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.status,
  });

  final String status;

  @override
  Widget build(BuildContext context) {
    final Color background;
    final Color foreground;

    switch (status) {
      case 'CONFIRMED':
        background = AppColors.confirmedBg;
        foreground = AppColors.confirmedText;
        break;

      case 'COMPLETED':
        background = AppColors.completedBg;
        foreground = AppColors.completedText;
        break;

      case 'CANCELLED':
        background = AppColors.cancelledBg;
        foreground = AppColors.cancelledText;
        break;

      default:
        background = AppColors.pendingBg;
        foreground = AppColors.pendingText;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status,
        style: AppTypography.labelXS.copyWith(
          color: foreground,
        ),
      ),
    );
  }
}

// ─── Shared Dashboard Card ────────────────────────────────────────────────────

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.title,
    required this.child,
    this.trailing,
  });

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.cardTitle,
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}