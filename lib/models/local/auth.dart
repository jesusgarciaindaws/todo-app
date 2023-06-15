// ignore_for_file: constant_identifier_names

import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_app/models/primary/user.dart';

class SessionAuth extends anxeb.Model<SessionAuth> {
  SessionAuth([data]) : super(data);

  @override
  void init() {
    field(() => user, (v) => user = v, 'user',
        instance: (data) => UserModel(data));
    field(() => roles, (v) => roles = v, 'roles',
        enumValues: AuthRoles.values, defect: () => <AuthRoles>[]);
    field(() => provider, (v) => provider = v, 'provider');
    field(() => token, (v) => token = v, 'token');
  }

  UserModel user;
  List<AuthRoles> roles;
  String provider;
  String token;
}

enum AuthRoles { member_basic }
