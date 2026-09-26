import 'package:flutter/material.dart';

class AppTheme {
  // ============================================================
  // PALETA PRINCIPAL DO APP
  // ============================================================

  // COR PRINCIPAL: usada em botões, ícones selecionados e destaques.
  static const Color primary = Color(0xFF2F80ED);

  // COR SECUNDÁRIA: usada em alguns destaques e elementos de apoio.
  static const Color secondary = Color(0xFF56CCF2);

  // BACKGROUND PRINCIPAL DO APP:
  // Altere este valor para mudar o fundo geral das telas.
  static const Color background = Color(0xFFF5F8FC);

  // BACKGROUND DOS CARDS:
  // Altere aqui caso queira mudar o fundo dos cards/listas.
  static const Color cardBackground = Colors.white;

  // COR DE TEXTO PRINCIPAL.
  static const Color textPrimary = Color(0xFF172B4D);

  // COR DE TEXTO SECUNDÁRIO.
  static const Color textSecondary = Color(0xFF718096);

  // COR PARA VAGAS DISPONÍVEIS.
  static const Color available = Color(0xFF27AE60);

  // COR PARA VAGAS OCUPADAS.
  static const Color occupied = Color(0xFFEB5757);

  // COR PARA ALERTAS.
  static const Color warning = Color(0xFFF2C94C);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,

      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: secondary,
        surface: cardBackground,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: cardBackground,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
      ),

      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 1,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,

        // BACKGROUND DOS CAMPOS DE FORMULÁRIO:
        // Altere fillColor para mudar o fundo dos TextFormField.
        fillColor: Colors.white,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
