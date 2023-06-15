import 'package:flutter/material.dart';
import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_app/screens/landing/about.dart';
import 'package:todo_app/screens/landing/login.dart';
import 'package:todo_app/middleware/application.dart';
import 'package:todo_app/middleware/global.dart';
import 'package:todo_app/screens/general/home.dart';

class LobbyScreen extends anxeb.ScreenWidget {
  LobbyScreen({
    Key key,
    anxeb.Application application,
  }) : super(
          'lobby',
          application: application,
          root: true,
          key: key,
        );

  @override
  anxeb.ScreenView<LobbyScreen, Application> createState() => _LobbyState();
}

class _LobbyState extends anxeb.ScreenView<LobbyScreen, Application> {
  bool _enableForeground;

  final ImageProvider _vignetteImage = const AssetImage(
    'assets/images/common/vignette.png',
  );
  final ImageProvider _iconImage = const AssetImage(
    'assets/images/brand/full-brand.png',
  );

  final List<anxeb.Slide> _slides = [
    anxeb.Slide(
      image: const AssetImage('assets/images/landing/slide-2.jpeg'),
      pushFrom: const Offset(0.0, 0.0),
      pushTo: const Offset(0.0, 0.0),
      scale: -1.37,
    ),
    anxeb.Slide(
      image: const AssetImage('assets/images/landing/slide-3.jpeg'),
      pushFrom: const Offset(0.0, 0.0),
      pushTo: const Offset(0.0, 0.0),
      scale: -1.37,
    ),
    anxeb.Slide(
      image: const AssetImage('assets/images/landing/slide-4.jpeg'),
      pushFrom: const Offset(0.0, 0.0),
      pushTo: const Offset(0.0, 0.0),
      scale: -1.37,
    ),
  ];

  @override
  void setup() async {
    _enableForeground = application.loaded;
    application.overlay.extendBodyFullScreen = true;
    application.overlay.brightness = Brightness.light;
    application.overlay.navigationFill = const Color(0xff3b3b3b);

    await precacheImage(_vignetteImage, context);
    await precacheImage(_iconImage, context);

    for (final $slide in _slides) {
      await precacheImage($slide.image, context);
    }

    await application.load();
    if (application.configuration.isAuthSaved) {
      try {
        await application.session.renew(scope: scope);
      } catch (err) {
        scope.alerts.error(err).show();
      }
    }

    await Future.delayed(const Duration(milliseconds: 300));
    rasterize();

    await Future.delayed(const Duration(milliseconds: 800));
    rasterize(() {
      _enableForeground = true;
    });
  }

  @override
  void prebuild() {}

  @override
  Widget content() {
    return Stack(
      children: <Widget>[
        AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: application.loaded ? 0 : 1,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: application.loaded ? 1 : 0,
          child: anxeb.SliderContainer(
            slides: _slides,
            options: anxeb.SliderOptions(
              fadeinDuration: const Duration(milliseconds: 1300),
              fadeoutDuration: const Duration(milliseconds: 800),
              transformDuration: const Duration(milliseconds: 7000),
              transitionDuration: const Duration(milliseconds: 5000),
              scale: -0.94,
            ),
            image: _vignetteImage,
            body: () {
              return Center(
                child: FractionallySizedBox(
                  widthFactor: 0.77,
                  heightFactor: 0.68,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: _enableForeground == true ? 1 : 0,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(top: 30),
                                constraints: const BoxConstraints(
                                  maxWidth: 380.0,
                                ),
                                child: Image(image: _iconImage),
                              ),
                            ],
                          ),
                        ),
                      ),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 600),
                        opacity: _enableForeground == true ? 1 : 0,
                        child: Container(
                          child: application.configuration.isAuthSaved
                              ? _getWelcomeButtons()
                              : _getSigninButtons(),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future _closeSession() async {
    final result = await scope.dialogs
        .confirm('¿Estás seguro que quieres terminar la sesión?')
        .show();
    if (result == true) {
      try {
        await application.session.close();
        rasterize();
      } catch (err) {
        scope.alerts.error(err).show();
      }
    }
  }

  Future _renewSession() async {
    await scope.busy();
    try {
      await application.session.renew(scope: scope);
      _goHome(silent: true);
    } catch (err) {
      await application.configuration.persist();
      rasterize();
      scope.alerts.error(err).show();
    } finally {
      await scope.idle();
    }
  }

  void _goHome({bool silent}) async {
    if (silent != true) {
      await scope.alerts
          .success('¡Hola ${application.session.user.toString()}!', delay: 2000)
          .show();
    }

    push(HomeScreen(), action: anxeb.ScreenPushAction.replace);
  }

  Widget _getSigninButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(bottom: 15),
          child: Column(
            children: [
              anxeb.TextButton(
                caption: anxeb.translate('screens.landing.lobby.access_button'),
                radius: scope.application.settings.dialogs.buttonRadius,
                color: scope.application.settings.colors.primary,
                margin: const EdgeInsets.only(bottom: 20),
                textColor: Colors.white,
                type: anxeb.ButtonType.primary,
                shadow: Global.shadows.button,
                size: anxeb.ButtonSize.normal,
                icon: anxeb.CommunityMaterialIcons.door_open,
                onPressed: () async {
                  push(LoginScreen());
                },
              ),
              anxeb.TextButton(
                caption: anxeb.translate('screens.landing.lobby.about_button'),
                radius: scope.application.settings.dialogs.buttonRadius,
                color: scope.application.settings.colors.secudary,
                margin: const EdgeInsets.only(bottom: 20),
                textColor: Colors.black,
                type: anxeb.ButtonType.secundary,
                shadow: Global.shadows.button,
                size: anxeb.ButtonSize.small,
                icon: Icons.info,
                iconColor: Colors.black,
                onPressed: () async {
                  push(AboutScreen());
                },
              ),
              anxeb.TextButton(
                caption:
                    anxeb.translate('screens.landing.lobby.language_button'),
                radius: scope.application.settings.dialogs.buttonRadius,
                color: scope.application.settings.colors.secudary,
                textColor: Colors.black,
                type: anxeb.ButtonType.secundary,
                shadow: Global.shadows.button,
                size: anxeb.ButtonSize.small,
                icon: Icons.language,
                iconColor: Colors.black,
                onPressed: () async {
                  application.changeLanguage(scope);
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _getWelcomeButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(top: 25),
          child: anxeb.TextButton(
            caption: 'Hola ${application.configuration.auth.user.lightName}',
            subtitle: 'Ingresar',
            radius: scope.application.settings.dialogs.buttonRadius,
            color: settings.colors.navigation.withOpacity(0.8),
            shadow: Global.shadows.button,
            size: anxeb.ButtonSize.medium,
            onPressed: _renewSession,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 15),
          child: anxeb.TextButton(
            caption: 'Cerrar Sesión',
            radius: scope.application.settings.dialogs.buttonRadius,
            color: Colors.white.withOpacity(0.5),
            textColor: Colors.black,
            shadow: Global.shadows.button,
            onPressed: _closeSession,
          ),
        ),
      ],
    );
  }
}
