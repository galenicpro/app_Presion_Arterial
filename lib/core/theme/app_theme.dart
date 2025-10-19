// lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';

class AppTheme {
  // Colores principales optimizados para visibilidad
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color secondaryColor = Color(0xFF4CAF50);
  static const Color dangerColor = Color(0xFFF44336);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color successColor = Color(0xFF4CAF50);

  // Colores para categorías de presión arterial
  static const Color crisisColor = Color(0xFFD32F2F);
  static const Color highPressureColor = Color(0xFFFF9800);
  static const Color elevatedPressureColor = Color(0xFFFFC107);
  static const Color normalPressureColor = Color(0xFF4CAF50);
  static const Color optimalPressureColor = Color(0xFF2E7D32);

  // Tema claro optimizado para adultos mayores
  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 2,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      displayMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      displaySmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      bodyLarge: TextStyle(fontSize: 18, color: Colors.black87),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
      bodySmall: TextStyle(fontSize: 14, color: Colors.black54),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: primaryColor,
      textTheme: ButtonTextTheme.primary,
      height: 54,
      minWidth: 200,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(200, 54),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(8),
    ),
  );

  // Tema oscuro (opcional)
  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: primaryColor,
    appBarTheme: const AppBarTheme(backgroundColor: primaryColor, elevation: 2),
  );
}
