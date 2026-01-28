import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primary = Color(0xFFA855F7); // Vibrant Purple
  static const Color secondary = Color(0xFFD946EF); // Fuchsia/Magenta

  // Background colors
  static const Color lightBg = Color(0xFFFDFCFE);
  static const Color darkBg = Color(0xFF020617); // Deep Midnight

  // Surface colors
  static const Color lightSurface = Colors.white;
  static const Color darkSurface = Color(0xFF0F172A); // Darker Blue-Grey

  // Text colors
  static const Color lightText = Color(0xFF0F172A);
  static const Color darkText = Color(0xFFF8FAFC);

  static const Color grey = Color(0xFF64748B);
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF22C55E);

  // Gradient - Matching the "Orbit" look
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFA855F7), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFD946EF), Color(0xFFA855F7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
