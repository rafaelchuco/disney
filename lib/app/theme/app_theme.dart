import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get darkTheme {
    const colorScheme = ColorScheme.dark(
      primary: Color(0xFF02D6E8),
      secondary: Color(0xFF02D6E8),
      surface: Color(0xFF040714),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF040714),
      colorScheme: colorScheme,
      textTheme: const TextTheme(
        bodyMedium: TextStyle(
          color: Color(0xFFCFD5E6),
          fontSize: 14,
          height: 1.35,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2C2E35),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF02D6E8)),
        ),
      ),
    );
  }
}
