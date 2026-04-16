import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'clay_colors.dart';

class ClayTheme {
  static ThemeData light() {
    final textTheme = TextTheme(
      displayLarge: GoogleFonts.nunito(
        fontSize: 34,
        fontWeight: FontWeight.w800,
        color: ClayColors.textPrimary,
      ),
      headlineLarge: GoogleFonts.nunito(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: ClayColors.textPrimary,
      ),
      titleLarge: GoogleFonts.nunito(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: ClayColors.textPrimary,
      ),
      bodyLarge: GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: ClayColors.textPrimary,
      ),
      bodyMedium: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: ClayColors.textPrimary,
      ),
      labelSmall: GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: ClayColors.textMuted,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: ClayColors.canvas,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ClayColors.primary,
        primary: ClayColors.primary,
        secondary: ClayColors.secondary,
        surface: ClayColors.surface,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: ClayColors.canvas,
        elevation: 0,
        titleTextStyle: textTheme.titleLarge,
        centerTitle: false,
        iconTheme: const IconThemeData(color: ClayColors.textPrimary),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: ClayColors.primary,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: CircleBorder(),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
