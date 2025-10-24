import 'package:flutter/material.dart';

ThemeData appThemeLight(BuildContext context) {
  final base = ThemeData.light(useMaterial3: true);
  final scheme = base.colorScheme.copyWith(
    primary: const Color(0xFF2F7BFF),
    secondary: const Color(0xFF00C389),
  );
  return base.copyWith(
    colorScheme: scheme,
    scaffoldBackgroundColor: const Color(0xFFF8F6FB),
    textTheme: base.textTheme.apply(
      bodyColor: const Color(0xFF1F2937),
      displayColor: const Color(0xFF1F2937),
    ),
    appBarTheme: const AppBarTheme(centerTitle: true),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    cardTheme: const CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      indicatorShape: StadiumBorder(),
    ),
  );
}

ThemeData appThemeDark(BuildContext context) {
  final base = ThemeData.dark(useMaterial3: true);
  final scheme = base.colorScheme.copyWith(
    primary: const Color(0xFF7CA8FF),
    secondary: const Color(0xFF35E1AE),
  );
  return base.copyWith(
    colorScheme: scheme,
    scaffoldBackgroundColor: const Color(0xFF0F1115),
    appBarTheme: const AppBarTheme(centerTitle: true),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    cardTheme: const CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      indicatorShape: StadiumBorder(),
    ),
  );
}
