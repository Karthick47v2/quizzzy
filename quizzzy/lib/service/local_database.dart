import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferences {
  late SharedPreferences _prefs;
  static UserSharedPreferences? _instance;
 
  /// Private named constructor for creating singleton.
  UserSharedPreferences._internal(SharedPreferences prefs) {
    _prefs = prefs;
  }

  /// Returns an object of [UserSharedPreferences] type without making a new one.
  factory UserSharedPreferences({prefs}) {
    if (prefs != null) {
      _instance ??= UserSharedPreferences._internal(prefs);
    }
    return _instance!;
  }

  /// The [SharedPreferences] instance.
  set prefs(SharedPreferences prefs) => _prefs = prefs;

  /// Store FCM token to local storage.
  Future setToken(String token) async => await _prefs.setString('token', token);

  /// Retrieve stored data using [setToken()]
  Future<String?> getToken() async => _prefs.getString('token');

  /// Store deleted questionnaire labels temporarily in local storage.
  Future setPoppedItems(List<String> list) async =>
      await _prefs.setStringList('popped_list', list);

  /// Retrieve stored data using [setPoppedItems()]
  Future<List<String>?> getPoppedItems() async =>
      _prefs.getStringList('popped_list');
}
