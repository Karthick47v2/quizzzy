import 'package:flutter_test/flutter_test.dart';
import 'package:quizzzy/src/service/local_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

main() {
  late UserSharedPreferences sharedPref;

  test("test set value of token", () async {
    SharedPreferences.setMockInitialValues({});
    sharedPref =
        UserSharedPreferences(prefs: await SharedPreferences.getInstance());
    await sharedPref.setToken('dummy');

    expect(await sharedPref.getToken(), 'dummy');
  });

  test("test get value of token", () async {
    SharedPreferences.setMockInitialValues({'token': 'dummy'});
    sharedPref =
        UserSharedPreferences(prefs: await SharedPreferences.getInstance());

    expect(await sharedPref.getToken(), 'dummy');
  });
}
