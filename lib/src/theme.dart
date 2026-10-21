import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const brand = Color(0xFF2848A8);
  static const canvas = Color(0xFFF5F7FB);
  static const ink = Color(0xFF182230);

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: brand,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: canvas,
      appBarTheme: const AppBarTheme(
        backgroundColor: canvas,
        foregroundColor: ink,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: Color(0xFFE5E9F0)),
        ),
      ),
    );
  }
}
