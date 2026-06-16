String? validatePassword(String? value, String username, String msg) {
  if (value == null ||
      value.isEmpty ||
      value.length < 8 ||
      value.length > 15 ||
      value.contains(" ") ||
      !RegExp(r'[A-Z]').hasMatch(value) ||
      !RegExp(r'[a-z]').hasMatch(value) ||
      !RegExp(r'[0-9]').hasMatch(value) ||
      RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
    return msg;
  }

  if (value.toLowerCase().contains(username.toLowerCase())) {
    return "Password cannot similar/same as user id";
  }
  return null;
}

bool isPasswordValid(String? value, String username) {
  if (value == null ||
      value.isEmpty ||
      value.length < 8 ||
      value.length > 15 ||
      value.contains(" ") ||
      !RegExp(r'[A-Z]').hasMatch(value) ||
      !RegExp(r'[a-z]').hasMatch(value) ||
      !RegExp(r'[0-9]').hasMatch(value) ||
      RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value) && value.toLowerCase().contains(username.toLowerCase())) {
    return false;
  }
  if (value.toLowerCase().contains(username.toLowerCase())) {
    return false;
  }
  return true;
}

bool isValidUsername(String value) {
  final regex = RegExp(r'^[a-zA-Z0-9]+$');
  return regex.hasMatch(value);
}

String? validateUsername(String? value) {
  final regex = RegExp(r'^[a-zA-Z0-9]+$');
  if (value == null || value.isEmpty || !regex.hasMatch(value)) {
    return "Username can only contain letters (a-z, A-Z) and numbers (0-9)";
  }
  return null;
}

bool isConfirmPasswordValid(String? confirmPassword, String? password, String username) {
  if (!isPasswordValid(confirmPassword, username)) {
    return false;
  }
  if (confirmPassword != password) {
    return false;
  }
  return true;
}

String? validateConfirmPassword(String? confirmPassword, String? password, String username, String msg) {
  if (!isPasswordValid(confirmPassword, username)) {
    return msg;
  }
  if (confirmPassword != password) {
    return "Confirm password does not match the password";
  }
  return null;
}
