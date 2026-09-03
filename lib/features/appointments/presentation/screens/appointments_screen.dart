import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

// ─── Data model ────────────────────────────────────────────────────────────────
enum AppointmentStatus { confirmed, completed, cancelled, pending }

// mutable copy so status changes are reflected in the UI
class _Appointment {
  _Appointment({
    required this.clientName,
    required this.clientEmail,
    required this.service,
    required this.date,
    required this.time,
    required this.status,
  });
  final String clientName;
  final String clientEmail;
  final String service;
  final String date;
  final String time;
  AppointmentStatus status; // mutable — updated when partner taps action
}

List<_Appointment> _mockAppointments() => [
  _Appointment(
    clientName: 'Arjun Sharma',
    clientEmail: 'arjun.sharma@gmail.com',
    service: 'Royal Beard Trim',
    date: '2026-08-05',
    time: '10:00 AM',
    status: AppointmentStatus.confirmed,
  ),
  _Appointment(
    clientName: 'Priya Mehta',
    clientEmail: 'priya.mehta@gmail.com',
    service: 'Balayage Highlights',
    date: '2026-08-05',
    time: '11:30 AM',
    status: AppointmentStatus.confirmed,
  ),
  _Appointment(
    clientName: 'Rohit Verma',
    clientEmail: 'rohit.verma@gmail.com',
    service: 'Moroccan Hair Spa',
    date: '2026-08-04',
    time: '02:00 PM',
    status: AppointmentStatus.completed,
  ),
  _Appointment(
    clientName: 'Sneha Patel',
    clientEmail: 'sneha.patel@gmail.com',
    service: 'Classic Facial',
    date: '2026-08-04',
    time: '04:30 PM',
    status: AppointmentStatus.completed,
  ),
  _Appointment(
    clientName: 'Deepak Kumar',
    clientEmail: 'deepak.kumar@gmail.com',
    service: 'Deep Hair Treatment',
    date: '2026-08-03',
    time: '12:00 PM',
    status: AppointmentStatus.cancelled,
  ),
  _Appointment(
    clientName: 'Ananya Singh',
    clientEmail: 'ananya.singh@gmail.com',
    service: 'Nail Art & Polish',
    date: '2026-08-06',
    time: '09:30 AM',
    status: AppointmentStatus.pending,
  ),
];

// ─── Screen ────────────────────────────────────────────────────────────────────
class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  late final List<_Appointment> _appointments = _mockAppointments();

  void _updateStatus(_Appointment appt, AppointmentStatus newStatus) {
    setState(() => appt.status = newStatus);

    final label = switch (newStatus) {
      AppointmentStatus.confirmed  => 'Appointment confirmed ✔',
      AppointmentStatus.completed  => 'Marked as completed ✔',
      AppointmentStatus.cancelled  => 'Appointment cancelled',
      AppointmentStatus.pending    => 'Moved to pending',
    };
    final color = switch (newStatus) {
      AppointmentStatus.confirmed  => AppColors.confirmedText,
      AppointmentStatus.completed  => AppColors.sidebarActive,
      AppointmentStatus.cancelled  => AppColors.cancelledText,
      AppointmentStatus.pending    => AppColors.pendingText,
    };
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(label,
            style: AppTypography.bodySM.copyWith(color: Colors.white)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Appointment Request', style: AppTypography.pageTitle)
                .animate()
                .fadeIn(duration: 300.ms)
                .slideY(begin: -0.1, end: 0, duration: 300.ms),
            const SizedBox(height: 16),
            Expanded(
              child: LayoutBuilder(builder: (context, constraints) {
                if (constraints.maxWidth >= 700) {
                  return _DesktopTable(
                    appointments: _appointments,
                    onStatusChange: _updateStatus,
                  );
                } else {
                  return _MobileCardList(
                    appointments: _appointments,
                    onStatusChange: _updateStatus,
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Desktop Table View ────────────────────────────────────────────────────────
class _DesktopTable extends StatelessWidget {
  const _DesktopTable({
    required this.appointments,
    required this.onStatusChange,
  });
  final List<_Appointment> appointments;
  final void Function(_Appointment, AppointmentStatus) onStatusChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              const Divider(height: 1, color: AppColors.borderLight),
              ...appointments.asMap().entries.map(
                    (e) => _DesktopRow(
                      appointment: e.value, 
                      index: e.key,
                      onStatusChange: onStatusChange,
                    ),
                  ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms);
  }

  Widget _buildHeader() {
    return Container(
      color: AppColors.cardBackground,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text('CLIENT', style: AppTypography.tableHeader)),
          Expanded(flex: 3, child: Text('SERVICE', style: AppTypography.tableHeader)),
          Expanded(flex: 3, child: Text('DATE & TIME', style: AppTypography.tableHeader)),
          Expanded(flex: 2, child: Text('STATUS', style: AppTypography.tableHeader)),
          Expanded(flex: 3, child: Text('ACTION', style: AppTypography.tableHeader, textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}

class _DesktopRow extends StatelessWidget {
  const _DesktopRow({
    required this.appointment,
    required this.index,
    required this.onStatusChange,
  });
  final _Appointment appointment;
  final int index;
  final void Function(_Appointment, AppointmentStatus) onStatusChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: index.isEven ? AppColors.cardBackground : const Color(0xFFFAF9F6),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // CLIENT
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(appointment.clientName,
                    style: AppTypography.tableCell
                        .copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(appointment.clientEmail,
                    style: AppTypography.tableCellSub,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          // SERVICE
          Expanded(
            flex: 3,
            child: Text(appointment.service,
                style: AppTypography.tableCell,
                overflow: TextOverflow.ellipsis),
          ),
          // DATE & TIME
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(appointment.date, style: AppTypography.tableCell),
                const SizedBox(height: 2),
                Text(
                  appointment.time,
                  style: AppTypography.tableCellSub.copyWith(
                    color: const Color(0xFFD4914A),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // STATUS
          Expanded(flex: 2, child: _StatusChip(status: appointment.status)),
          // ACTION
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: _buildActions(appointment.status),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms, delay: Duration(milliseconds: 60 + index * 50))
        .slideX(begin: 0.02, end: 0, duration: 250.ms);
  }

  List<Widget> _buildActions(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.confirmed:
        return [
          _ActionButton(
              label: 'COMPLETE',
              bgColor: AppColors.sidebarActive,
              textColor: AppColors.sidebarActiveText,
              onTap: () => onStatusChange(appointment, AppointmentStatus.completed)),
          const SizedBox(width: 8),
          _ActionButton(
              label: 'CANCEL',
              bgColor: AppColors.notReportedBg,
              textColor: AppColors.notReportedText,
              border: true,
              onTap: () => onStatusChange(appointment, AppointmentStatus.cancelled)),
        ];
      case AppointmentStatus.pending:
        return [
          _ActionButton(
              label: 'CONFIRM',
              bgColor: AppColors.confirmedBg,
              textColor: AppColors.confirmedText,
              onTap: () => onStatusChange(appointment, AppointmentStatus.confirmed)),
          const SizedBox(width: 8),
          _ActionButton(
              label: 'REJECT',
              bgColor: AppColors.notReportedBg,
              textColor: AppColors.notReportedText,
              border: true,
              onTap: () => onStatusChange(appointment, AppointmentStatus.cancelled)),
        ];
      case AppointmentStatus.completed:
      case AppointmentStatus.cancelled:
        return [
          const _ActionButton(
              label: 'VIEW',
              bgColor: Colors.transparent,
              textColor: AppColors.textMuted,
              isDisabled: true),
        ];
    }
  }
}

// ─── Mobile Card List ─────────────────────────────────────────────────────────
class _MobileCardList extends StatelessWidget {
  const _MobileCardList({
    required this.appointments,
    required this.onStatusChange,
  });
  final List<_Appointment> appointments;
  final void Function(_Appointment, AppointmentStatus) onStatusChange;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: appointments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return _MobileAppointmentCard(
          appointment: appointments[index],
          index: index,
          onStatusChange: onStatusChange,
        );
      },
    );
  }
}

class _MobileAppointmentCard extends StatelessWidget {
  const _MobileAppointmentCard({
    required this.appointment,
    required this.index,
    required this.onStatusChange,
  });
  final _Appointment appointment;
  final int index;
  final void Function(_Appointment, AppointmentStatus) onStatusChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: client name + status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(appointment.clientName,
                        style: AppTypography.labelLG),
                    const SizedBox(height: 2),
                    Text(appointment.clientEmail,
                        style: AppTypography.tableCellSub,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _StatusChip(status: appointment.status),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.borderLight, height: 1),
          const SizedBox(height: 12),
          // Service
          _InfoRow(
            icon: Icons.content_cut_rounded,
            label: appointment.service,
          ),
          const SizedBox(height: 6),
          // Date
          _InfoRow(
            icon: Icons.calendar_today_rounded,
            label: '${appointment.date}  •  ${appointment.time}',
            valueColor: const Color(0xFFD4914A),
          ),
          // Actions
          if (appointment.status == AppointmentStatus.confirmed ||
              appointment.status == AppointmentStatus.pending) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _MobileActionButton(
                    label: appointment.status == AppointmentStatus.pending
                        ? 'CONFIRM'
                        : 'COMPLETE',
                    bgColor: appointment.status == AppointmentStatus.pending
                        ? AppColors.confirmedBg
                        : AppColors.sidebarActive,
                    textColor: appointment.status == AppointmentStatus.pending
                        ? AppColors.confirmedText
                        : AppColors.sidebarActiveText,
                    onTap: () => onStatusChange(
                      appointment,
                      appointment.status == AppointmentStatus.pending
                          ? AppointmentStatus.confirmed
                          : AppointmentStatus.completed,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MobileActionButton(
                    label: appointment.status == AppointmentStatus.pending
                        ? 'REJECT'
                        : 'CANCEL',
                    bgColor: AppColors.notReportedBg,
                    textColor: AppColors.notReportedText,
                    border: true,
                    onTap: () => onStatusChange(
                        appointment, AppointmentStatus.cancelled),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms, delay: Duration(milliseconds: index * 60))
        .slideY(begin: 0.05, end: 0, duration: 280.ms);
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, this.valueColor});
  final IconData icon;
  final String label;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textMuted),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: AppTypography.bodySM.copyWith(
              color: valueColor ?? AppColors.textSecondary,
              fontWeight: valueColor != null ? FontWeight.w600 : FontWeight.w400,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _MobileActionButton extends StatelessWidget {
  const _MobileActionButton({
    required this.label,
    required this.bgColor,
    required this.textColor,
    this.border = false,
    required this.onTap,
  });
  final String label;
  final Color bgColor;
  final Color textColor;
  final bool border;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6),
          border: border ? Border.all(color: textColor.withValues(alpha: 0.4)) : null,
        ),
        alignment: Alignment.center,
        child: Text(label,
            style: AppTypography.labelXS
                .copyWith(color: textColor, fontWeight: FontWeight.w700)),
      ),
    );
  }
}

// ─── Shared sub-widgets ────────────────────────────────────────────────────────
class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final AppointmentStatus status;

  @override
  Widget build(BuildContext context) {
    late Color bg;
    late Color text;
    late String label;

    switch (status) {
      case AppointmentStatus.confirmed:
        bg = AppColors.confirmedBg; text = AppColors.confirmedText; label = 'CONFIRMED'; break;
      case AppointmentStatus.completed:
        bg = AppColors.completedBg; text = AppColors.completedText; label = 'COMPLETED'; break;
      case AppointmentStatus.cancelled:
        bg = AppColors.cancelledBg; text = AppColors.cancelledText; label = 'CANCELLED'; break;
      case AppointmentStatus.pending:
        bg = AppColors.pendingBg; text = AppColors.pendingText; label = 'PENDING'; break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4)),
      child: Text(label,
          style: AppTypography.labelXS.copyWith(color: text, letterSpacing: 0.5)),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.bgColor,
    required this.textColor,
    this.border     = false,
    this.isDisabled = false,
    this.onTap,
  });
  final String label;
  final Color bgColor;
  final Color textColor;
  final bool border;
  final bool isDisabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isDisabled ? null : onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(4),
          border: border ? Border.all(color: textColor.withValues(alpha: 0.3)) : null,
        ),
        child: Text(label,
            textAlign: TextAlign.center,
            style: AppTypography.labelXS.copyWith(
                color: textColor, fontWeight: FontWeight.w700, letterSpacing: 0.4)),
      ),
    );
  }
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.04),
        blurRadius: 12,
        offset: const Offset(0, 2),
      ),
    ],
  );
}
