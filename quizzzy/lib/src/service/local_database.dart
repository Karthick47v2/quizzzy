import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPrefernces {
  final SharedPreferences prefs;

  UserSharedPrefernces({required this.prefs});

  Future setToken(String token) async => await prefs.setString('token', token);

  Future<String?> getToken() async => prefs.getString('token');
}

late UserSharedPrefernces sharedPref;
