import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/config/partner_session.dart';
import '../../../../core/data/partner_repository.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

// â”€â”€â”€ Data model â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _Service {
  _Service({
    required this.id,
    required this.category,
    required this.name,
    required this.price,
    required this.duration,
    this.imageUrl,
  });

  final int id;
  String category;
  String name;
  num price;
  String duration;
  String? imageUrl;

  factory _Service.fromMap(Map<String, dynamic> map) {
    return _Service(
      id: (map['id'] as num).toInt(),
      category: map['category']?.toString() ?? '',
      name: map['title']?.toString() ?? '',
      price: _parsePrice(map['price']),
      duration: map['duration']?.toString() ?? '',
      imageUrl: map['image_url']?.toString(),
    );
  }

  static num _parsePrice(dynamic value) {
    if (value is num) {
      return value;
    }

    return num.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final PartnerRepository _repository = PartnerRepository.instance;

  List<_Service> _services = [];
  bool _loading = true;
  String? _errorMessage;

  bool _showAddModal = false;
  _Service? _editingService;

  int? get _vendorId => PartnerSession.vendorId;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
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
      final rows = await _repository.vendorServices(vendorId);

      if (!mounted) return;

      setState(() {
        _services = rows.map(_Service.fromMap).toList();
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
      return 'You do not have permission to access your services.';
    }

    if (message.contains('socketexception') ||
        message.contains('failed host lookup') ||
        message.contains('network')) {
      return 'Unable to connect to the server. Check your internet connection.';
    }

    return 'Unable to load services. Please try again.';
  }

  void _openAddPanel() {
    setState(() {
      _editingService = null;
      _showAddModal = true;
    });
  }

  void _openEditPanel(_Service service) {
    setState(() {
      _editingService = service;
      _showAddModal = true;
    });
  }

  Future<void> _onSave(_Service saved) async {
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

    try {
      final row = _editingService == null
          ? await _repository.createService(
              vendorId: vendorId,
              title: saved.name,
              category: saved.category,
              price: saved.price,
              duration: saved.duration,
              imageUrl: saved.imageUrl,
            )
          : await _repository.updateService(
              serviceId: _editingService!.id,
              vendorId: vendorId,
              title: saved.name,
              category: saved.category,
              price: saved.price,
              duration: saved.duration,
              imageUrl: saved.imageUrl,
            );

      final updatedService = _Service.fromMap(row);

      if (!mounted) return;

      setState(() {
        if (_editingService != null) {
          final index = _services.indexWhere(
            (service) => service.id == _editingService!.id,
          );

          if (index >= 0) {
            _services[index] = updatedService;
          }
        } else {
          _services.add(updatedService);
        }

        _showAddModal = false;
        _editingService = null;
      });
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

  Future<void> _onDelete(_Service service) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          'Delete Service',
          style: AppTypography.cardTitle,
        ),
        content: Text(
          'Remove "" from your services?',
          style: AppTypography.bodySM,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'CANCEL',
              style: AppTypography.labelSM.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              'DELETE',
              style: AppTypography.labelSM.copyWith(
                color: AppColors.logout,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

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

    try {
      await _repository.deleteService(
        serviceId: service.id,
        vendorId: vendorId,
      );

      final remainingRows = await _repository.vendorServices(vendorId);

      if (!mounted) return;

      final remainingServices = remainingRows.map(_Service.fromMap).toList();

      final stillExists = remainingServices.any(
        (item) => item.id == service.id,
      );

      if (stillExists) {
        throw Exception(
          'The service could not be deleted. Please try again.',
        );
      }

      setState(() {
        _services = remainingServices;
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('My Services', style: AppTypography.pageTitle)
                        .animate()
                        .fadeIn(duration: 300.ms),
                    _AddServiceButton(onTap: _openAddPanel)
                        .animate()
                        .fadeIn(duration: 300.ms, delay: 100.ms),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: _loading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : _errorMessage != null
                          ? _ServicesError(
                              message: _errorMessage!,
                              onRetry: _loadServices,
                            )
                          : _services.isEmpty
                              ? const _EmptyServices()
                              : _ServiceGrid(
                                  services: _services,
                                  onEdit: _openEditPanel,
                                  onDelete: _onDelete,
                                ),
                ),
              ],
            ),
          ),
          if (_showAddModal)
            _AddServiceSheet(
              existing: _editingService,
              onClose: () => setState(() {
                _showAddModal = false;
                _editingService = null;
              }),
              onSave: _onSave,
            ),
        ],
      ),
    );
  }
}

// â”€â”€â”€ Service Grid â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _ServicesError extends StatelessWidget {
  const _ServicesError({
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

class _ServiceGrid extends StatelessWidget {
  const _ServiceGrid({
    required this.services,
    required this.onEdit,
    required this.onDelete,
  });
  final List<_Service> services;
  final ValueChanged<_Service> onEdit;
  final ValueChanged<_Service> onDelete;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final int crossCount = constraints.maxWidth > 700 ? 3 : 2;
      return GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossCount,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          mainAxisExtent: 175,
        ),
        itemCount: services.length,
        itemBuilder: (context, index) => _ServiceCard(
          service: services[index],
          index: index,
          onEdit: () => onEdit(services[index]),
          onDelete: () => onDelete(services[index]),
        ),
      );
    });
  }
}

// â”€â”€â”€ Service Card â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _ServiceCard extends StatefulWidget {
  const _ServiceCard({
    required this.service,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });
  final _Service service;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _hovered ? 1.015 : 1.0,
          _hovered ? 1.015 : 1.0,
          1.0,
        ),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _hovered ? 0.08 : 0.04),
              blurRadius: _hovered ? 18 : 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: _CategoryBadge(label: widget.service.category),
                  ),
                  const SizedBox(width: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _IconAction(
                        icon: Icons.edit_outlined,
                        onTap: widget.onEdit,
                      ),
                      const SizedBox(width: 4),
                      _IconAction(
                        icon: Icons.delete_outline_rounded,
                        onTap: widget.onDelete,
                        isDelete: true,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                widget.service.name,
                style: AppTypography.cardTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      '\u20b9 ${widget.service.price}',
                      style: AppTypography.priceLG,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${widget.service.duration} MIN',
                    style: AppTypography.labelSM.copyWith(
                        color: AppColors.textMuted, letterSpacing: 0.5),
                  ),
                ],
              ),
            ],
          ),
        ),
      )
          .animate()
          .fadeIn(
            duration: 350.ms,
            delay: Duration(milliseconds: 80 + widget.index * 80),
          )
          .scale(
            begin: const Offset(0.96, 0.96),
            end: const Offset(1.0, 1.0),
            duration: 300.ms,
          ),
    );
  }
}

// â”€â”€â”€ Reusable sub-widgets â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.categoryBadgeBg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: AppTypography.labelXS,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({
    required this.icon,
    required this.onTap,
    this.isDelete = false,
  });
  final IconData icon;
  final VoidCallback onTap;
  final bool isDelete;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(
          icon,
          size: 17,
          color: isDelete ? AppColors.logout : AppColors.textMuted,
        ),
      ),
    );
  }
}

class _AddServiceButton extends StatelessWidget {
  const _AddServiceButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.buttonDark,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add_rounded,
                color: AppColors.buttonDarkText, size: 18),
            const SizedBox(width: 8),
            Text('ADD SERVICE', style: AppTypography.buttonText),
          ],
        ),
      ),
    );
  }
}

class _EmptyServices extends StatelessWidget {
  const _EmptyServices();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.build_outlined, size: 48, color: AppColors.textHint),
          const SizedBox(height: 16),
          Text('No services yet.',
              style: AppTypography.bodySM.copyWith(color: AppColors.textHint)),
        ],
      ),
    );
  }
}

// â”€â”€â”€ Add / Edit Service Panel â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _AddServiceSheet extends StatefulWidget {
  const _AddServiceSheet({
    required this.onClose,
    required this.onSave,
    this.existing,
  });
  final VoidCallback onClose;
  final Future<void> Function(_Service) onSave;
  final _Service? existing; // non-null when editing

  @override
  State<_AddServiceSheet> createState() => _AddServiceSheetState();
}

class _AddServiceSheetState extends State<_AddServiceSheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _categoryCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _durationCtrl;
  String? _error;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _nameCtrl = TextEditingController(text: e?.name ?? '');
    _categoryCtrl = TextEditingController(text: e?.category ?? '');
    _priceCtrl = TextEditingController(text: e != null ? '${e.price}' : '');
    _durationCtrl = TextEditingController(text: e != null ? e.duration : '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _categoryCtrl.dispose();
    _priceCtrl.dispose();
    _durationCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final name = _nameCtrl.text.trim();
    final category = _categoryCtrl.text.trim();
    final price = num.tryParse(_priceCtrl.text.trim());
    final duration = _durationCtrl.text.trim();

    if (name.isEmpty ||
        category.isEmpty ||
        _priceCtrl.text.trim().isEmpty ||
        duration.isEmpty) {
      setState(() => _error = 'Please fill in all required fields.');
      return;
    }

    if (price == null || price <= 0) {
      setState(() => _error = 'Enter a valid price.');
      return;
    }

    final durationMinutes = int.tryParse(duration);

    if (durationMinutes == null || durationMinutes <= 0) {
      setState(() => _error = 'Enter a valid duration in minutes.');
      return;
    }

    await widget.onSave(_Service(
      id: widget.existing?.id ?? 0,
      name: name,
      category: category.toUpperCase(),
      price: price,
      duration: duration,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final panelWidth = screenWidth < 440 ? screenWidth : 420.0;
    final isEdit = widget.existing != null;

    return GestureDetector(
      onTap: widget.onClose,
      child: ColoredBox(
        color: Colors.black.withValues(alpha: 0.25),
        child: Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: panelWidth,
              height: double.infinity,
              color: AppColors.cardBackground,
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isEdit ? 'Edit Service' : 'Add Service',
                        style: AppTypography.sectionTitle,
                      ),
                      IconButton(
                        onPressed: widget.onClose,
                        icon: const Icon(Icons.close_rounded, size: 22),
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _FormField(
                    label: 'SERVICE NAME',
                    hint: 'e.g. Haircut',
                    controller: _nameCtrl,
                  ),
                  const SizedBox(height: 16),
                  _FormField(
                    label: 'CATEGORY',
                    hint: "e.g. Hair Care",
                    controller: _categoryCtrl,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _FormField(
                          label: 'PRICE (\u20b9)',
                          hint: '250',
                          controller: _priceCtrl,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _FormField(
                          label: 'DURATION (MIN)',
                          hint: '45',
                          controller: _durationCtrl,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.cancelledBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline_rounded,
                              size: 15, color: AppColors.logout),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(_error!,
                                style: AppTypography.bodySM
                                    .copyWith(color: AppColors.logout)),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: InkWell(
                      onTap: _handleSave,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.buttonDark,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          isEdit ? 'UPDATE SERVICE' : 'SAVE SERVICE',
                          style: AppTypography.buttonText,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .slideX(
                    begin: 0.12,
                    end: 0,
                    duration: 280.ms,
                    curve: Curves.easeOut)
                .fadeIn(duration: 200.ms),
          ),
        ),
      ).animate().fadeIn(duration: 200.ms),
    );
  }
}

class _FormField extends StatelessWidget {
  const _FormField({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType,
    this.inputFormatters,
  });
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.inputLabel),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: 1,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: AppTypography.bodyMD,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodyMD.copyWith(color: AppColors.textHint),
          ),
        ),
      ],
    );
  }
}
