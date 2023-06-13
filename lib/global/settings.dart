// ignore_for_file: overridden_fields, annotate_overrides

abstract class GlobalSettings {
  final String apiUrl;
  final String backendUrl;
  final String firebaseKey;
  final String sentryDSN;

  bool get isTest;

  factory GlobalSettings(mode) {
    return mode == 'test' ? GlobalSettingsTest() : GlobalSettingsLive();
  }
}

class GlobalSettingsLive implements GlobalSettings {
  final String apiUrl = 'https://api.todo.com';
  final String backendUrl = 'https://admin.todo.com';
  final String firebaseKey = '';
  final String sentryDSN =
      'https://b9d19facc83443e79d6dcc0ab805efa0@o157936.ingest.sentry.io/4505349707988992';

  bool get isTest => false;
}

class GlobalSettingsTest extends GlobalSettingsLive {
  final String apiUrl = 'http://10.0.0.114:6401';
  final String backendUrl = 'http://10.0.0.114:5180';

  bool get isTest => true;
}
