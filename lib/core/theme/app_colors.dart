import 'package:flutter/material.dart';

/// App color palette — extracted from design screenshots.
/// Warm cream background, dark charcoal active states, coral accents.
class AppColors {
  AppColors._();

  // ─── Background ────────────────────────────────────────────
  static const Color scaffoldBackground = Color(0xFFF0EDE6);
  static const Color cardBackground     = Color(0xFFFFFFFF);
  static const Color sidebarBackground  = Color(0xFFFFFFFF);

  // ─── Sidebar ───────────────────────────────────────────────
  static const Color sidebarActive      = Color(0xFF2A2A2A);
  static const Color sidebarActiveText  = Color(0xFFFFFFFF);
  static const Color sidebarInactiveText= Color(0xFF8A8A8A);
  static const Color sidebarDivider     = Color(0xFFEEEEEE);

  // ─── Text ──────────────────────────────────────────────────
  static const Color textPrimary        = Color(0xFF1A1A1A);
  static const Color textSecondary      = Color(0xFF6B6B6B);
  static const Color textMuted          = Color(0xFF9E9E9E);
  static const Color textHint           = Color(0xFFBDBDBD);

  // ─── Accent ────────────────────────────────────────────────
  static const Color logout             = Color(0xFFD94F4F);
  static const Color accentGold         = Color(0xFFB8936A);

  // ─── Status Chips ──────────────────────────────────────────
  static const Color confirmedBg        = Color(0xFFD6F0DD);
  static const Color confirmedText      = Color(0xFF2D7A40);
  static const Color completedBg        = Color(0xFFF0F0F0);
  static const Color completedText      = Color(0xFF5A5A5A);
  static const Color cancelledBg        = Color(0xFFFFE4E4);
  static const Color cancelledText      = Color(0xFFD94F4F);
  static const Color notReportedBg      = Color(0xFFFFEBEB);
  static const Color notReportedText    = Color(0xFFD94F4F);
  static const Color pendingBg          = Color(0xFFFFF3CD);
  static const Color pendingText        = Color(0xFF856404);

  // ─── Buttons ───────────────────────────────────────────────
  static const Color buttonDark         = Color(0xFF2A2A2A);
  static const Color buttonDarkText     = Color(0xFFFFFFFF);

  // ─── Borders & Dividers ────────────────────────────────────
  static const Color borderLight        = Color(0xFFE8E5DF);
  static const Color divider            = Color(0xFFF0EDE6);

  // ─── Stars ─────────────────────────────────────────────────
  static const Color starEmpty          = Color(0xFFD9D9D9);
  static const Color starFilled         = Color(0xFFE8B84B);

  // ─── Input ─────────────────────────────────────────────────
  static const Color inputBorder        = Color(0xFFDDDAD4);
  static const Color inputBackground    = Color(0xFFFFFFFF);

  // ─── Category Badge ────────────────────────────────────────
  static const Color categoryBadgeBg   = Color(0xFFF3F0EB);
  static const Color categoryBadgeText = Color(0xFF7A7A7A);

  // ─── Chairs card ───────────────────────────────────────────
  static const Color chairsCardBg      = Color(0xFF2A2A2A);
  static const Color chairsCardTitle   = Color(0xFFD4914A);
}
