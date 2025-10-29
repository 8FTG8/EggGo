import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color _lightScaffoldColor = Color(0xFFEEEEEE);
  static const Color _darkScaffoldColor = Color(0xFF121212);

  // --- Cores do Tema Claro ---
  static const _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFDD5C01),
    onPrimary: Colors.white,        
    secondary: Color(0xFF1E5E2D),
    onSecondary: Colors.white,
    error: Color(0xFFB00020),
    onError: Colors.white,
    surface: Colors.white,            // Cor de cards, dialogs, etc.
    onSurface: Color(0xFF212121),     // Texto principal e sobre superfícies
    outline: Colors.grey,
  );

  // --- Cores do Tema Escuro ---
  static const _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFF57C00),       // Laranja mais vivo para o escuro
    onPrimary: Colors.white,          // Alterado para branco para melhor contraste
    secondary: Color(0xFF66BB6A),     // Verde mais claro
    onSecondary: Colors.white,        // Alterado para branco para melhor contraste
    error: Color(0xFFD32F2F),         // Tom de vermelho mais escuro para contraste com texto branco
    onError: Colors.white,            // Alterado para branco para consistência visual
    surface: Color(0xFF1E1E1E),       // Cor de cards, dialogs, etc.
    onSurface: Color(0xFFE0E0E0),     // Texto principal e sobre superfícies
    outline: Colors.grey,
  );

  static ThemeData _buildTheme(ColorScheme colorScheme) {
    final baseTheme = ThemeData(brightness: colorScheme.brightness);
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.brightness == Brightness.light ? _lightScaffoldColor : _darkScaffoldColor,
      textTheme: GoogleFonts.interTextTheme(baseTheme.textTheme).apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.outline.withAlpha(128)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
      ),
    );
  }

  // --- Tema Claro ---
  static final ThemeData lightTheme = _buildTheme(_lightColorScheme);

  // --- Tema Escuro ---
  static final ThemeData darkTheme = _buildTheme(_darkColorScheme);
}