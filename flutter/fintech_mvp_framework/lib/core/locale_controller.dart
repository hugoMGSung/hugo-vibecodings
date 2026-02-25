import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage/local_storage.dart';

// Riverpod 3.x
final localeProvider =
NotifierProvider<LocaleController, Locale?>(() => LocaleController());

class LocaleController extends Notifier<Locale?> {
  static const _key = 'app_locale'; // 'en' | 'ko' | null(=system)

  @override
  Locale? build() {
    _load();     // 비동기 로딩
    return null; // 시스템 언어 따름
  }

  Future<void> _load() async {
    final code = await LocalStorage.instance.getString(_key);
    if (code == null || code.isEmpty) {
      state = null;
    } else {
      state = Locale(code);
    }
  }

  Future<void> setLocale(String? code) async {
    if (code == null) {
      state = null;
      await LocalStorage.instance.remove(_key);
    } else {
      state = Locale(code);
      await LocalStorage.instance.setString(_key, code);
    }
  }
}