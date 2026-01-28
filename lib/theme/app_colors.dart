import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFFA855F7);
  static const Color primaryLight = Color(0xFFC084FC);
  static const Color secondary = Color(0xFFD946EF);

  // Backgrounds
  static const Color lightBg = Color(0xFFFDFCFE);
  static const Color darkBg = Color(0xFF020617);

  // Surfaces (Glassmorphism foundations)
  static const Color lightSurface = Colors.white;
  static const Color darkSurface = Color(0xFF0F172A);

  // Glassmorphism specific
  static Color glassWhite = Colors.white.withOpacity(0.15);
  static Color glassBorder = Colors.white.withOpacity(0.2);
  static Color darkGlass = const Color(0xFF1E293B).withOpacity(0.4);

  // Text
  static const Color lightText = Color(0xFF0F172A);
  static const Color darkText = Color(0xFFF8FAFC);
  static const Color grey = Color(0xFF64748B);

  // Status
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF22C55E);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFA855F7), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFD946EF), Color(0xFFC084FC)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient darkGlassGradient = LinearGradient(
    colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
