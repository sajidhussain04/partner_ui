import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

// ─── Data model ────────────────────────────────────────────────────────────────
class _Service {
  _Service({
    required this.category,
    required this.name,
    required this.price,
    required this.duration,
    this.description = '',
  });
  String category;
  String name;
  int price;
  int duration;
  String description;
}

final List<_Service> _mockServices = [
  _Service(
    category: "HAIR CARE",
    name: 'Balayage Highlights',
    price: 2500,
    duration: 90,
  ),
  _Service(
    category: "BEARD GROOMING",
    name: 'Royal Beard Trim & Style',
    price: 450,
    duration: 30,
  ),
  _Service(
    category: "SPA & WELLNESS",
    name: 'Moroccan Hair Spa',
    price: 1200,
    duration: 60,
  ),
  _Service(
    category: "SKIN CARE",
    name: 'Classic Luxury Facial',
    price: 800,
    duration: 45,
  ),
];

// ─── Screen ────────────────────────────────────────────────────────────────────
class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final List<_Service> _services = List.from(_mockServices);
  bool _showAddModal  = false;
  _Service? _editingService; // non-null when editing an existing service

  void _openAddPanel() {
    setState(() {
      _editingService  = null;
      _showAddModal    = true;
    });
  }

  void _openEditPanel(_Service service) {
    setState(() {
      _editingService = service;
      _showAddModal   = true;
    });
  }

  void _onSave(_Service saved) {
    setState(() {
      if (_editingService != null) {
        final idx = _services.indexOf(_editingService!);
        if (idx != -1) _services[idx] = saved;
      } else {
        _services.add(saved);
      }
      _showAddModal   = false;
      _editingService = null;
    });
  }

  void _onDelete(_Service service) {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('Delete Service', style: AppTypography.cardTitle),
        content: Text(
          'Remove "${service.name}" from your services?',
          style: AppTypography.bodySM,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('CANCEL',
                style: AppTypography.labelSM
                    .copyWith(color: AppColors.textMuted)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('DELETE',
                style: AppTypography.labelSM
                    .copyWith(color: AppColors.logout)),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        setState(() => _services.remove(service));
      }
    });
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
                  child: _services.isEmpty
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
                _showAddModal   = false;
                _editingService = null;
              }),
              onSave: _onSave,
            ),
        ],
      ),
    );
  }
}

// ─── Service Grid ─────────────────────────────────────────────────────────────
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

// ─── Service Card ─────────────────────────────────────────────────────────────
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
                    style: AppTypography.labelSM
                        .copyWith(color: AppColors.textMuted, letterSpacing: 0.5),
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

// ─── Reusable sub-widgets ──────────────────────────────────────────────────────
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
            const Icon(Icons.add_rounded, color: AppColors.buttonDarkText, size: 18),
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

// ─── Add / Edit Service Panel ──────────────────────────────────────────────────
class _AddServiceSheet extends StatefulWidget {
  const _AddServiceSheet({
    required this.onClose,
    required this.onSave,
    this.existing,
  });
  final VoidCallback onClose;
  final ValueChanged<_Service> onSave;
  final _Service? existing; // non-null when editing

  @override
  State<_AddServiceSheet> createState() => _AddServiceSheetState();
}

class _AddServiceSheetState extends State<_AddServiceSheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _categoryCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _durationCtrl;
  late final TextEditingController _descCtrl;
  String? _error;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _nameCtrl     = TextEditingController(text: e?.name ?? '');
    _categoryCtrl = TextEditingController(text: e?.category ?? '');
    _priceCtrl    = TextEditingController(text: e != null ? '${e.price}' : '');
    _durationCtrl = TextEditingController(text: e != null ? '${e.duration}' : '');
    _descCtrl     = TextEditingController(text: e?.description ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _categoryCtrl.dispose();
    _priceCtrl.dispose(); _durationCtrl.dispose(); _descCtrl.dispose();
    super.dispose();
  }

  void _handleSave() {
    final name     = _nameCtrl.text.trim();
    final category = _categoryCtrl.text.trim();
    final price    = int.tryParse(_priceCtrl.text.trim());
    final duration = int.tryParse(_durationCtrl.text.trim());

    if (name.isEmpty || category.isEmpty ||
        _priceCtrl.text.trim().isEmpty || _durationCtrl.text.trim().isEmpty) {
      setState(() => _error = 'Please fill in all required fields.');
      return;
    }
    if (price == null || price <= 0) {
      setState(() => _error = 'Enter a valid price.');
      return;
    }
    if (duration == null || duration <= 0) {
      setState(() => _error = 'Enter a valid duration in minutes.');
      return;
    }

    widget.onSave(_Service(
      name: name,
      category: category.toUpperCase(),
      price: price,
      duration: duration,
      description: _descCtrl.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final panelWidth  = screenWidth < 440 ? screenWidth : 420.0;
    final isEdit      = widget.existing != null;

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
                  _FormField(
                    label: 'DESCRIPTION',
                    hint: 'Brief description…',
                    controller: _descCtrl,
                    maxLines: 3,
                  ),

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
                .slideX(begin: 0.12, end: 0, duration: 280.ms, curve: Curves.easeOut)
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
    this.maxLines = 1,
    this.keyboardType,
    this.inputFormatters,
  });
  final String label;
  final String hint;
  final TextEditingController controller;
  final int maxLines;
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
          maxLines: maxLines,
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
