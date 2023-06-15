import 'package:flutter/material.dart';
import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_app/middleware/session.dart';
import 'package:todo_app/middleware/application.dart';

class AboutScreen extends anxeb.ScreenWidget {
  AboutScreen({Key key})
      : super(
          'about',
          title: anxeb.translate('screens.landing.about.title'),
          key: key,
        );

  @override
  anxeb.ScreenView<AboutScreen, Application> createState() => _AboutState();
}

class _AboutState extends anxeb.ScreenView<AboutScreen, Application> {
  final ImageProvider _fullBrand =
      const AssetImage('assets/images/brand/full-brand.png');
  anxeb.DeviceInfo _info;

  @override
  Future init() async {
    _info = anxeb.Device.info;
  }

  @override
  void setup() async {
    window.overlay.brightness = Brightness.dark;
    await precacheImage(_fullBrand, context);
  }

  @override
  dynamic drawer() => false;

  @override
  anxeb.ActionsHeader header() {
    return anxeb.ActionsHeader(
      scope: scope,
    );
  }

  @override
  void prebuild() {}

  @override
  Widget content() {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.7,
        heightFactor: 0.72,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(top: 0),
                    constraints: const BoxConstraints(
                      maxWidth: 380.0,
                    ),
                    child: Image(image: _fullBrand),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    child: GestureDetector(
                      onTap: () {
                        anxeb.Device.launchUrl(
                            scope: scope,
                            url: anxeb
                                .translate('screens.landing.about.url_link'));
                      },
                      child: Text(
                        anxeb.translate('screens.landing.about.url_label'),
                        style: TextStyle(
                            color: application.settings.colors.link,
                            fontSize: 17,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      anxeb.translate(
                        'screens.landing.about.version',
                        args: {
                          "version": _info?.package?.version ?? 'n/a',
                          "rev": _info?.package?.buildNumber ?? 'n/a'
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Session get session => application.session;
}
