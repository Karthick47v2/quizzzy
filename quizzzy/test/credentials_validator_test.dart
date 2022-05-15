import 'package:flutter_test/flutter_test.dart';
import 'package:quizzzy/src/auth/signup.dart';

// unity tests for business logics in login.dart and signup.dart            ///////////DO FOR VERIFY.dart  /// DO FOR IMPORT

///////////////////// YOU CAN D OFOR LOCAL_DATABSE
main() {
  // test functionality of email validator
  group("Email validation", (() {
    test('Empty email field returns error', () {
      expect("Email is required.", validateEmail(""));
    });

    test('Incorrect email format returns error', () {
      expect("Invalid Email format.", validateEmail("user"));
      expect("Invalid Email format.", validateEmail("user@"));
      expect("Invalid Email format.", validateEmail("user@mail"));
      expect("Invalid Email format.", validateEmail("@mail.com"));
    });

    test('Correct email returns null', () {
      expect(null, validateEmail("user@mail.com"));
    });
  }));

  // test functionality of password validator
  group("Password validation", () {
    test('Empty passsword field returns error', () {
      expect("Password is required.", validatePassword(""));
    });

    test('Password length less than 8 characters returns error', () {
      expect(
          "Password must be at least 8 characters & contain an uppercase letter, number and symbol.",
          validatePassword("abcdef"));
    });

    test('Password without an uppercase letter returns error', () {
      expect(
          "Password must be at least 8 characters & contain an uppercase letter, number and symbol.",
          validatePassword("abcdefghij"));
    });

    test('Password without a lower letter returns error', () {
      expect(
          "Password must be at least 8 characters & contain an uppercase letter, number and symbol.",
          validatePassword("ABCDEFGIJ"));
    });

    test('Password without a number returns error', () {
      expect(
          "Password must be at least 8 characters & contain an uppercase letter, number and symbol.",
          validatePassword("abcdeASDfghij"));
    });

    test('Password without a symbol returns error', () {
      expect(
          "Password must be at least 8 characters & contain an uppercase letter, number and symbol.",
          validatePassword("abcdeAS231Dfghij"));
    });

    test('Correct password returns null', () {
      expect(null, validatePassword("Abc@12345"));
    });
  });
}
