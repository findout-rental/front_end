import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Core
  static const primary = Color(0xFF4E6EF2);
  static const white = Colors.white;

  // Legacy (from second project – DO NOT REMOVE)
  static const background = Color(0xFFF3F3F3);
  static const textDark = Color(0xFF1F2937);
  static const textLight = Color(0xFF6B7280);

  // Modern theme system (from first project)
  static const light = _LightColors();
  static const dark = _DarkColors();
}

// --------------------
// Light Theme
// --------------------
class _LightColors {
  const _LightColors();

  Color get background => AppColors.background; // alias
  Color get surface => AppColors.white;

  Color get text => AppColors.textDark; // alias
  Color get textSecondary => AppColors.textLight;
}

// --------------------
// Dark Theme
// --------------------
class _DarkColors {
  const _DarkColors();

  Color get background => const Color(0xFF121212);
  Color get surface => const Color(0xFF1E1E1E);

  Color get text => AppColors.white;
  Color get textSecondary => Colors.white60;
}
