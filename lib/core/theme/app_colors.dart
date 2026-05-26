import 'package:flutter/material.dart';

/// Paleta de cores centralizada do E-Rank.
/// Todas as cores do app devem ser referenciadas aqui.
/// Nunca utilize cores hardcoded diretamente nos widgets.
class AppColors {
  AppColors._();

  // ── Backgrounds ────────────────────────────────────────────────────────────
  static const Color background = Color(0xFF0F0C29);
  static const Color surface = Color(0xFF1E1E2C);
  static const Color surfaceLight = Color(0xFF262642);

  // ── Brand / Primárias ───────────────────────────────────────────────────────
  static const Color primary = Color(0xFF7F5AF0);
  static const Color primaryGlow = Color(0x667F5AF0);
  static const Color accent = Color(0xFF2CB67D);
  static const Color accentGlow = Color(0x662CB67D);

  // ── Ranking ─────────────────────────────────────────────────────────────────
  static const Color gold = Color(0xFFFFB800);
  static const Color silver = Color(0xFFBEC5D1);
  static const Color bronze = Color(0xFFCD7F32);

  // ── Semânticas ──────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF2CB67D);
  static const Color danger = Color(0xFFEF4565);
  static const Color warning = Color(0xFFFFB800);
  static const Color pending = Color(0xFFFF8C00);
  static const Color info = Color(0xFF3D9BE9);

  // ── Texto ───────────────────────────────────────────────────────────────────
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFAAAAAA);
  static const Color textDisabled = Color(0xFF555577);

  // ── Borders / Overlays ──────────────────────────────────────────────────────
  static const Color borderSubtle = Color(0x1FFFFFFF); // white12
  static const Color borderDefault = Color(0x3DFFFFFF); // white24
  static const Color overlayDark = Color(0x99000000); // black60

  // ── Aliases legados (mantidos para compatibilidade com widgets existentes) ───
  static const Color white = Colors.white;
  static const Color white54 = Colors.white54;
  static const Color black87 = Colors.black87;
  static const Color grey = Colors.grey;
  static const Color greyShade100 = Color(0xFFF5F5F5);
  static const Color greyShade400 = Color(0xFFBDBDBD);
  static const Color greyShade600 = Color(0xFF757575);
  static const Color green = Color(0xFF2CB67D);
  static const Color red = Color(0xFFEF4565);
}
