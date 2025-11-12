// lib/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'theme_palette.dart';
import 'package:google_fonts/google_fonts.dart';

class UiTokens extends ThemeExtension<UiTokens> {
  final double radiusLg;
  final double radiusMd;
  final EdgeInsets pagePad;
  final List<BoxShadow> cardShadow;

  const UiTokens({
    required this.radiusLg,
    required this.radiusMd,
    required this.pagePad,
    required this.cardShadow,
  });

  @override
  UiTokens copyWith({
    double? radiusLg,
    double? radiusMd,
    EdgeInsets? pagePad,
    List<BoxShadow>? cardShadow,
  }) =>
      UiTokens(
        radiusLg: radiusLg ?? this.radiusLg,
        radiusMd: radiusMd ?? this.radiusMd,
        pagePad: pagePad ?? this.pagePad,
        cardShadow: cardShadow ?? this.cardShadow,
      );

  @override
  UiTokens lerp(ThemeExtension<UiTokens>? other, double t) {
    if (other is! UiTokens) return this;
    return this;
  }
}

class AppTheme {
  static ThemeData build(ThemePalette p,
      {Brightness brightness = Brightness.light}) {
    final base =
        ColorScheme.fromSeed(seedColor: p.primary, brightness: brightness);
    final cs = base.copyWith(
      primary: p.primary,
      secondary: p.secondary,
      error: p.error,
      // nicer soft tones
      surface: base.surface,
      surfaceContainerHighest: base.surfaceVariant,
    );

    final tokens = UiTokens(
      radiusLg: 18,
      radiusMd: 14,
      pagePad: const EdgeInsets.all(16),
      cardShadow: const [
        BoxShadow(
            color: Color(0x14000000), blurRadius: 14, offset: Offset(0, 10)),
      ],
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      brightness: brightness,
      primaryColor: p.primary,
      textTheme: GoogleFonts.interTextTheme(),
      extensions: [tokens],
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          shape: const StadiumBorder(),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cs.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: cs.primary, width: 1.6),
        ),
      ),
      chipTheme: ChipThemeData(
        selectedColor: p.secondary.withOpacity(.12),
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
