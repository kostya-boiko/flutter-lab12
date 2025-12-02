bool validateEmail(String email) {
  if (email.isEmpty) return false;
  final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return regex.hasMatch(email);
}