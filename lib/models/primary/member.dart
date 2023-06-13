import 'package:anxeb_flutter/anxeb.dart' as Anxeb;
import 'package:todo_app/helpers/member.dart';
import 'package:todo_app/models/common/identity.dart';
import 'package:todo_app/models/common/login.dart';

class MemberModel extends Anxeb.HelpedModel<MemberModel, MemberHelper> {
  MemberModel([data]) : super(data);

  @override
  void init() {
    field(() => id, (v) => id = v, 'id', primary: true);
    field(() => firstNames, (v) => firstNames = v, 'first_names');
    field(() => lastNames, (v) => lastNames = v, 'last_names');
    field(() => role, (v) => role = v, 'role', enumValues: UserRole.values);
    field(() => login, (v) => login = v, 'login',
        instance: (data) => LoginModel(data));
    field(() => info, (v) => info = v, 'info',
        instance: (data) => UserInfoModel(data));
  }

  @override
  MemberHelper helper() => MemberHelper();

  @override
  String toString() => fullName;

  String id;
  String firstNames;
  String lastNames;
  IdentityModel identity;
  DateTime created;
  UserRole role;
  LoginModel login;
  UserInfoModel info;

  String get fullName => ('$firstNames $lastNames'.trim());

  String get lightName =>
      Anxeb.Utils.convert.fromNamesToFullName(firstNames, lastNames);

  bool filter(String lookup) =>
      lookup?.toUpperCase()?.split(' ')?.any(($key) => [fullName, login.email]
          .any(($item) =>
              $item != null && $item.toUpperCase().contains($key))) ==
      true;
}

class UserInfoModel extends Anxeb.Model<UserInfoModel> {
  UserInfoModel([data]) : super(data);

  @override
  void init() {
    field(() => language, (v) => language = v, 'language');
  }

  String language;
}

enum UserRole { client, admin }
