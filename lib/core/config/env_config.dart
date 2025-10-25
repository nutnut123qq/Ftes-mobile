class EnvConfig {
  static String get googleClientId {
    return const String.fromEnvironment('GOOGLE_CLIENT_ID', 
        defaultValue: '957561951017-38543te6feepe3geb5sh6ae2jpgsksi4.apps.googleusercontent.com');
  }
  
  static String get redirectUri {
    return const String.fromEnvironment('REDIRECT_URI', 
        defaultValue: 'http://localhost:3001/auth/callback');
  }
}
