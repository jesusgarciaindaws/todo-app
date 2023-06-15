import 'package:anxeb_flutter/anxeb.dart' as anxeb;

class LoginModel extends anxeb.Model<LoginModel> {
  LoginModel([data]) : super(data);

  @override
  void init() {
    field(
      () => provider,
      (v) => provider = v,
      'provider',
      enumValues: LoginProvider.values,
    );
    field(
      () => state,
      (v) => state = v,
      'state',
      enumValues: LoginState.values,
    );
    field(() => email, (v) => email = v, 'email');
    field(
      () => date,
      (v) => date = v,
      'date',
      instance: (data) =>
          data != null ? anxeb.Utils.convert.fromTickToDate(data) : null,
    );
  }

  LoginProvider provider;
  String email;
  LoginState state;
  DateTime date;
}

enum LoginProvider { email, facebook, google, apple }

enum LoginState { active, inactive }
