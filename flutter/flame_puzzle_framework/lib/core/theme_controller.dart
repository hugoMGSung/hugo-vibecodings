import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage/local_storage.dart';

final themeModeProvider =
StateNotifierProvider<ThemeModeController, ThemeMode>(
      (ref) => ThemeModeController()..load(),
);

class ThemeModeController extends StateNotifier<ThemeMode> {
  ThemeModeController() : super(ThemeMode.light);

  static const _key = 'darkMode';

  Future<void> load() async {
    final v = await LocalStorage.instance.getBool(_key) ?? false;
    state = v ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> setDark(bool isDark) async {
    state = isDark ? ThemeMode.dark : ThemeMode.light;
    await LocalStorage.instance.setBool(_key, isDark);
  }

  bool get isDark => state == ThemeMode.dark;
}
