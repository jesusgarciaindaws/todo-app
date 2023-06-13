import 'package:anxeb_flutter/anxeb.dart' as Anxeb;
import 'package:todo_app/models/primary/member.dart';

class SessionAuth extends Anxeb.Model<SessionAuth> {
  SessionAuth([data]) : super(data);

  @override
  void init() {
    field(() => member, (v) => member = v, 'user',
        instance: (data) => MemberModel(data));
    field(() => roles, (v) => roles = v, 'roles',
        enumValues: AuthRoles.values, defect: () => <AuthRoles>[]);
    field(() => provider, (v) => provider = v, 'provider');
    field(() => token, (v) => token = v, 'token');
  }

  MemberModel member;
  List<AuthRoles> roles;
  String provider;
  String token;
}

enum AuthRoles { member_basic }
