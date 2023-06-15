class Environment {
  static String get apiURL => const String.fromEnvironment('API_URL', defaultValue: 'http://45.147.97.105:1811');
}