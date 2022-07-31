/// validates [email]
///
/// Returns null if [email] is in correct format. Throws error if [email] is empty or not in
/// __alum@alum.alum__ format
///
/// ```dart
/// validateEmail("ktk@gmail.com") == null
/// validateEmail("ktk@gmail") == "Invalid Email format."
/// ```
String? validateEmail(String? email) {
  if (email == null || email.isEmpty) {
    return "Email is required.";
  }

  RegExp regex = RegExp(r'\w+@\w+\.\w+');

  if (!regex.hasMatch(email)) {
    return "Invalid Email format.";
  }
  return null;
}

/// validates [pass]
///
/// Returns null if [pass] is in correct format. Throws error if [pass] is empty or doesn't contain
/// 8 letters (min), atlest 1 upper and lower case letters, symbol and number.
///
/// '''dart
/// validatePassword("Ktk@12345") == null
/// '''
String? validatePassword(String? pass) {
  if (pass == null || pass.isEmpty) {
    return "Password is required.";
  }

  RegExp regExp =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  if (pass.length < 8) {
    return "Password must be at least 8 characters.";
  }

  if (!regExp.hasMatch(pass)) {
    return "Passwrod must contain an uppercase letter, number and symbol.";
  }
  return null;
}
