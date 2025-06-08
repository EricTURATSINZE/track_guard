bool validateEmail(String email) {
  // Regular expression for validating email addresses
  final RegExp emailRegex = RegExp(
    r'^[\w\+-]+(\.[\w\+-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
  );

  return emailRegex.hasMatch(email);
}

String initials(String name) {
  List<String> nameParts = name.trim().split(' ');
  if (nameParts.length > 1) {
    return '${nameParts[0][0]}${nameParts[1][0]}';
  } else {
    return nameParts[0][0];
  }
}
