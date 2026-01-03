import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    primaryColor: const Color(0xFF2D9CDB),
    primaryColorDark: const Color(0xFF2F80ED),
    primaryColorLight: const Color(0xFF56CCF2),
    scaffoldBackgroundColor: const Color(0xFFF8F9FA),
    //backgroundColor: Colors.white,
    cardColor: Colors.white,
    brightness: Brightness.light,
    fontFamily: 'Inter',
    
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
      displayMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
      displaySmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
      bodySmall: TextStyle(fontSize: 12, color: Colors.black54),
    ),
    
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2D9CDB),
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF2D9CDB), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      hintStyle: const TextStyle(color: Colors.grey),
    ),
  );

  static final darkTheme = ThemeData(
    primaryColor: const Color(0xFF2D9CDB),
    scaffoldBackgroundColor: const Color(0xFF121212),
    //backgroundColor:  Color(0xFF1E1E1E),
    cardColor: const Color(0xFF2D2D2D),
    brightness: Brightness.dark,
  );
}