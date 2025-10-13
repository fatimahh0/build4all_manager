import 'package:flutter/material.dart';
import 'theme_palette.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData build(ThemePalette p,
      {Brightness brightness = Brightness.light}) {
    final seed = p.primary;
    final base = ColorScheme.fromSeed(seedColor: seed, brightness: brightness);
    final cs = base.copyWith(
      primary: p.primary,
      secondary: p.secondary,
      error: p.error,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      brightness: brightness,
      primaryColor: p.primary,
      textTheme: GoogleFonts.interTextTheme(),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          shape: const StadiumBorder(),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: cs.primary, width: 1.6),
        ),
      ),
      chipTheme: ChipThemeData(
        selectedColor: p.secondary.withOpacity(.15),
        deleteIconColor: p.error,
      ),
    );
  }
}
