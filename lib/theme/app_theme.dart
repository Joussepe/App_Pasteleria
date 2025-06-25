import 'package:flutter/material.dart';

class AppTheme {
  // Colores cálidos y elegantes
  static const Color primaryColor = Color(0xFFA05A2C); // Marrón cálido
  static const Color secondaryColor = Color(0xFFF6B8A8); // Rosado pastel
  static const Color accentColor = Color(0xFFF8D7A4); // Dorado suave
  static const Color backgroundColor = Color(0xFFFDF4E9); // Beige claro
  static const Color surfaceColor = Colors.white;
  static const Color textColor = Color(0xFFA05A2C); // Marrón cálido

  // Estilos de texto
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textColor,
    fontFamily: 'Poppins',
    letterSpacing: 1.0,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textColor,
    fontFamily: 'Poppins',
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14,
    color: textColor,
    fontFamily: 'Poppins',
  );

  // Estilos de botones
  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: accentColor,
    foregroundColor: textColor,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    textStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 14),
    elevation: 2,
  );

  static final ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: secondaryColor,
    foregroundColor: textColor,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    textStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 14),
    elevation: 0,
  );

  // Estilos de tarjetas
  static final BoxDecoration cardDecoration = BoxDecoration(
    color: surfaceColor,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // Tema de la aplicación
  static ThemeData get theme => ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: const ColorScheme.light(
          primary: primaryColor,
          secondary: secondaryColor,
          background: backgroundColor,
          surface: surfaceColor,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
            letterSpacing: 1.0,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: primaryButtonStyle,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surfaceColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: accentColor, width: 2),
          ),
        ),
        fontFamily: 'Poppins',
      );
} 