import 'package:flutter/material.dart';

ThemeData customTheme = ThemeData(
  // primarySwatch: Colors.blue,
  brightness: Brightness.light,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.blue),
    ),
    labelStyle: const TextStyle(color: Colors.blue),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
    titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  ),
  scaffoldBackgroundColor: Colors.white,
  bottomSheetTheme: BottomSheetThemeData(
    surfaceTintColor: Colors.grey,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
  ),
  colorSchemeSeed: Colors.grey,
);