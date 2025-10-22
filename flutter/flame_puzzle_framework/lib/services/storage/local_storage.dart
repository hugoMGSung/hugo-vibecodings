import 'package:shared_preferences/shared_preferences.dart';

/// Thin wrapper over SharedPreferences used by settings/tutorial flags.
class LocalStorage {
  LocalStorage._();
  static final instance = LocalStorage._();

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  Future<bool?> getBool(String key) async {
    final p = await _prefs;
    return p.getBool(key);
    return null;
  }

  Future<void> setBool(String key, bool value) async {
    final p = await _prefs;
    await p.setBool(key, value);
  }
}
