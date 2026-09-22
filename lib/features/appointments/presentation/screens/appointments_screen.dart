import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/config/partner_session.dart';
import '../../../../core/data/partner_repository.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

// ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ Data model ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬
enum AppointmentStatus { confirmed, completed, cancelled, pending }

class _Appointment {
  _Appointment({
    required this.id,
    required this.clientName,
    required this.clientEmail,
    required this.service,
    required this.date,
    required this.time,
    required this.status,
  });

  final int id;
  final String clientName;
  final String clientEmail;
  final String service;
  final String date;
  final String time;
  AppointmentStatus status;

  factory _Appointment.fromMap(Map<String, dynamic> map) {
    return _Appointment(
      id: (map['id'] as num).toInt(),
      clientName: map['client_name']?.toString() ?? 'Guest',
      clientEmail: map['user_email']?.toString() ?? '',
      service: map['service_title']?.toString() ?? 'Service',
      date: map['date']?.toString() ?? '',
      time: map['time']?.toString() ?? '',
      status: _statusFromDatabase(map['status']),
    );
  }

  static AppointmentStatus _statusFromDatabase(dynamic value) {
    switch (value?.toString().toLowerCase()) {
      case 'confirmed':
        return AppointmentStatus.confirmed;
      case 'completed':
        return AppointmentStatus.completed;
      case 'cancelled':
        return AppointmentStatus.cancelled;
      case 'pending':
      default:
        return AppointmentStatus.pending;
    }
  }
}

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final PartnerRepository _repository = PartnerRepository.instance;

  List<_Appointment> _appointments = [];
  bool _loading = true;
  String? _errorMessage;

  int? get _vendorId => PartnerSession.vendorId;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    final vendorId = _vendorId;

    if (vendorId == null) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _errorMessage =
            'Your Partner session is not available. Please log in again.';
      });
      return;
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final rows = await _repository.vendorBookings(vendorId);

      if (!mounted) return;

      setState(() {
        _appointments = rows.map(_Appointment.fromMap).toList();
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
    final message = error.toString().toLowerCase();

    if (message.contains('permission') ||
        message.contains('row-level security') ||
        message.contains('rls')) {
      return 'You do not have permission to access your appointments.';
    }

    if (message.contains('socketexception') ||
        message.contains('failed host lookup') ||
        message.contains('network')) {
      return 'Unable to connect to the server. Check your internet connection.';
    }

    return 'Unable to load appointments. Please try again.';
  }

  Future<void> _updateStatus(
    _Appointment appointment,
    AppointmentStatus newStatus,
  ) async {
    final vendorId = _vendorId;

    if (vendorId == null) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Your Partner session is not available. Please log in again.',
          ),
          backgroundColor: AppColors.logout,
        ),
      );
      return;
    }

    final databaseStatus = switch (newStatus) {
      AppointmentStatus.confirmed => 'Confirmed',
      AppointmentStatus.completed => 'Completed',
      AppointmentStatus.cancelled => 'Cancelled',
      AppointmentStatus.pending => 'Pending',
    };

    try {
      final row = await _repository.updateBookingStatus(
        bookingId: appointment.id,
        vendorId: vendorId,
        status: databaseStatus,
      );

      final updatedAppointment = _Appointment.fromMap(row);

      if (!mounted) return;

      setState(() {
        final index = _appointments.indexWhere(
          (item) => item.id == updatedAppointment.id,
        );

        if (index >= 0) {
          _appointments[index] = updatedAppointment;
        }
      });

      final label = switch (updatedAppointment.status) {
        AppointmentStatus.confirmed => 'Appointment confirmed',
        AppointmentStatus.completed => 'Marked as completed',
        AppointmentStatus.cancelled => 'Appointment cancelled',
        AppointmentStatus.pending => 'Moved to pending',
      };

      final snackColor = switch (updatedAppointment.status) {
        AppointmentStatus.confirmed => AppColors.confirmedText,
        AppointmentStatus.completed => AppColors.sidebarActive,
        AppointmentStatus.cancelled => AppColors.cancelledText,
        AppointmentStatus.pending => AppColors.pendingText,
      };

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            label,
            style: AppTypography.bodySM.copyWith(
              color: Colors.white,
            ),
          ),
          backgroundColor: snackColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_friendlyError(e)),
          backgroundColor: AppColors.logout,
        ),
      );
    }
  }

  void _viewAppointment(_Appointment appointment) {
    final status = appointment.status.name[0].toUpperCase() +
        appointment.status.name.substring(1);

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Appointment Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Booking ID: #${appointment.id}'),
              const SizedBox(height: 10),
              Text('Client: ${appointment.clientName}'),
              const SizedBox(height: 6),
              Text(
                appointment.clientEmail.isEmpty
                    ? 'Email: Not provided'
                    : 'Email: ${appointment.clientEmail}',
              ),
              const SizedBox(height: 6),
              Text('Service: ${appointment.service}'),
              const SizedBox(height: 6),
              Text('Date: ${appointment.date}'),
              const SizedBox(height: 6),
              Text('Time: ${appointment.time}'),
              const SizedBox(height: 6),
              Text('Status: $status'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CLOSE'),
            ),
          ],
        );
      },
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
            Text(
              'Appointment Request',
              style: AppTypography.pageTitle,
            ).animate().fadeIn(duration: 300.ms).slideY(
                  begin: -0.1,
                  end: 0,
                  duration: 300.ms,
                ),
            const SizedBox(height: 16),
            Expanded(
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _errorMessage != null
                      ? _AppointmentsError(
                          message: _errorMessage!,
                          onRetry: _loadAppointments,
                        )
                      : _appointments.isEmpty
                          ? const _EmptyAppointments()
                          : LayoutBuilder(
                              builder: (context, constraints) {
                                if (constraints.maxWidth >= 700) {
                                  return _DesktopTable(
                                    appointments: _appointments,
                                    onStatusChange: _updateStatus,
                                    onView: _viewAppointment,
                                  );
                                }

                                return _MobileCardList(
                                  appointments: _appointments,
                                  onStatusChange: _updateStatus,
                                  onView: _viewAppointment,
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppointmentsError extends StatelessWidget {
  const _AppointmentsError({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 42,
              color: AppColors.logout,
            ),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.bodySM,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: onRetry,
              child: Text(
                'TRY AGAIN',
                style: AppTypography.labelSM.copyWith(
                  color: AppColors.buttonDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyAppointments extends StatelessWidget {
  const _EmptyAppointments();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 42,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 14),
            Text(
              'No appointments yet',
              style: AppTypography.cardTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'New appointment requests will appear here.',
              style: AppTypography.bodySM,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _DesktopTable extends StatelessWidget {
  const _DesktopTable({
    required this.appointments,
    required this.onStatusChange,
    required this.onView,
  });
  final List<_Appointment> appointments;
  final void Function(_Appointment, AppointmentStatus) onStatusChange;
  final void Function(_Appointment) onView;

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
                      onView: onView,
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
          Expanded(
              flex: 3, child: Text('CLIENT', style: AppTypography.tableHeader)),
          Expanded(
              flex: 3,
              child: Text('SERVICE', style: AppTypography.tableHeader)),
          Expanded(
              flex: 3,
              child: Text('DATE & TIME', style: AppTypography.tableHeader)),
          Expanded(
              flex: 2, child: Text('STATUS', style: AppTypography.tableHeader)),
          Expanded(
              flex: 3,
              child: Text('ACTION',
                  style: AppTypography.tableHeader,
                  textAlign: TextAlign.right)),
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
    required this.onView,
  });
  final _Appointment appointment;
  final int index;
  final void Function(_Appointment, AppointmentStatus) onStatusChange;
  final void Function(_Appointment) onView;

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
        .fadeIn(
            duration: 300.ms, delay: Duration(milliseconds: 60 + index * 50))
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
              onTap: () =>
                  onStatusChange(appointment, AppointmentStatus.completed)),
          const SizedBox(width: 8),
          _ActionButton(
              label: 'CANCEL',
              bgColor: AppColors.notReportedBg,
              textColor: AppColors.notReportedText,
              border: true,
              onTap: () =>
                  onStatusChange(appointment, AppointmentStatus.cancelled)),
        ];
      case AppointmentStatus.pending:
        return [
          _ActionButton(
              label: 'CONFIRM',
              bgColor: AppColors.confirmedBg,
              textColor: AppColors.confirmedText,
              onTap: () =>
                  onStatusChange(appointment, AppointmentStatus.confirmed)),
          const SizedBox(width: 8),
          _ActionButton(
              label: 'REJECT',
              bgColor: AppColors.notReportedBg,
              textColor: AppColors.notReportedText,
              border: true,
              onTap: () =>
                  onStatusChange(appointment, AppointmentStatus.cancelled)),
        ];
      case AppointmentStatus.completed:
      case AppointmentStatus.cancelled:
        return [
          _ActionButton(
            label: 'VIEW',
            bgColor: Colors.transparent,
            textColor: AppColors.textMuted,
            onTap: () => onView(appointment),
          ),
        ];
    }
  }
}

// ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ Mobile Card List ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬
class _MobileCardList extends StatelessWidget {
  const _MobileCardList({
    required this.appointments,
    required this.onStatusChange,
    required this.onView,
  });
  final List<_Appointment> appointments;
  final void Function(_Appointment, AppointmentStatus) onStatusChange;
  final void Function(_Appointment) onView;

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
          onView: onView,
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
    required this.onView,
  });
  final _Appointment appointment;
  final int index;
  final void Function(_Appointment, AppointmentStatus) onStatusChange;
  final void Function(_Appointment) onView;

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
                    Text(appointment.clientName, style: AppTypography.labelLG),
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
            label: '${appointment.date}  ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¢  ${appointment.time}',
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
              fontWeight:
                  valueColor != null ? FontWeight.w600 : FontWeight.w400,
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
          border: border
              ? Border.all(color: textColor.withValues(alpha: 0.4))
              : null,
        ),
        alignment: Alignment.center,
        child: Text(label,
            style: AppTypography.labelXS
                .copyWith(color: textColor, fontWeight: FontWeight.w700)),
      ),
    );
  }
}

// ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ Shared sub-widgets ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬
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
        bg = AppColors.confirmedBg;
        text = AppColors.confirmedText;
        label = 'CONFIRMED';
        break;
      case AppointmentStatus.completed:
        bg = AppColors.completedBg;
        text = AppColors.completedText;
        label = 'COMPLETED';
        break;
      case AppointmentStatus.cancelled:
        bg = AppColors.cancelledBg;
        text = AppColors.cancelledText;
        label = 'CANCELLED';
        break;
      case AppointmentStatus.pending:
        bg = AppColors.pendingBg;
        text = AppColors.pendingText;
        label = 'PENDING';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4)),
      child: Text(label,
          style:
              AppTypography.labelXS.copyWith(color: text, letterSpacing: 0.5)),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.bgColor,
    required this.textColor,
    this.border = false,
    this.onTap,
  });
  final String label;
  final Color bgColor;
  final Color textColor;
  final bool border;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(4),
          border: border
              ? Border.all(color: textColor.withValues(alpha: 0.3))
              : null,
        ),
        child: Text(label,
            textAlign: TextAlign.center,
            style: AppTypography.labelXS.copyWith(
                color: textColor,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4)),
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
