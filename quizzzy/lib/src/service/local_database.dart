import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferences {
  SharedPreferences _prefs;

  UserSharedPreferences({required prefs}) : _prefs = prefs;

  set prefs(SharedPreferences prefs) => _prefs = prefs;

  Future setToken(String token) async => await _prefs.setString('token', token);

  Future<String?> getToken() async => _prefs.getString('token');
}

late UserSharedPreferences sharedPref;
