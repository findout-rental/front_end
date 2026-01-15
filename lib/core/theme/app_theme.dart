import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  // --------------------
  // Shared styles
  // --------------------
  static final _elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.white,
    disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
    disabledForegroundColor: AppColors.white.withOpacity(0.7),
    minimumSize: const Size(double.infinity, 48),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      fontFamily: 'Amiri',
    ),
  );

  static final _cardShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15),
  );

  static final _inputDecorationBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(15.0),
    borderSide: BorderSide.none,
  );

  // --------------------
  // Light Theme
  // --------------------
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Amiri',
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.light.background,

    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.primary, // from second project
      surface: AppColors.light.surface,
      onPrimary: AppColors.white,
      onSurface: AppColors.light.text,
      error: Colors.red.shade700,
    ),

    textTheme: TextTheme(
      titleLarge: TextStyle(
        color: AppColors.light.text,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        color: AppColors.light.text,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: AppColors.light.text,
        fontSize: 14,
      ),
      bodySmall: TextStyle(
        color: AppColors.light.textSecondary,
        fontSize: 12,
      ),
      labelLarge: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: 'Amiri',
      ),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.light.surface, // compatible with both
      foregroundColor: AppColors.light.text,
      elevation: 0.5,
    ),

    bottomAppBarTheme: BottomAppBarThemeData(
      color: AppColors.light.surface,
      surfaceTintColor: AppColors.light.surface,
      elevation: 2.0,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(style: _elevatedButtonStyle),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.light.surface,
      hintStyle: TextStyle(color: AppColors.light.textSecondary),
      prefixIconColor: AppColors.light.textSecondary,
      suffixIconColor: AppColors.light.textSecondary,
      border: _inputDecorationBorder,
      enabledBorder: _inputDecorationBorder,
      focusedBorder: _inputDecorationBorder.copyWith(
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    ),

    dividerTheme: DividerThemeData(
      color: Colors.grey.shade300,
      thickness: 0.8,
    ),

    cardTheme: CardThemeData(
      elevation: 2,
      color: AppColors.light.surface,
      surfaceTintColor: AppColors.light.surface,
      shape: _cardShape,
    ),

    listTileTheme: const ListTileThemeData(
      iconColor: AppColors.primary,
    ),
  );

  // --------------------
  // Dark Theme
  // --------------------
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Amiri',
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.dark.background,

    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.primary,
      surface: AppColors.dark.surface,
      onPrimary: AppColors.white,
      onSurface: AppColors.dark.text,
      error: Colors.redAccent.shade100,
    ),

    textTheme: TextTheme(
      titleLarge: TextStyle(
        color: AppColors.dark.text,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        color: AppColors.dark.text,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: AppColors.dark.text.withOpacity(0.87),
        fontSize: 14,
      ),
      bodySmall: TextStyle(
        color: AppColors.dark.textSecondary,
        fontSize: 12,
      ),
      labelLarge: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: 'Amiri',
      ),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.dark.surface,
      foregroundColor: AppColors.dark.text,
      elevation: 0.5,
    ),

    bottomAppBarTheme: BottomAppBarThemeData(
      color: AppColors.dark.surface,
      surfaceTintColor: AppColors.dark.surface,
      elevation: 2.0,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(style: _elevatedButtonStyle),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.dark.surface,
      hintStyle: TextStyle(color: AppColors.dark.textSecondary),
      prefixIconColor: AppColors.dark.textSecondary,
      suffixIconColor: AppColors.dark.textSecondary,
      border: _inputDecorationBorder,
      enabledBorder: _inputDecorationBorder,
      focusedBorder: _inputDecorationBorder.copyWith(
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    ),

    dividerTheme: const DividerThemeData(
      color: Colors.white24,
      thickness: 0.8,
    ),

    cardTheme: CardThemeData(
      elevation: 1,
      color: AppColors.dark.surface,
      surfaceTintColor: AppColors.dark.surface,
      shape: _cardShape,
    ),

    listTileTheme: const ListTileThemeData(
      iconColor: AppColors.primary,
    ),
  );
}
