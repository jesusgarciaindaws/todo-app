// ignore_for_file: overridden_fields, annotate_overrides

abstract class GlobalSettings {
  final String apiUrl;
  final String backendUrl;
  final String firebaseKey;
  final String sentryDSN;

  bool get isTest;

  factory GlobalSettings(mode) {
    return GlobalSettingsTest();
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
  final String apiUrl = 'https://8335-82-213-205-71.ngrok-free.app';
  final String backendUrl = 'https://8335-82-213-205-71.ngrok-free.app';

  bool get isTest => true;
}
