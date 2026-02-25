import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage/local_storage.dart';

// Riverpod 3.x
final themeModeProvider =
NotifierProvider<ThemeModeController, ThemeMode>(() => ThemeModeController());

class ThemeModeController extends Notifier<ThemeMode> {
  static const _key = 'darkMode';

  @override
  ThemeMode build() {
    // 초기값
    _load();                 // 비동기 로딩 (완료되면 state 갱신)
    return ThemeMode.light;
  }

  Future<void> _load() async {
    final isDark = await LocalStorage.instance.getBool(_key) ?? false;
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> setDark(bool isDark) async {
    state = isDark ? ThemeMode.dark : ThemeMode.light;
    await LocalStorage.instance.setBool(_key, isDark);
  }

  bool get isDark => state == ThemeMode.dark;
}
