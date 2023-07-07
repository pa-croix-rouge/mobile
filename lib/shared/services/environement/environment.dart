class Environment {
  static String get apiURL => const String.fromEnvironment(
        'API_URL',
        defaultValue: 'https://api.pa-crx.fr:443',
        //defaultValue: 'http://localhost:8080',
      );
}
