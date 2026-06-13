import 'package:hive_flutter/hive_flutter.dart';

class LocalStorageService {
  static late Box<dynamic> _authBox;
  static late Box<dynamic> _appBox;
  static late Box<dynamic> _userBox;

  static Future<void> initialize() async {
    _authBox = await Hive.openBox('auth');
    _appBox = await Hive.openBox('app');
    _userBox = await Hive.openBox('user');
  }

  // Auth Box Methods
  static void saveToken(String token) => _authBox.put('token', token);
  static String? getToken() => _authBox.get('token') as String?;
  static void clearToken() => _authBox.delete('token');

  static void saveRefreshToken(String token) => _authBox.put('refreshToken', token);
  static String? getRefreshToken() => _authBox.get('refreshToken') as String?;
  static void clearRefreshToken() => _authBox.delete('refreshToken');

  // User Box Methods
  static void saveUserId(String uid) => _userBox.put('uid', uid);
  static String? getUserId() => _userBox.get('uid') as String?;
  static void clearUserId() => _userBox.delete('uid');

  static void saveUserData(String key, dynamic value) => _userBox.put(key, value);
  static dynamic getUserData(String key) => _userBox.get(key);
  static void clearUserData() => _userBox.clear();

  // App Box Methods
  static void saveAppPreference(String key, dynamic value) => _appBox.put(key, value);
  static dynamic getAppPreference(String key) => _appBox.get(key);
  static void clearAppPreference(String key) => _appBox.delete(key);

  // Utility Methods
  static Future<void> clearAll() async {
    await _authBox.clear();
    await _appBox.clear();
    await _userBox.clear();
  }

  static Future<void> close() async {
    await _authBox.close();
    await _appBox.close();
    await _userBox.close();
  }
}
