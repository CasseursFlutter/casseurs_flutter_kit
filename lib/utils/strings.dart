bool isEmail(String value) {
  return RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(value);
}

String capitalized(String value) {
  if (value.isEmpty) return value;    
  return value.substring(0, 1).toUpperCase()
    + value.substring(1, value.length).toLowerCase();
}

String eachWordCapitalized(String value) {
  if (value.isEmpty) return value;
  final words = value.split(' ').map((e) => capitalized(e));
  return words.join(' ');
}

String nonBreaking(String value) {
  const int $nbsp = 0x00A0;
  return value.replaceAll(' ', String.fromCharCode($nbsp));
}
