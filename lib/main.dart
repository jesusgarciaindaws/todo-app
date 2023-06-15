import 'dart:async';
import 'package:flutter/material.dart';
import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_app/middleware/error.dart';
import 'package:todo_app/middleware/application.dart';
import 'package:todo_app/screens/landing/lobby.dart';

Future<void> main() async {
  runZonedGuarded<Future<void>>(
    () async {
      final application = Application();
      await application.setup(locales: ['es', 'en']);

      runApp(
        anxeb.EntryScreen(
          home: LobbyScreen(application: application),
          theme: ThemeData(
            primaryColor: application.settings.colors.primary,
            colorScheme: ColorScheme.light(
              primary: application.settings.colors.primary,
              secondary: application.settings.colors.secudary,
              secondaryContainer: application.settings.colors.navigation,
              onSecondary: Colors.white,
            ),
            dialogTheme: const DialogTheme(),
            primaryIconTheme: const IconThemeData(color: Colors.white),
            primaryTextTheme: const TextTheme(
              titleLarge: TextStyle(color: Colors.white),
            ),
            fontFamily: 'Montserrat',
          ),
        ),
      );
    },
    SentryManager.reportError,
  );
}
