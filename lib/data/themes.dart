import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Colors.amber,
    secondary: Colors.blue,
    background: Colors.white,
    onPrimary: Colors.white,
    onBackground: Colors.white,
    onSecondary: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black,
  ),
  fontFamily: "Poppins",
  
);