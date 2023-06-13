import 'dart:io';
import 'package:flutter/material.dart';
import 'package:anxeb_flutter/anxeb.dart' as Anxeb;
import 'package:todo_app/middleware/application.dart';
import 'package:todo_app/middleware/global.dart';
import 'package:todo_app/middleware/session.dart';
import 'package:todo_app/models/local/credentials.dart';
import 'package:todo_app/screens/general/home.dart';

class LoginScreen extends Anxeb.ScreenWidget {
  LoginScreen({Key key}) : super('login', key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends Anxeb.ScreenView<LoginScreen, Application> {
  @override
  void setup() {
    application.overlay.extendBodyFullScreen = false;
    application.overlay.brightness = Brightness.dark;
  }

  @override
  Future init() async {
    if (application?.configuration?.auth?.member?.login?.email != null) {
      scope.forms.current.set(
        'email',
        application?.configuration?.auth?.member?.login?.email,
      );
    }
  }

  @override
  Anxeb.ScreenAction action() {
    return Anxeb.ScreenAction.back(
      scope: scope,
      isVisible: () => Platform.isIOS,
    );
  }

  @override
  Widget content() {
    return Anxeb.GradientContainer(
      scope: scope,
      fadding: const EdgeInsets.only(
        left: 0.111,
        right: 0.111,
        top: 0.14,
        bottom: 0.12,
      ),
      gradient: Global.gradients.light,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            constraints: const BoxConstraints(
              maxWidth: 380.0,
            ),
            padding: const EdgeInsets.only(bottom: 6),
            child: GestureDetector(
              onTap: dismiss,
              child: Image.asset('assets/images/brand/full-brand.png'),
            ),
          ),
          Expanded(
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 350.0,
              ),
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Anxeb.TextInputField(
                    scope: scope,
                    name: 'email',
                    icon: Icons.email,
                    label: 'Correo',
                    type: Anxeb.TextInputFieldType.email,
                    fetcher: () =>
                        application?.configuration?.auth?.member?.login?.email,
                    validator: Anxeb.Utils.validators.email,
                    action: TextInputAction.next,
                  ),
                  Anxeb.TextInputField(
                    scope: scope,
                    name: 'password',
                    margin: const EdgeInsets.only(top: 20, bottom: 20),
                    icon: Icons.lock,
                    label: 'Contraseña',
                    type: Anxeb.TextInputFieldType.password,
                    validator: Anxeb.Utils.validators.password,
                    action: TextInputAction.go,
                    onActionSubmit: (val) => _login(),
                  ),
                ],
              ),
            ),
          ),
          Container(
            constraints: const BoxConstraints(
              maxWidth: 300.0,
            ),
            padding: const EdgeInsets.only(left: 25, right: 25, bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Anxeb.TextButton(
                  caption: 'Entrar',
                  radius: scope.application.settings.dialogs.buttonRadius,
                  color: scope.application.settings.colors.primary,
                  onPressed: _login,
                  type: Anxeb.ButtonType.primary,
                  icon: Anxeb.CommunityMaterialIcons.door_open,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _login() async {
    if (session.closed && scope.forms.valid()) {
      final credentials = CredentialsModel(scope.forms.data());
      await scope.busy();

      try {
        final auth = await session.open(
          credentials: credentials,
        );

        if (auth != null) {
          await scope.alerts
              .success(
                '¡Hola ${session.user.toString()}!',
                delay: 1700,
              )
              .show();

          await _goDashboard();
        }
      } catch (err) {
        scope.forms.current.fields['password'].select();
        await session.close();
        scope.alerts.error(err).show();
      } finally {
        await scope.idle();
      }
    }
  }

  Future<void> _goDashboard() async {
    final result = await push(
      HomeScreen(),
      action: Anxeb.ScreenPushAction.replace,
    );
    pop(result: result);
  }

  Session get session => application.session;
}
