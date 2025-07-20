bool isValidDomain(String email, String region) {
  final username = email.split('@')[0].toLowerCase();
  final domain = email.split('@')[1].toLowerCase();
  final expectedRegion = 'region${region.split(' ').last.toLowerCase()}';
  return domain == 'gmail.com' && username.endsWith(expectedRegion);
}