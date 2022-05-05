import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPrefernces {
  static SharedPreferences? _prefs;
  static Future init() async => _prefs = await SharedPreferences.getInstance();

  static Future setToken(String token) async =>
      await _prefs?.setString('token', token);

  static Future<String?> getToken() async => _prefs?.getString('token');
}
