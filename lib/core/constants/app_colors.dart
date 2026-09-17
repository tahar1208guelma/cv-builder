import 'package:flutter/material.dart';

class AppColors {
  // Brand / Default UI Palette
  static const Color primary = Color(0xFF1E3A8A); // Deep Navy
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color secondary = Color(0xFF0F766E); // Deep Teal
  static const Color accent = Color(0xFFF59E0B); // Amber

  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Colors.white;
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color borderLight = Color(0xFFE2E8F0);

  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color borderDark = Color(0xFF334155);

  // Preset CV Color Themes
  static const List<Map<String, dynamic>> presetCvColors = [
    {'name': 'Navy', 'hex': '#1E3A8A', 'color': Color(0xFF1E3A8A)},
    {'name': 'Teal', 'hex': '#0F766E', 'color': Color(0xFF0F766E)},
    {'name': 'Slate', 'hex': '#334155', 'color': Color(0xFF334155)},
    {'name': 'Burgundy', 'hex': '#881337', 'color': Color(0xFF881337)},
    {'name': 'Emerald', 'hex': '#065F46', 'color': Color(0xFF065F46)},
    {'name': 'Royal', 'hex': '#2563EB', 'color': Color(0xFF2563EB)},
    {'name': 'Charcoal', 'hex': '#18181B', 'color': Color(0xFF18181B)},
    {'name': 'Indigo', 'hex': '#4338CA', 'color': Color(0xFF4338CA)},
  ];

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    try {
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (_) {
      return primary;
    }
  }

  static String toHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
  }
}
