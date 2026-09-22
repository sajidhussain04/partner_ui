import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/config/partner_session.dart';
import '../../../../core/data/partner_repository.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  final PartnerRepository _repository = PartnerRepository.instance;

  bool _loading = true;
  String? _errorMessage;

  int _totalBookings = 0;
  int _pendingBookings = 0;
  int _confirmedBookings = 0;
  int _completedBookings = 0;
  int _cancelledBookings = 0;

  List<_ServicePreviewData> _services = [];
  List<_BookingData> _recentBookings = [];

  int? get _vendorId => PartnerSession.vendorId;

  @override
  void initState() {
    super.initState();
    _loadOverview();
  }

  Future<void> _loadOverview() async {
    final vendorId = _vendorId;

    if (vendorId == null) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _errorMessage = 'Partner session was not found. Please log in again.';
      });
      return;
    }

    if (mounted) {
      setState(() {
        _loading = true;
        _errorMessage = null;
      });
    }

    try {
      final data = await _repository.vendorOverview(vendorId);

      final bookingRows =
          List<Map<String, dynamic>>.from(data['bookings'] as List);

      final serviceRows =
          List<Map<String, dynamic>>.from(data['services'] as List);

      final recentRows = bookingRows.take(4).map(_BookingData.fromMap).toList();

      final servicePreviews =
          serviceRows.take(4).map(_ServicePreviewData.fromMap).toList();

      if (!mounted) return;

      setState(() {
        _totalBookings = (data['totalBookings'] as num).toInt();
        _pendingBookings = (data['pendingBookings'] as num).toInt();
        _confirmedBookings = (data['confirmedBookings'] as num).toInt();
        _completedBookings = (data['completedBookings'] as num).toInt();
        _cancelledBookings = (data['cancelledBookings'] as num).toInt();

        _recentBookings = recentRows;
        _services = servicePreviews;

        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _errorMessage = _friendlyError(e);
      });
    }
  }

  String _friendlyError(Object error) {
    final message = error.toString();

    if (message.contains('SocketException') ||
        message.contains('Failed host lookup')) {
      return 'Unable to connect to Supabase. Check your internet connection.';
    }

    if (message.contains('permission denied') ||
        message.contains('row-level security')) {
      return 'You do not have permission to view this partner data.';
    }

    return 'Unable to load the dashboard. Please try again.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: RefreshIndicator(
        onRefresh: _loadOverview,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 600;

            if (_loading) {
              return const SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: 600,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }

            if (_errorMessage != null) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 28,
                  vertical: 24,
                ),
                children: [
                  const _PageHeader(),
                  const SizedBox(height: 24),
                  _OverviewError(
                    message: _errorMessage!,
                    onRetry: _loadOverview,
                  ),
                ],
              );
            }

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 28,
                vertical: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _PageHeader().animate().fadeIn(duration: 350.ms).slideY(
                        begin: -0.08,
                        end: 0,
                      ),
                  const SizedBox(height: 24),
                  const _RevenueSection(),
                  const SizedBox(height: 24),
                  _OverviewMainGrid(
                    totalBookings: _totalBookings,
                    pendingBookings: _pendingBookings,
                    confirmedBookings: _confirmedBookings,
                    completedBookings: _completedBookings,
                    cancelledBookings: _cancelledBookings,
                    services: _services,
                  ),
                  const SizedBox(height: 24),
                  _RecentBookingsCard(
                    bookings: _recentBookings,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

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

class _RevenueSection extends StatelessWidget {
  const _RevenueSection();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 900 ? 3 : 1;

        const revenueItems = [
          _RevenueData(
            title: "TODAY'S REVENUE",
            value: 'Unavailable',
            icon: Icons.payments_outlined,
          ),
          _RevenueData(
            title: 'WEEKLY REVENUE',
            value: 'Unavailable',
            icon: Icons.trending_up_rounded,
          ),
          _RevenueData(
            title: 'MONTHLY REVENUE',
            value: 'Unavailable',
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

class _OverviewMainGrid extends StatelessWidget {
  const _OverviewMainGrid({
    required this.totalBookings,
    required this.pendingBookings,
    required this.confirmedBookings,
    required this.completedBookings,
    required this.cancelledBookings,
    required this.services,
  });

  final int totalBookings;
  final int pendingBookings;
  final int confirmedBookings;
  final int completedBookings;
  final int cancelledBookings;
  final List<_ServicePreviewData> services;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 800;

        if (!isWide) {
          return Column(
            children: [
              _BookingStatisticsCard(
                total: totalBookings,
                pending: pendingBookings,
                confirmed: confirmedBookings,
                completed: completedBookings,
                cancelled: cancelledBookings,
              ),
              const SizedBox(height: 16),
              _ActiveServicesCard(
                services: services,
              ),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: _BookingStatisticsCard(
                total: totalBookings,
                pending: pendingBookings,
                confirmed: confirmedBookings,
                completed: completedBookings,
                cancelled: cancelledBookings,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _ActiveServicesCard(
                services: services,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BookingStatisticsCard extends StatelessWidget {
  const _BookingStatisticsCard({
    required this.total,
    required this.pending,
    required this.confirmed,
    required this.completed,
    required this.cancelled,
  });

  final int total;
  final int pending;
  final int confirmed;
  final int completed;
  final int cancelled;

  @override
  Widget build(BuildContext context) {
    final stats = [
      ('TOTAL', total.toString(), AppColors.textPrimary),
      ('PENDING', pending.toString(), AppColors.pendingText),
      ('CONFIRMED', confirmed.toString(), AppColors.confirmedText),
      ('COMPLETED', completed.toString(), AppColors.completedText),
      ('CANCELLED', cancelled.toString(), AppColors.cancelledText),
    ];

    return _DashboardCard(
      title: 'Booking Statistics',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmall = constraints.maxWidth < 360;

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

class _ActiveServicesCard extends StatelessWidget {
  const _ActiveServicesCard({
    required this.services,
  });

  final List<_ServicePreviewData> services;

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      title: 'Active Services',
      trailing: Text(
        '${services.length} ACTIVE',
        style: AppTypography.labelXS.copyWith(
          color: AppColors.confirmedText,
        ),
      ),
      child: services.isEmpty
          ? Text(
              'No services found.',
              style: AppTypography.bodySM,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: services.map((service) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _ServicePreview(
                    name: service.name,
                    price: service.price,
                    duration: service.duration,
                  ),
                );
              }).toList(),
            ),
    );
  }
}

class _ServicePreviewData {
  const _ServicePreviewData({
    required this.name,
    required this.price,
    required this.duration,
  });

  final String name;
  final String price;
  final String duration;

  factory _ServicePreviewData.fromMap(Map<String, dynamic> map) {
    final rawPrice = map['price'];

    String price;

    if (rawPrice is num) {
      price = '₹ ';
    } else {
      price =
          'ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¹ ${rawPrice?.toString() ?? '0'}';
    }

    return _ServicePreviewData(
      name: map['title']?.toString() ?? 'Untitled service',
      price: price,
      duration: map['duration']?.toString().isNotEmpty == true
          ? '${map['duration']} min'
          : 'Duration not set',
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
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySM,
                ),
                const SizedBox(height: 5),
                Text(
                  duration,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodyXS,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              price,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: AppTypography.bodySM,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentBookingsCard extends StatelessWidget {
  const _RecentBookingsCard({
    required this.bookings,
  });

  final List<_BookingData> bookings;

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      title: 'Recent Bookings',
      child: bookings.isEmpty
          ? Text(
              'No bookings found.',
              style: AppTypography.bodySM,
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 600;

                if (isMobile) {
                  return Column(
                    children: bookings.asMap().entries.map((entry) {
                      return _MobileBookingCard(
                        booking: entry.value,
                        index: entry.key,
                      );
                    }).toList(),
                  );
                }

                return _DesktopBookingsTable(
                  bookings: bookings,
                );
              },
            ),
    );
  }
}

class _BookingData {
  const _BookingData({
    required this.client,
    required this.service,
    required this.date,
    required this.status,
  });

  final String client;
  final String service;
  final String date;
  final String status;

  factory _BookingData.fromMap(Map<String, dynamic> map) {
    final rawStatus = map['status']?.toString() ?? 'Pending';

    final status = rawStatus.toUpperCase();

    return _BookingData(
      client: map['client_name']?.toString().trim().isNotEmpty == true
          ? map['client_name'].toString()
          : map['user_email']?.toString() ?? 'Unknown client',
      service: map['service_title']?.toString() ?? 'Unknown service',
      date: map['date']?.toString() ?? 'Date unavailable',
      status: status,
    );
  }
}

class _DesktopBookingsTable extends StatelessWidget {
  const _DesktopBookingsTable({
    required this.bookings,
  });

  final List<_BookingData> bookings;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
              const SizedBox(
                width: 110,
                child: Text(
                  'STATUS',
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
          return _BookingRow(
            booking: entry.value,
            index: entry.key,
          );
        }),
      ],
    );
  }
}

class _BookingRow extends StatelessWidget {
  const _BookingRow({
    required this.booking,
    required this.index,
  });

  final _BookingData booking;
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
              booking.client,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.tableCell,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              booking.service,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.tableCellSub,
            ),
          ),
          Expanded(
            child: Text(
              booking.date,
              style: AppTypography.tableCellSub,
            ),
          ),
          SizedBox(
            width: 110,
            child: Align(
              alignment: Alignment.centerRight,
              child: _StatusChip(
                status: booking.status,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(
          duration: 280.ms,
          delay: Duration(
            milliseconds: 380 + index * 60,
          ),
        );
  }
}

class _MobileBookingCard extends StatelessWidget {
  const _MobileBookingCard({
    required this.booking,
    required this.index,
  });

  final _BookingData booking;
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
                  booking.client,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.tableCell.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _StatusChip(
                status: booking.status,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            booking.service,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodySM,
          ),
          const SizedBox(height: 4),
          Text(
            booking.date,
            style: AppTypography.tableCellSub,
          ),
        ],
      ),
    ).animate().fadeIn(
          duration: 280.ms,
          delay: Duration(milliseconds: 380 + index * 60),
        );
  }
}

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

class _OverviewError extends StatelessWidget {
  const _OverviewError({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      title: 'Dashboard unavailable',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: AppTypography.bodySM,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('RETRY'),
          ),
        ],
      ),
    );
  }
}

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
