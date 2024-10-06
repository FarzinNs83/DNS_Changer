import 'package:flutter/material.dart';

TextTheme lightTextTheme = const TextTheme(
  bodyLarge: TextStyle(color: Colors.grey, fontSize: 12),
  bodyMedium: TextStyle(color: Colors.black, fontSize: 14),
  bodySmall: TextStyle(
      color: Colors.black54, fontSize: 18, fontWeight: FontWeight.bold),
  displayLarge: TextStyle(
      color: Colors.black87, fontSize: 32, fontWeight: FontWeight.bold),
  displayMedium: TextStyle(
      color: Colors.black87, fontSize: 28, fontWeight: FontWeight.bold),
  displaySmall: TextStyle(
      color: Colors.black87, fontSize: 24, fontWeight: FontWeight.bold),
  headlineMedium: TextStyle(
      color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
  headlineSmall: TextStyle(
      color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
  titleLarge: TextStyle(
      color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
  titleMedium: TextStyle(
      color: Color(0xFF6200EE), fontSize: 14, fontWeight: FontWeight.w300),
  titleSmall: TextStyle(color: Colors.black87, fontSize: 12),
);

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFF6200EE),
  scaffoldBackgroundColor: const Color(0xFFEFEFEF),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFFEFEFEF),
    selectedItemColor: Color(0xFF6200EE),
    unselectedItemColor: Colors.grey,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF6200EE),
    foregroundColor: Colors.white,
  ),
  textTheme: lightTextTheme,
  snackBarTheme: SnackBarThemeData(
    backgroundColor: const Color(0xFF6200EE),
    contentTextStyle: lightTextTheme.bodyMedium,
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: const Color(0xFF6200EE),
      textStyle: lightTextTheme.bodyMedium,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: const Color(0xFF6200EE),
      textStyle: lightTextTheme.bodyMedium,
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF6200EE),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFEFEFEF),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFF6200EE)),
    ),
  ),
);

TextTheme darkTextTheme = const TextTheme(
  bodyLarge: TextStyle(color: Colors.greenAccent, fontSize: 12),
  bodyMedium: TextStyle(color: Colors.white, fontSize: 14),
  bodySmall:
      TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
  displayLarge: TextStyle(
      color: Colors.greenAccent, fontSize: 32, fontWeight: FontWeight.bold),
  displayMedium: TextStyle(
      color: Colors.greenAccent, fontSize: 28, fontWeight: FontWeight.bold),
  displaySmall: TextStyle(
      color: Colors.greenAccent, fontSize: 24, fontWeight: FontWeight.bold),
  headlineMedium: TextStyle(
      color: Colors.greenAccent, fontSize: 20, fontWeight: FontWeight.bold),
  headlineSmall: TextStyle(
      color: Colors.greenAccent, fontSize: 18, fontWeight: FontWeight.bold),
  titleLarge: TextStyle(
      color: Colors.greenAccent, fontSize: 16, fontWeight: FontWeight.bold),
  titleMedium: TextStyle(
      color: Color.fromARGB(255, 95, 156, 141),
      fontSize: 14,
      fontWeight: FontWeight.w300),
  titleSmall: TextStyle(color: Colors.greenAccent, fontSize: 12),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF3ECF8E),
  scaffoldBackgroundColor: const Color(0xFF1B1B1F),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF1B1B1F),
    selectedItemColor: Color(0xFF3ECF8E),
    unselectedItemColor: Colors.white60,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1B1B1F),
    foregroundColor: Colors.white,
  ),
  textTheme: darkTextTheme,
  snackBarTheme: SnackBarThemeData(
    backgroundColor: const Color(0xFF3ECF8E),
    contentTextStyle: darkTextTheme.bodyMedium,
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: const Color(0xFF3ECF8E),
      textStyle: darkTextTheme.bodyMedium,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.black,
      backgroundColor: const Color(0xFF3ECF8E),
      textStyle: darkTextTheme.bodyMedium,
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF3ECF8E),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.black12,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFF3ECF8E)),
    ),
  ),
);
