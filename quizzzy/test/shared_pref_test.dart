import 'package:flutter_test/flutter_test.dart';
import 'package:quizzzy/service/local_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

main() {
  late UserSharedPreferences sharedPref;

  group('test token', () {
    test('test set value of token', () async {
      SharedPreferences.setMockInitialValues({});
      sharedPref =
          UserSharedPreferences(prefs: await SharedPreferences.getInstance());
      await sharedPref.setToken('dummy');

      expect(await sharedPref.getToken(), 'dummy');
    });

    test('test get value and type of token', () async {
      SharedPreferences.setMockInitialValues({'token': 'dummy'});
      sharedPref =
          UserSharedPreferences(prefs: await SharedPreferences.getInstance());
      var result = await sharedPref.getToken();

      expect(result.runtimeType, String);
      expect(result, 'dummy');
    });
  });

  group('test questionnaire list', () {
    List<String> dummy = ['d', 'u', 'mm'];
    test('test set value of questionnaire list', () async {
      SharedPreferences.setMockInitialValues({});
      sharedPref =
          UserSharedPreferences(prefs: await SharedPreferences.getInstance());
      await sharedPref.setPoppedItems(dummy);

      expect(await sharedPref.getPoppedItems(), dummy);
    });

    test('test get value and type of questionnaire list', () async {
      SharedPreferences.setMockInitialValues({'popped_list': dummy});
      sharedPref =
          UserSharedPreferences(prefs: await SharedPreferences.getInstance());
      var result = await sharedPref.getPoppedItems();

      expect(result.runtimeType, List<String>);
      expect(result, dummy);
    });
  });
}
