import 'package:flutter/material.dart';

class VaultTheme {
  const VaultTheme._();

  static const Color canvas = Color(0xFFF5F4F1);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFEDEBE6);
  static const Color surfaceContainerLow = Color(0xFFF1EFEA);
  static const Color surfaceContainer = Color(0xFFEAE7E1);
  static const Color surfaceContainerHigh = Color(0xFFE3E0D9);
  static const Color surfaceContainerHighest = Color(0xFFDAD6CD);
  static const Color hairline = Color(0xFFE4E1DA);
  static const Color ink = Color(0xFF10231C);
  static const Color inkMuted = Color(0xFF5C6660);

  static const Color primary = Color(0xFF0B3B2E);
  static const Color primaryBright = Color(0xFF1B7A52);
  static const Color primarySoft = Color(0xFFD7E6DD);
  static const Color onPrimary = Color(0xFFFFFFFF);

  static const Color error = Color(0xFFB3261E);

  static const String fontFamily = 'Roboto';

  static const double radiusSm = 12;
  static const double radiusMd = 14;
  static const double radiusLg = 20;
  static const double radiusXl = 28;

  static const double pad = 20;
  static const double gap = 16;
  static const double sectionGap = 32;
  static const double navClearance = 104;

  static List<BoxShadow> get e1 => [
    BoxShadow(
      color: ink.withValues(alpha: 0.05),
      offset: const Offset(0, 1),
      blurRadius: 2,
    ),
    BoxShadow(
      color: ink.withValues(alpha: 0.06),
      offset: const Offset(0, 8),
      blurRadius: 24,
    ),
  ];

  static List<BoxShadow> get e2 => [
    BoxShadow(
      color: ink.withValues(alpha: 0.10),
      offset: const Offset(0, 8),
      blurRadius: 30,
    ),
  ];

  static const TextStyle _base = TextStyle(fontFamily: fontFamily);

  static TextStyle get overline => _base.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.6,
    height: 1.3,
    color: inkMuted,
  );

  static TextStyle get stat => _base.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.0,
    color: ink,
  );

  static TextTheme get textTheme => TextTheme(
    displayLarge: _base.copyWith(
      fontSize: 40,
      fontWeight: FontWeight.w700,
      height: 1.05,
      letterSpacing: -1.0,
      color: ink,
    ),
    displayMedium: _base.copyWith(
      fontSize: 34,
      fontWeight: FontWeight.w700,
      height: 1.1,
      letterSpacing: -0.8,
      color: ink,
    ),
    headlineLarge: _base.copyWith(
      fontSize: 30,
      fontWeight: FontWeight.w700,
      height: 1.15,
      letterSpacing: -0.6,
      color: ink,
    ),
    headlineMedium: _base.copyWith(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      height: 1.2,
      letterSpacing: -0.3,
      color: ink,
    ),
    headlineSmall: _base.copyWith(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 1.3,
      color: ink,
    ),
    titleMedium: _base.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.4,
      color: ink,
    ),
    titleSmall: _base.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.4,
      color: ink,
    ),
    bodyLarge: _base.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.5,
      color: ink,
    ),
    bodyMedium: _base.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.45,
      color: inkMuted,
    ),
    bodySmall: _base.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.4,
      color: inkMuted,
    ),
    labelLarge: _base.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      height: 1.2,
      letterSpacing: 0.1,
      color: ink,
    ),
    labelMedium: _base.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 1.3,
      letterSpacing: 0.3,
      color: ink,
    ),
    labelSmall: _base.copyWith(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      height: 1.3,
      letterSpacing: 1.6,
      color: inkMuted,
    ),
  );

  static ThemeData build() {
    const colors = ColorScheme.light(
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primarySoft,
      onPrimaryContainer: primary,
      secondary: Color(0xFF4A554E),
      onSecondary: canvas,
      secondaryContainer: surfaceMuted,
      onSecondaryContainer: ink,
      tertiary: primaryBright,
      onTertiary: onPrimary,
      tertiaryContainer: primarySoft,
      onTertiaryContainer: primary,
      error: error,
      onError: onPrimary,
      errorContainer: Color(0xFFF9DEDC),
      onErrorContainer: Color(0xFF410E0B),
      surface: surface,
      onSurface: ink,
      onSurfaceVariant: inkMuted,
      surfaceContainerLowest: surface,
      surfaceContainerLow: surfaceContainerLow,
      surfaceContainer: surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh,
      surfaceContainerHighest: surfaceContainerHighest,
      outline: Color(0xFF8A857A),
      outlineVariant: hairline,
      inverseSurface: ink,
      onInverseSurface: canvas,
      inversePrimary: primaryBright,
      surfaceTint: Colors.transparent,
    );
    final text = textTheme;
    return ThemeData(
      colorScheme: colors,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: canvas,
      canvasColor: canvas,
      textTheme: text,
      visualDensity: VisualDensity.standard,
      appBarTheme: AppBarThemeData(
        backgroundColor: canvas,
        foregroundColor: ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: text.headlineSmall,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          disabledBackgroundColor: surfaceMuted,
          disabledForegroundColor: inkMuted,
          elevation: 1,
          shadowColor: ink.withValues(alpha: 0.3),
          minimumSize: const Size(0, 54),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: .circular(radiusMd)),
          textStyle: text.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ink,
          side: const BorderSide(color: hairline),
          minimumSize: const Size(0, 54),
          shape: RoundedRectangleBorder(borderRadius: .circular(radiusMd)),
          textStyle: text.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: text.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: surfaceMuted,
        hintStyle: text.bodyMedium?.copyWith(
          color: inkMuted.withValues(alpha: 0.6),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: .circular(radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: .circular(radiusMd),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: .circular(radiusMd),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: .circular(radiusMd),
          borderSide: const BorderSide(color: error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: .circular(radiusMd),
          borderSide: const BorderSide(color: error, width: 1.5),
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: .circular(radiusLg)),
      ),
      dividerTheme: const DividerThemeData(
        color: hairline,
        thickness: 1,
        space: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceMuted,
        selectedColor: primarySoft,
        side: const BorderSide(color: hairline),
        shape: RoundedRectangleBorder(borderRadius: .circular(999)),
        labelStyle: text.labelMedium?.copyWith(color: ink),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        showCheckmark: false,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: .circular(24)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: hairline,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(radiusXl)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: primarySoft,
        height: 68,
        elevation: 0,
        labelTextStyle: WidgetStatePropertyAll(text.labelMedium),
        iconTheme: const WidgetStatePropertyAll(IconThemeData(color: inkMuted)),
      ),
      iconTheme: const IconThemeData(color: ink, size: 22),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: primary,
        selectionColor: primary.withValues(alpha: 0.18),
        selectionHandleColor: primary,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: _VaultPageTransitions(),
          TargetPlatform.iOS: _VaultPageTransitions(),
          TargetPlatform.macOS: _VaultPageTransitions(),
          TargetPlatform.windows: _VaultPageTransitions(),
          TargetPlatform.linux: _VaultPageTransitions(),
          TargetPlatform.fuchsia: _VaultPageTransitions(),
        },
      ),
    );
  }
}

class _VaultPageTransitions extends PageTransitionsBuilder {
  const _VaultPageTransitions();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.02),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}
