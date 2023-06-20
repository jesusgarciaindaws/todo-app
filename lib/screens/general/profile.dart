import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_app/middleware/global.dart';
import 'package:todo_app/middleware/session.dart';
import 'package:todo_app/middleware/application.dart';
import 'package:todo_app/models/common/login.dart';
import 'package:todo_app/widgets/blocks/title.dart';

class ProfileScreen extends anxeb.ScreenWidget {
  ProfileScreen({Key key})
      : super('profile', title: 'Perfil de Usuario', key: key);

  @override
  anxeb.ScreenView<ProfileScreen, Application> createState() => _ProfileState();
}

class _ProfileState extends anxeb.ScreenView<ProfileScreen, Application> {
  ScrollController _scrollerController;

  @override
  Future init() async {
    _scrollerController = ScrollController(initialScrollOffset: 0.0);
    await _refresh();
  }

  @override
  void setup() {}

  @override
  void prebuild() {}

  @override
  dynamic drawer() => true;

  @override
  anxeb.ActionsHeader header() {
    return anxeb.ActionsHeader(
      scope: scope,
    );
  }

  @override
  anxeb.ScreenTabs tabs() {
    return anxeb.ScreenTabs(
      scope: scope,
      items: [
        anxeb.TabItem(
          caption: () => 'Identidad',
          name: 'identity',
          body: () => Container(
            padding: const EdgeInsets.only(top: 8, left: 12, right: 12),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                TitleBlock(
                  scope: scope,
                  title: session.user.fullName,
                  titleStyle: TextStyle(
                    fontSize: 23,
                    letterSpacing: -0.2,
                    color: settings.colors.navigation,
                    fontWeight: FontWeight.w300,
                  ),
                  imageUrl: application.api
                      .getUri('/storage/profile/avatar?t=${scope.tick}'),
                  subtitle: session.user.login.email,
                  iconColor: scope.application.settings.colors.navigation,
                  noMargin: true,
                  onTap: () {
                    _changePhoto();
                  },
                ),
                Expanded(child: SingleChildScrollView(child: _getInfoBlock())),
              ],
            ),
          ),
        ),
        anxeb.TabItem(
          caption: () => 'Seguridad',
          name: 'security',
          body: () => Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: anxeb.ScrollableContainer(
                  scope: scope,
                  controller: _scrollerController,
                  fadding: Global.faddings.base,
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 18.0, bottom: 2),
                          child: Icon(
                            Icons.lock,
                            color: settings.colors.primary,
                            size: 96,
                          ),
                        ),
                      ),
                      anxeb.TextInputField(
                        scope: scope,
                        name: 'email',
                        group: 'security',
                        readonly:
                            session.user.login.provider != LoginProvider.email,
                        margin: const EdgeInsets.only(top: 20),
                        icon: anxeb.FontAwesome5.envelope,
                        label: 'Correo',
                        type: anxeb.TextInputFieldType.email,
                        validator: anxeb.Utils.validators.email,
                        // refocus: false,
                        action: TextInputAction.next,
                      ),
                      anxeb.TextInputField(
                        scope: scope,
                        name: 'password_new',
                        group: 'security',
                        margin: const EdgeInsets.only(top: 20),
                        icon: anxeb.FontAwesome.key,
                        label: 'Contraseña Nueva',
                        type: anxeb.TextInputFieldType.password,
                        action: TextInputAction.next,
                      ),
                      anxeb.TextInputField(
                        scope: scope,
                        name: 'password_rep',
                        group: 'security',
                        margin: const EdgeInsets.only(top: 20),
                        icon: anxeb.FontAwesome.key,
                        label: 'Repetir Contraseña',
                        type: anxeb.TextInputFieldType.password,
                        validator: (val) {
                          if (val !=
                              scope.forms['security'].fields['password_new']
                                  .value) {
                            return 'Iguale a la contraseña nueva';
                          } else {
                            return null;
                          }
                        },
                        action: TextInputAction.done,
                        // refocus: false,
                        onActionSubmit: (val) =>
                            _scrollDown(_scrollerController),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  anxeb.ActionsFooter footer() {
    return anxeb.ActionsFooter(
      scope: scope,
      actions: <anxeb.ActionIcon>[
        anxeb.ActionIcon(
          icon: () => Icons.refresh,
          onPressed: () => _refresh(refreshSession: true),
        ),
        anxeb.ActionIcon(
          icon: () => anxeb.CommunityMaterialIcons.qrcode,
          onPressed: () {
            session.user.using(scope).showQR();
          },
        ),
      ],
    );
  }

  @override
  anxeb.ScreenAction action() {
    return anxeb.ScreenAction(
      scope: scope,
      onPressed: () {
        _update();
      },
      isVisible: () {
        return _currentTab == 'security' || _currentTab == 'contact';
      },
      icon: () => Icons.check,
    );
  }

  Widget _getInfoBlock() {
    final $user = session.user;
    return Container(
      margin: const EdgeInsets.only(left: 6, right: 6, bottom: 20),
      child: Column(
        children: <Widget>[
          anxeb.PropertyBlock(
            margin: const EdgeInsets.only(top: 16),
            icon: anxeb.CommunityMaterialIcons.badge_account,
            label: 'Nombre de Usuario',
            value: $user.fullName,
          ),
          anxeb.PropertyBlock(
            margin: const EdgeInsets.only(top: 16),
            icon: Icons.email,
            label: 'Correo',
            isEmail: true,
            value: session.user?.login?.email,
          ),
          anxeb.PropertyBlock(
            margin: const EdgeInsets.only(top: 16),
            icon: Icons.fingerprint,
            label: Global.captions.identityCaption($user?.identity?.type),
            value: $user?.identity?.number ?? '',
          ),
        ],
      ),
    );
  }

  Future _update() async {
    final params = {};
    if (_currentTab == 'security' && scope.forms['security'].valid()) {
      final data = scope.forms['security'].data();
      final email = data['email'];
      final newPassword = data['password_new'];
      final repPassword = data['password_rep'];

      if (newPassword?.toString()?.isNotEmpty == true ||
          email != session.user.login.email) {
        if (session.user.login.provider == LoginProvider.email) {
          final currentPassword = await scope.dialogs
              .prompt(
                'Contraseña actual',
                hint: 'Contraseña',
                type: anxeb.TextInputFieldType.password,
                value: '',
                icon: anxeb.FontAwesome.key,
              )
              .show();

          if (currentPassword != null) {
            if (email != session.user.login.email) {
              params['email'] = email;
            }
            params['password'] = currentPassword;
          } else {
            return;
          }
        } else {
          anxeb.AuthResultModel auth;
          if (session.user.login.provider == LoginProvider.google) {
            auth = await _socialAuth(scope.auths.google);
          } else if (session.user.login.provider == LoginProvider.facebook) {
            auth = await _socialAuth(scope.auths.facebook);
          } else if (session.user.login.provider == LoginProvider.apple &&
              Platform.isIOS) {
            auth = await _socialAuth(scope.auths.apple);
          }

          if (auth != null) {
            if (auth.email == session.user.login.email) {
              params['auth'] = auth.toObjects(usePrimaryKeys: true);
            } else {
              scope.alerts.error('Cuenta seleccionada incorrecta').show();
              scope.idle();
              return;
            }
          } else {
            scope.idle();
            return;
          }
        }

        params['password_new'] = newPassword;
        params['password_rep'] = repPassword;

        return _save(params);
      }
    } else if (_currentTab == 'contact' && scope.forms['contact'].valid()) {
      final data = scope.forms['contact'].data();
      data['location']['address'] = data['address'];

      params['phones'] = data['phones'];
      params['location'] = data['location'];

      return _save(params);
    }
  }

  Future _save(params) async {
    await scope.busy();
    try {
      await session.api.post('/profile', params);
      await session.refresh(scope: scope);
      scope.alerts.success('Perfil actualizado correctamente').show();
    } catch (err) {
      scope.alerts.error(err).show();
    } finally {
      await scope.idle();
    }
  }

  Future _refresh({bool refreshSession}) async {
    if (refreshSession == true) {
      await scope.busy();
      try {
        await session.refresh(scope: scope);
        scope.retick();
      } catch (err) {
        scope.alerts.error(err).show();
      } finally {
        await scope.idle();
      }
    }
    scope.forms['security'].update({
      'email': session.user.login.email,
    });
  }

  void _changePhoto() async {
    scope.unfocus();
    final result = await anxeb.Device.photo(
      scope: scope,
      title: 'Foto Perfil',
      initFaceCamera: true,
      allowMainCamera: true,
      flash: false,
      fullImage: false,
      option: anxeb.FileSourceOption.prompt,
    );

    if (result != null) {
      await scope.busy();
      try {
        final b64 = base64Encode(result.readAsBytesSync());
        await session.api.post(
            '/profile/picture', {'picture': 'data:image/png;base64,$b64'});
        await session.refresh(scope: scope);
        scope.retick();
        scope.alerts.success('Foto de perfil actualizada correctamente').show();
      } catch (err) {
        scope.alerts.error(err).show();
      } finally {
        await scope.idle();
      }
    }
  }

  Future<anxeb.AuthResultModel> _socialAuth(anxeb.AuthProvider provider) async {
    await scope.busy(timeout: -1);
    await provider.logout();
    try {
      return await provider.login();
    } catch (err) {
      scope.alerts.error(err).show();
    }
    return null;
  }

  void _scrollDown(ScrollController controller) {
    Future.delayed(const Duration(milliseconds: 200), () {
      controller.animateTo(controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.decelerate);
    });
  }

  String get _currentTab => parts?.tabs?.current?.name;

  Session get session => application.session;
}
