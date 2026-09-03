import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class ShopProfileScreen extends StatefulWidget {
  const ShopProfileScreen({super.key});

  @override
  State<ShopProfileScreen> createState() => _ShopProfileScreenState();
}

class _ShopProfileScreenState extends State<ShopProfileScreen> {
  static const String _shopNameKey = 'shop_name';
  static const String _chairsKey = 'shop_chairs';
  static const String _imagesKey = 'shop_images';

  final TextEditingController _nameController =
      TextEditingController(text: 'vendor2');

  final ImagePicker _imagePicker = ImagePicker();

  int _chairs = 5;

  List<String?> _imagePaths = List<String?>.filled(5, null);

  bool _isLoading = true;
  bool _isSavingImages = false;

  @override
  void initState() {
    super.initState();
    _loadShopSettings();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Load saved shop settings
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> _loadShopSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String savedName =
        prefs.getString(_shopNameKey)?.trim().isNotEmpty == true
            ? prefs.getString(_shopNameKey)!.trim()
            : 'vendor2';

    final int savedChairs = prefs.getInt(_chairsKey) ?? 5;

    final List<String> savedImages =
        prefs.getStringList(_imagesKey) ?? <String>[];

    final List<String?> loadedImages = List<String?>.filled(5, null);

    for (int i = 0; i < savedImages.length && i < loadedImages.length; i++) {
      final String path = savedImages[i];

      if (File(path).existsSync()) {
        loadedImages[i] = path;
      }
    }

    if (!mounted) return;

    setState(() {
      _nameController.text = savedName;
      _chairs = savedChairs < 1 ? 1 : savedChairs;
      _imagePaths = loadedImages;
      _isLoading = false;
    });
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Save shop name
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> _saveShopName() async {
    FocusScope.of(context).unfocus();

    final String name = _nameController.text.trim();

    if (name.isEmpty) {
      _showMessage(
        'Shop name cannot be empty.',
        isError: true,
      );
      return;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(_shopNameKey, name);

    if (!mounted) return;

    _showMessage('Shop name updated successfully.');
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Pick image
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> _pickImage(int index) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile == null) {
        return;
      }

      final Directory appDirectory =
          await getApplicationDocumentsDirectory();

      final Directory shopImagesDirectory =
          Directory('${appDirectory.path}/shop_images');

      if (!await shopImagesDirectory.exists()) {
        await shopImagesDirectory.create(recursive: true);
      }

      final String extension = _fileExtension(pickedFile.path);

      final String fileName =
          'shop_image_${DateTime.now().millisecondsSinceEpoch}_$index$extension';

      final String permanentPath =
          '${shopImagesDirectory.path}/$fileName';

      final File copiedFile = await File(pickedFile.path).copy(permanentPath);

      if (!mounted) return;

      setState(() {
        _imagePaths[index] = copiedFile.path;
      });

      _showMessage('Image ${index + 1} selected.');
    } catch (error) {
      if (!mounted) return;

      _showMessage(
        'Unable to select image.',
        isError: true,
      );
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Save images
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> _saveImages() async {
    if (_isSavingImages) return;

    setState(() {
      _isSavingImages = true;
    });

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final List<String> paths = _imagePaths
          .whereType<String>()
          .where((path) => File(path).existsSync())
          .toList();

      await prefs.setStringList(_imagesKey, paths);

      if (!mounted) return;

      setState(() {
        _isSavingImages = false;
      });

      _showMessage(
        paths.length >= 2
            ? 'Shop images saved successfully.'
            : 'Please upload at least 2 images.',
        isError: paths.length < 2,
      );
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isSavingImages = false;
      });

      _showMessage(
        'Unable to save images.',
        isError: true,
      );
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Save chairs
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> _saveChairs(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt(_chairsKey, value);
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Chair controls
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> _decrementChairs() async {
    if (_chairs <= 1) return;

    final int newValue = _chairs - 1;

    setState(() {
      _chairs = newValue;
    });

    await _saveChairs(newValue);
  }

  Future<void> _incrementChairs() async {
    final int newValue = _chairs + 1;

    setState(() {
      _chairs = newValue;
    });

    await _saveChairs(newValue);
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Helpers
  // ───────────────────────────────────────────────────────────────────────────

  String _fileExtension(String path) {
    final int dotIndex = path.lastIndexOf('.');

    if (dotIndex == -1) {
      return '.jpg';
    }

    return path.substring(dotIndex).toLowerCase();
  }

  void _showMessage(
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: AppTypography.bodySM.copyWith(
              color: Colors.white,
            ),
          ),
          backgroundColor:
              isError ? AppColors.logout : AppColors.sidebarActive,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.sidebarActive,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(28),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 680,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Shop Settings',
                style: AppTypography.shopSettingsTitle,
              )
                  .animate()
                  .fadeIn(duration: 300.ms),

              const SizedBox(height: 24),

              // ────────────────────────────────────────────────────────────────
              // Main settings card
              // ────────────────────────────────────────────────────────────────

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: _cardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SHOP NAME',
                      style: AppTypography.inputLabel,
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: _nameController,
                      style: AppTypography.bodyMD,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 13,
                        ),
                      ),
                      onSubmitted: (_) => _saveShopName(),
                    )
                        .animate()
                        .fadeIn(
                          duration: 300.ms,
                          delay: 100.ms,
                        ),

                    const SizedBox(height: 16),

                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: _saveShopName,
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.buttonDark,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'SAVE CHANGES',
                            style: AppTypography.buttonText,
                          ),
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(
                          duration: 300.ms,
                          delay: 130.ms,
                        ),

                    const SizedBox(height: 28),

                    // ──────────────────────────────────────────────────────────
                    // Shop Image section
                    // ──────────────────────────────────────────────────────────

                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.borderLight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SHOP IMAGE',
                            style: AppTypography.inputLabel,
                          ),

                          const SizedBox(height: 16),

                          _ShopImagesRow(
                            imagePaths: _imagePaths,
                            onPickImage: _pickImage,
                          ),

                          const SizedBox(height: 12),

                          Text(
                            'Upload at least 2 images. Clients will rotate through them on hover.',
                            style: AppTypography.bodyXS.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),

                          const SizedBox(height: 14),

                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: _isSavingImages
                                  ? null
                                  : _saveImages,
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: _isSavingImages
                                      ? AppColors.buttonDark
                                          .withValues(alpha: 0.6)
                                      : AppColors.buttonDark,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: _isSavingImages
                                    ? const SizedBox(
                                        width: 14,
                                        height: 14,
                                        child:
                                            CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        'SAVE IMAGES',
                                        style: AppTypography.buttonText,
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(
                          duration: 350.ms,
                          delay: 150.ms,
                        ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(
                    duration: 300.ms,
                    delay: 80.ms,
                  ),

              const SizedBox(height: 16),

              // ────────────────────────────────────────────────────────────────
              // Chairs card
              // ────────────────────────────────────────────────────────────────

              _ChairsCard(
                value: _chairs,
                onDecrement: _decrementChairs,
                onIncrement: _incrementChairs,
              )
                  .animate()
                  .fadeIn(
                    duration: 350.ms,
                    delay: 200.ms,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────────
// Shop Images Row
// ───────────────────────────────────────────────────────────────────────────────

class _ShopImagesRow extends StatelessWidget {
  const _ShopImagesRow({
    required this.imagePaths,
    required this.onPickImage,
  });

  final List<String?> imagePaths;
  final Future<void> Function(int index) onPickImage;

  @override
  Widget build(BuildContext context) {
    const List<Color> placeholderColors = [
      Color(0xFF8D7B6A),
      Color(0xFF7A9E8E),
      Color(0xFF9E8E7A),
      Color(0xFF6A8D7B),
      Color(0xFFB8A99A),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          5,
          (index) {
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: _ShopImageSlot(
                index: index,
                placeholder: placeholderColors[index],
                imagePath: imagePaths[index],
                onPick: () => onPickImage(index),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────────
// Individual Shop Image Slot
// ───────────────────────────────────────────────────────────────────────────────

class _ShopImageSlot extends StatelessWidget {
  const _ShopImageSlot({
    required this.index,
    required this.placeholder,
    required this.imagePath,
    required this.onPick,
  });

  final int index;
  final Color placeholder;
  final String? imagePath;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final bool hasImage =
        imagePath != null && File(imagePath!).existsSync();

    return Column(
      children: [
        Text(
          'IMAGE ${index + 1}',
          style: AppTypography.labelXS,
        ),

        const SizedBox(height: 6),

        Container(
          width: 96,
          height: 70,
          decoration: BoxDecoration(
            color: placeholder,
            borderRadius: BorderRadius.circular(6),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: hasImage
                ? Image.file(
                    File(imagePath!),
                    fit: BoxFit.cover,
                    errorBuilder: (
                      context,
                      error,
                      stackTrace,
                    ) {
                      return _PlaceholderImage(
                        color: placeholder,
                      );
                    },
                  )
                : _PlaceholderImage(
                    color: placeholder,
                  ),
          ),
        ),

        const SizedBox(height: 6),

        // Choose File button
        InkWell(
          onTap: onPick,
          borderRadius: BorderRadius.circular(4),
          child: Container(
            width: 96,
            height: 26,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.borderLight,
              ),
              borderRadius: BorderRadius.circular(4),
              color: AppColors.cardBackground,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      hasImage ? 'Change' : 'Choose File',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyXS.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  color: AppColors.borderLight,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  child: Text(
                    hasImage ? '✓' : 'N...',
                    style: AppTypography.bodyXS.copyWith(
                      color: hasImage
                          ? AppColors.confirmedText
                          : AppColors.textMuted,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────────
// Placeholder Image
// ───────────────────────────────────────────────────────────────────────────────

class _PlaceholderImage extends StatelessWidget {
  const _PlaceholderImage({
    required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.9),
            color.withValues(alpha: 0.6),
          ],
        ),
      ),
      child: const Icon(
        Icons.storefront_outlined,
        color: Color(0x80FFFFFF),
        size: 28,
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────────
// Chairs Card
// ───────────────────────────────────────────────────────────────────────────────

class _ChairsCard extends StatelessWidget {
  const _ChairsCard({
    required this.value,
    required this.onDecrement,
    required this.onIncrement,
  });

  final int value;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.chairsCardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOTAL CHAIRS AVAILABLE',
            style: AppTypography.chairsTitle,
          ),

          const SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Number box
              Container(
                width: 60,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.borderLight,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$value',
                  style: AppTypography.chairsValue,
                ),
              ),

              const SizedBox(width: 20),

              // Controls
              Column(
                children: [
                  _ChairButton(
                    icon: Icons.keyboard_arrow_up_rounded,
                    onTap: onIncrement,
                  ),
                  const SizedBox(height: 4),
                  _ChairButton(
                    icon: Icons.keyboard_arrow_down_rounded,
                    onTap: onDecrement,
                  ),
                ],
              ),

              const SizedBox(width: 20),

              Expanded(
                child: Text(
                  'Set the maximum number of customers you can serve simultaneously. The system automatically deducts occupied seats.',
                  style: AppTypography.bodySM.copyWith(
                    color: Colors.white.withValues(
                      alpha: 0.65,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────────
// Chair Button
// ───────────────────────────────────────────────────────────────────────────────

class _ChairButton extends StatelessWidget {
  const _ChairButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: 28,
        height: 24,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          icon,
          size: 18,
          color: Colors.white70,
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────────
// Main Card Decoration
// ───────────────────────────────────────────────────────────────────────────────

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