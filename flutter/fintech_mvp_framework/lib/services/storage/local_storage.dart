import 'package:shared_preferences/shared_preferences.dart';

/// Thin wrapper over SharedPreferences used by settings/tutorial flags.
class LocalStorage {

  Future<String?> getString(String key) async => (await _prefs).getString(key);
  Future<void> setString(String key, String value) async => (await _prefs).setString(key, value);
  Future<void> remove(String key) async => (await _prefs).remove(key);


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
