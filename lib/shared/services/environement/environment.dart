class Environment {
  static String get apiURL => const String.fromEnvironment('API_URL', defaultValue: 'http://127.0.0.1:8080');
}
