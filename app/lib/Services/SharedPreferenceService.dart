import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  static SharedPreferences _sharedPrefs;

  factory SharedPreferenceService() => SharedPreferenceService._internal();

  SharedPreferenceService._internal();

  Future<void> init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  static Future<bool> setToken(String token) {
    return _sharedPrefs.setString("token", token);
  }

  static String getToken() {
    return _sharedPrefs.getString("token");
  }
}
