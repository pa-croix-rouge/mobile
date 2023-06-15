class Environment {
  static String get apiURL => const String.fromEnvironment('API_URL', defaultValue: 'http://10.10.146.254:8080');
}