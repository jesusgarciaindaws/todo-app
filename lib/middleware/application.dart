import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_app/middleware/error.dart';
import 'package:todo_app/models/local/configuration.dart';
import 'package:todo_app/middleware/service.dart';
import 'package:todo_app/middleware/global.dart';
import 'package:todo_app/middleware/session.dart';

class Application extends anxeb.Application {
  final Duration _timeOut = const Duration(seconds: 120000);
  Session _session;
  anxeb.Api _api;
  anxeb.Overlay _overlay;
  ConfigurationModel _configuration;
  String _token;
  bool _loaded;
  Service _service;

  Application() {
    _loaded = false;
  }

  @override
  void onMessage(anxeb.RemoteMessage message, anxeb.MessageEventType event) {}

  @override
  void onEvent(anxeb.ApplicationEventType type,
      {String reference, String description, dynamic data}) {}

  @override
  void init() {
    _api = anxeb.Api(
      Global.settings.apiUrl,
      connectTimeout: _timeOut,
      receiveTimeout: _timeOut,
    );

    final $appVersion = anxeb.Device?.info?.package?.version;
    final $buildNumber = anxeb.Device?.info?.package?.buildNumber;
    final $tz = DateTime.now().timeZoneOffset?.inMinutes;
    String $osType;
    String $osVersion;
    try {
      $osType = Platform?.operatingSystem;
    } catch (err) {
      //ignore
    }
    try {
      $osVersion = Platform?.version;
    } catch (err) {
      //ignore
    }

    _api.interceptors.add(
      anxeb.InterceptorsWrapper(
        onRequest: (anxeb.RequestOptions options,
            anxeb.RequestInterceptorHandler handler) {
          options.headers['accept-language'] = _configuration?.language ?? 'es';

          if ($tz != null) {
            options.headers['tz-offset'] = $tz;
          }
          if ($osType != null) {
            options.headers['device-os-type'] = $osType;
          }
          if ($osVersion != null) {
            options.headers['device-os-ver'] = $osVersion;
          }
          if ($appVersion != null) {
            options.headers['app-ver'] = $appVersion;
          }
          if ($buildNumber != null) {
            options.headers['app-rev'] = $buildNumber;
          }

          return handler.next(options);
        },
        onResponse:
            (anxeb.Response e, anxeb.ResponseInterceptorHandler handler) {
          return handler.next(e);
        },
        onError: (anxeb.DioException e, anxeb.ErrorInterceptorHandler handler) {
          return handler.next(e);
        },
      ),
    );
    _overlay = anxeb.Overlay(navigationFill: settings.colors.navigation);

    _api.interceptors.add(
      anxeb.InterceptorsWrapper(
        onRequest: (anxeb.RequestOptions options,
            anxeb.RequestInterceptorHandler handler) {
          return handler.next(options);
        },
        onResponse:
            (anxeb.Response e, anxeb.ResponseInterceptorHandler handler) {
          return handler.next(e);
        },
        onError: (anxeb.DioException e, anxeb.ErrorInterceptorHandler handler) {
          return handler.next(e);
        },
      ),
    );

    _service = Service(_api);
    _session = Session(this);
    _configuration = ConfigurationModel();

    _setSettings();

    super.init();
  }

  @override
  Future setup({List<String> locales}) async {
    await super.setup(locales: locales);
    await _setSentry();
    _setFlutterErrorHandler();
  }

  Future changeLanguage(anxeb.Scope scope) async {
    final options = localization.supportedLocales
        .map((item) => anxeb.DialogButton<Locale>(
            Global.captions.languageLabels(item.languageCode), item))
        .toList();

    options.add(anxeb.DialogButton<Locale>(
        anxeb.translate('anxeb.common.cancel'), null,
        fillColor: settings.colors.accent));

    final Locale selectedLanguage = await scope.dialogs
        .options<Locale>(
            anxeb.translate('middleware.application.change_language_title'),
            //'Cambiar Idioma',
            options: options)
        .show();

    if (selectedLanguage != null) {
      localization.changeLocale(selectedLanguage);
      configuration.language = selectedLanguage.languageCode;
      configuration.persist();

      final currentLang = session.authenticated == true
          ? (session.auth?.user != null
              ? session.auth?.user?.info?.language
              : session.auth?.user?.info?.language)
          : null;

      if (currentLang != null && currentLang != configuration.language) {
        api.post('/auth/language', {'code': configuration.language}).then(
            (value) {
          session.auth.user.info.language = configuration.language;
        }).catchError((err) {
          //ignore
        });
      }
    }
  }

  String getBackendUri(String uri) {
    return Global.settings.backendUrl + uri;
  }

  Future load() async {
    await configuration.loadFromDisk('configuration');
    final locale = localization.supportedLocales.firstWhere(
        (element) => element.languageCode == configuration.language,
        orElse: () => null);
    if (locale != null) {
      localization.changeLocale(locale);
    }

    _loaded = true;
  }

  void unload() {
    _loaded = false;
  }

  void exit(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _setSettings() {
    settings.analytics.available = false;
    settings.colors.navigation = const Color(0xff797979);
    settings.colors.primary = const Color(0xff3b3b3b);
    settings.colors.secudary = const Color(0xffb08f00);
  }

  Future<void> _setSentry() async {
    final context = await SentryManager.getSentryEnvEvent();
    await SentryFlutter.init((options) {
      options.dsn = Global.settings.sentryDSN;
      options.release = context['release'];
      options.environment = context['env'];
    });
    Sentry.configureScope((scope) {
      for (final entry in context.entries) {
        scope.setContexts(entry.key, entry.value);
      }
    });
  }

  void _setFlutterErrorHandler() {
    FlutterError.onError =
        (FlutterErrorDetails details, {bool forceReport = false}) {
      if (Global.settings.isTest) {
        FlutterError.dumpErrorToConsole(details);
      } else {
        Zone.current.handleUncaughtError(
          details.exception,
          details.stack ??
              StackTrace.fromString(details.toString()) ??
              StackTrace.current,
        );
      }
    };
  }

  @override
  anxeb.Overlay get overlay => _overlay;

  @override
  anxeb.Api get api => _api;

  Service get service => _service;

  ConfigurationModel get configuration => _configuration;

  Session get session => _session;

  bool get loaded => _loaded;

  String get token => _token;
}
