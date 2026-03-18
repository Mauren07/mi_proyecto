import 'package:flutter/material.dart';

class ThemeApp {

  static ThemeData lightTheme = ThemeData(

    primaryColor: const Color.fromARGB(255, 42, 115, 154),

    appBarTheme: AppBarTheme(
      backgroundColor: const Color.fromARGB(255, 42, 115, 154),
      foregroundColor: Colors.white,
      centerTitle: true,
    ),

    scaffoldBackgroundColor: Colors.grey[100],

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor:const Color.fromARGB(255, 42, 115, 154),
        foregroundColor: Colors.white,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromARGB(255, 55, 176, 138),
          width: 2,
        ),
      ),
    ),

  );

}
