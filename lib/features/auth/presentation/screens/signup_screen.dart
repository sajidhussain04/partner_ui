import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../shared/widgets/auth_widgets.dart';

// ─── Service data ──────────────────────────────────────────────────────────────
class _ServiceEntry {
  final String name;
  final int price;
  final int duration;
  const _ServiceEntry(this.name, this.price, this.duration);
}

const _kCategories = [
  'Hair Care',
  'Beard Grooming',
  'Skin Care',
  'Spa & Wellness',
  'Nail Care',
  'Makeup',
];

const _kSkillsByCategory = {
  'Hair Care': [
    'Haircut', 'Blowdry', 'Hair Colouring', 'Balayage',
    'Keratin Treatment', 'Deep Conditioning',
  ],
  'Beard Grooming': [
    'Beard Coloring', 'Beard Styling', 'Beard Trim',
    'Clean Shave', 'Moustache Styling', 'Special Shave',
  ],
  'Skin Care': [
    'Facial', 'Clean-up', 'Detan', 'Bleach',
    'Waxing', 'Threading',
  ],
  'Spa & Wellness': [
    'Head Massage', 'Body Massage', 'Foot Massage',
    'Moroccan Bath', 'Steam & Sauna',
  ],
  'Nail Care': [
    'Manicure', 'Pedicure', 'Nail Art', 'Gel Polish',
  ],
  'Makeup': [
    'Party Makeup', 'Bridal Makeup', 'Eye Makeup',
  ],
};

const _kGenders = ['Male', 'Female', 'Other', 'Prefer not to say'];

// ─── Screen ────────────────────────────────────────────────────────────────────
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  int _step = 0; // 0–3

  // ── Step 1 – Account ──────────────────────────────
  final _nameCtrl        = TextEditingController();
  final _shopCtrl        = TextEditingController();
  final _emailCtrl       = TextEditingController();
  final _mobileCtrl      = TextEditingController();
  final _passwordCtrl    = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  String? _gender;
  bool _obscure        = true;
  bool _obscureConfirm = true;
  String? _step1Error;

  static final _emailRegex =
      RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w]{2,}$');

  // ── Step 2 – Services ─────────────────────────────
  String? _selectedCategory;
  String? _selectedSkill;
  final _priceCtrl    = TextEditingController();
  final _durationCtrl = TextEditingController();
  final List<_ServiceEntry> _services = [];
  String? _step2Error;

  // ── Step 3 – Address ──────────────────────────────
  final _cityCtrl     = TextEditingController();
  final _addressCtrl  = TextEditingController();
  final _pincodeCtrl  = TextEditingController();
  final _chairsCtrl   = TextEditingController();
  String? _step3Error;

  // ── Submit ─────────────────────────────────────────
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose(); _shopCtrl.dispose(); _emailCtrl.dispose();
    _mobileCtrl.dispose(); _passwordCtrl.dispose(); _confirmPassCtrl.dispose();
    _priceCtrl.dispose(); _durationCtrl.dispose();
    _cityCtrl.dispose(); _addressCtrl.dispose();
    _pincodeCtrl.dispose(); _chairsCtrl.dispose();
    super.dispose();
  }

  // ── Validation ─────────────────────────────────────
  bool _validateStep1() {
    if (_nameCtrl.text.trim().isEmpty ||
        _shopCtrl.text.trim().isEmpty ||
        _emailCtrl.text.trim().isEmpty ||
        _mobileCtrl.text.trim().isEmpty ||
        _gender == null ||
        _passwordCtrl.text.isEmpty) {
      setState(() => _step1Error = 'Please fill in all required fields.');
      return false;
    }
    if (!_emailRegex.hasMatch(_emailCtrl.text.trim())) {
      setState(() => _step1Error = 'Please enter a valid email address.');
      return false;
    }
    if (_mobileCtrl.text.trim().length < 10) {
      setState(() => _step1Error = 'Enter a valid 10-digit mobile number.');
      return false;
    }
    if (_passwordCtrl.text.length < 6) {
      setState(() => _step1Error = 'Password must be at least 6 characters.');
      return false;
    }
    if (_confirmPassCtrl.text != _passwordCtrl.text) {
      setState(() => _step1Error = 'Passwords do not match.');
      return false;
    }
    setState(() => _step1Error = null);
    return true;
  }

  bool _validateStep2() {
    if (_services.isEmpty) {
      setState(() => _step2Error = 'Please add at least one service.');
      return false;
    }
    setState(() => _step2Error = null);
    return true;
  }

  bool _validateStep3() {
    if (_cityCtrl.text.trim().isEmpty ||
        _addressCtrl.text.trim().isEmpty ||
        _pincodeCtrl.text.trim().isEmpty ||
        _chairsCtrl.text.trim().isEmpty) {
      setState(() => _step3Error = 'Please fill in all address fields.');
      return false;
    }
    setState(() => _step3Error = null);
    return true;
  }

  void _next() {
    if (_step == 0 && !_validateStep1()) return;
    if (_step == 1 && !_validateStep2()) return;
    if (_step == 2 && !_validateStep3()) return;
    setState(() => _step++);
  }

  void _back() => setState(() => _step--);

  Future<void> _submit() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    AuthSession.isLoggedIn = true;
    if (mounted) context.go(AppRoutes.overview);
  }

  void _addService() {
    if (_selectedCategory == null || _selectedSkill == null ||
        _priceCtrl.text.isEmpty || _durationCtrl.text.isEmpty) {
      setState(() => _step2Error = 'Please select a category, skill, price and duration.');
      return;
    }
    final price    = int.tryParse(_priceCtrl.text) ?? 0;
    final duration = int.tryParse(_durationCtrl.text) ?? 0;
    setState(() {
      _services.add(_ServiceEntry(_selectedSkill!, price, duration));
      _selectedCategory = null;
      _selectedSkill    = null;
      _priceCtrl.clear();
      _durationCtrl.clear();
      _step2Error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.of(context).size.width >= 800;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: isWide ? _wideLayout() : _narrowLayout(),
    );
  }

  Widget _wideLayout() => Row(
    children: [
      Expanded(child: _BrandPanel()),
      Expanded(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(48),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: _buildStep(),
            ),
          ),
        ),
      ),
    ],
  );

  Widget _narrowLayout() => SingleChildScrollView(
    physics: const AlwaysScrollableScrollPhysics(),
    child: Column(
      children: [
        _MobileHeader(),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
          child: _buildStep(),
        ),
      ],
    ),
  );

  Widget _buildStep() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, anim) => FadeTransition(
        opacity: anim,
        child: SlideTransition(
          position: Tween(begin: const Offset(0.04, 0), end: Offset.zero)
              .animate(anim),
          child: child,
        ),
      ),
      child: KeyedSubtree(
        key: ValueKey(_step),
        child: switch (_step) {
          0 => _Step1Account(
              nameCtrl: _nameCtrl, shopCtrl: _shopCtrl,
              emailCtrl: _emailCtrl, mobileCtrl: _mobileCtrl,
              passwordCtrl: _passwordCtrl,
              confirmPassCtrl: _confirmPassCtrl,
              gender: _gender,
              obscure: _obscure,
              obscureConfirm: _obscureConfirm,
              onGenderChanged: (v) => setState(() => _gender = v),
              onToggleObscure: () => setState(() => _obscure = !_obscure),
              onToggleObscureConfirm:
                  () => setState(() => _obscureConfirm = !_obscureConfirm),
              error: _step1Error,
              onNext: _next,
              onLogin: () => context.go(AppRoutes.login),
            ),
          1 => _Step2Services(
              categories: _kCategories,
              skillsByCategory: _kSkillsByCategory,
              selectedCategory: _selectedCategory,
              selectedSkill: _selectedSkill,
              priceCtrl: _priceCtrl,
              durationCtrl: _durationCtrl,
              services: _services,
              error: _step2Error,
              onCategoryChanged: (v) => setState(() {
                _selectedCategory = v;
                _selectedSkill    = null;
              }),
              onSkillChanged: (v) => setState(() => _selectedSkill = v),
              onAddService: _addService,
              onRemoveService: (i) => setState(() => _services.removeAt(i)),
              onNext: _next,
              onBack: _back,
              onLogin: () => context.go(AppRoutes.login),
            ),
          2 => _Step3Address(
              cityCtrl: _cityCtrl, addressCtrl: _addressCtrl,
              pincodeCtrl: _pincodeCtrl, chairsCtrl: _chairsCtrl,
              error: _step3Error,
              onNext: _next, onBack: _back,
              onLogin: () => context.go(AppRoutes.login),
            ),
          _ => _Step4Review(
              name: _nameCtrl.text.trim(),
              shop: _shopCtrl.text.trim(),
              email: _emailCtrl.text.trim(),
              mobile: _mobileCtrl.text.trim(),
              gender: _gender ?? '',
              city: _cityCtrl.text.trim(),
              address: _addressCtrl.text.trim(),
              pincode: _pincodeCtrl.text.trim(),
              chairs: _chairsCtrl.text.trim(),
              services: _services,
              loading: _loading,
              onSubmit: _submit,
              onBack: _back,
            ),
        },
      ),
    );
  }
}

// ─── Step Progress Indicator ───────────────────────────────────────────────────
class _StepBar extends StatelessWidget {
  const _StepBar({required this.current});
  final int current;

  static const _labels = ['ACCOUNT', 'SERVICES', 'ADDRESS', 'REVIEW'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_labels.length, (i) {
        final bool active = i == current;
        final bool done   = i < current;
        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${i + 1}.',
                      style: AppTypography.labelXS.copyWith(
                        color: active
                            ? AppColors.textPrimary
                            : done
                                ? AppColors.accentGold
                                : AppColors.textHint,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      _labels[i],
                      style: AppTypography.labelXS.copyWith(
                        fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                        color: active
                            ? AppColors.textPrimary
                            : done
                                ? AppColors.accentGold
                                : AppColors.textHint,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

// ─── Shared header ─────────────────────────────────────────────────────────────
class _FormHeader extends StatelessWidget {
  const _FormHeader({required this.step});
  final int step;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Join the Club', style: AppTypography.pageTitle)
            .animate().fadeIn(duration: 400.ms),
        const SizedBox(height: 4),
        Text('START YOUR JOURNEY', style: AppTypography.labelXS)
            .animate().fadeIn(duration: 400.ms, delay: 50.ms),
        const SizedBox(height: 20),
        _StepBar(current: step)
            .animate().fadeIn(duration: 380.ms, delay: 80.ms),
        const SizedBox(height: 24),
      ],
    );
  }
}

// ─── Shared login link ─────────────────────────────────────────────────────────
class _LoginLink extends StatelessWidget {
  const _LoginLink({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          'ALREADY HAVE AN ACCOUNT? LOGIN',
          style: AppTypography.labelXS.copyWith(
            color: AppColors.accentGold,
            decoration: TextDecoration.underline,
            decorationColor: AppColors.accentGold,
          ),
        ),
      ),
    );
  }
}

// ─── Shared nav buttons ────────────────────────────────────────────────────────
class _NavButtons extends StatelessWidget {
  const _NavButtons({
    required this.onNext,
    this.onBack,
    required this.nextLabel,
    this.loading = false,
  });
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final String nextLabel;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    if (onBack == null) {
      return SizedBox(
        width: double.infinity,
        child: _DarkButton(label: nextLabel, onTap: onNext, loading: loading),
      );
    }
    return Row(
      children: [
        Expanded(
          child: _OutlineButton(label: 'BACK', onTap: onBack!),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: _DarkButton(label: nextLabel, onTap: onNext, loading: loading),
        ),
      ],
    );
  }
}

class _DarkButton extends StatelessWidget {
  const _DarkButton({
    required this.label,
    required this.onTap,
    this.loading = false,
  });
  final String label;
  final VoidCallback onTap;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: loading ? null : onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: loading
              ? AppColors.sidebarActive.withValues(alpha: 0.6)
              : AppColors.sidebarActive,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: loading
            ? const SizedBox(
                width: 18, height: 18,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label, style: AppTypography.buttonText),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_forward_rounded,
                      color: Colors.white, size: 14),
                ],
              ),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  const _OutlineButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderLight, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTypography.buttonText
              .copyWith(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}

// ─── Styled text field ─────────────────────────────────────────────────────────
class _Field extends StatelessWidget {
  const _Field({
    required this.hint,
    required this.controller,
    this.icon,
    this.obscure = false,
    this.suffix,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
  });
  final String hint;
  final TextEditingController controller;
  final IconData? icon;
  final bool obscure;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.categoryBadgeBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLines: maxLines,
        style: AppTypography.bodyMD,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTypography.bodyMD.copyWith(color: AppColors.textHint),
          prefixIcon: icon != null
              ? Icon(icon, size: 18, color: AppColors.textMuted)
              : null,
          suffixIcon: suffix,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: AppColors.accentGold, width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

// ─── Styled dropdown ───────────────────────────────────────────────────────────
class _DropField<T> extends StatelessWidget {
  const _DropField({
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.icon,
  });
  final String hint;
  final T? value;
  final List<T> items;
  final ValueChanged<T?>? onChanged;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.categoryBadgeBg,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Row(
            children: [
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(icon, size: 18, color: AppColors.textMuted),
                ),
              Text(hint,
                  style: AppTypography.bodyMD
                      .copyWith(color: AppColors.textHint)),
            ],
          ),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              size: 18, color: AppColors.textMuted),
          items: items
              .map((e) => DropdownMenuItem<T>(
                    value: e,
                    child: Text(e.toString(),
                        style: AppTypography.bodyMD),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// STEP 1 – ACCOUNT
// ═══════════════════════════════════════════════════════════════════════════════
class _Step1Account extends StatelessWidget {
  const _Step1Account({
    required this.nameCtrl,
    required this.shopCtrl,
    required this.emailCtrl,
    required this.mobileCtrl,
    required this.passwordCtrl,
    required this.confirmPassCtrl,
    required this.gender,
    required this.obscure,
    required this.obscureConfirm,
    required this.onGenderChanged,
    required this.onToggleObscure,
    required this.onToggleObscureConfirm,
    required this.error,
    required this.onNext,
    required this.onLogin,
  });

  final TextEditingController nameCtrl, shopCtrl, emailCtrl,
      mobileCtrl, passwordCtrl, confirmPassCtrl;
  final String? gender;
  final bool obscure, obscureConfirm;
  final ValueChanged<String?> onGenderChanged;
  final VoidCallback onToggleObscure, onToggleObscureConfirm;
  final String? error;
  final VoidCallback onNext, onLogin;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FormHeader(step: 0),

        _Field(hint: 'Your Full Name',
            controller: nameCtrl,
            icon: Icons.person_outline_rounded)
            .animate().fadeIn(duration: 350.ms, delay: 100.ms),
        const SizedBox(height: 12),

        _Field(hint: 'Salon / Shop Name',
            controller: shopCtrl,
            icon: Icons.store_outlined)
            .animate().fadeIn(duration: 350.ms, delay: 140.ms),
        const SizedBox(height: 12),

        _Field(hint: 'Email Address',
            controller: emailCtrl,
            icon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress)
            .animate().fadeIn(duration: 350.ms, delay: 180.ms),
        const SizedBox(height: 12),

        _Field(hint: 'Mobile Number',
            controller: mobileCtrl,
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ])
            .animate().fadeIn(duration: 350.ms, delay: 220.ms),
        const SizedBox(height: 12),

        _DropField<String>(
          hint: 'Select Gender',
          value: gender,
          items: _kGenders,
          onChanged: onGenderChanged,
        ).animate().fadeIn(duration: 350.ms, delay: 260.ms),
        const SizedBox(height: 12),

        _Field(
          hint: 'Password',
          controller: passwordCtrl,
          icon: Icons.lock_outline_rounded,
          obscure: obscure,
          suffix: IconButton(
            icon: Icon(
              obscure
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 18, color: AppColors.textMuted,
            ),
            onPressed: onToggleObscure,
          ),
        ).animate().fadeIn(duration: 350.ms, delay: 300.ms),
        const SizedBox(height: 12),

        _Field(
          hint: 'Confirm Password',
          controller: confirmPassCtrl,
          icon: Icons.lock_outline_rounded,
          obscure: obscureConfirm,
          suffix: IconButton(
            icon: Icon(
              obscureConfirm
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 18, color: AppColors.textMuted,
            ),
            onPressed: onToggleObscureConfirm,
          ),
        ).animate().fadeIn(duration: 350.ms, delay: 340.ms),

        if (error != null) ...[
          const SizedBox(height: 12),
          AuthErrorBanner(message: error!)
              .animate().fadeIn(duration: 250.ms),
        ],
        const SizedBox(height: 24),

        _NavButtons(nextLabel: 'NEXT STEP', onNext: onNext)
            .animate().fadeIn(duration: 350.ms, delay: 340.ms),
        const SizedBox(height: 20),

        _LoginLink(onTap: onLogin)
            .animate().fadeIn(duration: 350.ms, delay: 380.ms),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// STEP 2 – SERVICES
// ═══════════════════════════════════════════════════════════════════════════════
class _Step2Services extends StatelessWidget {
  const _Step2Services({
    required this.categories,
    required this.skillsByCategory,
    required this.selectedCategory,
    required this.selectedSkill,
    required this.priceCtrl,
    required this.durationCtrl,
    required this.services,
    required this.error,
    required this.onCategoryChanged,
    required this.onSkillChanged,
    required this.onAddService,
    required this.onRemoveService,
    required this.onNext,
    required this.onBack,
    required this.onLogin,
  });

  final List<String> categories;
  final Map<String, List<String>> skillsByCategory;
  final String? selectedCategory, selectedSkill;
  final TextEditingController priceCtrl, durationCtrl;
  final List<_ServiceEntry> services;
  final String? error;
  final ValueChanged<String?> onCategoryChanged, onSkillChanged;
  final VoidCallback onAddService, onNext, onBack, onLogin;
  final ValueChanged<int> onRemoveService;

  @override
  Widget build(BuildContext context) {
    final skills = selectedCategory != null
        ? (skillsByCategory[selectedCategory] ?? [])
        : <String>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FormHeader(step: 1),

        // ── Category ──────────────────────────────────
        _DropField<String>(
          hint: 'Select Service Category',
          value: selectedCategory,
          items: categories,
          onChanged: onCategoryChanged,
          icon: Icons.category_outlined,
        ).animate().fadeIn(duration: 350.ms, delay: 100.ms),
        const SizedBox(height: 12),

        // ── Skill ─────────────────────────────────────
        AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: selectedCategory != null ? 1 : 0.4,
          child: _DropField<String>(
            hint: 'Select Specific Skill',
            value: skills.contains(selectedSkill) ? selectedSkill : null,
            items: skills,
            onChanged: skills.isEmpty ? null : onSkillChanged,
            icon: Icons.auto_fix_high_outlined,
          ),
        ).animate().fadeIn(duration: 350.ms, delay: 140.ms),
        const SizedBox(height: 12),

        // ── Price & Duration ──────────────────────────
        Row(
          children: [
            Expanded(
              child: _Field(
                hint: 'Price (₹)',
                controller: priceCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _Field(
                hint: 'Duration (min)',
                controller: durationCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
          ],
        ).animate().fadeIn(duration: 350.ms, delay: 180.ms),
        const SizedBox(height: 14),

        // ── Add button ────────────────────────────────
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onAddService,
            icon: const Icon(Icons.add_rounded, size: 16),
            label: Text('ADD SERVICE',
                style: AppTypography.buttonText
                    .copyWith(color: AppColors.textPrimary)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 13),
              side: const BorderSide(color: AppColors.borderLight, width: 1.5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              foregroundColor: AppColors.textPrimary,
            ),
          ),
        ).animate().fadeIn(duration: 350.ms, delay: 220.ms),

        if (error != null) ...[
          const SizedBox(height: 10),
          AuthErrorBanner(message: error!)
              .animate().fadeIn(duration: 250.ms),
        ],

        // ── Service chips ─────────────────────────────
        if (services.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text('ADDED SERVICES (${services.length})',
              style: AppTypography.labelXS),
          const SizedBox(height: 8),
          ...services.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _ServiceChip(
                  service: e.value,
                  onRemove: () => onRemoveService(e.key),
                ),
              )),
        ],

        const SizedBox(height: 24),
        _NavButtons(
          nextLabel: 'NEXT STEP',
          onNext: onNext,
          onBack: onBack,
        ).animate().fadeIn(duration: 350.ms, delay: 260.ms),
        const SizedBox(height: 20),
        _LoginLink(onTap: onLogin)
            .animate().fadeIn(duration: 350.ms, delay: 300.ms),
      ],
    );
  }
}

class _ServiceChip extends StatelessWidget {
  const _ServiceChip({required this.service, required this.onRemove});
  final _ServiceEntry service;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.categoryBadgeBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline_rounded,
              size: 14, color: AppColors.confirmedText),
          const SizedBox(width: 8),
          Expanded(
            child: Text(service.name, style: AppTypography.bodyMD),
          ),
          Text('₹${service.price}',
              style: AppTypography.priceLG
                  .copyWith(fontSize: 13, color: AppColors.textSecondary)),
          const SizedBox(width: 6),
          Text('(${service.duration} min)',
              style: AppTypography.labelXS
                  .copyWith(color: AppColors.textHint)),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close_rounded,
                size: 14, color: AppColors.logout),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// STEP 3 – ADDRESS
// ═══════════════════════════════════════════════════════════════════════════════
class _Step3Address extends StatelessWidget {
  const _Step3Address({
    required this.cityCtrl,
    required this.addressCtrl,
    required this.pincodeCtrl,
    required this.chairsCtrl,
    required this.error,
    required this.onNext,
    required this.onBack,
    required this.onLogin,
  });

  final TextEditingController cityCtrl, addressCtrl, pincodeCtrl, chairsCtrl;
  final String? error;
  final VoidCallback onNext, onBack, onLogin;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FormHeader(step: 2),

        _Field(
          hint: 'City',
          controller: cityCtrl,
          icon: Icons.location_on_outlined,
        ).animate().fadeIn(duration: 350.ms, delay: 100.ms),
        const SizedBox(height: 12),

        _Field(
          hint: 'Complete Shop Address',
          controller: addressCtrl,
          maxLines: 3,
        ).animate().fadeIn(duration: 350.ms, delay: 140.ms),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _Field(
                hint: 'Pincode',
                controller: pincodeCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _Field(
                hint: 'Total Chairs',
                controller: chairsCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
          ],
        ).animate().fadeIn(duration: 350.ms, delay: 180.ms),

        if (error != null) ...[
          const SizedBox(height: 12),
          AuthErrorBanner(message: error!)
              .animate().fadeIn(duration: 250.ms),
        ],

        const SizedBox(height: 24),
        _NavButtons(
          nextLabel: 'NEXT STEP',
          onNext: onNext,
          onBack: onBack,
        ).animate().fadeIn(duration: 350.ms, delay: 220.ms),
        const SizedBox(height: 20),
        _LoginLink(onTap: onLogin)
            .animate().fadeIn(duration: 350.ms, delay: 260.ms),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// STEP 4 – REVIEW
// ═══════════════════════════════════════════════════════════════════════════════
class _Step4Review extends StatelessWidget {
  const _Step4Review({
    required this.name,
    required this.shop,
    required this.email,
    required this.mobile,
    required this.gender,
    required this.city,
    required this.address,
    required this.pincode,
    required this.chairs,
    required this.services,
    required this.loading,
    required this.onSubmit,
    required this.onBack,
  });

  final String name, shop, email, mobile, gender;
  final String city, address, pincode, chairs;
  final List<_ServiceEntry> services;
  final bool loading;
  final VoidCallback onSubmit, onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FormHeader(step: 3),

        // ── Business details card ──────────────────────
        _ReviewCard(
          title: 'BUSINESS DETAILS',
          child: Column(
            children: [
              _ReviewRow('Full Name', name),
              _ReviewRow('Shop Name', shop),
              _ReviewRow('City', city.toUpperCase()),
              _ReviewRow('Address', address),
              _ReviewRow('Pincode', pincode),
              _ReviewRow('Total Chairs', chairs),
              _ReviewRow('Email', email),
              _ReviewRow('Mobile', mobile),
              _ReviewRow('Gender', gender),
              const _ReviewRow('Password', '••••••••'),
            ],
          ),
        ).animate().fadeIn(duration: 380.ms, delay: 80.ms),
        const SizedBox(height: 16),

        // ── Services card ─────────────────────────────
        _ReviewCard(
          title: 'SERVICES ADDED (${services.length})',
          child: Column(
            children: services
                .map((s) => _ReviewRow(
                      s.name,
                      '₹${s.price} (${s.duration} min)',
                    ))
                .toList(),
          ),
        ).animate().fadeIn(duration: 380.ms, delay: 140.ms),
        const SizedBox(height: 28),

        _NavButtons(
          nextLabel: 'CREATE ACCOUNT',
          onNext: onSubmit,
          onBack: onBack,
          loading: loading,
        ).animate().fadeIn(duration: 380.ms, delay: 200.ms),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.labelXS),
          const SizedBox(height: 10),
          const Divider(color: AppColors.borderLight, height: 1),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow(this.label, this.value);
  final String label, value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text('$label:',
                style: AppTypography.bodySM
                    .copyWith(color: AppColors.textSecondary)),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.bodyMD
                  .copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Brand Panel (wide) ────────────────────────────────────────────────────────
class _BrandPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.sidebarActive,
      padding: const EdgeInsets.all(52),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Stylewow Logo ──────────────────────────────────────────────
          Image.asset(
            'assets/images/LOGO-c7veMtdM.png',
            height: 52,
            fit: BoxFit.contain,
            color: Colors.white,
            colorBlendMode: BlendMode.srcIn,
          ).animate().fadeIn(duration: 500.ms),
          const Spacer(),
          Text('Start Your\nJourney Today.',
            style: AppTypography.displayLarge.copyWith(
                color: Colors.white, fontSize: 36, height: 1.15),
          ).animate().fadeIn(duration: 600.ms, delay: 100.ms),
          const SizedBox(height: 20),
          Text(
            'Register your salon and start accepting\nbookings in minutes.',
            style: AppTypography.bodyLG.copyWith(
                color: Colors.white.withValues(alpha: 0.6), height: 1.6),
          ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
          const SizedBox(height: 40),
          ...[
            '✓  Free to get started',
            '✓  No commission on first 30 bookings',
            '✓  24 / 7 partner support',
            '✓  Instant payout setup',
          ].asMap().entries.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(e.value,
                style: AppTypography.bodyLG.copyWith(
                    color: Colors.white.withValues(alpha: 0.75))),
          ).animate().fadeIn(
            duration: 400.ms,
            delay: Duration(milliseconds: 300 + e.key * 80))),
          const Spacer(),
        ],
      ),
    );
  }
}

// ─── Mobile Header ─────────────────────────────────────────────────────────────
class _MobileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.sidebarActive,
      padding: const EdgeInsets.fromLTRB(24, 52, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Stylewow Logo ──────────────────────────────────────────────
          Image.asset(
            'assets/images/LOGO-c7veMtdM.png',
            height: 40,
            fit: BoxFit.contain,
            color: Colors.white,
            colorBlendMode: BlendMode.srcIn,
          ),
        ],
      ),
    );
  }
}
