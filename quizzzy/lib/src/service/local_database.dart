import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferences {
  SharedPreferences _prefs;

  UserSharedPreferences({required prefs}) : _prefs = prefs;

  set prefs(SharedPreferences prefs) => _prefs = prefs;

  Future setToken(String token) async => await _prefs.setString('token', token);

  Future<String?> getToken() async => _prefs.getString('token');

  Future setPoppedItems(List<String> list) async =>
      await _prefs.setStringList('popped_list', list);

  Future<List<String>?> getPoppedItems() async =>
      _prefs.getStringList('popped_list');
}


late UserSharedPreferences sharedPref;
