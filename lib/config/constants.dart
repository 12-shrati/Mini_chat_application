/// Application-wide constants
class AppConstants {
  // API Configuration
  static const String apiBaseUrl = 'https://jsonplaceholder.typicode.com';
  static const String dictionaryApiUrl =
      'https://api.dictionaryapi.dev/api/v2/entries/en';
  static const Duration apiTimeout = Duration(seconds: 10);

  // UI Configuration
  static const double defaultPadding = 16.0;
  static const double messageBubbleBorderRadius = 20.0;

  // Animation Durations
  static const Duration scrollAnimationDuration = Duration(milliseconds: 300);
}
