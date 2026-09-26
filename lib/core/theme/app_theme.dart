import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color surface = Color(0xfffaf8ff);
  static const Color surfaceDim = Color(0xffd2d9f4);
  static const Color surfaceBright = Color(0xfffaf8ff);

  static const Color surfaceContainerLowest = Color(0xffffffff);
  static const Color surfaceContainerLow = Color(0xfff2f3ff);
  static const Color surfaceContainer = Color(0xffeaedff);
  static const Color surfaceContainerHigh = Color(0xffe2e7ff);
  static const Color surfaceContainerHighest = Color(0xffdae2fd);

  static const Color onSurface = Color(0xff131b2e);
  static const Color onSurfaceVariant = Color(0xff404940);
  static const Color inverseSurface = Color(0xff283044);
  static const Color inverseOnSurface = Color(0xffeef0ff);

  static const Color outline = Color(0xff707a6f);
  static const Color outlineVariant = Color(0xffbfc9bd);
  static const Color surfaceTint = Color(0xff1f6c3a);

  static const Color primary = Color(0xff004c22);
  static const Color onPrimary = Color(0xffffffff);
  static const Color primaryContainer = Color(0xff166534);
  static const Color onPrimaryContainer = Color(0xff93e0a2);
  static const Color inversePrimary = Color(0xff8bd79b);

  static const Color secondary = Color(0xff006a63);
  static const Color onSecondary = Color(0xffffffff);
  static const Color secondaryContainer = Color(0xff99efe5);
  static const Color onSecondaryContainer = Color(0xff006f67);

  static const Color tertiary = Color(0xff004b1e);
  static const Color onTertiary = Color(0xffffffff);
  static const Color tertiaryContainer = Color(0xff00662b);
  static const Color onTertiaryContainer = Color(0xff54e97d);

  static const Color error = Color(0xffba1a1a);
  static const Color onError = Color(0xffffffff);
  static const Color errorContainer = Color(0xffffdad6);
  static const Color onErrorContainer = Color(0xff93000a);

  static const Color primaryFixed = Color(0xffa6f4b5);
  static const Color primaryFixedDim = Color(0xff8bd79b);
  static const Color onPrimaryFixed = Color(0xff00210b);
  static const Color onPrimaryFixedVariant = Color(0xff005226);

  static const Color secondaryFixed = Color(0xff9cf2e8);
  static const Color secondaryFixedDim = Color(0xff80d5cb);
  static const Color onSecondaryFixed = Color(0xff00201d);
  static const Color onSecondaryFixedVariant = Color(0xff00504a);

  static const Color tertiaryFixed = Color(0xff6bff8f);
  static const Color tertiaryFixedDim = Color(0xff4ae176);
  static const Color onTertiaryFixed = Color(0xff002109);
  static const Color onTertiaryFixedVariant = Color(0xff005321);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        inversePrimary: inversePrimary,
        secondary: secondary,
        onSecondary: onSecondary,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: onSecondaryContainer,
        tertiary: tertiary,
        onTertiary: onTertiary,
        tertiaryContainer: tertiaryContainer,
        onTertiaryContainer: onTertiaryContainer,
        error: error,
        onError: onError,
        errorContainer: errorContainer,
        onErrorContainer: onErrorContainer,
        surface: surface,
        surfaceDim: surfaceDim,
        surfaceBright: surfaceBright,
        surfaceContainerLowest: surfaceContainerLowest,
        surfaceContainerLow: surfaceContainerLow,
        surfaceContainer: surfaceContainer,
        surfaceContainerHigh: surfaceContainerHigh,
        surfaceContainerHighest: surfaceContainerHighest,
        onSurface: onSurface,
        onSurfaceVariant: onSurfaceVariant,
        inverseSurface: inverseSurface,
        onInverseSurface: inverseOnSurface,
        outline: outline,
        outlineVariant: outlineVariant,
        surfaceTint: surfaceTint,
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.plusJakartaSans(
          fontSize: 26,
          fontWeight: .w700,
          height: 1.231,
          letterSpacing: -0.39,
        ),
        headlineMedium: GoogleFonts.plusJakartaSans(
          fontSize: 22,
          fontWeight: .w600,
          height: 1.273,
          letterSpacing: -0.22,
        ),
        headlineSmall: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: .w600,
          height: 1.333,
          letterSpacing: -0.09,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: .w400,
          height: 1.500,
          letterSpacing: 0.0,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: .w400,
          height: 1.429,
          letterSpacing: 0.0,
        ),
        bodySmall: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: .w400,
          height: 1.333,
          letterSpacing: 0.12,
        ),
        labelLarge: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: .w600,
          height: 1.429,
          letterSpacing: 0.14,
        ),
        labelMedium: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: .w600,
          height: 1.333,
          letterSpacing: 0.24,
        ),
        labelSmall: GoogleFonts.plusJakartaSans(
          fontSize: 10,
          fontWeight: .w700,
          height: 1.400,
          letterSpacing: 0.40,
        ),
      ),
    );
  }
}
