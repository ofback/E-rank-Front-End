import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erank_app/core/theme/app_colors.dart';

/// Tema centralizado do E-Rank.
/// Utiliza ColorScheme.dark para garantir consistência em todos os
/// componentes Material sem necessidade de sobrescrever cor por cor.
class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    final colorScheme = ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: AppColors.textPrimary,
      secondary: AppColors.accent,
      onSecondary: AppColors.textPrimary,
      error: AppColors.danger,
      onError: AppColors.textPrimary,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      outline: AppColors.borderDefault,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,

      // ── Tipografia global ────────────────────────────────────────────────
      textTheme: GoogleFonts.poppinsTextTheme(
        ThemeData.dark().textTheme.apply(
              bodyColor: AppColors.textPrimary,
              displayColor: AppColors.textPrimary,
            ),
      ),

      // ── AppBar ───────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: GoogleFonts.bevan(
          fontSize: 22,
          color: AppColors.textPrimary,
          letterSpacing: 1.5,
        ),
      ),

      // ── BottomNavigationBar ───────────────────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.background.withValues(alpha: 0.95),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textDisabled,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.exo2(
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: GoogleFonts.exo2(
          fontSize: 10,
        ),
      ),

      // ── ElevatedButton ────────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textPrimary,
          disabledBackgroundColor: AppColors.greyShade600,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // ── TextButton ───────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // ── OutlinedButton ───────────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),

      // ── InputDecoration ──────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.black87.withValues(alpha: 0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderDefault),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderDefault),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: AppColors.danger, width: 1.5),
        ),
        labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary),
        hintStyle: GoogleFonts.poppins(color: AppColors.textDisabled),
        errorStyle: GoogleFonts.poppins(
          color: AppColors.danger,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        prefixIconColor: AppColors.textSecondary,
        suffixIconColor: AppColors.textSecondary,
      ),

      // ── Card ─────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderSubtle),
        ),
      ),

      // ── Dialog ───────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: GoogleFonts.exo2(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: GoogleFonts.poppins(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
      ),

      // ── SnackBar ─────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        contentTextStyle: GoogleFonts.poppins(color: AppColors.textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // ── TabBar ───────────────────────────────────────────────────────────
      tabBarTheme: TabBarThemeData(
        indicatorColor: AppColors.primary,
        labelColor: AppColors.textPrimary,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: GoogleFonts.exo2(fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.exo2(),
      ),

      // ── CircularProgressIndicator ─────────────────────────────────────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),

      // ── FloatingActionButton ──────────────────────────────────────────────
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textPrimary,
      ),

      // ── Divider ───────────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.borderSubtle,
        thickness: 1,
      ),
    );
  }
}
