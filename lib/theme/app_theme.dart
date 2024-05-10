import 'package:flutter/material.dart';

class AppTheme {
  static final Color primary = Colors.blue.shade300;

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    // Color del AppBar Theme
    appBarTheme: AppBarTheme(color: primary, elevation: 0),
    listTileTheme: ListTileThemeData(iconColor: primary),

    //TextButton Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: primary),
    ),
    //FloatingActionButton Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primary,
      elevation: 5,
    ),
    //ElevateButton Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        shape: const StadiumBorder(),
        elevation: 5,
      ),
    ),
    //InputDecoration Theme
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelStyle: TextStyle(color: primary),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primary),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: primary,
      selectedIconTheme: IconThemeData(color: primary),
      unselectedItemColor: primary,
      unselectedIconTheme: IconThemeData(color: primary),
    ),
    //IconTheme
    iconTheme: IconThemeData(color: Colors.pink),
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    // Color del AppBar Theme
    appBarTheme: AppBarTheme(color: primary, elevation: 0),
    listTileTheme: ListTileThemeData(iconColor: primary),

    //TextButton Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: primary),
    ),
    //FloatingActionButton Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primary,
      elevation: 5,
    ),
    //ElevateButton Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        shape: const StadiumBorder(),
        elevation: 5,
      ),
    ),
    //InputDecoration Theme
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelStyle: TextStyle(color: primary),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primary),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: primary,
      selectedIconTheme: IconThemeData(color: primary),
      unselectedItemColor: primary,
      unselectedIconTheme: IconThemeData(color: primary),
    ),
    //IconTheme
    iconTheme: IconThemeData(color: Colors.pink),
  );
}
