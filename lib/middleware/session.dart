import 'dart:io';
import 'package:flutter/material.dart';
import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_app/middleware/application.dart';
import 'package:todo_app/models/local/credentials.dart';
import 'package:todo_app/models/local/auth.dart';
import 'package:todo_app/models/primary/user.dart';

class Session {
  Application _application;
  SessionAuth _auth;
  int _tick;
  Directory _cacheDirectory;

  Session(Application application) {
    _application = application;
    _tick = DateTime.now().toUtc().millisecondsSinceEpoch;
  }

  Future<SessionAuth> open({CredentialsModel credentials}) async {
    anxeb.Data data;
    if (credentials != null) {
      data = await application.api.post('/auth/user', credentials.toObjects());
    }

    if (data == null) {
      return null;
    } else {
      return _buildSessionAuth(data);
    }
  }

  Future<SessionAuth> refresh({anxeb.Scope scope}) async {
    return renew(scope: scope);
  }

  Future<SessionAuth> renew({anxeb.Scope scope}) async {
    anxeb.Data data;
    if (application.configuration.isAuthSaved) {
      final $auth = application.configuration?.auth;
      api.token = $auth?.token;
      try {
        data = await application.api.post('/auth/renew', {});
      } catch (err) {
        await close();
        if (err.code == 6013) {
          data = null;
        } else if (err.code == 911 && scope != null) {
          scope.alerts.error(err).show();
          Future.delayed(const Duration(milliseconds: 1000), () {
            Navigator.of(scope.context).popUntil((route) => route.isFirst);
          });
        } else {
          rethrow;
        }
      }
    }

    if (data == null) {
      api.token = null;
      throw Exception('Tiempo de sesión expirado. Favor volver a ingresar');
    } else {
      return _buildSessionAuth(data);
    }
  }

  Future<SessionAuth> _buildSessionAuth(data) async {
    final auth = SessionAuth(data);

    _auth = auth;

    api.token = _auth.token;
    application.configuration.auth = _auth;
    await application.configuration.persist();
    await _checkDirectories();

    _tick = DateTime.now().toUtc().millisecondsSinceEpoch;

    application.analytics?.configure(onToken: (token) {
      _tokenize(token);
    });

    if (application.analytics?.token != null) {
      await _tokenize(application.analytics.token);
    }

    application?.analytics?.property(
        'user_login_provider', user.login.provider.toString().split('.')[1]);
    application?.analytics?.login();

    return _auth;
  }

  Future _tokenize([String token]) async {
    await application.api.post('/auth/tokenize', {'token': token ?? ''});
  }

  Future close() async {
    try {
      await application.api.post('/auth/close', {'member': user.id});
    } catch (err) {
      //ignore
    }

    application.analytics?.logout();
    application.configuration.auth = null;
    api.token = null;

    _auth = null;
    _cacheDirectory = null;

    await application.configuration.persist();
  }

  Future _checkDirectories() async {
    _cacheDirectory = await anxeb.getTemporaryDirectory();
  }

  Directory get cacheDirectory => _cacheDirectory;

  bool get closed => _auth == null || _auth.user == null || api.token != null;

  Application get application => _application;

  UserModel get user => _auth?.user;

  anxeb.Api get api => _application.api;

  SessionAuth get auth => _auth;

  int get tick => _tick;

  bool get authenticated => _auth?.user?.id != null;

  List<AuthRoles> get roles => _auth?.roles ?? [];
}
