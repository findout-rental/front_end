// lib/core/theme/app_colors.dart

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const primary = Color(0xFF4E6EF2);

  static const white = Colors.white;

  static const light = _LightColors();

  static const dark = _DarkColors();
}

class _LightColors {
  const _LightColors();

  Color get background => const Color(0xFFF3F3F3);
  
  Color get surface => AppColors.white;

  Color get text => const Color(0xFF1F2937);

  Color get textSecondary => const Color(0xFF6B7280);
}

class _DarkColors {
  const _DarkColors();

  Color get background => const Color(0xFF121212);

  Color get surface => const Color(0xFF1E1E1E);

  Color get text => AppColors.white;

  Color get textSecondary => Colors.white60;
}
