import 'package:flutter/material.dart';

ThemeData appTheme(BuildContext context) {
  final base = ThemeData.light(useMaterial3: true);
  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: const Color(0xFF2F7BFF),
      secondary: const Color(0xFF00C389),
    ),
    textTheme: base.textTheme.apply(
      bodyColor: const Color(0xFF1F2937),
      displayColor: const Color(0xFF1F2937),
    ),
    appBarTheme: const AppBarTheme(centerTitle: true),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    cardTheme: const CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      indicatorShape: StadiumBorder(),
    ),
  );
}
